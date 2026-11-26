import 'package:get/get.dart';

import '../core/utils/haptic_service.dart';

/// A saved delivery address.
class SavedAddress {
  const SavedAddress({
    required this.id,
    required this.label,
    required this.fullName,
    required this.line1,
    required this.city,
    required this.postcode,
    required this.country,
    required this.phone,
  });

  final String id;
  final String label;
  final String fullName;
  final String line1;
  final String city;
  final String postcode;
  final String country;
  final String phone;

  String get oneLine => '$line1, $city, $postcode';
  String get twoLines => '$line1\n$city, $postcode, $country';

  SavedAddress copyWith({
    String? label,
    String? fullName,
    String? line1,
    String? city,
    String? postcode,
    String? country,
    String? phone,
  }) =>
      SavedAddress(
        id: id,
        label: label ?? this.label,
        fullName: fullName ?? this.fullName,
        line1: line1 ?? this.line1,
        city: city ?? this.city,
        postcode: postcode ?? this.postcode,
        country: country ?? this.country,
        phone: phone ?? this.phone,
      );
}

enum InboxCategory { order, drop, offer, atelier }

/// One message in the in-app inbox.
class InboxMessage {
  InboxMessage({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
  });

  final String id;
  final InboxCategory category;
  final String title;
  final String body;
  final DateTime time;
  bool isRead;
}

/// A past order shown in the order history page.
class OrderSummary {
  const OrderSummary({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    required this.status,
    required this.imageUrl,
    this.delivered = false,
  });

  final String id;
  final String date;
  final String items;
  final double total;
  final String status;
  final String imageUrl;
  final bool delivered;
}

/// Holds the signed-in shopper's account data: addresses, body
/// measurements, inbox messages and order history (all local demo data).
class AccountController extends GetxController {
  static AccountController get to => Get.find<AccountController>();

  // ---------------- Addresses ----------------
  final RxList<SavedAddress> addresses = <SavedAddress>[
    const SavedAddress(
      id: 'a1',
      label: 'Home',
      fullName: 'Sary Danish',
      line1: '14 Rue de la Paix, 1er Arrondissement',
      city: 'Paris',
      postcode: '75001',
      country: 'France',
      phone: '+33 6 12 34 56 78',
    ),
    const SavedAddress(
      id: 'a2',
      label: 'Studio',
      fullName: 'Sary Danish',
      line1: '8 Via Montenapoleone',
      city: 'Milan',
      postcode: '20121',
      country: 'Italy',
      phone: '+39 347 555 0192',
    ),
  ].obs;
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
  final RxList<InboxMessage> inbox = <InboxMessage>[
    InboxMessage(
      id: 'n1',
      category: InboxCategory.order,
      title: 'Your trench coat is on its way',
      body: 'Order #ATL-894201 left our Paris workshop. Track it live in your profile.',
      time: DateTime.now().subtract(const Duration(minutes: 18)),
    ),
    InboxMessage(
      id: 'n2',
      category: InboxCategory.drop,
      title: 'New drop: Winter Capsule 26',
      body: '24 new pieces just landed — wool, cashmere and technical outerwear.',
      time: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    InboxMessage(
      id: 'n3',
      category: InboxCategory.offer,
      title: '20% off with code SILOU20',
      body: 'Members get an extra 20% on full-price items until Sunday midnight.',
      time: DateTime.now().subtract(const Duration(hours: 9)),
    ),
    InboxMessage(
      id: 'n4',
      category: InboxCategory.atelier,
      title: 'Salon fitting confirmed',
      body: 'See you Thursday at 15:00 in our Paris salon. Champagne is on us.',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    InboxMessage(
      id: 'n5',
      category: InboxCategory.order,
      title: 'Delivered: Silk slip dress',
      body: 'Order #ATL-781932 was delivered. How does it fit? Leave a review.',
      time: DateTime.now().subtract(const Duration(days: 4)),
      isRead: true,
    ),
  ].obs;

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
  final List<OrderSummary> orders = const [
    OrderSummary(
      id: '#ATL-894201',
      date: 'Yesterday, 14:20',
      items: '1x Double-Breasted Wool Trench (S)',
      total: 389.00,
      status: 'In Transit',
      imageUrl:
          'https://images.unsplash.com/photo-1539533018447-63fcce2678e3?auto=format&fit=crop&w=300&q=70',
    ),
    OrderSummary(
      id: '#ATL-781932',
      date: 'Sep 18, 2026',
      items: '1x Bias-Cut Silk Slip Dress (M)',
      total: 245.00,
      status: 'Delivered',
      delivered: true,
      imageUrl:
          'https://images.unsplash.com/photo-1595777457583-95e059d581b8?auto=format&fit=crop&w=300&q=70',
    ),
    OrderSummary(
      id: '#ATL-650417',
      date: 'Aug 02, 2026',
      items: '2x Merino Crew Knit, 1x Leather Loafers',
      total: 412.50,
      status: 'Delivered',
      delivered: true,
      imageUrl:
          'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?auto=format&fit=crop&w=300&q=70',
    ),
    OrderSummary(
      id: '#ATL-512098',
      date: 'Jun 21, 2026',
      items: '1x Canvas Tote Bag',
      total: 89.00,
      status: 'Returned',
      delivered: true,
      imageUrl:
          'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=300&q=70',
    ),
  ];
}
