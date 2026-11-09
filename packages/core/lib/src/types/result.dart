import '../error/failure.dart';

/// Outcome of a call that can fail: either [Success] with the [Success.data],
/// or [Failed] with the [Failed.failure]. API and storage classes return it
/// instead of throwing, and callers handle both cases with a `switch`:
///
/// ```dart
/// switch (await api.getCharacter(1)) {
///   case Success(:final data): ...
///   case Failed(:final failure): ...
/// }
/// ```
sealed class Result<T> {
  const Result();

  /// Runs [body] and turns any exception into a [Failed] with
  /// [toFailure] of it.
  static Future<Result<T>> guard<T>(
    Future<T> Function() body, {
    required Failure Function(Object error) toFailure,
  }) async {
    try {
      return Success(await body());
    } catch (error) {
      return Failed(toFailure(error));
    }
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  bool operator ==(Object other) => other is Success && other.data == data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

/// Equal to any other [Failed] with the same [failure], whatever its `T`.
final class Failed<T> extends Result<T> {
  const Failed(this.failure);

  final Failure failure;

  @override
  bool operator ==(Object other) => other is Failed && other.failure == failure;

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'Failed($failure)';
}
