import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

Map<String, Object?> fixture(String name) =>
    jsonDecode(File('test/fixtures/$name').readAsStringSync())
        as Map<String, Object?>;

/// Dio adapter that answers from a handler, so tests exercise Dio's real
/// decoding, status validation and cancellation instead of mocking `get`.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.handler);

  final Future<ResponseBody> Function(RequestOptions options) handler;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    requests.add(options);
    final response = handler(options);
    final cancelled = options.cancelToken?.whenCancel ?? cancelFuture;
    if (cancelled == null) return response;
    return Future.any([
      response,
      cancelled.then<ResponseBody>(
        (_) => throw DioException.requestCancelled(
          requestOptions: options,
          reason: 'cancelled',
        ),
      ),
    ]);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody jsonBody(Object? body, {int status = 200}) =>
    ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

Dio dioWith(FakeAdapter adapter) =>
    Dio(BaseOptions(baseUrl: 'https://api.test'))..httpClientAdapter = adapter;

/// Stand-in for the app's [FavoriteButtonScope]: every [FavoriteSlot] below
/// [wrap] renders a heart (filled for [favorites]) that records its taps.
class FakeFavorites {
  FakeFavorites({this.favorites = const []});

  final List<FavoriteItem> favorites;
  final List<FavoriteItem> tapped = [];

  Widget wrap(Widget child) => FavoriteButtonScope(
    builder: (context, item, {compact = false}) {
      final isFavorite = favorites.containsResource(item.type, item.id);
      return IconButton(
        tooltip: isFavorite
            ? 'Remover dos favoritos'
            : 'Adicionar aos favoritos',
        icon: Icon(
          isFavorite ? PhosphorIconsFill.heart : PhosphorIconsRegular.heart,
        ),
        onPressed: () => tapped.add(item),
      );
    },
    child: child,
  );
}
