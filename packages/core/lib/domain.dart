/// Pure-Dart building blocks for the `domain` layer of every feature.
/// Safe to import from domain code: no Flutter, no Dio.
library;

export 'package:dartz/dartz.dart'
    show Either, Left, Right, Unit, left, right, unit;

export 'src/domain/page_result.dart';
export 'src/domain/resource_type.dart';
export 'src/error/failure.dart';
