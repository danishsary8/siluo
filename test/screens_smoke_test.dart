import 'package:clothing_app/controllers/account_controller.dart';
import 'package:clothing_app/controllers/atelier_controller.dart';
import 'package:clothing_app/core/theme/app_theme.dart';
import 'package:clothing_app/data/mock/mock_atelier_data.dart';
import 'package:clothing_app/modules/archive/atelier_heritage_archive_view.dart';
import 'package:clothing_app/modules/authenticity/atelier_passport_view.dart';
import 'package:clothing_app/modules/checkout/atelier_checkout_view.dart';
import 'package:clothing_app/modules/compare/atelier_compare_view.dart';
import 'package:clothing_app/modules/concierge/atelier_consultation_suite_view.dart';
import 'package:clothing_app/modules/gifting/atelier_gifting_view.dart';
import 'package:clothing_app/modules/journal/atelier_journal_view.dart';
import 'package:clothing_app/modules/lookbook/style_the_look_view.dart';
import 'package:clothing_app/modules/magazine/atelier_magazine_view.dart';
import 'package:clothing_app/modules/orders/atelier_order_tracking_view.dart';
import 'package:clothing_app/modules/product_detail/atelier_pdp_view.dart';
import 'package:clothing_app/modules/salon/atelier_salon_booking_view.dart';
import 'package:clothing_app/modules/samples/atelier_swatch_order_view.dart';
import 'package:clothing_app/modules/shell/atelier_shell_view.dart';
import 'package:clothing_app/modules/soundscape/atelier_acoustic_view.dart';
import 'package:clothing_app/modules/vault/nocturne_vault_view.dart';
import 'package:clothing_app/modules/vip/atelier_club_view.dart';
import 'package:clothing_app/modules/visual_search/atelier_visual_search_view.dart';
import 'package:clothing_app/modules/wardrobe/atelier_wardrobe_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Opens every main screen at phone size, in light and dark mode, and fails
/// on any exception (including RenderFlex overflows) raised while building.
void main() {
  final screens = <String, Widget Function()>{
    'Shell (home tab)': () => const AtelierShellView(),
    'Product page': () => AtelierPdpView(product: mockAtelierProducts.first),
    'Checkout': () => const AtelierCheckoutView(),
    'Order tracking': () => const AtelierOrderTrackingView(),
    'Compare': () => const AtelierCompareView(),
    'Passport': () => const AtelierPassportView(),
    'Club': () => const AtelierClubView(),
    'Wardrobe': () => const AtelierWardrobeView(),
    'Vault': () => const NocturneVaultView(),
    'Salon booking': () => const AtelierSalonBookingView(),
    'Consultation': () => const AtelierConsultationSuiteView(),
    'Acoustic': () => const AtelierAcousticView(),
    'Archive': () => const AtelierHeritageArchiveView(),
    'Journal': () => const AtelierJournalView(),
    'Magazine': () => const AtelierMagazineView(),
    'Style the look': () => const StyleTheLookView(),
    'Gifting': () => const AtelierGiftingView(),
    'Visual search': () => const AtelierVisualSearchView(),
    'Swatch order': () => const AtelierSwatchOrderView(),
  };

  setUp(() {
    Get.testMode = true;
    Get.put(AtelierController());
    Get.put(AccountController());
  });
  tearDown(Get.reset);

  for (final dark in [false, true]) {
    for (final entry in screens.entries) {
      testWidgets('${entry.key} builds without errors (${dark ? 'dark' : 'light'})', (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await _preloadFonts(tester);

        // Network images can't load in tests (HTTP returns 400); ignore those
        // and collect every other framework error with its source location.
        final errors = <String>[];
        final previous = FlutterError.onError;
        FlutterError.onError = (details) {
          if (details.exception is NetworkImageLoadException) return;
          final where = RegExp(r'file:///[^\s]+lib/[^\s)]+')
              .firstMatch(details.toString())
              ?.group(0)
              ?.replaceFirst(RegExp(r'^.*?lib/'), 'lib/');
          errors.add('${details.exceptionAsString().split('\n').first}  @ $where');
        };

        await tester.pumpWidget(GetMaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: dark ? ThemeMode.dark : ThemeMode.light,
          home: entry.value(),
        ));
        for (var i = 0; i < 6; i++) {
          await tester.pump(const Duration(milliseconds: 500));
        }

        // Unmount and let any delayed callbacks or timers finish.
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(seconds: 10));

        // The binding requires the original handler back before the test ends.
        FlutterError.onError = previous;
        expect(errors, isEmpty, reason: errors.toSet().join('\n'));
      });
    }
  }
}

/// Loads every bundled font weight up front so the first frame of a screen is
/// laid out with real metrics (not the wide placeholder test font, which would
/// report overflows that never happen on a device).
Future<void> _preloadFonts(WidgetTester tester) async {
  const weights = [FontWeight.w300, FontWeight.w400, FontWeight.w500, FontWeight.w600, FontWeight.w700, FontWeight.w800];
  await tester.pumpWidget(MaterialApp(
    home: Column(children: [
      for (final w in weights) Text('a', style: GoogleFonts.plusJakartaSans(fontWeight: w)),
      // Only the bundled Cormorant styles: an unbundled one would try the network.
      for (final w in weights.skip(2).take(3)) Text('a', style: GoogleFonts.cormorantGaramond(fontWeight: w)),
      for (final w in [FontWeight.w600, FontWeight.w700])
        Text('a', style: GoogleFonts.cormorantGaramond(fontWeight: w, fontStyle: FontStyle.italic)),
      Text('a', style: GoogleFonts.sourceCodePro(fontWeight: FontWeight.w600)),
      Text('a', style: GoogleFonts.sourceCodePro(fontWeight: FontWeight.w700)),
    ]),
  ));
  await tester.runAsync(GoogleFonts.pendingFonts);
  await tester.pumpWidget(const SizedBox());
}
