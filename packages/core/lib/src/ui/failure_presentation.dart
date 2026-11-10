import 'package:flutter/material.dart';

import '../error/failure.dart';
import '../strings/app_strings.dart';

/// User-facing copy and icon for each [Failure].
///
/// `Failure` (in `types.dart`) carries no text; screens keep the `Failure` in
/// their state and turn it into [AppStrings] here, so every case gets its own
/// title and icon.
extension FailurePresentation on Failure {
  /// Short heading for full-screen error states.
  String get title => switch (this) {
    NetworkFailure() => AppStrings.failureTitleNetwork,
    TooManyRequestsFailure() => AppStrings.failureTitleTooManyRequests,
    NotFoundFailure() => AppStrings.failureTitleNotFound,
    _ => AppStrings.failureTitleGeneric,
  };

  /// One-sentence explanation, also used in snackbars and inline errors.
  String get message => switch (this) {
    NotFoundFailure() => AppStrings.failureNotFound,
    NetworkFailure() => AppStrings.failureNetwork,
    TooManyRequestsFailure() => AppStrings.failureTooManyRequests,
    ServerFailure(:final statusCode?) => AppStrings.failureServerWithStatus(
      statusCode,
    ),
    ServerFailure() => AppStrings.failureServer,
    CancelledFailure() => AppStrings.failureCancelled,
    CacheFailure() => AppStrings.failureCache,
    UnexpectedFailure() => AppStrings.failureUnexpected,
  };

  IconData get icon => switch (this) {
    NetworkFailure() => Icons.wifi_off,
    TooManyRequestsFailure() => Icons.hourglass_empty,
    NotFoundFailure() => Icons.search_off,
    CacheFailure() => Icons.sd_card_alert_outlined,
    _ => Icons.cloud_off_outlined,
  };
}
