import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'offline_cache_interceptor.dart';
import 'offline_status.dart';
import 'rate_limit_retry_interceptor.dart';

abstract final class ApiConfig {
  static const baseUrl = 'https://rickandmortyapi.com/api';
  static const timeout = Duration(seconds: 15);
}

/// API client: base URL, timeouts, retry on 429 and, when [cacheDirectory]
/// is given, the offline fallback of [OfflineCacheInterceptor], which reports
/// to [offlineStatus] whether the data came from the cache.
Dio createDio({
  String baseUrl = ApiConfig.baseUrl,
  Directory? cacheDirectory,
  OfflineStatus? offlineStatus,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: ApiConfig.timeout,
      receiveTimeout: ApiConfig.timeout,
      responseType: ResponseType.json,
    ),
  );
  dio.interceptors.add(RateLimitRetryInterceptor(dio));
  if (cacheDirectory != null) {
    dio.interceptors.add(
      OfflineCacheInterceptor(cacheDirectory, status: offlineStatus),
    );
  }
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        logPrint: (line) => debugPrint(line.toString()),
      ),
    );
  }
  return dio;
}
