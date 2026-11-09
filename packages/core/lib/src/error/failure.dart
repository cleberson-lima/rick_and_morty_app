import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Domain-level error. API and storage calls return `Result<T>` and never
/// throw, so presentation can map each case to a dedicated screen state.
///
/// It carries no user-facing text: the presentation layer turns it into
/// copy and icons (see `FailurePresentation` in `core.dart`).
@freezed
sealed class Failure with _$Failure {
  /// The API answered 404 ("There is nothing here"): the search matched nothing.
  const factory Failure.notFound() = NotFoundFailure;

  /// No connection, DNS failure or timeout.
  const factory Failure.network() = NetworkFailure;

  /// The API answered 429: too many requests in a short time, even after
  /// the automatic retries in `RateLimitRetryInterceptor`.
  const factory Failure.tooManyRequests() = TooManyRequestsFailure;

  /// The API answered with another error status.
  const factory Failure.server({int? statusCode}) = ServerFailure;

  /// The request was cancelled because a newer one replaced it.
  const factory Failure.cancelled() = CancelledFailure;

  /// Reading or writing local storage failed.
  const factory Failure.cache() = CacheFailure;

  const factory Failure.unexpected() = UnexpectedFailure;
}
