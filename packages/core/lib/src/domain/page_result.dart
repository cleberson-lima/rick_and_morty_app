import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_result.freezed.dart';

/// One page of a paginated API response.
@freezed
abstract class PageResult<T> with _$PageResult<T> {
  const PageResult._();

  const factory PageResult({
    required List<T> items,
    required int totalCount,

    /// Number of the next page, or `null` when this is the last one.
    int? nextPage,
  }) = _PageResult<T>;

  bool get hasNext => nextPage != null;
}
