import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/atelier_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/widgets/liquid_glass_container.dart';
import '../product_detail/atelier_pdp_view.dart';
import '../../shared/widgets/image_fallback.dart';

class JournalSection {
  final String? subtitle;
  final String body;
  final String? pullQuote;
  final String? inlineImageUrl;
  final String? imageCaption;
  final String? featuredProductId;

  const JournalSection({
    this.subtitle,
    required this.body,
    this.pullQuote,
    this.inlineImageUrl,
    this.imageCaption,
    this.featuredProductId,
  });
}

class JournalArticle {
  final String id;
  final String issueTag;
  final String title;
  final String kicker;
  final String author;
  final String authorTitle;
  final String readTime;
  final String publishedDate;
  final String heroImageUrl;
  final List<JournalSection> sections;

  const JournalArticle({
    required this.id,
    required this.issueTag,
    required this.title,
    required this.kicker,
    required this.author,
    required this.authorTitle,
    required this.readTime,
    required this.publishedDate,
    required this.heroImageUrl,
    required this.sections,
  });

  static const JournalArticle defaultArticle = JournalArticle(
    id: 'art_architecture_drape',
    issueTag: 'L’ÉDITION N° 04 • COUTURE CULTURE',
    title: 'The Architecture of Drape: Sculpting Silence in Motion',
    kicker: 'AN INVESTIGATION INTO WEIGHT, FORM, AND MINIMALIST VOLUME',
    author: 'Éléonore Vance',
    authorTitle: 'Creative Director & Master Tailor',
    readTime: '6 MIN READ',
    publishedDate: 'PARIS • WINTER 2026',
    heroImageUrl:
        'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1200&q=80',
    sections: [
      JournalSection(
        subtitle: 'I. The Geometry of Gravity',
        body:
            'When Cristóbal Balenciaga famously stated that a couturier must be an architect for patterns, a sculptor for form, and a philosopher for proportion, he was contemplating the exact threshold where textile surrenders to gravity. In modern tailoring, volume is no longer built through aggressive boning or rigid interfacings; it is carved from emptiness. Our 520gsm Melton Wool overcoat does not cling to the silhouette; it hovers suspended from the acromion, establishing an aerodynamic envelope between the skin and the winter breeze.',
        pullQuote:
            '“True elegance does not demand attention; it commands stillness through absolute mastery of weight.”',
        featuredProductId: 'zd_w_01',
      ),
      JournalSection(
        subtitle: 'II. Biella: Where Alpine Snow Melt Softens Wool',
        body:
            'High in the foothills of the Italian Alps, the water of the Cervo river flows with near-zero calcium content. This glacial purity washes raw superfine merino fibres, coaxing out a buttery cashmere-like hand that industrial chemicals cannot replicate. We traveled to Lanificio di Tollegno to witness the wooden warp shuttles gliding in hypnotizing meter, spinning threads calibrated to absorb ambient light rather than reflect it.',
        inlineImageUrl:
            'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?auto=format&fit=crop&w=1000&q=80',
        imageCaption:
            'PLATE 14: Heritage wooden shuttle loom at Lanificio di Tollegno, Northern Italy.',
      ),
      JournalSection(
        subtitle: 'III. The Anatomy of the Dropped Shoulder',
        body:
            'Observe the pitch of the sleeve seam. By rotating the sleeve head backward by exactly 4 degrees, the garment anticipates the natural forward stance of the human stride. The hem does not swing erratically; it ripples with mathematical harmonic frequency, creating a silhouette that looks as deliberate when stationary as it does navigating the cobblestones of the Place Vendôme.',
        pullQuote:
            '“The garment is a living kinetic sculpture; it only completes its composition when worn in the street.”',
        featuredProductId: 'zd_w_02',
      ),
      JournalSection(
        subtitle: 'IV. Epilogue: Permanence Over Novelty',
        body:
            'In an epoch consumed by ephemeral velocity, the Atelier commits to eternal permanence. Each horn button is hand-carved from water buffalo horn, counter-stitched with waxed linen thread to survive decades of continuous wear. When you step into this coat, you do not wear a season; you inhabit an architectural manifesto.',
      ),
    ],
  );
}

class AtelierJournalView extends StatefulWidget {
  final JournalArticle? article;

  const AtelierJournalView({super.key, this.article});

  @override
  State<AtelierJournalView> createState() => _AtelierJournalViewState();
}

