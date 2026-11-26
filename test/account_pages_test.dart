import 'package:clothing_app/controllers/account_controller.dart';
import 'package:clothing_app/controllers/atelier_controller.dart';
import 'package:clothing_app/modules/account/atelier_address_book_view.dart';
import 'package:clothing_app/modules/account/atelier_inbox_view.dart';
import 'package:clothing_app/modules/account/atelier_measurements_view.dart';
import 'package:clothing_app/modules/account/atelier_order_history_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Widget _app(Widget home) => GetMaterialApp(home: home);

/// Pumps [page] and waits for bundled Google Fonts to finish loading so no
/// font relayout is still pending when the test ends.
Future<void> _pump(WidgetTester tester, Widget page) async {
  await tester.pumpWidget(_app(page));
  await tester.runAsync(GoogleFonts.pendingFonts);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put(AtelierController());
    Get.put(AccountController());
  });
  tearDown(Get.reset);

  testWidgets('measurements: stepper updates value and size', (tester) async {
    await _pump(tester, const AtelierMeasurementsView());
    expect(find.text('84 cm'), findsOneWidget);
    await tester.tap(find.byIcon(CupertinoIcons.add).at(1)); // Bust +
    await tester.pumpAndSettle();
    expect(find.text('85 cm'), findsOneWidget);
  });

  testWidgets('inbox: filter, read all', (tester) async {
    await _pump(tester, const AtelierInboxView());
    expect(AccountController.to.unreadCount, 3);
    await tester.tap(find.text('Offers'));
    await tester.pumpAndSettle();
    expect(find.text('20% off with code SILOU20'), findsOneWidget);
    expect(find.text('New drop: Winter Capsule 26'), findsNothing);
    await tester.tap(find.text('Read all'));
    await tester.pumpAndSettle();
    expect(AccountController.to.unreadCount, 0);
  });

  testWidgets('address book: set default and open form', (tester) async {
    await _pump(tester, const AtelierAddressBookView());
    await tester.tap(find.text('Studio'));
    await tester.pumpAndSettle();
    expect(AccountController.to.defaultAddressId.value, 'a2');
    await tester.tap(find.text('ADD NEW ADDRESS'));
    await tester.pumpAndSettle();
    expect(find.text('New address'), findsOneWidget);
    await tester.tap(find.text('SAVE ADDRESS'));
    await tester.pumpAndSettle();
    expect(find.text('Required'), findsWidgets); // validation blocks empty save
  });

  testWidgets('order history: tabs filter', (tester) async {
    await _pump(tester, const AtelierOrderHistoryView());
    expect(find.text('#ATL-512098'), findsOneWidget);
    await tester.tap(find.text('In Transit').first);
    await tester.pumpAndSettle();
    expect(find.text('#ATL-512098'), findsNothing);
    expect(find.text('#ATL-894201'), findsOneWidget);
  });
}
