import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/account_controller.dart';
import 'controllers/auth_controller.dart';
import 'core/network/api_client.dart';
import 'data/mock/mock_api_client.dart';
import 'data/repositories/account_repository.dart';
import 'data/repositories/catalog_repository.dart';
import 'controllers/atelier_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/notifications_controller.dart';
import 'controllers/orders_controller.dart';
import 'controllers/wishlist_controller.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global error net: framework errors are reported as usual, and async
  // errors that escape every handler are logged instead of crashing the app.
  // Plug a crash reporter in here once one is chosen.
  FlutterError.onError = FlutterError.presentError;
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Uncaught async error: $error\n$stack');
    return true;
  };

  // Edge to edge transparent system navigation
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await GetStorage.init();

  // Composition root: the one place that decides which API backs the app.
  // Replace MockApiClient with an HTTP ApiClient once the backend is live
  // (see docs/API.md); nothing else needs to change.
  final ApiClient api = MockApiClient();
  Get.put(AuthController());
  Get.put(AtelierController(repository: CatalogRepository(api)));
  Get.put(AccountController(repository: AccountRepository(api)));

  // Legacy controllers for backward compatibility
  Get.put(CartController());
  Get.put(WishlistController());
  Get.put(OrdersController());
  Get.put(NotificationsController());

  runApp(const AtelierApp());
}

class AtelierApp extends StatelessWidget {
  const AtelierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SILOU',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      // iOS-style slide + edge swipe-back on every pushed page, so the
      // installed web app navigates like a native one.
      defaultTransition: Transition.cupertino,
      popGesture: true,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
