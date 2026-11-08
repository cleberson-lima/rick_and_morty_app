import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'rate_limit_retry_interceptor.dart';

abstract final class ApiConfig {
  static const baseUrl = 'https://rickandmortyapi.com/api';
  static const timeout = Duration(seconds: 15);
}

Dio createDio({String baseUrl = ApiConfig.baseUrl}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: ApiConfig.timeout,
      receiveTimeout: ApiConfig.timeout,
      responseType: ResponseType.json,
    ),
  );
  dio.interceptors.add(RateLimitRetryInterceptor(dio));
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
