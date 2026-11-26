/// Typed reasons an operation can fail, each with a plain-language [message]
/// that is safe to show to shoppers (no stack traces or server internals).
sealed class AppFailure {
  const AppFailure();

  /// User-facing explanation of what went wrong and what to do next.
  String get message;
}

/// The device could not reach the server (offline, DNS, timeout).
final class NetworkFailure extends AppFailure {
  const NetworkFailure();

  @override
  String get message => 'You appear to be offline. Check your connection and try again.';
}

/// The server answered with an error status (5xx, or an unexpected 4xx).
final class ServerFailure extends AppFailure {
  const ServerFailure(this.statusCode);

  /// HTTP status code returned by the server.
  final int statusCode;

  @override
  String get message => 'Something went wrong on our side ($statusCode). Please try again in a moment.';
}

/// The requested resource does not exist (HTTP 404).
final class NotFoundFailure extends AppFailure {
  const NotFoundFailure(this.resource);

  /// Human-readable name of what was requested, e.g. `product zd_w_01`.
  final String resource;

  @override
  String get message => 'We couldn\'t find $resource. It may have been removed.';
}

/// The server answered, but the payload did not match the expected shape.
final class ParseFailure extends AppFailure {
  const ParseFailure(this.details);

  /// Developer-facing description of the mismatch (logged, not shown).
  final String details;

  @override
  String get message => 'We received data we couldn\'t read. Please update the app or try again later.';
}

/// Any other unexpected error.
final class UnknownFailure extends AppFailure {
  const UnknownFailure(this.error);

  /// The original error, kept for logging.
  final Object error;

  @override
  String get message => 'Something unexpected happened. Please try again.';
}
