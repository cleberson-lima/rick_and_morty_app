/// JSON object as decoded by Dio.
typedef Json = Map<String, Object?>;

/// Extracts the trailing id from a resource URL
/// (`https://rickandmortyapi.com/api/location/3` → 3). Empty or missing
/// URLs (unknown origin) give `null`.
int? idFromResourceUrl(String? url) {
  if (url == null || url.isEmpty) return null;
  final segments = Uri.tryParse(url)?.pathSegments.where((s) => s.isNotEmpty);
  return segments == null || segments.isEmpty
      ? null
      : int.tryParse(segments.last);
}

/// Number of items in a JSON list of URLs (`episode`, `characters`,
/// `residents`); a missing list counts as empty.
int countOf(Object? list) => (list as List<Object?>?)?.length ?? 0;
