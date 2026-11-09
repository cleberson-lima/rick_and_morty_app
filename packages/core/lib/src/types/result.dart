import 'dart:developer' as developer;

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
  ///
  /// Exceptions that become an [UnexpectedFailure] or a [CacheFailure] point
  /// to a bug or a broken device (e.g. a `TypeError` after the API changed its
  /// JSON), so they also go to [reportError]. Network, HTTP status and
  /// cancellation failures are expected and are not reported.
  static Future<Result<T>> guard<T>(
    Future<T> Function() body, {
    required Failure Function(Object error) toFailure,
  }) async {
    try {
      return Success(await body());
    } catch (error, stackTrace) {
      final failure = toFailure(error);
      if (failure is UnexpectedFailure || failure is CacheFailure) {
        reportError(error, stackTrace);
      }
      return Failed(failure);
    }
  }

  /// Receives the exceptions [guard] reports. Logs them by default; replace it
  /// to send them to a crash reporting service.
  static ErrorReporter reportError = logError;
}

/// Receives an exception that should not have happened, with its stack trace.
typedef ErrorReporter = void Function(Object error, StackTrace stackTrace);

/// Default [Result.reportError]: writes to the `dart:developer` log, shown in
/// the IDE console and in DevTools.
void logError(Object error, StackTrace stackTrace) => developer.log(
  'Unexpected error',
  name: 'core.Result',
  error: error,
  stackTrace: stackTrace,
);

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
