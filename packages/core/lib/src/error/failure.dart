import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Domain-level error. Repositories return `Either<Failure, T>` and never
/// throw, so presentation can map each case to a dedicated screen state.
@freezed
sealed class Failure with _$Failure {
  const Failure._();

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
}
