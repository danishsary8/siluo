import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/haptic_service.dart';
import '../../shared/widgets/liquid_glass_container.dart';

class HeritageEra {
  final int year;
  final String title;
  final String frenchSubtitle;
  final String narrative;
  final String imageUrl;
  final String artifactName;
  final String archiveRegistryCode;
  final String curatorVoiceNote;

  const HeritageEra({
    required this.year,
    required this.title,
    required this.frenchSubtitle,
    required this.narrative,
    required this.imageUrl,
    required this.artifactName,
    required this.archiveRegistryCode,
    required this.curatorVoiceNote,
  });
}

class AtelierHeritageArchiveView extends StatefulWidget {
  const AtelierHeritageArchiveView({super.key});

  @override
  State<AtelierHeritageArchiveView> createState() => _AtelierHeritageArchiveViewState();
}

class _AtelierHeritageArchiveViewState extends State<AtelierHeritageArchiveView>
    with SingleTickerProviderStateMixin {
  int _selectedEraIndex = 0;
  bool _isPlayingAudio = false;

  late final PageController _pageController;

  static const List<HeritageEra> _eras = [
    HeritageEra(
      year: 1924,
      title: "L'Origine au 12 Rue de la Paix",
      frenchSubtitle: "FONDATION DU PREMIER ATELIER PAR HENRI DE VANCE",
      narrative:
          "In the golden light of autumn 1924, master tailor Henri de Vance signed the lease for a four-room salon overlooking the Place Vendôme. With three walnut cutting tables and shears forged in Solingen, the Atelier was born under a singular doctrine: clothing must honor the dignity of silent movement.",
      imageUrl:
          "https://images.unsplash.com/photo-1558769132-cb1aea458c5e?auto=format&fit=crop&w=1000&q=80",
      artifactName: "Original 1924 Hand-Forged Brass Tailor's Shears (No. 01)",
      archiveRegistryCode: "ARC-1924-PAIX-001",
      curatorVoiceNote: "Écouter l'enregistrement d'époque (Henri de Vance, 1924)",
    ),
    HeritageEra(
      year: 1947,
      title: "Le Nouveau Volume Sculptural",
      frenchSubtitle: "RÉINVENTION DU CAPE DRAPÉ ET DE LA LAINE DE BIELLA",
      narrative:
          "Rejecting post-war austerity, the Maison unveiled the sculpted 520gsm Melton Wool bell cape. By shaping wool using vaporous water baths rather than interior boning, Henri achieved an architectural silhouette that floated effortlessly around the female body.",
      imageUrl:
          "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1000&q=80",
      artifactName: "Blueprint Pattern: Bell Silhouette Melton Cape (Vapor Pressing)",
      archiveRegistryCode: "ARC-1947-CAP-084",
      curatorVoiceNote: "Journal de confection: Démonstration de drapé à la vapeur",
    ),
    HeritageEra(
      year: 1968,
      title: "L'Émancipation Géométrique",
      frenchSubtitle: "LE SMOKING FÉMININ & LA DÉCONSTRUCTION DU CORSET",
      narrative:
          "As Parisian streets filled with cultural revolution, Atelier dismantled the rigid internal canvas of traditional tailoring. The first unlined female tuxedo was presented in midnight barathea wool, featuring lapels cut on the bias to hug the collarbone.",
      imageUrl:
          "https://images.unsplash.com/photo-1539109136881-3be0616acf4b?auto=format&fit=crop&w=1000&q=80",
      artifactName: "First Unlined Midnight Barathea Tuxedo Jacket (1968 Prototype)",
      archiveRegistryCode: "ARC-1968-SMK-210",
      curatorVoiceNote: "Entretien d'archive: Éléonore de Vance sur la liberté de mouvement",
    ),
    HeritageEra(
      year: 1989,
      title: "L'Obsidienne & Le Minimalisme",
      frenchSubtitle: "BREVET DU BOUTON EN CORNE NATURELLE & TISSAGE OBSIDIENNE",
      narrative:
          "The Atelier registered French Patent No. 4192 for its signature water buffalo horn button with double-concave recessed eyelets. The decade was defined by stark, architectural obsidian outerwear that set the standard for modern couture purism.",
      imageUrl:
          "https://images.unsplash.com/photo-1490481651871-ab68de25d43d?auto=format&fit=crop&w=1000&q=80",
      artifactName: "Patent No. 4192: Natural Water Buffalo Horn Button Matrix",
      archiveRegistryCode: "ARC-1989-PAT-4192",
      curatorVoiceNote: "Notes de laboratoire: Teinture minérale noir obsidienne",
    ),
    HeritageEra(
      year: 2005,
      title: "L'Or Alchimique & Soie de Lyon",
      frenchSubtitle: "FUSION DES JACQUARDS SÉCULAIRES ET DES FILAMENTS D'OR",
      narrative:
          "Partnering with the historic silk mills of Lyon, the Maison wove 24-karat gold-wrapped silk filaments directly into silk twill linings. Each jacket lining concealed a secret golden heraldic crest visible only to the wearer.",
      imageUrl:
          "https://images.unsplash.com/photo-1469334031218-e382a71b716b?auto=format&fit=crop&w=1000&q=80",
      artifactName: "Spool of 24k Gold Gilt Silk Filament (Manufacture de Lyon)",
      archiveRegistryCode: "ARC-2005-LYN-880",
      curatorVoiceNote: "Chronique des métiers d'art: Tissage à bras jacquard",
    ),
    HeritageEra(
      year: 2026,
      title: "La Haute Couture Numérique",
      frenchSubtitle: "SIMULATION KINÉTIQUE, BLOCKCHAIN AURA & DRAPÉ D'AVENIR",
      narrative:
          "Today, the Atelier enters its second century. Aerodynamic kinetic drape simulators, encrypted Aura blockchain provenance chips, and bespoke zero-waste algorithmic cutting coexist with 100-year-old hand-stitching traditions in our Paris salon.",
      imageUrl:
          "https://images.unsplash.com/photo-1485968579580-b6d095142e6e?auto=format&fit=crop&w=1000&q=80",
      artifactName: "Aura Blockchain Physical NFC Micro-Chip (Couture Passport 2026)",
      archiveRegistryCode: "ARC-2026-NFC-CENTURY",
      curatorVoiceNote: "Manifeste du centenaire: Permanence et innovation quantique",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectEra(int index) {
    if (_selectedEraIndex == index) return;
    HapticService.heavy();
    setState(() {
      _selectedEraIndex = index;
      _isPlayingAudio = false;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void _toggleAudioSnippet(HeritageEra era) {
    HapticService.selection();
    setState(() => _isPlayingAudio = !_isPlayingAudio);
    if (_isPlayingAudio) {
      Get.snackbar(
        'Archival Audio Playback',
        era.curatorVoiceNote,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: AppColors.champagneGold,
        icon: const Icon(CupertinoIcons.waveform, color: AppColors.champagneGold),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeEra = _eras[_selectedEraIndex];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0917) : const Color(0xFFF3F0FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'L’ARCHIVE HISTORIQUE',
          style: AppTypography.brandLogo(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.champagneGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.champagneGold, width: 0.8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.shield_fill, size: 12, color: AppColors.champagneGold),
                SizedBox(width: 4),
                Text(
                  '1924–2026',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: AppColors.champagneGold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Interactive Century Timeline Ribbon
          Container(
            height: 72,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF121217) : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.white12 : Colors.black12,
                ),
              ),
            ),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _eras.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final era = _eras[index];
                final isSelected = _selectedEraIndex == index;

                return GestureDetector(
                  onTap: () => _selectEra(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.champagneGold
                          : (isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFEFECE6)),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.champagneGold
                            : (isDark ? Colors.white10 : Colors.black12),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.champagneGold.withValues(alpha: 0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${era.year}',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? Colors.black
                                  : (isDark ? Colors.white : Colors.black87),
                            ),
                          ),
                          Container(
                            width: 12,
                            height: 2,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.black54 : Colors.transparent,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. Era Content PageView
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _eras.length,
              onPageChanged: (i) {
                HapticService.selection();
                setState(() {
                  _selectedEraIndex = i;
                  _isPlayingAudio = false;
                });
              },
              itemBuilder: (context, index) {
                final era = _eras[index];
                return _buildEraDetailPage(era, isDark);
              },
            ),
          ),

          // 3. Bottom Registry Code & Curator Audio Pill
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF101014) : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.white12 : Colors.black12,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.champagneGold.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.archivebox_fill,
                      size: 16,
                      color: AppColors.champagneGold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'NATIONAL ARCHIVE REGISTRY',
                          style: AppTypography.microTag(color: AppColors.champagneGold),
                        ),
                        Text(
                          activeEra.archiveRegistryCode,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Courier',
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _toggleAudioSnippet(activeEra),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: _isPlayingAudio
                            ? AppColors.champagneGold
                            : (isDark ? Colors.white12 : Colors.black12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isPlayingAudio
                                ? CupertinoIcons.pause_fill
                                : CupertinoIcons.play_arrow_solid,
                            size: 12,
                            color: _isPlayingAudio
                                ? Colors.black
                                : (isDark ? Colors.white : Colors.black),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isPlayingAudio ? 'PLAYING' : 'AUDIO',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: _isPlayingAudio
                                  ? Colors.black
                                  : (isDark ? Colors.white : Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEraDetailPage(HeritageEra era, bool isDark) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      children: [
        // Year Hero
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '${era.year}',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 64,
                fontWeight: FontWeight.w700,
                color: AppColors.champagneGold,
                height: 0.9,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CENTURY CHRONICLE',
                    style: AppTypography.microTag(
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                  ),
                  Text(
                    era.frenchSubtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                      color: isDark ? AppColors.champagneGold : const Color(0xFF4B2FD6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Title
        Text(
          era.title,
          style: GoogleFonts.cormorantGaramond(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            height: 1.2,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),

        // Photographic Parchment Card with Vintage Frame
        Container(
          height: 230,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.champagneGold.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                era.imageUrl,
                fit: BoxFit.cover,
              ),
              // Sepia / Vignette overlay
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF664422).withValues(alpha: 0.25),
                      Colors.black.withValues(alpha: 0.75),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 14,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.rosette, size: 14, color: AppColors.champagneGold),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        era.artifactName,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Narrative Body in parchment box
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF17132C) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.black12,
            ),
          ),
          child: Text(
            era.narrative,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 18,
              height: 1.6,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFFE2E2E8) : const Color(0xFF2E2E32),
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Provenance & Authenticity Guarantee Box
        LiquidGlassContainer(
          borderRadius: 18,
          blur: 16,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          color: isDark
              ? const Color(0xFF181820).withValues(alpha: 0.6)
              : const Color(0xFFF1EFEA).withValues(alpha: 0.9),
          borderColor: AppColors.champagneGold.withValues(alpha: 0.3),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.champagneGold,
                ),
                child: const Center(
                  child: Text(
                    'V',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontFamily: 'serif',
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
                      'CONSERVATEUR DU PATRIMOINE',
                      style: AppTypography.microTag(color: AppColors.champagneGold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Certified authentic by the Maison Atelier Historical Trust.',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
