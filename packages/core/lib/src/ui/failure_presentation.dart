import 'package:flutter/material.dart';

import '../error/failure.dart';
import '../l10n/generated/app_localizations.dart';

/// User-facing copy and icon for each [Failure].
///
/// `Failure` (in `types.dart`) carries no text; screens keep the `Failure` in
/// their state and translate it here with the app's [AppLocalizations]
/// (`context.l10n`), so every case gets its own title and icon.
extension FailurePresentation on Failure {
  /// Short heading for full-screen error states.
  String title(AppLocalizations l10n) => switch (this) {
    NetworkFailure() => l10n.failureTitleNetwork,
    TooManyRequestsFailure() => l10n.failureTitleTooManyRequests,
    NotFoundFailure() => l10n.failureTitleNotFound,
    _ => l10n.failureTitleGeneric,
  };

  /// One-sentence explanation, also used in snackbars and inline errors.
  String message(AppLocalizations l10n) => switch (this) {
    NotFoundFailure() => l10n.failureNotFound,
    NetworkFailure() => l10n.failureNetwork,
    TooManyRequestsFailure() => l10n.failureTooManyRequests,
    ServerFailure(:final statusCode?) => l10n.failureServerWithStatus(
      statusCode,
    ),
    ServerFailure() => l10n.failureServer,
    CancelledFailure() => l10n.failureCancelled,
    CacheFailure() => l10n.failureCache,
    UnexpectedFailure() => l10n.failureUnexpected,
  };

  IconData get icon => switch (this) {
    NetworkFailure() => Icons.wifi_off,
    TooManyRequestsFailure() => Icons.hourglass_empty,
    NotFoundFailure() => Icons.search_off,
    CacheFailure() => Icons.sd_card_alert_outlined,
    _ => Icons.cloud_off_outlined,
  };
}
