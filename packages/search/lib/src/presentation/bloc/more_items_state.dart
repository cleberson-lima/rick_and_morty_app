part of 'more_items_cubit.dart';

@freezed
sealed class MoreItemsState<T> with _$MoreItemsState<T> {
  const factory MoreItemsState.loading({required int page}) =
      MoreItemsLoading<T>;

  const factory MoreItemsState.success({
    required List<T> items,
    required int page,
    required int totalPages,
  }) = MoreItemsSuccess<T>;

  const factory MoreItemsState.error({
    required String message,
    required int page,
  }) = MoreItemsError<T>;
}
