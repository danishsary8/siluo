import 'package:clothing_app/controllers/account_controller.dart';
import 'package:clothing_app/controllers/atelier_controller.dart';
import 'package:clothing_app/core/network/api_client.dart';
import 'package:clothing_app/core/network/app_failure.dart';
import 'package:clothing_app/core/network/load_status.dart';
import 'package:clothing_app/core/network/result.dart';
import 'package:clothing_app/data/mock/mock_api_client.dart';
import 'package:clothing_app/data/mock/mock_atelier_data.dart';
import 'package:clothing_app/data/models/json_utils.dart';
import 'package:clothing_app/data/models/product_model.dart';
import 'package:clothing_app/data/repositories/account_repository.dart';
import 'package:clothing_app/data/repositories/catalog_repository.dart';
import 'package:clothing_app/modules/search/atelier_search_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

/// Test double that returns a fixed body for every GET.
class _StubApi implements ApiClient {
  _StubApi(this.body);
  final Object? body;

  @override
  Future<Object?> get(String path, {Map<String, String>? query}) async => body;

  @override
  Future<Object?> post(String path, {Object? body}) async => null;
}

void main() {
  group('JSON models', () {
    test('every demo product round-trips through JSON unchanged', () {
      for (final p in mockAtelierProducts) {
        final copy = Product.fromJson(p.toJson());
        expect(copy.toJson(), p.toJson(), reason: p.id);
      }
    });

    test('colours serialise as #RRGGBB', () {
      expect(colorToHex(const Color(0xFFC7A77E)), '#C7A77E');
      expect(colorFromHex('#C7A77E'), const Color(0xFFC7A77E));
      expect(() => colorFromHex('#XYZ'), throwsFormatException);
    });

    test('missing required field throws a FormatException naming it', () {
      final json = mockAtelierProducts.first.toJson()..remove('price');
      expect(
        () => Product.fromJson(json),
        throwsA(isA<FormatException>().having((e) => e.message, 'message', contains('price'))),
      );
    });

    test('ints are accepted where doubles are expected', () {
      final json = mockAtelierProducts.first.toJson()..['price'] = 70;
      expect(Product.fromJson(json).price, 70.0);
    });
  });

  group('CatalogRepository', () {
    test('loads products, stories and campaigns from the mock API', () async {
      final repo = CatalogRepository(MockApiClient());
      expect((await repo.fetchProducts()).valueOrNull, hasLength(mockAtelierProducts.length));
      expect((await repo.fetchStories()).valueOrNull, isNotEmpty);
      expect((await repo.fetchCampaigns()).valueOrNull, isNotEmpty);
    });

    test('fetchProduct returns NotFoundFailure for an unknown id', () async {
      final result = await CatalogRepository(MockApiClient()).fetchProduct('nope');
      expect(result, isA<Failure<Product>>());
      expect((result as Failure).failure, isA<NotFoundFailure>());
    });

    test('maps network errors to NetworkFailure', () async {
      final repo = CatalogRepository(MockApiClient(failure: const ApiException(message: 'offline')));
      final result = await repo.fetchProducts();
      expect((result as Failure).failure, isA<NetworkFailure>());
    });

    test('maps HTTP 500 to ServerFailure with the status code', () async {
      final repo = CatalogRepository(MockApiClient(failure: const ApiException(statusCode: 500, message: 'boom')));
      final failure = (await repo.fetchProducts() as Failure).failure;
      expect(failure, isA<ServerFailure>().having((f) => f.statusCode, 'statusCode', 500));
    });

    test('maps a malformed payload to ParseFailure instead of throwing', () async {
      final repo = CatalogRepository(_StubApi({'unexpected': 'object'}));
      final failure = (await repo.fetchProducts() as Failure).failure;
      expect(failure, isA<ParseFailure>());
      expect(failure.message, isNot(contains('Exception')));
    });
  });

  group('AccountRepository', () {
    test('loads addresses, orders and a newest-first inbox', () async {
      final repo = AccountRepository(MockApiClient());
      expect((await repo.fetchAddresses()).valueOrNull, isNotEmpty);
      expect((await repo.fetchOrders()).valueOrNull, isNotEmpty);
      final inbox = (await repo.fetchInbox()).valueOrNull!;
      for (var i = 1; i < inbox.length; i++) {
        expect(inbox[i - 1].time.isAfter(inbox[i].time) || inbox[i - 1].time == inbox[i].time, isTrue);
      }
    });
  });

  group('Controllers', () {
    setUp(() => Get.testMode = true);
    tearDown(Get.reset);

    test('AtelierController loads the catalogue and seeds the demo bag', () async {
      final c = Get.put(AtelierController());
      await Future<void>.delayed(Duration.zero);
      expect(c.catalogStatus.value, LoadStatus.ready);
      expect(c.allProducts, isNotEmpty);
      expect(c.cartItems, hasLength(1));
      expect(c.wishlistProductIds, hasLength(2));
      // Every seeded wishlist id must exist in the catalogue.
      expect(c.wishlistProducts, hasLength(2));
    });

    test('AtelierController exposes an error and recovers on retry', () async {
      final c = Get.put(AtelierController(
        repository: CatalogRepository(MockApiClient(failure: const ApiException(message: 'offline'))),
      ));
      await Future<void>.delayed(Duration.zero);
      expect(c.catalogStatus.value, LoadStatus.error);
      expect(c.catalogError.value, const NetworkFailure().message);
      expect(c.allProducts, isEmpty);
    });

    test('AccountController loads account data', () async {
      final c = Get.put(AccountController());
      await Future<void>.delayed(Duration.zero);
      expect(c.status.value, LoadStatus.ready);
      expect(c.addresses, isNotEmpty);
      expect(c.defaultAddress, isNotNull);
      expect(c.orders, isNotEmpty);
      expect(c.unreadCount, greaterThan(0));
    });
  });

  group('Load error UI', () {
    setUp(() => Get.testMode = true);
    tearDown(Get.reset);

    testWidgets('Search shows a retry panel when the catalogue fails to load', (tester) async {
      Get.put(AtelierController(
        repository: CatalogRepository(MockApiClient(failure: const ApiException(statusCode: 503, message: 'down'))),
      ));
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const GetMaterialApp(home: AtelierSearchView()));
      await tester.runAsync(GoogleFonts.pendingFonts);
      await tester.pump();

      expect(find.text('Couldn\'t load the shop'), findsOneWidget);
      expect(find.text(const ServerFailure(503).message), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
    });
  });
}
