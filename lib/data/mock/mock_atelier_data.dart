import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/capsule_collection.dart';
import '../models/lookbook_story.dart';

// ==========================================
// SILOU PROMOTIONAL STORIES (Circular Feed)
// ==========================================
final List<LookbookStory> mockStories = [
  const LookbookStory(
    id: 's_flash',
    label: 'Flash Sale',
    imageUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?auto=format&fit=crop&w=600&q=80',
  ),
  const LookbookStory(
    id: 's_street',
    label: 'Streetwear',
    imageUrl: 'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?auto=format&fit=crop&w=600&q=80',
  ),
  const LookbookStory(
    id: 's_dresses',
    label: 'Dresses',
    imageUrl: 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?auto=format&fit=crop&w=600&q=80',
  ),
  const LookbookStory(
    id: 's_sneakers',
    label: 'Kicks Drop',
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=600&q=80',
  ),
  const LookbookStory(
    id: 's_denim',
    label: 'Denim Days',
    imageUrl: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=600&q=80',
  ),
  const LookbookStory(
    id: 's_blazers',
    label: 'Tailored',
    imageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?auto=format&fit=crop&w=600&q=80',
  ),
  const LookbookStory(
    id: 's_summer',
    label: 'Summer Edit',
    imageUrl: 'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?auto=format&fit=crop&w=600&q=80',
  ),
  const LookbookStory(
    id: 's_bags',
    label: 'Bags & Acc',
    imageUrl: 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=600&q=80',
  ),
];

// ==========================================
// SILOU HIGH-CONVERSION HERO CAMPAIGN BANNERS
// ==========================================
final List<CapsuleCollection> mockCapsules = [
  const CapsuleCollection(
    id: 'c1',
    tag: 'Flash sale, today only',
    title: 'Up To 70% Off Everything',
    subtitle: 'Over 12,000 summer styles, sneakers, and denim marked down.',
    imageUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=1400&q=85',
    ctaText: 'Shop the sale',
  ),
  const CapsuleCollection(
    id: 'c2',
    tag: 'New streetwear drop',
    title: 'Nike, Adidas & Street Icons',
    subtitle: 'Limited sneaker releases, graphic hoodies, and retro tracksuits.',
    imageUrl: 'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?auto=format&fit=crop&w=1400&q=85',
    ctaText: 'Shop streetwear',
  ),
  const CapsuleCollection(
    id: 'c3',
    tag: 'Summer edit by Zara & Mango',
    title: 'Effortless Linen & Dresses',
    subtitle: 'Breezy silhouettes and warm neutrals crafted for sunny escapes.',
    imageUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=1400&q=85',
    ctaText: 'Shop the summer edit',
  ),
  const CapsuleCollection(
    id: 'c4',
    tag: 'Denim week at Levi’s',
    title: 'Vintage Fit & Wide Leg Edit',
    subtitle: 'Buy 1, Get 2nd at 50% Off. The jeans you will live in all season.',
    imageUrl: 'https://images.unsplash.com/photo-1516762689617-e1cffcef479d?auto=format&fit=crop&w=1400&q=85',
    ctaText: 'Shop denim',
  ),
];

