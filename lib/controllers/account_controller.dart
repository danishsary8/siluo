import 'package:get/get.dart';

import '../core/network/load_status.dart';
import '../core/network/result.dart';
import '../core/utils/haptic_service.dart';
import '../data/mock/mock_api_client.dart';
import '../data/models/account_models.dart';
import '../data/repositories/account_repository.dart';

// Re-exported so existing `import 'account_controller.dart'` call sites keep
// access to the account models.
export '../data/models/account_models.dart';

/// Holds the signed-in shopper's account data: addresses, body
/// measurements, inbox messages and order history.
///
/// Remote data is loaded through [AccountRepository]; edits are applied
/// locally (optimistic) until write endpoints exist on the backend.
class AccountController extends GetxController {
  /// Creates the controller. Pass a [repository] to use a real API client;
  /// it defaults to the demo [MockApiClient].
  AccountController({AccountRepository? repository})
      : _repository = repository ?? AccountRepository(MockApiClient());

  final AccountRepository _repository;

  static AccountController get to => Get.find<AccountController>();

  /// Load state of the remote account data.
  final Rx<LoadStatus> status = LoadStatus.loading.obs;

  /// User-facing message for the last failed load, if any.
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  /// Loads addresses, inbox and orders in parallel. Safe to call again to
  /// retry after a failure.
  Future<void> load() async {
    status.value = LoadStatus.loading;
    errorMessage.value = null;
    final results = await Future.wait([
      _repository.fetchAddresses(),
      _repository.fetchInbox(),
      _repository.fetchOrders(),
    ]);
    if (isClosed) return;

    final failure = results.whereType<Failure<Object?>>().firstOrNull;
    if (results[0] case Success(:final List<SavedAddress> value)) {
      addresses.assignAll(value);
      if (addresses.isNotEmpty && defaultAddress?.id != defaultAddressId.value) {
        defaultAddressId.value = addresses.first.id;
      }
    }
    if (results[1] case Success(:final List<InboxMessage> value)) inbox.assignAll(value);
    if (results[2] case Success(:final List<OrderSummary> value)) orders.assignAll(value);

    status.value = failure == null ? LoadStatus.ready : LoadStatus.error;
    errorMessage.value = failure?.failure.message;
  }

  // ---------------- Addresses ----------------
  /// Saved delivery addresses (`GET /me/addresses`).
  final RxList<SavedAddress> addresses = <SavedAddress>[].obs;
  final RxString defaultAddressId = 'a1'.obs;

  SavedAddress? get defaultAddress =>
      addresses.firstWhereOrNull((a) => a.id == defaultAddressId.value) ??
      addresses.firstOrNull;

  void setDefaultAddress(String id) {
    HapticService.selection();
    defaultAddressId.value = id;
  }

  void saveAddress(SavedAddress address) {
    final i = addresses.indexWhere((a) => a.id == address.id);
    if (i == -1) {
      addresses.add(address);
      if (addresses.length == 1) defaultAddressId.value = address.id;
    } else {
      addresses[i] = address;
    }
    HapticService.success();
  }

  void deleteAddress(String id) {
    addresses.removeWhere((a) => a.id == id);
    if (defaultAddressId.value == id && addresses.isNotEmpty) {
      defaultAddressId.value = addresses.first.id;
    }
    HapticService.medium();
  }

  // ---------------- Measurements (cm) ----------------
  final RxMap<String, double> measurements = <String, double>{
    'Height': 172,
    'Bust': 84,
    'Waist': 66,
    'Hips': 92,
    'Inseam': 78,
    'Shoulder': 39,
  }.obs;
  final RxString preferredFit = 'Regular'.obs;

  String get measurementSummary =>
      'Bust ${measurements['Bust']!.round()}cm • '
      'Waist ${measurements['Waist']!.round()}cm • '
      'Hips ${measurements['Hips']!.round()}cm';

  /// Simple size recommendation from bust + hips.
  String get recommendedSize {
    final b = measurements['Bust']!;
    final h = measurements['Hips']!;
    final avg = (b + h) / 2;
    if (avg < 84) return 'XS';
    if (avg < 90) return 'S';
    if (avg < 97) return 'M';
    if (avg < 104) return 'L';
    return 'XL';
  }

  void updateMeasurement(String key, double value) {
    measurements[key] = value;
  }

  // ---------------- Inbox ----------------
  /// Inbox messages, newest first (`GET /me/notifications`).
  final RxList<InboxMessage> inbox = <InboxMessage>[].obs;

  int get unreadCount => inbox.where((m) => !m.isRead).length;

  void markRead(String id) {
    final m = inbox.firstWhereOrNull((m) => m.id == id);
    if (m != null && !m.isRead) {
      m.isRead = true;
      inbox.refresh();
    }
  }

  void markAllRead() {
    for (final m in inbox) {
      m.isRead = true;
    }
    inbox.refresh();
    HapticService.success();
  }

  InboxMessage? removeMessage(String id) {
    final i = inbox.indexWhere((m) => m.id == id);
    if (i == -1) return null;
    HapticService.light();
    return inbox.removeAt(i);
  }

  void restoreMessage(InboxMessage m) {
    inbox.add(m);
    inbox.sort((a, b) => b.time.compareTo(a.time));
  }

  // ---------------- Orders ----------------
  /// Past orders (`GET /me/orders`).
  final RxList<OrderSummary> orders = <OrderSummary>[].obs;
}
