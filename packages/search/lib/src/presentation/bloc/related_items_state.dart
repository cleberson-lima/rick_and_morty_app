part of 'related_items_cubit.dart';

@freezed
sealed class RelatedItemsState<T> with _$RelatedItemsState<T> {
  const factory RelatedItemsState.loading({required int page}) =
      RelatedItemsLoading<T>;

  const factory RelatedItemsState.success({
    required List<T> items,
    required int page,
    required int totalPages,
  }) = RelatedItemsSuccess<T>;

  const factory RelatedItemsState.error({
    required Failure failure,
    required int page,
  }) = RelatedItemsError<T>;
}
