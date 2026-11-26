# SILOU REST API contract

The app is frontend-only today: every request below is answered by
`MockApiClient` (`lib/data/mock/mock_api_client.dart`) using local demo data.
This document is the contract the real backend should implement. When it
does, add an HTTP `ApiClient` and register it in `lib/main.dart`; no screen
or controller code needs to change.

## How the app talks to the API

```
Screens ──▶ Controllers (GetX) ──▶ Repositories ──▶ ApiClient ──▶ REST API
                 ▲                      │
                 └── Result<T> ◀────────┘   (never throws to the UI)
```

| Layer | Location | Responsibility |
| :--- | :--- | :--- |
| `ApiClient` | `lib/core/network/api_client.dart` | Sends requests, returns decoded JSON, throws `ApiException` on failure |
| Repositories | `lib/data/repositories/` | Map JSON → typed models; turn every error into a `Failure` |
| Models | `lib/data/models/` | `fromJson` / `toJson`; reject payloads that break this contract |
| Controllers | `lib/controllers/` | Expose `LoadStatus` (loading / ready / error) and a retry |

## Conventions

- **Base URL:** configurable (e.g. `https://api.silou.app/v1`). All paths below are relative to it.
- **Format:** JSON, UTF-8. Field names are `camelCase`.
- **Money:** decimal numbers in **USD** (e.g. `69.99`). The app converts for display with the shopper's currency setting.
- **Colours:** `#RRGGBB` hex strings.
- **Timestamps:** ISO-8601 in UTC (e.g. `2026-11-26T18:30:00Z`).
- **Auth (planned):** `/me/*` endpoints will require `Authorization: Bearer <token>`. They are open in demo mode.
- **Unknown fields** are ignored, so the backend can add fields without breaking older app versions.
- **Missing or wrongly typed required fields** are rejected (shown as "We received data we couldn't read").

## Errors

Non-2xx responses should return:

```json
{ "error": { "code": "product_not_found", "message": "Product zd_w_99 not found" } }
```

The app never shows `message` to shoppers. It maps the status to a friendly message:

| Situation | App failure | Shown to the shopper |
| :--- | :--- | :--- |
| No response (offline, timeout) | `NetworkFailure` | "You appear to be offline. Check your connection and try again." |
| `404` | `NotFoundFailure` | "We couldn't find … It may have been removed." |
| Other `4xx` / `5xx` | `ServerFailure` | "Something went wrong on our side (503). Please try again in a moment." |
| Body doesn't match this contract | `ParseFailure` | "We received data we couldn't read. …" |

## Catalogue

### `GET /products`

All products. Returns an array of **Product**.

### `GET /products/{id}`

One **Product**, or `404` if it doesn't exist.

**Product**

```json
{
  "id": "zd_w_01",
  "title": "Flowing Belted Trench Coat",
  "category": "Outerwear",
  "brand": "ZARA",
  "gender": "Women",
  "price": 69.99,
  "originalPrice": 129.99,
  "discountPercent": 46,
  "rating": 4.8,
  "reviewsCount": 384,
  "fabricCare": "65% Cotton, 35% Polyester. Machine wash 30°C delicate.",
  "sizeFitNotes": "Relaxed contemporary drape. Fits true to size. Model is 176cm wearing S.",
  "description": "Iconic double-breasted trench in lightweight structured cotton blend. Features storm flap, notched lapels, tort buckle belt, and deep welt pockets.",
  "stockLeft": 7,
  "sizes": ["XS", "S", "M", "L", "XL"],
  "colorVariants": [
    {
      "name": "Classic Camel",
      "hex": "#C7A77E",
      "images": [
        "https://images.unsplash.com/photo-1544441893-675973e31985?auto=format&fit=crop&w=1000&q=80",
        "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1000&q=80",
        "https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&w=1000&q=80"
      ]
    }
  ],
  "isNewSeason": true,
  "isTrending": true,
  "isFlashDeal": true,
  "isBestSeller": true
}
```

| Field | Type | Required | Notes |
| :--- | :--- | :---: | :--- |
| `id` | string | ✓ | Stable identifier |
| `title`, `category`, `description`, `fabricCare`, `sizeFitNotes` | string | ✓ | |
| `brand` | string | | Defaults to `SILOU` |
| `gender` | string | | `Women`, `Men` or `Kids`; defaults to `Women` |
| `price` | number | ✓ | Current price, USD |
| `originalPrice` | number | | Pre-discount price; omit when not on sale |
| `discountPercent` | integer | | Defaults to `0` (the app derives it from `originalPrice` if `0`) |
| `rating` | number | ✓ | 0–5 |
| `reviewsCount`, `stockLeft` | integer | ✓ | |
| `sizes` | string[] | ✓ | |
| `colorVariants` | ColorVariant[] | ✓ | First image of the first variant is the card image |
| `isNewSeason`, `isTrending`, `isFlashDeal`, `isBestSeller` | boolean | | Default `false`; drive home-screen rails |

**ColorVariant:** `name` (string), `hex` (`#RRGGBB`), `images` (string[] of image URLs, at least one).

## Home content

### `GET /home/stories`

Story bubbles. Array of:

```json
{
  "id": "s_flash",
  "label": "Flash Sale",
  "imageUrl": "https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?auto=format&fit=crop&w=600&q=80",
  "hasUnseen": true
}
```

### `GET /home/campaigns`

Hero banners. Array of:

```json
{
  "id": "c1",
  "tag": "Flash sale, today only",
  "title": "Up To 70% Off Everything",
  "subtitle": "Over 12,000 summer styles, sneakers, and denim marked down.",
  "imageUrl": "https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=1400&q=85",
  "ctaText": "Shop the sale"
}
```

## Account (`/me`)

### `GET /me/addresses`

Saved delivery addresses. Array of:

```json
{
  "id": "a1",
  "label": "Home",
  "fullName": "Sary Danish",
  "line1": "14 Rue de la Paix, 1er Arrondissement",
  "city": "Paris",
  "postcode": "75001",
  "country": "France",
  "phone": "+33 6 12 34 56 78"
}
```

### `GET /me/notifications`

Inbox messages (the app sorts them newest first). Array of:

```json
{
  "id": "n1",
  "category": "order",
  "title": "Your trench coat is on its way",
  "body": "Order #ATL-894201 left our Paris workshop. Track it live in your profile.",
  "sentAt": "2026-11-26T18:30:00Z",
  "isRead": false
}
```

`category` is one of `order`, `drop`, `offer`, `atelier`.

### `GET /me/orders`

Order history. Array of:

```json
{
  "id": "#ATL-894201",
  "date": "Yesterday, 14:20",
  "items": "1x Double-Breasted Wool Trench (S)",
  "total": 389.0,
  "status": "In Transit",
  "imageUrl": "https://images.unsplash.com/photo-1539533018447-63fcce2678e3?auto=format&fit=crop&w=300&q=70",
  "delivered": false
}
```

`status` is one of `In Transit`, `Delivered`, `Returned`.

## Planned write endpoints

These are handled locally in the app today and should be added next:

| Endpoint | Purpose |
| :--- | :--- |
| `POST /auth/login`, `POST /auth/register` | Accounts |
| `GET/PUT /me/cart` | Bag synced across devices |
| `GET/PUT /me/wishlist` | Wishlist synced across devices |
| `POST/PUT/DELETE /me/addresses[/{id}]` | Manage addresses |
| `PATCH /me/notifications/{id}` | Mark a message read |
| `POST /orders` | Place an order (with a payment-provider token) |
| `GET /orders/{id}/tracking` | Live delivery status |
