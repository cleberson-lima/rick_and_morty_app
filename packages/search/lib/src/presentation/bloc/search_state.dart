import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_state.freezed.dart';

@freezed
sealed class SearchState<T> with _$SearchState<T> {
  const SearchState._();

  const factory SearchState.initial() = SearchInitial<T>;

  const factory SearchState.loading({required String query}) = SearchLoading<T>;

  const factory SearchState.success({
    required String query,
    required List<T> items,
    required int totalCount,
    int? nextPage,
    @Default(false) bool isLoadingMore,
    String? loadMoreError,
  }) = SearchSuccess<T>;

  /// The API answered 200 with zero results.
  const factory SearchState.empty({required String query}) = SearchEmpty<T>;

  /// The API answered 404: nothing matches [query].
  const factory SearchState.notFound({required String query}) =
      SearchNotFound<T>;

  const factory SearchState.error({
    required String query,
    required String message,
  }) = SearchError<T>;

  /// Query this state belongs to, or `null` before the first search.
  String? get currentQuery => switch (this) {
    SearchInitial() => null,
    SearchLoading(:final query) ||
    SearchSuccess(:final query) ||
    SearchEmpty(:final query) ||
    SearchNotFound(:final query) ||
    SearchError(:final query) => query,
  };
}
