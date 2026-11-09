import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_list.freezed.dart';

/// One page of a paginated API response.
@freezed
abstract class PaginatedList<T> with _$PaginatedList<T> {
  const PaginatedList._();

  const factory PaginatedList({
    required List<T> items,
    required int totalCount,

    /// Number of the next page, or `null` when this is the last one.
    int? nextPage,
  }) = _PaginatedList<T>;

  bool get hasNext => nextPage != null;
}
