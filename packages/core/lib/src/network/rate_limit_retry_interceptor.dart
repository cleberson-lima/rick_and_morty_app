import 'dart:async';
import 'dart:math' as math;

import 'package:dio/dio.dart';

/// Retries requests the API rejected with **429 Too Many Requests**.
///
/// Scrolling to the end of a long list fires dozens of page requests (plus
/// one avatar per character) at the same host within seconds, and Cloudflare
/// starts answering 429. Instead of surfacing an error right away, wait and
/// retry: `Retry-After` seconds when the server sends it, otherwise
/// exponential backoff ([baseDelay], 2×, 4×…), up to [maxRetries] times.
/// If it still fails, the 429 propagates and becomes `Failure.tooManyRequests`.
class RateLimitRetryInterceptor extends Interceptor {
  RateLimitRetryInterceptor(
    this._dio, {
    this.maxRetries = 3,
    this.baseDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 10),
    Future<void> Function(Duration delay)? wait,
  }) : _wait = wait ?? Future<void>.delayed;

  static const _attemptKey = 'rate_limit_retry_attempt';

  final Dio _dio;
  final int maxRetries;
  final Duration baseDelay;
  final Duration maxDelay;
  final Future<void> Function(Duration delay) _wait;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final attempt = (options.extra[_attemptKey] as int?) ?? 0;
    final isRateLimited = err.response?.statusCode == 429;
    final cancelled = options.cancelToken?.isCancelled ?? false;
    if (!isRateLimited || attempt >= maxRetries || cancelled) {
      return handler.next(err);
    }

    await _wait(_delayFor(err.response!, attempt));
    if (options.cancelToken?.isCancelled ?? false) {
      return handler.next(err); // a newer search replaced this one meanwhile
    }

    options.extra[_attemptKey] = attempt + 1;
    try {
      handler.resolve(await _dio.fetch<dynamic>(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Duration _delayFor(Response<dynamic> response, int attempt) {
    final retryAfter = int.tryParse(
      response.headers.value('retry-after')?.trim() ?? '',
    );
    final delay = retryAfter != null
        ? Duration(seconds: retryAfter)
        : baseDelay * math.pow(2, attempt).toInt();
    return delay > maxDelay ? maxDelay : delay;
  }
}
