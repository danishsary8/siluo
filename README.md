<div align="center">

# SILOU<span style="color:#FF4838;">.</span>

**A fashion & streetwear shopping app UI, built with Flutter.**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.3-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![GetX](https://img.shields.io/badge/GetX-4.6-8A2BE2?style=for-the-badge)](https://pub.dev/packages/get)
[![Platforms](https://img.shields.io/badge/iOS%20·%20Android%20·%20Web-111827?style=for-the-badge)](#-getting-started)
[![Netlify](https://img.shields.io/badge/Netlify-ready-00C7B7?style=for-the-badge&logo=netlify&logoColor=white)](./netlify.toml)

*Browse → try on → personalise → check out → track. Every screen is interactive.*

</div>

---

## ✨ What is SILOU?

**SILOU** (from *silhouette*) is a **frontend-only** Flutter app that shows what a premium
fashion e-commerce experience can feel like on mobile. It runs entirely on local demo data —
no backend, no accounts, no payments — so you can open it and tap through every flow.

It has two layers:

1. **The shop** — home feed, search & filters, product pages, wishlist, bag, promo codes, checkout and order tracking.
2. **The atelier** — showcase screens that go beyond a normal store: a 360° turntable, fabric zoom, virtual mirror, monogram studio, live runway, VIP club, salon booking and more.

> 🎯 **Purpose:** a portfolio / UI-showcase project, and a starting point for a real fashion store front end.

---

## 📱 Features

### 🛍️ Shopping
| Screen | What you can do |
| :--- | :--- |
| **Home** | Stories, hero campaigns, flash deals, brand filter, best sellers, light/dark toggle, inbox bell |
| **Search** | Live text search, category / brand / size / price filters, sorting, visual search |
| **Product page** | Gallery, size & colour pickers, reviews, compare, add to bag with a bounce animation |
| **Wishlist** | Animated hearts, synced with every product card |
| **Bag** | Quantity stepper, swipe to remove, promo codes, multi-currency totals |
| **Checkout** | Address picker, gift packaging, 3D unboxing preview, success screen |
| **Order tracking** | Timeline and a live courier map |

### 👤 Account *(new)*
| Screen | What you can do |
| :--- | :--- |
| **Saved addresses** | Add / edit with a validated form, set default, swipe to delete. Also used as the address picker in checkout |
| **My measurements** | Sliders and +/- steppers for 6 body measurements, preferred fit, and a **live size recommendation** |
| **Inbox** | Filter by Orders / Drops / Offers / Atelier, unread dots, mark all read, swipe to delete with **Undo** |
| **My orders** | Full order history with In Transit / Delivered / Returned tabs, each opening its tracking page |

### 🪡 Atelier showcase
360° Turntable · Fabric Weave Loupe · Kinetic Drape · Bespoke Tailor · Virtual Mirror ·
Monogram Studio · Gifting · Style the Look · Runway Live · Magazine & Journal ·
Nocturne Vault · VIP Club · Salon Booking · Video Consultation · Authenticity Passport ·
Digital Wardrobe · Swatch Ordering · Heritage Archive · Acoustic Soundscapes

---

## 🎨 Design system

| Token | Hex | Used for |
| :--- | :--- | :--- |
| **SILOU Coral** | `#FF4838` | Brand accent, badges, active states |
| **Champagne Gold** | `#C5A880` | Atelier / VIP highlights, selected states |
| **Obsidian CTA** | `#1C1917` | Primary buttons |
| **Stone White** | `#FAFAF9` | Light canvas |
| **Obsidian Canvas** | `#0E0E10` | Dark canvas |
| **Flash Amber** | `#FF9800` | Deals & urgency |

- **Light & dark themes** — switchable from Home or Profile.
- **Motion** — press-scale buttons, staggered list entrances, animated switchers, custom curves (`core/utils/motion_curves.dart`).
- **Haptics** — `HapticService` gives light / selection / success feedback on taps.
- **Glass** — `LiquidGlassContainer` for the floating tab bar and overlays.

---

## 🧱 Project structure

```text
lib/
├── main.dart                 # Bootstrap: storage, controllers, theme, routes
├── controllers/
│   ├── atelier_controller.dart   # Catalog, filters, wishlist, bag, currency, soundscape
│   ├── account_controller.dart   # Addresses, measurements, inbox, order history
│   └── ...                       # Older controllers kept for the legacy screens
├── core/
│   ├── constants/            # AppColors, AppTypography
│   ├── theme/                # Light & dark ThemeData
│   └── utils/                # HapticService, MotionCurves
├── data/                     # Models + mock catalog
├── modules/                  # One folder per feature
│   ├── shell/                # Bottom tab bar (Home · Search · Bag · Wishlist · Profile)
│   ├── home/  search/  product_detail/  cart/  checkout/  orders/
│   ├── account/              # Addresses, measurements, inbox, order history
│   └── try_on/  runway/  vault/  salon/  ...   # Atelier showcase screens
├── routes/                   # Named routes (GetX)
└── shared/widgets/           # LiquidGlass, product cards, haptic buttons, shimmer
test/
└── account_pages_test.dart   # Widget tests for the account pages
```

**State:** GetX (`Rx` values + `Obx`), with two app-wide controllers: `AtelierController` for
shopping and `AccountController` for the user's account data.

---

## 🚀 Getting started

**Requirements:** Flutter SDK 3.x and a simulator, emulator, device or Chrome.

```bash
git clone https://github.com/danishsary8/siluo.git
```

```bash
cd siluo && flutter pub get
```

```bash
flutter run            # or: flutter run -d chrome
```

### Checks

```bash
flutter analyze
```

```bash
flutter test
```

### Web build (Netlify)

```bash
flutter build web --release
```

`netlify.toml` already publishes `build/web` with SPA redirects and security headers.

---

## 🧪 Try these

- Promo codes in the bag: **`SILOU20`**, **`SAVE20`**, **`ATELIER15`**, **`WELCOME15`**
- Profile → **Bespoke Measurements**: drag the sliders and watch your size change
- Checkout → **Edit** address: pick another address, or add a new one
- Home → 🔔 bell: open the inbox, swipe a message away, then tap **Undo**
- Tap 🌙 on Home to switch to dark mode

---

## ⚠️ Notes

- All data is mocked locally; nothing is sent to a server.
- Some images load from Unsplash, so they need an internet connection.
- `ui-ux-pro-max-skill/` is a separate design-tooling folder and is not part of the app.

---

<div align="center">

**Made by [Danish Sary](https://github.com/danishsary8)** · Built with Flutter & GetX

</div>
