import '../models/account_models.dart';

// Demo account data served by MockApiClient until the real backend exists.
// Shapes mirror the `/me/*` endpoints documented in docs/API.md.

/// Seed for `GET /me/addresses`.
const List<SavedAddress> mockAddresses = [
  SavedAddress(
    id: 'a1',
    label: 'Home',
    fullName: 'Sary Danish',
    line1: '14 Rue de la Paix, 1er Arrondissement',
    city: 'Paris',
    postcode: '75001',
    country: 'France',
    phone: '+33 6 12 34 56 78',
  ),
  SavedAddress(
    id: 'a2',
    label: 'Studio',
    fullName: 'Sary Danish',
    line1: '8 Via Montenapoleone',
    city: 'Milan',
    postcode: '20121',
    country: 'Italy',
    phone: '+39 347 555 0192',
  ),
];

/// Seed for `GET /me/notifications`. A function so the relative timestamps
/// ("18 minutes ago") are computed when requested.
List<InboxMessage> mockInbox() => [
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
    ];

/// Seed for `GET /me/orders`.
const List<OrderSummary> mockOrders = [
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