class _AtelierJournalViewState extends State<AtelierJournalView> {
  final ScrollController _scrollController = ScrollController();
  double _readingProgress = 0.0;
  double _fontSize = 17.0;
  bool _isBookmarked = false;
  bool _isAudioPlaying = false;

  late final JournalArticle _article;

  @override
  void initState() {
    super.initState();
    _article = widget.article ?? JournalArticle.defaultArticle;
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (maxScroll > 0) {
      final progress = (currentScroll / maxScroll).clamp(0.0, 1.0);
      if ((progress - _readingProgress).abs() > 0.01) {
        setState(() => _readingProgress = progress);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _adjustFontSize(double delta) {
    HapticService.selection();
    setState(() {
      _fontSize = (_fontSize + delta).clamp(14.0, 24.0);
    });
  }

  void _toggleBookmark() {
    HapticService.selection();
    setState(() => _isBookmarked = !_isBookmarked);
    Get.snackbar(
      _isBookmarked ? 'Article Bookmarked' : 'Bookmark Removed',
      _isBookmarked
          ? 'Saved to your Atelier Private Reading Library.'
          : 'Removed from Reading Library.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void _toggleAudioNarration() {
    HapticService.heavy();
    setState(() => _isAudioPlaying = !_isAudioPlaying);
    Get.snackbar(
      _isAudioPlaying ? 'Editorial Audio Narration Active' : 'Narration Paused',
      _isAudioPlaying
          ? 'Bespoke vocal performance by Éléonore Vance (Spatial Ambience: Place Vendôme Rain).'
          : 'Audio playback suspended.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = AtelierController.to;

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Editorial Parallax Sliver App Bar
              SliverAppBar(
                expandedHeight: 380,
                pinned: true,
                backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      CupertinoIcons.back,
                      size: 20,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                actions: [
                  // Audio Narration Button
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isAudioPlaying ? CupertinoIcons.waveform_circle_fill : CupertinoIcons.waveform_circle,
                        color: _isAudioPlaying ? AppColors.champagneGold : (isDark ? Colors.white : Colors.black),
                        size: 20,
                      ),
                      onPressed: _toggleAudioNarration,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Bookmark Button
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isBookmarked ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
                        color: _isBookmarked ? AppColors.champagneGold : (isDark ? Colors.white : Colors.black),
                        size: 20,
                      ),
                      onPressed: _toggleBookmark,
                    ),
                  ),
                  const SizedBox(width: 14),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        _article.heroImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: ImageFallback.builder,
                      ),
                      // Luxury Film Scrim Gradient
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.2),
                              Colors.black.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                      ),
                      // Kicker & Issue Overlay
                      Positioned(
                        bottom: 24,
                        left: 24,
                        right: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.champagneGold.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: AppColors.champagneGold.withValues(alpha: 0.5),
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                _article.issueTag,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                  color: AppColors.champagneGold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _article.kicker,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Article Header, Title, Author Bylines
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _article.title,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          height: 1.15,
                          letterSpacing: -0.5,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Author Bylines & Reading Info
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [AppColors.champagneGold, Color(0xFF4B2FD6)],
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'ÉV',
                                  style: GoogleFonts.cormorantGaramond(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _article.author,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${_article.authorTitle} • ${_article.readTime}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _article.publishedDate.split('•').first.trim(),
                              style: AppTypography.microTag(color: AppColors.champagneGold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Divider(
                        color: isDark ? AppColors.cardBorderDark : AppColors.cardBorderLight,
                        height: 1,
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Article Body Sections with Drop Cap and Pull Quotes
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final section = _article.sections[index];
                      final isFirstSection = index == 0;
                      return _buildSectionWidget(section, isFirstSection, isDark, controller);
                    },
                    childCount: _article.sections.length,
                  ),
                ),
              ),

              // 4. Article Footer & Curator Signing
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 100),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.champagneGold.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              CupertinoIcons.rosette,
                              size: 28,
                              color: AppColors.champagneGold,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'L’ÉDITION ATELIER ARCHIVE',
                              style: AppTypography.microTag(color: AppColors.champagneGold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Published exclusively for members of the Atelier Couture Salon. All archival rights reserved.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.5,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.champagneGold),
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              onPressed: () {
                                HapticService.selection();
                                Get.snackbar(
                                  'Archival Citation',
                                  'DOI: 10.1924/ATELIER.VOL4.DRAPE copied to clipboard.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.black87,
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(16),
                                );
                              },
                              icon: const Icon(CupertinoIcons.doc_text, size: 14, color: AppColors.champagneGold),
                              label: const Text(
                                'CITE THIS ESSAY',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                  color: AppColors.champagneGold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 5. Reading Progress Indicator Bar at Top of Viewport
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: LinearProgressIndicator(
                value: _readingProgress,
                minHeight: 2.5,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.champagneGold),
              ),
            ),
          ),

          // 6. Floating Typography Adjuster Pill at Bottom Right
          Positioned(
            bottom: 24,
            right: 20,
            child: SafeArea(
              child: LiquidGlassContainer(
                borderRadius: 24,
                blur: 20,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                color: isDark
                    ? Colors.black.withValues(alpha: 0.75)
                    : Colors.white.withValues(alpha: 0.85),
                borderColor: isDark ? Colors.white12 : Colors.black12,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => _adjustFontSize(-1.5),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          'A-',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 14,
                      color: isDark ? Colors.white24 : Colors.black12,
                    ),
                    GestureDetector(
                      onTap: () => _adjustFontSize(1.5),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          'A+',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionWidget(
    JournalSection section,
    bool isFirstSection,
    bool isDark,
    AtelierController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (section.subtitle != null) ...[
            Text(
              section.subtitle!,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Paragraph Body (with Drop Cap if first section)
          if (isFirstSection)
            _buildDropCapParagraph(section.body, isDark)
          else
            Text(
              section.body,
              style: TextStyle(
                fontSize: _fontSize,
                height: 1.7,
                fontWeight: FontWeight.w400,
                color: isDark ? const Color(0xFFD6D6DD) : const Color(0xFF2B2645),
              ),
            ),

          // Pull Quote if present
          if (section.pullQuote != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
              decoration: BoxDecoration(
                border: const Border(
                  left: BorderSide(
                    color: AppColors.champagneGold,
                    width: 3.0,
                  ),
                ),
                color: AppColors.champagneGold.withValues(alpha: isDark ? 0.08 : 0.05),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                section.pullQuote!,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                  color: isDark ? AppColors.champagneGold : const Color(0xFF4B2FD6),
                ),
              ),
            ),
          ],

          // Inline Photographic Plate if present
          if (section.inlineImageUrl != null) ...[
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                section.inlineImageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 240,
                errorBuilder: (_, __, ___) => const ImageFallback(width: double.infinity, height: 240),
              ),
            ),
            if (section.imageCaption != null) ...[
              const SizedBox(height: 8),
              Text(
                section.imageCaption!,
                style: TextStyle(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                ),
              ),
            ],
          ],

          // Featured Product "Acquire the Look" card if linked
          if (section.featuredProductId != null) ...[
            const SizedBox(height: 24),
            _buildAcquireTheLookCard(section.featuredProductId!, isDark, controller),
          ],
        ],
      ),
    );
  }

  Widget _buildDropCapParagraph(String text, bool isDark) {
    if (text.isEmpty) return const SizedBox.shrink();
    final firstChar = text[0];
    final remainingText = text.substring(1);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          firstChar,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 56,
            fontWeight: FontWeight.w700,
            height: 0.85,
            color: AppColors.champagneGold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            remainingText,
            style: TextStyle(
              fontSize: _fontSize,
              height: 1.7,
              fontWeight: FontWeight.w400,
              color: isDark ? const Color(0xFFD6D6DD) : const Color(0xFF2B2645),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAcquireTheLookCard(
    String productId,
    bool isDark,
    AtelierController controller,
  ) {
    final product = controller.allProducts.firstWhereOrNull((p) => p.id == productId);
    if (product == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        HapticService.light();
        Get.to(() => AtelierPdpView(product: product));
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.champagneGold.withValues(alpha: 0.35),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                product.primaryImage,
                width: 65,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ImageFallback(width: 65, height: 80),
              ),
            ),
            const SizedBox(width: 14),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(CupertinoIcons.sparkles, size: 11, color: AppColors.champagneGold),
                      const SizedBox(width: 4),
                      Text(
                        'FEATURED IN ESSAY',
                        style: AppTypography.microTag(color: AppColors.champagneGold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.formatPrice(product.price),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // View Piece CTA
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.white : AppColors.ctaDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'VIEW',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: isDark ? AppColors.canvasDark : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    CupertinoIcons.arrow_right,
                    size: 11,
                    color: isDark ? AppColors.canvasDark : Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
