import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'offline_status.dart';

/// Network first, cache as fallback: every successful `GET` response is saved
/// to [directory] (one file per URL), and when a later request for the same
/// URL fails because there is no connection or it timed out, it is answered
/// with the saved copy instead of an error.
///
/// So without network the app still shows the last search results and the
/// details pages already opened. API errors (404, 429, 5xx) and cancelled
/// requests are not replaced by the cache. Responses served from the cache
/// carry `extra[fromCacheKey] == true`.
///
/// Keeps at most [maxEntries] files; the least recently written go first.
/// When given a [status], it tells whether the last response came from the
/// cache, so the app can warn that the data shown may be old.
class OfflineCacheInterceptor extends Interceptor {
  OfflineCacheInterceptor(this.directory, {this.maxEntries = 100, this.status});

  /// Set to `true` in [Response.extra] when the response came from the cache.
  static const fromCacheKey = 'from_offline_cache';

  final Directory directory;
  final int maxEntries;
  final OfflineStatus? status;

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    final options = response.requestOptions;
    if (options.method == 'GET' && response.statusCode == 200) {
      status?.value = false;
      await _guard(() => _save(options.uri, response.data));
    }
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    if (options.method != 'GET' || !_isOffline(err)) return handler.next(err);

    final cached = await _guard(() => _read(options.uri));
    if (cached == null) return handler.next(err);
    status?.value = true;
    handler.resolve(
      Response<dynamic>(
        requestOptions: options,
        statusCode: 200,
        data: cached,
        extra: {fromCacheKey: true},
      ),
    );
  }

  static bool _isOffline(DioException err) => switch (err.type) {
    DioExceptionType.connectionError ||
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => true,
    DioExceptionType.unknown => err.error is SocketException,
    _ => false,
  };

  Future<void> _save(Uri uri, Object? data) async {
    if (data is! Map && data is! List) return;
    await directory.create(recursive: true);
    await _fileFor(uri).writeAsString(jsonEncode(data), flush: true);
    await _evictOldest();
  }

  Future<Object?> _read(Uri uri) async {
    final file = _fileFor(uri);
    if (!file.existsSync()) return null;
    return jsonDecode(await file.readAsString());
  }

  Future<void> _evictOldest() async {
    final files = directory.listSync().whereType<File>().toList();
    if (files.length <= maxEntries) return;
    files.sort((a, b) => a.lastModifiedSync().compareTo(b.lastModifiedSync()));
    for (final file in files.take(files.length - maxEntries)) {
      await file.delete();
    }
  }

  File _fileFor(Uri uri) =>
      File('${directory.path}/${_fnv1a(uri.toString())}.json');

  /// Stable 64-bit FNV-1a hash, so a URL always maps to the same file name.
  static String _fnv1a(String text) {
    var hash = 0xcbf29ce484222325;
    for (final unit in utf8.encode(text)) {
      hash ^= unit;
      hash *= 0x100000001b3; // wraps at 64 bits
    }
    return hash.toUnsigned(64).toRadixString(16);
  }

  /// A broken cache must never break a request: on any file error the
  /// request goes on as if there were no cache.
  static Future<T?> _guard<T>(Future<T> Function() body) async {
    try {
      return await body();
    } on Object {
      return null;
    }
  }
}