// ==========================================
// COMPLETE SILOU SHOPPING CATALOG (24 ITEMS)
// Real consumer brands, high-res multi-angle images
// ==========================================
final List<Product> mockAtelierProducts = [
  // -------------------------------------------------------------
  // WOMEN'S FASHION
  // -------------------------------------------------------------
  const Product(
    id: 'zd_w_01',
    brand: 'ZARA',
    gender: 'Women',
    title: 'Flowing Belted Trench Coat',
    category: 'Outerwear',
    price: 69.99,
    originalPrice: 129.99,
    discountPercent: 46,
    rating: 4.8,
    reviewsCount: 384,
    stockLeft: 7,
    isFlashDeal: true,
    isTrending: true,
    isNewSeason: true,
    isBestSeller: true,
    sizes: ['XS', 'S', 'M', 'L', 'XL'],
    description: 'Iconic double-breasted trench in lightweight structured cotton blend. Features storm flap, notched lapels, tort buckle belt, and deep welt pockets.',
    fabricCare: '65% Cotton, 35% Polyester. Machine wash 30°C delicate.',
    sizeFitNotes: 'Relaxed contemporary drape. Fits true to size. Model is 176cm wearing S.',
    colorVariants: [
      ProductColorVariant(
        name: 'Classic Camel',
        color: Color(0xFFC7A77E),
        images: [
          'https://images.unsplash.com/photo-1544441893-675973e31985?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
      ProductColorVariant(
        name: 'Onyx Noir',
        color: Color(0xFF18181B),
        images: [
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1469334031218-e382a71b716b?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_w_02',
    brand: 'MANGO',
    gender: 'Women',
    title: 'Floral Tiered Midi Sundress',
    category: 'Dresses',
    price: 39.99,
    originalPrice: 79.99,
    discountPercent: 50,
    rating: 4.9,
    reviewsCount: 512,
    stockLeft: 4,
    isFlashDeal: true,
    isTrending: true,
    isBestSeller: true,
    sizes: ['XS', 'S', 'M', 'L'],
    description: 'Breezy botanical print wrap midi dress with sweet flutter sleeves, a cinched tie waist, and cascading tiered ruffle hemline. Perfect for weekend outings.',
    fabricCare: '100% EcoVero™ Viscose. Cold gentle cycle.',
    sizeFitNotes: 'Flattering A-line cut with adjustable waist tie. Model is 174cm wearing S.',
    colorVariants: [
      ProductColorVariant(
        name: 'Petal Floral',
        color: Color(0xFFF472B6),
        images: [
          'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_w_03',
    brand: "LEVI'S",
    gender: 'Women',
    title: "501® 90s Vintage Straight Jeans",
    category: 'Denim',
    price: 54.99,
    originalPrice: 98.00,
    discountPercent: 44,
    rating: 4.8,
    reviewsCount: 890,
    stockLeft: 12,
    isFlashDeal: false,
    isTrending: true,
    isBestSeller: true,
    sizes: ['25', '26', '27', '28', '29', '30', '31'],
    description: 'The denim that started it all. High rise with a classic straight leg, signature button fly, and authentic non-stretch denim wash.',
    fabricCare: '100% Premium Cotton Denim. Wash inside out in cold water.',
    sizeFitNotes: 'Snug through hip and thigh; eases up naturally with wear.',
    colorVariants: [
      ProductColorVariant(
        name: 'Light Stonewash',
        color: Color(0xFF93C5FD),
        images: [
          'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1582552938357-32b906df40cb?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
      ProductColorVariant(
        name: 'Washed Medium Blue',
        color: Color(0xFF3B82F6),
        images: [
          'https://images.unsplash.com/photo-1584370848010-d7fe6bc767ec?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_w_04',
    brand: 'ZARA',
    gender: 'Women',
    title: 'Oversized Double-Breasted Blazer',
    category: 'Tailoring',
    price: 59.99,
    originalPrice: 119.00,
    discountPercent: 50,
    rating: 4.7,
    reviewsCount: 276,
    stockLeft: 5,
    isFlashDeal: true,
    isTrending: true,
    sizes: ['XS', 'S', 'M', 'L'],
    description: 'Power dressing relaxed. Peak lapels, flap pockets, structured shoulder pads, and tailored back vent.',
    fabricCare: 'Poly-viscose blend with full satin lining. Dry clean.',
    sizeFitNotes: 'Intentionally oversized. Size down for a narrower silhouette.',
    colorVariants: [
      ProductColorVariant(
        name: 'Vanilla Ecru',
        color: Color(0xFFF5F5F0),
        images: [
          'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_w_05',
    brand: 'COTTON ON',
    gender: 'Women',
    title: 'Cropped Ribbed Knit Cardigan',
    category: 'Knitwear',
    price: 24.99,
    originalPrice: 44.99,
    discountPercent: 44,
    rating: 4.6,
    reviewsCount: 198,
    stockLeft: 15,
    sizes: ['XS', 'S', 'M', 'L'],
    description: 'Chunky vertical rib knit with tortoiseshell buttons and cropped hem. Soft touch yarn that layers easily over denim or slip skirts.',
    fabricCare: '60% Recycled Cotton, 40% Acrylic.',
    sizeFitNotes: 'Cropped body hitting at high waistline.',
    colorVariants: [
      ProductColorVariant(
        name: 'Sage Mint',
        color: Color(0xFFA7F3D0),
        images: [
          'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1516762689617-e1cffcef479d?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_w_06',
    brand: 'NIKE',
    gender: 'Women',
    title: 'Air Force 1 ’07 Next Nature',
    category: 'Footwear',
    price: 89.99,
    originalPrice: 115.00,
    discountPercent: 22,
    rating: 4.9,
    reviewsCount: 1240,
    stockLeft: 3,
    isBestSeller: true,
    sizes: ['US 5', 'US 6', 'US 7', 'US 8', 'US 9'],
    description: 'The radiance lives on. Crisp leather accents, bold stitching, and Air cushioning for timeless court-to-street style.',
    fabricCare: 'Wipe clean with soft damp cloth.',
    sizeFitNotes: 'Runs true to sneaker size. Order regular Nike sizing.',
    colorVariants: [
      ProductColorVariant(
        name: 'Triple White',
        color: Color(0xFFFFFFFF),
        images: [
          'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_w_07',
    brand: 'MANGO',
    gender: 'Women',
    title: 'Quilted Chain Crossbody Bag',
    category: 'Accessories',
    price: 29.99,
    originalPrice: 59.99,
    discountPercent: 50,
    rating: 4.8,
    reviewsCount: 420,
    stockLeft: 8,
    isFlashDeal: true,
    sizes: ['One Size'],
    description: 'Chic diamond quilted vegan leather bag with gold-tone hardware, twist lock clasp, and convertible chain shoulder strap.',
    fabricCare: 'Premium faux leather. Wipe clean.',
    sizeFitNotes: 'Dimensions: 22cm x 15cm x 7cm. Fits iPhone Pro Max and daily essentials.',
    colorVariants: [
      ProductColorVariant(
        name: 'Caramel Tan',
        color: Color(0xFFB45309),
        images: [
          'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_w_08',
    brand: 'CALVIN KLEIN',
    gender: 'Women',
    title: 'Modern Cotton Bralette & Brief Set',
    category: 'Activewear',
    price: 34.99,
    originalPrice: 52.00,
    discountPercent: 33,
    rating: 4.9,
    reviewsCount: 960,
    stockLeft: 18,
    isBestSeller: true,
    sizes: ['XS', 'S', 'M', 'L'],
    description: 'Ultra-soft pima cotton blend bralette featuring racerback design and iconic Calvin Klein repeating logo elastic underband.',
    fabricCare: '53% Cotton, 35% Modal, 12% Elastane. Machine wash cold.',
    sizeFitNotes: 'Stretchy second-skin fit.',
    colorVariants: [
      ProductColorVariant(
        name: 'Heather Grey',
        color: Color(0xFF9CA3AF),
        images: [
          'https://images.unsplash.com/photo-1509631179647-0177331693ae?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  // -------------------------------------------------------------
  // MEN'S FASHION
  // -------------------------------------------------------------
  const Product(
    id: 'zd_m_01',
    brand: "LEVI'S",
    gender: 'Men',
    title: 'Sherpa-Lined Trucker Jacket',
    category: 'Outerwear',
    price: 79.99,
    originalPrice: 148.00,
    discountPercent: 46,
    rating: 4.9,
    reviewsCount: 710,
    stockLeft: 6,
    isFlashDeal: true,
    isTrending: true,
    isBestSeller: true,
    sizes: ['S', 'M', 'L', 'XL', 'XXL'],
    description: 'Rugged heavyweight denim trucker jacket lined with cozy fuzzy sherpa for chilly seasons. Classic point collar, snap closures, and dual chest pockets.',
    fabricCare: '100% Cotton non-stretch denim. Wash cold.',
    sizeFitNotes: 'Regular fit. Hits right at the hip.',
    colorVariants: [
      ProductColorVariant(
        name: 'Dark Indigo Wash',
        color: Color(0xFF1E3A8A),
        images: [
          'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1516257984-b1b4d707412e?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_m_02',
    brand: 'NIKE',
    gender: 'Men',
    title: 'Club Fleece Overhead Pullover Hoodie',
    category: 'Tops',
    price: 44.99,
    originalPrice: 65.00,
    discountPercent: 31,
    rating: 4.8,
    reviewsCount: 1140,
    stockLeft: 22,
    isBestSeller: true,
    sizes: ['S', 'M', 'L', 'XL', 'XXL'],
    description: 'Our top-selling fleece hoodie. Brushed-back fleece feels soft and smooth against skin. Drawstring hood and front kangaroo pocket.',
    fabricCare: '80% Cotton, 20% Polyester. Machine wash warm.',
    sizeFitNotes: 'Standard relaxed athletic fit.',
    colorVariants: [
      ProductColorVariant(
        name: 'Charcoal Heather',
        color: Color(0xFF374151),
        images: [
          'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
      ProductColorVariant(
        name: 'Obsidian Black',
        color: Color(0xFF111827),
        images: [
          'https://images.unsplash.com/photo-1509967419530-da38b4704bc6?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_m_03',
    brand: 'ADIDAS',
    gender: 'Men',
    title: 'Originals Samba Classic Leather Kicks',
    category: 'Footwear',
    price: 74.99,
    originalPrice: 100.00,
    discountPercent: 25,
    rating: 4.9,
    reviewsCount: 1890,
    stockLeft: 4,
    isFlashDeal: true,
    isTrending: true,
    isBestSeller: true,
    sizes: ['US 7', 'US 8', 'US 9', 'US 10', 'US 11', 'US 12'],
    description: 'The legendary indoor football shoe turned global street icon. Full grain leather upper with suede T-toe overlay and iconic gum rubber outsole.',
    fabricCare: 'Leather clean with damp sponge.',
    sizeFitNotes: 'True to size. Snug lockdown fit.',
    colorVariants: [
      ProductColorVariant(
        name: 'Cloud White / Core Black',
        color: Color(0xFFE5E7EB),
        images: [
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_m_04',
    brand: 'ZARA',
    gender: 'Men',
    title: 'Slim Fit Comfort Stretch Chinos',
    category: 'Tops',
    price: 34.99,
    originalPrice: 59.99,
    discountPercent: 42,
    rating: 4.6,
    reviewsCount: 310,
    stockLeft: 14,
    sizes: ['30', '32', '34', '36', '38'],
    description: 'Versatile cotton twill chinos infused with elastane for all-day mobility. Features slant front pockets and buttoned back welt pockets.',
    fabricCare: '98% Cotton, 2% Elastane. Machine wash 30°C.',
    sizeFitNotes: 'Slim through thigh with a clean taper towards the ankle.',
    colorVariants: [
      ProductColorVariant(
        name: 'Desert Khaki',
        color: Color(0xFFD97706),
        images: [
          'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1479064555552-3ef4979f8908?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_m_05',
    brand: 'COTTON ON',
    gender: 'Men',
    title: 'Heavyweight Oversized Vintage Graphic Tee',
    category: 'Tops',
    price: 19.99,
    originalPrice: 34.99,
    discountPercent: 43,
    rating: 4.7,
    reviewsCount: 450,
    stockLeft: 25,
    sizes: ['S', 'M', 'L', 'XL'],
    description: '240 GSM dense cotton tee with dropped shoulders, thick ribbed collar, and faded retro motorsport chest graphic.',
    fabricCare: '100% Combed Cotton. Machine wash cold.',
    sizeFitNotes: 'Boxy streetwear cut. Stay regular size for oversized look.',
    colorVariants: [
      ProductColorVariant(
        name: 'Vintage Bone',
        color: Color(0xFFF3F4F6),
        images: [
          'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_m_06',
    brand: 'PUMA',
    gender: 'Men',
    title: 'Essentials Padded Warm Winter Puffer',
    category: 'Outerwear',
    price: 59.99,
    originalPrice: 110.00,
    discountPercent: 45,
    rating: 4.8,
    reviewsCount: 220,
    stockLeft: 5,
    isFlashDeal: true,
    sizes: ['M', 'L', 'XL'],
    description: 'Water-repellent thermal down-feel puffer with windCELL technology, chin guard zip, and fleece lined hand-warmer pockets.',
    fabricCare: '100% Recycled Polyester fill and shell.',
    sizeFitNotes: 'Generous cut to accommodate winter sweaters underneath.',
    colorVariants: [
      ProductColorVariant(
        name: 'Matte Forest',
        color: Color(0xFF064E3B),
        images: [
          'https://images.unsplash.com/photo-1544923246-77307dd654cb?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1544441893-675973e31985?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  // -------------------------------------------------------------
  // KIDS' FASHION
  // -------------------------------------------------------------
  const Product(
    id: 'zd_k_01',
    brand: 'COTTON ON',
    gender: 'Kids',
    title: 'Kids Classic Denim Dungarees Overalls',
    category: 'Denim',
    price: 29.99,
    originalPrice: 49.99,
    discountPercent: 40,
    rating: 4.9,
    reviewsCount: 175,
    stockLeft: 9,
    isBestSeller: true,
    sizes: ['3-4Y', '5-6Y', '7-8Y', '9-10Y'],
    description: 'Durable stretch denim overalls with adjustable metal buckle straps, chest pocket, and rolled cuffs. Built for playground adventure.',
    fabricCare: '99% Cotton, 1% Elastane. Machine wash.',
    sizeFitNotes: 'Comfortable roomy fit over tees and sweaters.',
    colorVariants: [
      ProductColorVariant(
        name: 'Mid Indigo',
        color: Color(0xFF2563EB),
        images: [
          'https://images.unsplash.com/photo-1519457431-44ccd64a579b?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_k_02',
    brand: 'H&M',
    gender: 'Kids',
    title: 'Kids Cozy Fleece Colorblock Half-Zip',
    category: 'Tops',
    price: 18.99,
    originalPrice: 32.99,
    discountPercent: 42,
    rating: 4.8,
    reviewsCount: 230,
    stockLeft: 12,
    isFlashDeal: true,
    sizes: ['4-5Y', '6-7Y', '8-9Y', '10-12Y'],
    description: 'Ultra-plush thermal teddy fleece with high stand collar, safe zipper guard, and elastic binding on cuffs and hem.',
    fabricCare: '100% Recycled Polyester Fleece.',
    sizeFitNotes: 'True to age size.',
    colorVariants: [
      ProductColorVariant(
        name: 'Mustard & Navy',
        color: Color(0xFFF59E0B),
        images: [
          'https://images.unsplash.com/photo-1503919545889-aef636e10ad4?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_k_03',
    brand: 'NIKE',
    gender: 'Kids',
    title: 'Kids Court Borough Low 2 Sneakers',
    category: 'Footwear',
    price: 39.99,
    originalPrice: 55.00,
    discountPercent: 27,
    rating: 4.9,
    reviewsCount: 340,
    stockLeft: 8,
    isBestSeller: true,
    sizes: ['11C', '12C', '13C', '1Y', '2Y', '3Y'],
    description: 'All-star comfort for little feet. Durable leather look with hook-and-loop strap alongside elastic laces for easy on and off.',
    fabricCare: 'Wipe clean.',
    sizeFitNotes: 'Secure ankle collar with padded insole.',
    colorVariants: [
      ProductColorVariant(
        name: 'White / University Red',
        color: Color(0xFFEF4444),
        images: [
          'https://images.unsplash.com/photo-1514989940723-e8e51635b782?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  // -------------------------------------------------------------
  // MORE TRENDING CONSUMER STYLES
  // -------------------------------------------------------------
  const Product(
    id: 'zd_w_09',
    brand: 'MANGO',
    gender: 'Women',
    title: 'Linen Blend Wide-Leg Trousers',
    category: 'Tailoring',
    price: 34.99,
    originalPrice: 69.99,
    discountPercent: 50,
    rating: 4.8,
    reviewsCount: 310,
    stockLeft: 6,
    isFlashDeal: true,
    sizes: ['XS', 'S', 'M', 'L'],
    description: 'High-rise trousers cut from breezy linen-blend fabric with front pleats, elastic back waist, and fluid wide legs.',
    fabricCare: '55% Linen, 45% Viscose. Cold wash.',
    sizeFitNotes: 'High rise. Full length hitting top of shoes.',
    colorVariants: [
      ProductColorVariant(
        name: 'Sand Oat',
        color: Color(0xFFE5E5DC),
        images: [
          'https://images.unsplash.com/photo-1485968579580-b6d095142e6e?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_m_07',
    brand: 'NEW BALANCE',
    gender: 'Men',
    title: '550 Vintage White / Green Lifestyle Shoes',
    category: 'Footwear',
    price: 94.99,
    originalPrice: 120.00,
    discountPercent: 21,
    rating: 4.9,
    reviewsCount: 880,
    stockLeft: 3,
    isBestSeller: true,
    isTrending: true,
    sizes: ['US 8', 'US 9', 'US 10', 'US 11', 'US 12'],
    description: 'Tribute to 90s pro basketballers and streetwear heritage. Premium leather upper with vintage accents and durable rubber cupsole.',
    fabricCare: 'Leather clean.',
    sizeFitNotes: 'Runs true to size.',
    colorVariants: [
      ProductColorVariant(
        name: 'Sea Salt / Pine Green',
        color: Color(0xFF15803D),
        images: [
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_w_10',
    brand: 'ZARA',
    gender: 'Women',
    title: 'Satin Bias Cut Maxi Slip Skirt',
    category: 'Dresses',
    price: 29.99,
    originalPrice: 59.99,
    discountPercent: 50,
    rating: 4.7,
    reviewsCount: 420,
    stockLeft: 11,
    isFlashDeal: true,
    sizes: ['XS', 'S', 'M', 'L'],
    description: 'Liquid satin maxi skirt tailored on the bias for fluid feminine movement. Hidden elastic waistband.',
    fabricCare: '100% Polyester Satin. Gentle cycle.',
    sizeFitNotes: 'Skims hips gracefully without clinging.',
    colorVariants: [
      ProductColorVariant(
        name: 'Champagne Shimmer',
        color: Color(0xFFFDE68A),
        images: [
          'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_m_08',
    brand: 'CALVIN KLEIN',
    gender: 'Men',
    title: 'Classic Monogram Leather Cardholder',
    category: 'Accessories',
    price: 22.99,
    originalPrice: 45.00,
    discountPercent: 49,
    rating: 4.8,
    reviewsCount: 390,
    stockLeft: 15,
    sizes: ['One Size'],
    description: 'Slim genuine leather card sleeve with 4 card slots, central cash compartment, and embossed CK monogram.',
    fabricCare: '100% Genuine Leather.',
    sizeFitNotes: 'Ultra-slim pocket profile.',
    colorVariants: [
      ProductColorVariant(
        name: 'Obsidian Black',
        color: Color(0xFF18181B),
        images: [
          'https://images.unsplash.com/photo-1627123424574-724758594e93?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_w_11',
    brand: 'COTTON ON',
    gender: 'Women',
    title: 'Cropped Seamless Rib Tank Top',
    category: 'Tops',
    price: 14.99,
    originalPrice: 24.99,
    discountPercent: 40,
    rating: 4.8,
    reviewsCount: 620,
    stockLeft: 30,
    isBestSeller: true,
    sizes: ['XS', 'S', 'M', 'L'],
    description: 'Ultra-stretchy seamless scoop neck tank top. The everyday layering essential that sculpts your silhouette.',
    fabricCare: '92% Nylon, 8% Elastane.',
    sizeFitNotes: 'Fitted stretch silhouette.',
    colorVariants: [
      ProductColorVariant(
        name: 'Warm Taupe',
        color: Color(0xFFD6D3D1),
        images: [
          'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),

  const Product(
    id: 'zd_m_09',
    brand: 'ADIDAS',
    gender: 'Men',
    title: 'Tiro 23 League Training Track Pants',
    category: 'Activewear',
    price: 38.99,
    originalPrice: 55.00,
    discountPercent: 29,
    rating: 4.8,
    reviewsCount: 840,
    stockLeft: 10,
    sizes: ['S', 'M', 'L', 'XL'],
    description: 'Moisture-absorbing AEROREADY track pants with ankle zips for quick changes over boots or sneakers.',
    fabricCare: '100% Recycled Polyester doubleknit.',
    sizeFitNotes: 'Tapered athletic leg.',
    colorVariants: [
      ProductColorVariant(
        name: 'Black / White 3-Stripes',
        color: Color(0xFF111827),
        images: [
          'https://images.unsplash.com/photo-1552374196-1ab2a1c593e8?auto=format&fit=crop&w=1000&q=80',
        ],
      ),
    ],
  ),
];
