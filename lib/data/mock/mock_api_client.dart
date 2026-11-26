import 'dart:convert';

import '../../core/network/api_client.dart';
import 'mock_account_data.dart';
import 'mock_atelier_data.dart';

/// In-memory [ApiClient] that serves the demo catalogue and account data as
/// JSON, exactly as the REST backend described in `docs/API.md` will.
///
/// Responses are round-tripped through `jsonEncode`/`jsonDecode`, so the app
/// parses the same untyped maps and lists it will get from a real server.
///
/// Swap it for an HTTP implementation in `main.dart` once the backend exists.
class MockApiClient implements ApiClient {
  MockApiClient({this.latency = Duration.zero, this.failure});

  /// Artificial delay before each response (useful to preview loading UI).
  final Duration latency;

  /// When set, every request throws this instead of responding (for tests).
  final ApiException? failure;

  @override
  Future<Object?> get(String path, {Map<String, String>? query}) async {
    await _simulateNetwork();
    final segments = Uri.parse(path).pathSegments;
    final body = switch (segments) {
      ['products'] => mockAtelierProducts.map((p) => p.toJson()).toList(),
      ['products', final id] => mockAtelierProducts
          .where((p) => p.id == id)
          .map((p) => p.toJson())
          .firstOrNull ??
          (throw ApiException(statusCode: 404, message: 'Product $id not found')),
      ['home', 'stories'] => mockStories.map((s) => s.toJson()).toList(),
      ['home', 'campaigns'] => mockCapsules.map((c) => c.toJson()).toList(),
      ['me', 'addresses'] => mockAddresses.map((a) => a.toJson()).toList(),
      ['me', 'notifications'] => mockInbox().map((m) => m.toJson()).toList(),
      ['me', 'orders'] => mockOrders.map((o) => o.toJson()).toList(),
      _ => throw ApiException(statusCode: 404, message: 'No route for GET $path'),
    };
    return _asWireJson(body);
  }

  @override
  Future<Object?> post(String path, {Object? body}) async {
    await _simulateNetwork();
    throw ApiException(statusCode: 501, message: 'POST $path is not available in demo mode');
  }

  Future<void> _simulateNetwork() async {
    if (latency > Duration.zero) await Future<void>.delayed(latency);
    final error = failure;
    if (error != null) throw error;
  }

  /// Encodes and decodes [value] so callers receive plain JSON types.
  static Object? _asWireJson(Object? value) => jsonDecode(jsonEncode(value));
}
