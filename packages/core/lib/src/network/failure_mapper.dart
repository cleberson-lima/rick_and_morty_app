import 'dart:io';

import 'package:dio/dio.dart';

import '../error/failure.dart';

/// Converts anything thrown by the data layer into a [Failure].
Failure mapExceptionToFailure(Object error) {
  if (error is DioException) {
    return switch (error.type) {
      DioExceptionType.cancel => const Failure.cancelled(),
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.transformTimeout ||
      DioExceptionType.connectionError => const Failure.network(),
      DioExceptionType.badResponse => switch (error.response?.statusCode) {
        404 => const Failure.notFound(),
        429 => const Failure.tooManyRequests(),
        final status => Failure.server(statusCode: status),
      },
      DioExceptionType.badCertificate => const Failure.network(),
      DioExceptionType.unknown =>
        error.error is SocketException
            ? const Failure.network()
            : const Failure.unexpected(),
    };
  }
  if (error is SocketException) return const Failure.network();
  return const Failure.unexpected();
}

/// Extracts the page number from the API's `info.next` URL
/// (e.g. `https://rickandmortyapi.com/api/character/?page=2&name=rick`).
int? parseNextPage(String? nextUrl) {
  if (nextUrl == null) return null;
  final page = Uri.tryParse(nextUrl)?.queryParameters['page'];
  return page == null ? null : int.tryParse(page);
}
