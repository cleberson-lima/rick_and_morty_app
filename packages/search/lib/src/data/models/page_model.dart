import 'package:core/core.dart';

import 'model.dart';

/// Paginated response: `{ "info": { "count", "next" }, "results": [...] }`.
///
/// Each item of `results` is parsed by [Model.fromJson] for the type [M].
class PageModel<M extends Model<Object?>> {
  const PageModel({required this.count, required this.results, this.next});

  factory PageModel.fromJson(Json json) {
    final info = json['info']! as Json;
    return PageModel(
      count: info['count']! as int,
      next: info['next'] as String?,
      results: [
        for (final item in json['results']! as List<Object?>)
          Model.fromJson<M>(item! as Json),
      ],
    );
  }

  /// Total number of items across all pages.
  final int count;

  /// URL of the next page, `null` on the last one.
  final String? next;
  final List<M> results;

  int? get nextPage => parseNextPage(next);
}
