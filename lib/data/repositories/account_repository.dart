import '../../core/network/api_client.dart';
import '../../core/network/result.dart';
import '../models/account_models.dart';
import '../models/json_utils.dart';
import 'repository_guard.dart';

/// Read access to the signed-in shopper's account (`/me/*` endpoints).
///
/// Every method returns a [Result] instead of throwing.
class AccountRepository {
  const AccountRepository(this._api);

  final ApiClient _api;

  /// Saved delivery addresses (`GET /me/addresses`).
  Future<Result<List<SavedAddress>>> fetchAddresses() => guardRequest(
        'your addresses',
        () async => asJsonList(await _api.get('/me/addresses'), '/me/addresses').map(SavedAddress.fromJson).toList(),
      );

  /// Inbox messages, newest first (`GET /me/notifications`).
  Future<Result<List<InboxMessage>>> fetchInbox() => guardRequest(
        'your inbox',
        () async {
          final messages =
              asJsonList(await _api.get('/me/notifications'), '/me/notifications').map(InboxMessage.fromJson).toList();
          return messages..sort((a, b) => b.time.compareTo(a.time));
        },
      );

  /// Past orders, newest first as sent by the server (`GET /me/orders`).
  Future<Result<List<OrderSummary>>> fetchOrders() => guardRequest(
        'your orders',
        () async => asJsonList(await _api.get('/me/orders'), '/me/orders').map(OrderSummary.fromJson).toList(),
      );
}
