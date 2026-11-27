/**
 * SILOU — portfolio entry, ready to paste.
 *
 * Shaped like the Bookly entry in Danish_portfolio/src/content/portfolio.ts.
 * "How I built it" (steps, practices, challenges, lessons) is left empty on purpose.
 * Phone screens only (430×932 at 1.2×, saved 516×1118). There are no laptop shots,
 * so `desktop` repeats the phone file; hide the laptop frame when both are equal.
 *
 * Every number was checked against the code on 27 Nov 2026:
 *   23 demo products and 10 brands in lib/data/mock/mock_atelier_data.dart,
 *   57 tests passing (`flutter test`), 6 body measurements on My Measurements.
 */

// 1) In src/lib/assets.ts:
//   const sl = import.meta.glob("@/assets/projects/silou/*.webp", { eager: true, import: "default" }) as Record<string, string>;
//   const silou = (name: string) => sl[`/src/assets/projects/silou/${name}.webp`] ?? "";
//   and inside ASSETS.projects:  silouShot: silou,
// 2) Add "silou" to Project["id"], and widen screens[].group with "Shop" | "Atelier" | "Account".

const shot = (n: string) => ({ desktop: `m-${n}`, phone: `m-${n}` });

export const silouProject = {
  id: "silou",
  title: "SILOU",
  coverLine: "Fashion & streetwear, from first look to doorstep",
  kind: "Fashion shopping app · Flutter",
  summary:
    "A fashion and streetwear shopping app built in Flutter for iOS, Android and web: browse, search, try pieces on, personalise, check out and track the order. The frontend is complete and runs on local demo data; the backend is the next step.",
  highlights: [
    "Full shopping flow: home, search, product, bag, checkout, tracking",
    "Premium extras: 360° view, monogram studio, salon booking, VIP club",
    "Mock API behind a repository layer, ready to swap for a real backend",
  ],
  stack: ["Flutter", "Dart", "GetX", "GetStorage"],
  hosting: "Netlify (web build)",
  liveUrl: "https://silou-fashion.netlify.app",
  githubUrl: "https://github.com/danishsary8/siluo",
  imageAlt: "SILOU home screen, product page and courier map on phones",

  caseStudy: {
    pitch:
      "A shopping app that feels like a fashion magazine: find a piece, see it from every side, make it yours, and watch it come to your door.",

    facts: [
      { label: "Role", value: "Solo, frontend" },
      { label: "Status", value: "Frontend done · backend next" },
      { label: "Platforms", value: "iOS · Android · Web" },
      { label: "Built with", value: "Flutter + GetX" },
    ],

    problem:
      "Most small fashion shops sell through a feed and a chat. Shoppers can't search properly, can't tell if a size will fit, and don't know where their order is.",

    solution:
      "A complete shop on the phone: search and filters, rich product pages, a size helper from your own measurements, a three-step checkout and live order tracking.",

    steps: [],

    screens: [
      { group: "Shop", title: "Home", text: "Stories, campaigns, a flash-deal timer and brand filters on one feed.", ...shot("home") },
      { group: "Shop", title: "Search", text: "Live search with quick chips, visual search and a link to try pieces on.", ...shot("search") },
      { group: "Shop", title: "Product page", text: "Price, stock, colours, sizes and every extra tool for the piece.", ...shot("product") },
      { group: "Atelier", title: "360° view", text: "Drag to turn the piece all the way around, frame by frame.", ...shot("turntable-360") },
      { group: "Atelier", title: "Monogram studio", text: "Pick initials, lettering, thread colour and where it's stitched.", ...shot("monogram") },
      { group: "Shop", title: "Bag", text: "Change quantities, apply a promo code and see the total with tax.", ...shot("bag") },
      { group: "Shop", title: "Checkout", text: "Address, gift packaging and payment in three clear steps.", ...shot("checkout") },
      { group: "Shop", title: "Order confirmed", text: "Order number and delivery window right after paying.", ...shot("order-confirmed") },
      { group: "Account", title: "Order tracking", text: "A timeline of every step from workshop to doorstep.", ...shot("order-tracking") },
      { group: "Account", title: "Courier map", text: "The courier's live route, ETA and a handover passcode.", ...shot("courier-map") },
      { group: "Account", title: "My measurements", text: "Six body measurements and a fit choice give a live size suggestion.", ...shot("measurements") },
      { group: "Account", title: "Inbox", text: "Order, drop, offer and atelier messages, with filters and unread dots.", ...shot("inbox") },
      { group: "Atelier", title: "Salon booking", text: "Choose a flagship salon, a tailor and a welcome drink.", ...shot("salon-booking") },
      { group: "Atelier", title: "VIP club", text: "Membership card, points progress and member perks.", ...shot("vip-club") },
    ],

    stats: [
      { value: 23, label: "demo products" },
      { value: 10, label: "brands" },
      { value: 57, label: "tests passing" },
      { value: 6, label: "body measurements" },
    ],

    practices: [],
    challenges: [],
    lessons: [],

    next: [
      "Connect a real backend: accounts, catalogue and orders",
      "Real payments and order processing",
      "Push notifications for drops and deliveries",
      "Publish to the App Store and Google Play",
    ],
  },
} as const;
