import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/src/domain/usecases/search_usecases.dart';
import 'package:search/src/presentation/bloc/search_bloc.dart';
import 'package:search/src/presentation/bloc/search_event.dart';
import 'package:search/src/presentation/bloc/search_state.dart';

class _MockSearch extends Mock implements SearchUseCase<String> {}

const _debounce = Duration(milliseconds: 50);
// Generous slack: a busy CI machine may fire the debounce timer late.
const _afterDebounce = Duration(milliseconds: 500);

PageResult<String> _page(List<String> items, {int? next, int total = 0}) =>
    PageResult(items: items, totalCount: total, nextPage: next);

void main() {
  late _MockSearch search;

  SearchBloc<String> build() => SearchBloc<String>(search, debounce: _debounce);

  setUp(() => search = _MockSearch());

  group('typing (debounced)', () {
    blocTest<SearchBloc<String>, SearchState<String>>(
      'fires a single request for the last query after a burst of keystrokes',
      setUp: () => when(
        () => search('rick'),
      ).thenAnswer((_) async => Right(_page(['Rick'], total: 1))),
      build: build,
      act: (bloc) => bloc
        ..add(const SearchQueryChanged('r'))
        ..add(const SearchQueryChanged('ri'))
        ..add(const SearchQueryChanged('ric'))
        ..add(const SearchQueryChanged('rick')),
      wait: _afterDebounce,
      expect: () => const [
        SearchState<String>.loading(query: 'rick'),
        SearchState<String>.success(
          query: 'rick',
          items: ['Rick'],
          totalCount: 1,
        ),
      ],
      verify: (_) {
        verify(() => search('rick')).called(1);
        verifyNoMoreInteractions(search);
      },
    );

    blocTest<SearchBloc<String>, SearchState<String>>(
      'ignores a change that only adds whitespace',
      setUp: () => when(
        () => search('rick'),
      ).thenAnswer((_) async => Right(_page(['Rick'], total: 1))),
      build: build,
      seed: () => const SearchState<String>.success(
        query: 'rick',
        items: ['Rick'],
        totalCount: 1,
      ),
      act: (bloc) => bloc.add(const SearchQueryChanged('rick  ')),
      wait: _afterDebounce,
      expect: () => const <SearchState<String>>[],
    );
  });

  group('results', () {
    blocTest<SearchBloc<String>, SearchState<String>>(
      '404 becomes notFound, not a generic error',
      setUp: () => when(
        () => search('xyz'),
      ).thenAnswer((_) async => const Left(Failure.notFound())),
      build: build,
      act: (bloc) => bloc.add(const SearchSubmitted('xyz')),
      expect: () => const [
        SearchState<String>.loading(query: 'xyz'),
        SearchState<String>.notFound(query: 'xyz'),
      ],
    );

    blocTest<SearchBloc<String>, SearchState<String>>(
      'network failure becomes error with a message',
      setUp: () => when(
        () => search(''),
      ).thenAnswer((_) async => const Left(Failure.network())),
      build: build,
      act: (bloc) => bloc.add(const SearchSubmitted('')),
      expect: () => [
        const SearchState<String>.loading(query: ''),
        SearchState<String>.error(
          query: '',
          message: const Failure.network().message,
        ),
      ],
    );

    blocTest<SearchBloc<String>, SearchState<String>>(
      'zero results becomes empty',
      setUp: () =>
          when(() => search('a')).thenAnswer((_) async => Right(_page([]))),
      build: build,
      act: (bloc) => bloc.add(const SearchSubmitted('a')),
      expect: () => const [
        SearchState<String>.loading(query: 'a'),
        SearchState<String>.empty(query: 'a'),
      ],
    );

    blocTest<SearchBloc<String>, SearchState<String>>(
      'a cancelled request emits nothing after loading',
      setUp: () => when(
        () => search('a'),
      ).thenAnswer((_) async => const Left(Failure.cancelled())),
      build: build,
      act: (bloc) => bloc.add(const SearchSubmitted('a')),
      expect: () => const [SearchState<String>.loading(query: 'a')],
    );

    blocTest<SearchBloc<String>, SearchState<String>>(
      'a slow older response never overwrites a newer search',
      setUp: () {
        when(
          () => search('fast'),
        ).thenAnswer((_) async => Right(_page(['fresh'], total: 1)));
      },
      build: build,
      // Deterministic: the "slow" response is released only after the newer
      // search has finished, so no real-time race decides the outcome.
      act: (bloc) async {
        final slow = Completer<Either<Failure, PageResult<String>>>();
        when(() => search('slow')).thenAnswer((_) => slow.future);

        bloc.add(const SearchSubmitted('slow'));
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SearchQueryChanged('fast'));
        await bloc.stream.firstWhere((s) => s is SearchSuccess<String>);

        slow.complete(Right(_page(['stale'], total: 1)));
        await Future<void>.delayed(Duration.zero);
      },
      expect: () => const [
        SearchState<String>.loading(query: 'slow'),
        SearchState<String>.loading(query: 'fast'),
        SearchState<String>.success(
          query: 'fast',
          items: ['fresh'],
          totalCount: 1,
        ),
      ],
    );
  });

  group('pagination', () {
    const firstPage = SearchSuccess<String>(
      query: 'rick',
      items: ['a', 'b'],
      totalCount: 3,
      nextPage: 2,
    );

    blocTest<SearchBloc<String>, SearchState<String>>(
      'appends the next page',
      setUp: () => when(
        () => search('rick', page: 2),
      ).thenAnswer((_) async => Right(_page(['c'], total: 3))),
      build: build,
      seed: () => firstPage,
      act: (bloc) => bloc.add(const SearchNextPageRequested()),
      expect: () => [
        firstPage.copyWith(isLoadingMore: true),
        const SearchState<String>.success(
          query: 'rick',
          items: ['a', 'b', 'c'],
          totalCount: 3,
        ),
      ],
    );

    blocTest<SearchBloc<String>, SearchState<String>>(
      'drops repeated requests while a page is loading',
      build: build,
      seed: () => firstPage,
      // The page stays in flight until all three requests were dispatched.
      act: (bloc) async {
        final page = Completer<Either<Failure, PageResult<String>>>();
        when(() => search('rick', page: 2)).thenAnswer((_) => page.future);
        bloc
          ..add(const SearchNextPageRequested())
          ..add(const SearchNextPageRequested())
          ..add(const SearchNextPageRequested());
        await Future<void>.delayed(Duration.zero);
        page.complete(Right(_page(['c'], total: 3)));
        await bloc.stream.firstWhere(
          (s) => s is SearchSuccess<String> && !s.isLoadingMore,
        );
      },
      verify: (_) => verify(() => search('rick', page: 2)).called(1),
    );

    blocTest<SearchBloc<String>, SearchState<String>>(
      'keeps items and exposes the error when a page fails',
      setUp: () => when(
        () => search('rick', page: 2),
      ).thenAnswer((_) async => const Left(Failure.network())),
      build: build,
      seed: () => firstPage,
      act: (bloc) => bloc.add(const SearchNextPageRequested()),
      expect: () => [
        firstPage.copyWith(isLoadingMore: true),
        firstPage.copyWith(loadMoreError: const Failure.network().message),
      ],
    );

    blocTest<SearchBloc<String>, SearchState<String>>(
      'after a failed page, scrolling alone does not retry; the button does',
      setUp: () => when(
        () => search('rick', page: 2),
      ).thenAnswer((_) async => Right(_page(['c'], total: 3))),
      build: build,
      seed: () => firstPage.copyWith(loadMoreError: 'boom'),
      act: (bloc) async {
        bloc.add(const SearchNextPageRequested());
        await Future<void>.delayed(Duration.zero);
        bloc.add(const SearchNextPageRequested(retry: true));
      },
      verify: (_) => verify(() => search('rick', page: 2)).called(1),
    );

    blocTest<SearchBloc<String>, SearchState<String>>(
      'does nothing on the last page',
      build: build,
      seed: () => const SearchState<String>.success(
        query: 'rick',
        items: ['a'],
        totalCount: 1,
      ),
      act: (bloc) => bloc.add(const SearchNextPageRequested()),
      expect: () => const <SearchState<String>>[],
      verify: (_) => verifyZeroInteractions(search),
    );
  });
}
