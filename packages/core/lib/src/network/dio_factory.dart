import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
