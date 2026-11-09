import 'package:flutter/material.dart';

import '../error/failure.dart';

/// User-facing copy and icon for each [Failure].
///
/// `Failure` lives in the domain and carries no text; screens keep the
/// `Failure` in their state and translate it here, so every case can get its
/// own title and icon (and, later, localized strings).
extension FailurePresentation on Failure {
  /// Short heading for full-screen error states.
  String get title => switch (this) {
    NetworkFailure() => 'Sem conexão',
    TooManyRequestsFailure() => 'Muitas requisições',
    NotFoundFailure() => 'Nada encontrado',
    _ => 'Ops! Algo deu errado',
  };

  /// One-sentence explanation, also used in snackbars and inline errors.
  String get message => switch (this) {
    NotFoundFailure() => 'Nada encontrado.',
    NetworkFailure() =>
      'Sem conexão com a internet. Verifique sua rede e tente novamente.',
    TooManyRequestsFailure() =>
      'Muitas requisições em pouco tempo. Aguarde alguns segundos e tente novamente.',
    ServerFailure(:final statusCode) =>
      'O servidor respondeu com erro${statusCode != null ? ' ($statusCode)' : ''}. Tente novamente.',
    CancelledFailure() => 'Requisição cancelada.',
    CacheFailure() => 'Não foi possível acessar os dados salvos.',
    UnexpectedFailure() => 'Algo deu errado. Tente novamente.',
  };

  IconData get icon => switch (this) {
    NetworkFailure() => Icons.wifi_off,
    TooManyRequestsFailure() => Icons.hourglass_empty,
    NotFoundFailure() => Icons.search_off,
    CacheFailure() => Icons.sd_card_alert_outlined,
    _ => Icons.cloud_off_outlined,
  };
}
