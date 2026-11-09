import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/src/domain/usecases/search_usecases.dart';
import 'package:search/src/presentation/bloc/more_items_cubit.dart';

class _MockSearch extends Mock implements SearchUseCase<String> {}

PageResult<String> _page(List<String> items, int total) =>
    PageResult(items: items, totalCount: total);

void main() {
  late _MockSearch search;

  setUp(() => search = _MockSearch());

  blocTest<MoreItemsCubit<String>, MoreItemsState<String>>(
    'loads a page and computes the page count (20 per page)',
    setUp: () => when(
      () => search('', page: 2),
    ).thenAnswer((_) async => Right(_page(['a', 'b'], 826))),
    build: () => MoreItemsCubit<String>(search),
    act: (cubit) => cubit.load(2),
    expect: () => const [
      MoreItemsState<String>.loading(page: 2),
      MoreItemsState<String>.success(
        items: ['a', 'b'],
        page: 2,
        totalPages: 42,
      ),
    ],
  );

  blocTest<MoreItemsCubit<String>, MoreItemsState<String>>(
    'a single short page still has one page',
    setUp: () => when(
      () => search('', page: 1),
    ).thenAnswer((_) async => Right(_page(['a'], 1))),
    build: () => MoreItemsCubit<String>(search),
    act: (cubit) => cubit.load(1),
    skip: 1,
    expect: () => const [
      MoreItemsState<String>.success(items: ['a'], page: 1, totalPages: 1),
    ],
  );

  blocTest<MoreItemsCubit<String>, MoreItemsState<String>>(
    'failure keeps the page so retry asks for it again',
    setUp: () {
      var calls = 0;
      when(() => search('', page: 3)).thenAnswer(
        (_) async => calls++ == 0
            ? const Left(Failure.network())
            : Right(_page(['c'], 60)),
      );
    },
    build: () => MoreItemsCubit<String>(search),
    act: (cubit) async {
      await cubit.load(3);
      await cubit.retry();
    },
    expect: () => [
      const MoreItemsState<String>.loading(page: 3),
      const MoreItemsState<String>.error(failure: Failure.network(), page: 3),
      const MoreItemsState<String>.loading(page: 3),
      const MoreItemsState<String>.success(
        items: ['c'],
        page: 3,
        totalPages: 3,
      ),
    ],
  );

  blocTest<MoreItemsCubit<String>, MoreItemsState<String>>(
    'a slow older page never overwrites a newer one',
    setUp: () {
      final slow = Completer<Either<Failure, PageResult<String>>>();
      when(() => search('', page: 2)).thenAnswer((_) => slow.future);
      when(
        () => search('', page: 3),
      ).thenAnswer((_) async => Right(_page(['page 3'], 60)));
      addTearDown(() => slow.complete(Right(_page(['page 2'], 60))));
    },
    build: () => MoreItemsCubit<String>(search),
    act: (cubit) async {
      unawaited(cubit.load(2));
      await cubit.load(3);
    },
    expect: () => const [
      MoreItemsState<String>.loading(page: 2),
      MoreItemsState<String>.loading(page: 3),
      MoreItemsState<String>.success(items: ['page 3'], page: 3, totalPages: 3),
    ],
  );

  blocTest<MoreItemsCubit<String>, MoreItemsState<String>>(
    'a cancelled request emits nothing after loading',
    setUp: () => when(
      () => search('', page: 1),
    ).thenAnswer((_) async => const Left(Failure.cancelled())),
    build: () => MoreItemsCubit<String>(search),
    act: (cubit) => cubit.load(1),
    expect: () => const [MoreItemsState<String>.loading(page: 1)],
  );
}
