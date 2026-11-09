import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/types.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/src/presentation/bloc/related_items_cubit.dart';

/// Stand-in for a `SearchApi.searchX` method, so the test can stub it.
abstract class _Search {
  Future<Result<PaginatedList<String>>> call(String query, {int page = 1});
}

class _MockSearch extends Mock implements _Search {}

PaginatedList<String> _page(List<String> items, int total) =>
    PaginatedList(items: items, totalCount: total);

void main() {
  late _MockSearch search;

  setUp(() => search = _MockSearch());

  blocTest<RelatedItemsCubit<String>, RelatedItemsState<String>>(
    'loads a page and computes the page count (20 per page)',
    setUp: () => when(
      () => search('', page: 2),
    ).thenAnswer((_) async => Success(_page(['a', 'b'], 826))),
    build: () => RelatedItemsCubit<String>(search.call),
    act: (cubit) => cubit.load(2),
    expect: () => const [
      RelatedItemsState<String>.loading(page: 2),
      RelatedItemsState<String>.success(
        items: ['a', 'b'],
        page: 2,
        totalPages: 42,
      ),
    ],
  );

  blocTest<RelatedItemsCubit<String>, RelatedItemsState<String>>(
    'a single short page still has one page',
    setUp: () => when(
      () => search('', page: 1),
    ).thenAnswer((_) async => Success(_page(['a'], 1))),
    build: () => RelatedItemsCubit<String>(search.call),
    act: (cubit) => cubit.load(1),
    skip: 1,
    expect: () => const [
      RelatedItemsState<String>.success(items: ['a'], page: 1, totalPages: 1),
    ],
  );

  blocTest<RelatedItemsCubit<String>, RelatedItemsState<String>>(
    'failure keeps the page so retry asks for it again',
    setUp: () {
      var calls = 0;
      when(() => search('', page: 3)).thenAnswer(
        (_) async => calls++ == 0
            ? const Failed(Failure.network())
            : Success(_page(['c'], 60)),
      );
    },
    build: () => RelatedItemsCubit<String>(search.call),
    act: (cubit) async {
      await cubit.load(3);
      await cubit.retry();
    },
    expect: () => [
      const RelatedItemsState<String>.loading(page: 3),
      const RelatedItemsState<String>.error(
        failure: Failure.network(),
        page: 3,
      ),
      const RelatedItemsState<String>.loading(page: 3),
      const RelatedItemsState<String>.success(
        items: ['c'],
        page: 3,
        totalPages: 3,
      ),
    ],
  );

  blocTest<RelatedItemsCubit<String>, RelatedItemsState<String>>(
    'a slow older page never overwrites a newer one',
    setUp: () {
      final slow = Completer<Result<PaginatedList<String>>>();
      when(() => search('', page: 2)).thenAnswer((_) => slow.future);
      when(
        () => search('', page: 3),
      ).thenAnswer((_) async => Success(_page(['page 3'], 60)));
      addTearDown(() => slow.complete(Success(_page(['page 2'], 60))));
    },
    build: () => RelatedItemsCubit<String>(search.call),
    act: (cubit) async {
      unawaited(cubit.load(2));
      await cubit.load(3);
    },
    expect: () => const [
      RelatedItemsState<String>.loading(page: 2),
      RelatedItemsState<String>.loading(page: 3),
      RelatedItemsState<String>.success(
        items: ['page 3'],
        page: 3,
        totalPages: 3,
      ),
    ],
  );

  blocTest<RelatedItemsCubit<String>, RelatedItemsState<String>>(
    'a cancelled request emits nothing after loading',
    setUp: () => when(
      () => search('', page: 1),
    ).thenAnswer((_) async => const Failed(Failure.cancelled())),
    build: () => RelatedItemsCubit<String>(search.call),
    act: (cubit) => cubit.load(1),
    expect: () => const [RelatedItemsState<String>.loading(page: 1)],
  );
}
