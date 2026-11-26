import 'json_utils.dart';

/// A saved delivery address (`GET /me/addresses`).
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

  /// Short name chosen by the shopper, e.g. `Home` or `Studio`.
  final String label;
  final String fullName;
  final String line1;
  final String city;
  final String postcode;
  final String country;
  final String phone;

  /// Street, city and postcode on one line.
  String get oneLine => '$line1, $city, $postcode';

  /// Street on the first line; city, postcode and country on the second.
  String get twoLines => '$line1\n$city, $postcode, $country';

  /// Parses one item of `GET /me/addresses`.
  factory SavedAddress.fromJson(JsonMap json) => SavedAddress(
        id: json.str('id'),
        label: json.str('label'),
        fullName: json.str('fullName'),
        line1: json.str('line1'),
        city: json.str('city'),
        postcode: json.str('postcode'),
        country: json.str('country'),
        phone: json.str('phone'),
      );

  /// Serialises to the API JSON shape.
  JsonMap toJson() => {
        'id': id,
        'label': label,
        'fullName': fullName,
        'line1': line1,
        'city': city,
        'postcode': postcode,
        'country': country,
        'phone': phone,
      };

  /// Copy with the given fields replaced; [id] never changes.
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

/// What an inbox message is about; drives its icon, colour and filter chip.
enum InboxCategory {
  order,
  drop,
  offer,
  atelier;

  /// Parses the API's lowercase category name.
  static InboxCategory fromJson(String value) => InboxCategory.values.firstWhere(
        (c) => c.name == value,
        orElse: () => throw FormatException('Unknown inbox category "$value"'),
      );
}

/// One message in the in-app inbox (`GET /me/notifications`).
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

  /// When the message was sent.
  final DateTime time;

  /// Mutable so the inbox can mark messages read locally before syncing.
  bool isRead;

  /// Parses one item of `GET /me/notifications`.
  factory InboxMessage.fromJson(JsonMap json) => InboxMessage(
        id: json.str('id'),
        category: InboxCategory.fromJson(json.str('category')),
        title: json.str('title'),
        body: json.str('body'),
        time: json.dateTime('sentAt'),
        isRead: json.boolOr('isRead'),
      );

  /// Serialises to the API JSON shape.
  JsonMap toJson() => {
        'id': id,
        'category': category.name,
        'title': title,
        'body': body,
        'sentAt': time.toUtc().toIso8601String(),
        'isRead': isRead,
      };
}

/// A past order shown in the order history (`GET /me/orders`).
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

  /// Display date as sent by the server (already localised).
  final String date;

  /// One-line summary of the items, e.g. `2x Merino Crew Knit`.
  final String items;

  /// Order total in USD; converted for display by the currency setting.
  final double total;

  /// One of `In Transit`, `Delivered`, `Returned`.
  final String status;
  final String imageUrl;
  final bool delivered;

  /// Parses one item of `GET /me/orders`.
  factory OrderSummary.fromJson(JsonMap json) => OrderSummary(
        id: json.str('id'),
        date: json.str('date'),
        items: json.str('items'),
        total: json.dbl('total'),
        status: json.str('status'),
        imageUrl: json.str('imageUrl'),
        delivered: json.boolOr('delivered'),
      );

  /// Serialises to the API JSON shape.
  JsonMap toJson() => {
        'id': id,
        'date': date,
        'items': items,
        'total': total,
        'status': status,
        'imageUrl': imageUrl,
        'delivered': delivered,
      };
}
