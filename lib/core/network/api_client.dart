/// Transport-level contract for talking to the SILOU REST API.
///
/// The app depends only on this interface. Today it is served by
/// `MockApiClient` (local demo data); when the backend exists, add an
/// HTTP implementation (for example with `package:http` or `dio`) that maps
/// responses to the same JSON shapes documented in `docs/API.md`, and register
/// it in `main.dart` instead. Nothing else in the app needs to change.
abstract interface class ApiClient {
  /// Sends `GET {baseUrl}{path}` and returns the decoded JSON body.
  ///
  /// Throws [ApiException] for non-2xx responses and network errors.
  Future<Object?> get(String path, {Map<String, String>? query});

  /// Sends `POST {baseUrl}{path}` with a JSON [body] and returns the decoded
  /// JSON response.
  ///
  /// Throws [ApiException] for non-2xx responses and network errors.
  Future<Object?> post(String path, {Object? body});
}

/// Error raised by an [ApiClient] for failed requests.
///
/// [statusCode] is `null` when no response was received (offline, timeout).
class ApiException implements Exception {
  const ApiException({this.statusCode, required this.message});

  /// HTTP status code, or `null` for network-level failures.
  final int? statusCode;

  /// Developer-facing description, e.g. the server's error message.
  final String message;

  /// Whether no response was received at all.
  bool get isNetworkError => statusCode == null;

  @override
  String toString() => 'ApiException(${statusCode ?? 'network'}): $message';
}
