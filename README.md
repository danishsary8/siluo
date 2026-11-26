<div align="center">

# SILOU<span style="color:#FF4838;">.</span>

### Modern Fashion, Streetwear & Interactive Atelier Commerce — Built with Flutter

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.3.0-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![State Management](https://img.shields.io/badge/GetX-4.6.6-8A2BE2?style=for-the-badge)](https://pub.dev/packages/get)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20Android%20%7C%20Web-111827?style=for-the-badge)](#getting-started)
[![Deploy](https://img.shields.io/badge/Netlify-Web%20Ready-00C7B7?style=for-the-badge&logo=netlify&logoColor=white)](./netlify.toml)

*Curated multi-brand fashion and streetwear shopping fused with tactile, editorial-grade mobile experiences.*

</div>

---

## Overview

**SILOU.** (inspired by *silhouette*) is a cross-platform Flutter fashion e-commerce application designed to go far beyond a conventional shopping template. It pairs high-conversion multi-brand discovery—flash sales, lookbook stories, live filtering, and instant checkout—with bespoke interactive experiences including a **360° Product Turntable**, **Fabric Weave Loupe**, **Kinetic Drape Preview**, **Virtual Mirror**, **Live Runway**, and **Nocturne Vault**.

Built with a modular **GetX** architecture, **Light & Dark editorial themes**, liquid-glass surfaces, custom motion curves, and subtle haptic feedback throughout.

---

## Key Features

### Discovery & High-Conversion Shopping
- **Cinematic Splash & Editorial Home Feed:** Animated hero splash screen, circular lookbook story feed, flash sale banners, and curated brand edits.
- **Smart Search & Visual Search:** Instant catalog filtering by category, brand, price range, and size, plus a dedicated Visual Search module.
- **Rich Product Detail Page (PDP):** Multi-angle imagery, size/color selection, customer reviews modal, side-by-side product comparison, and interactive material inspection.
- **Cart, Wishlist & Seamless Checkout:** Persistent local storage (`get_storage`), animated wishlist hearts, promo code engine (`SILOU20`, `SAVE20`, `ATELIER15`, `WELCOME15`), packaging selection, 3D unboxing simulation, and live courier order tracking.

### Signature Interactive Atelier Experiences
| Module | Experience |
| :--- | :--- |
| **360° Turntable & Fabric Loupe** | Inspect silhouettes from every angle, zoom into fabric weave detail, and preview kinetic drape motion. |
| **Virtual Mirror & Bespoke Tailor** | Interactive virtual try-on interface and custom tailoring measurement modal. |
| **Monogram & Gifting Studio** | Personalize pieces with custom monograms and luxury gift packaging options. |
| **Runway Live & Editorial Magazine** | Shoppable runway stories, editorial journal, lookbook "Style the Look" curation, and digital magazine. |
| **Nocturne Vault & VIP Club** | Members-only vault drops, VIP tier perks, private salon booking, and concierge consultation suite. |
| **Authenticity Passport & Wardrobe** | Digital authenticity verification, personal wardrobe manager, fabric swatch ordering, and ambient acoustic soundscapes. |

---

## Design System

SILOU balances crisp editorial minimalism with bold, energetic retail accents across both **Light** and **Dark** themes:

| Token | Hex | Role |
| :--- | :--- | :--- |
| **SILOU Coral** | `#FF4838` | Primary brand accent, CTAs, active states |
| **Warm Stone White** | `#FAFAF9` | Editorial light canvas background |
| **Obsidian Canvas** | `#0E0E10` | Deep dark mode background |
| **Modern Slate Onyx** | `#0F172A` | High-contrast typography & secondary surfaces |
| **Champagne Gold** | `#C5A880` | Luxury atelier & VIP highlights |
| **Flash Deal Amber** | `#FF9800` | Flash sales & urgency badges |

- **Typography:** `Poppins` & `Google Fonts` editorial hierarchy
- **Motion & Tactility:** Custom `MotionCurves`, `LiquidGlassContainer` frosted overlays, shimmer skeletons, and `HapticService` micro-feedback

---

## Architecture & Project Structure

The codebase follows a clean, feature-first modular layout powered by **GetX** for reactive state management, dependency injection, and named route transitions:

```text
lib/
├── controllers/          # Reactive GetX controllers (Atelier, Cart, Wishlist, Orders, Notifications)
├── core/
│   ├── constants/        # AppColors design tokens & AppTypography scales
│   ├── theme/            # Light & Dark ThemeData definitions
│   └── utils/            # HapticService & custom MotionCurves
├── data/
│   ├── mock/             # Curated multi-brand catalog, stories & campaign capsules
│   └── models/           # Product, CartItem, CapsuleCollection, LookbookStory, Soundscape
├── modules/              # 25+ self-contained feature modules
│   ├── onboarding/       # Animated SILOU. splash screen
│   ├── shell/            # Persistent navigation shell & floating soundscape bar
│   ├── home/             # Stories, hero campaigns, flash deals & trending grids
│   ├── product_detail/   # PDP + 360° turntable, fabric loupe, kinetic drape & tailor modals
│   ├── cart/ & checkout/ # Bag, promo codes, packaging sheet & 3D unboxing simulation
│   ├── search/           # Filterable search & visual search
│   ├── try_on/           # Virtual mirror experience
│   ├── runway/ & vault/  # Live runway, Nocturne Vault & VIP Club
│   └── ...               # Archive, Authenticity, Concierge, Gifting, Journal, Salon, Wardrobe
├── routes/               # Centralized GetX routes & page bindings
├── shared/widgets/       # Reusable UI primitives (LiquidGlass, ProductCard, HapticButton)
└── main.dart             # App bootstrap, edge-to-edge system UI & GetStorage initialization
```

---

## Tech Stack

- **Framework:** Flutter (iOS, Android, Web, Desktop)
- **Language:** Dart (`>=3.3.0 <4.0.0`)
- **State Management & Routing:** `get` (`^4.6.6`)
- **Local Persistence:** `get_storage` (`^2.1.1`)
- **Typography & Icons:** `google_fonts` (`^6.3.0`), `cupertino_icons` (`^1.0.8`)
- **Web Deployment:** Netlify (`netlify.toml` configured with SPA redirects and security headers)

---

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>=3.3.0`)
- Dart SDK (bundled with Flutter)
- An iOS Simulator, Android Emulator, Chrome (for Web), or physical device

### Installation & Run

```bash
# 1. Clone the repository
git clone https://github.com/danishsary8/siluo.git
cd siluo

# 2. Install dependencies
flutter pub get

# 3. Run on your connected device or emulator
flutter run

# Or run directly in Chrome (Web)
flutter run -d chrome
```

### Production Web Build (Netlify)

```bash
flutter build web --release
```

> **Try it in the app:** Head to the shopping bag and apply promo code **`SILOU20`** (20% off) or **`ATELIER15`** (15% off) to test the interactive discount flow.

---

## Author

**Danish Sary**
- GitHub: [@danishsary8](https://github.com/danishsary8)

---

<div align="center">
  <sub>Built with Flutter & GetX — Crafted for modern mobile commerce.</sub>
</div>
