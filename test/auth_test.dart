import 'dart:io';

import 'package:clothing_app/controllers/auth_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final dir = Directory.systemTemp.createTempSync('silou_auth_test');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (_) async => dir.path,
    );
    await GetStorage.init();
  });

  setUp(() async {
    await GetStorage().erase();
    Get.testMode = true;
  });
  tearDown(Get.reset);

  group('validation', () {
    test('email', () {
      expect(AuthController.validateEmail('a@b.co'), isNull);
      expect(AuthController.validateEmail('  A@B.co '), isNull);
      expect(AuthController.validateEmail('nope'), isNotNull);
      expect(AuthController.validateEmail('a@b'), isNotNull);
      expect(AuthController.validateEmail(''), isNotNull);
    });

    test('password: sign-in vs create account', () {
      expect(AuthController.validatePassword('abcdefgh'), isNull);
      expect(AuthController.validatePassword('short'), isNotNull);
      expect(AuthController.validatePassword('abcdefgh', strict: true), isNotNull);
      expect(AuthController.validatePassword('abcd1234', strict: true), isNull);
    });

    test('name rejects markup', () {
      expect(AuthController.validateName('Jane Doe'), isNull);
      expect(AuthController.validateName('<script>'), isNotNull);
      expect(AuthController.validateName('J'), isNotNull);
    });
  });

  test('register signs in, never stores the password, and survives restart', () async {
    final auth = Get.put(AuthController());
    expect(auth.isSignedIn, isFalse);
    expect(auth.shouldNudge, isTrue);

    final error = await auth.register(name: ' Jane   Doe ', email: 'Jane@Example.com', password: 'secret123');
    expect(error, isNull);
    expect(auth.user.value!.name, 'Jane Doe');
    expect(auth.user.value!.email, 'jane@example.com');
    expect(auth.shouldNudge, isFalse);

    final box = GetStorage();
    for (final key in box.getKeys<Iterable<String>>()) {
      expect(box.read(key).toString(), isNot(contains('secret123')));
    }

    Get.reset();
    final restored = Get.put(AuthController());
    expect(restored.user.value?.name, 'Jane Doe');

    restored.signOut();
    expect(restored.isSignedIn, isFalse);

    // Signing in again remembers the registered name.
    expect(await restored.signIn(email: 'jane@example.com', password: 'whatever1'), isNull);
    expect(restored.user.value!.name, 'Jane Doe');
  });

  test('locks out after repeated invalid attempts', () async {
    final auth = Get.put(AuthController());
    for (var i = 0; i < AuthController.maxAttempts; i++) {
      await auth.signIn(email: 'bad', password: 'x');
    }
    final error = await auth.signIn(email: 'ok@example.com', password: 'goodpass1');
    expect(error, contains('Too many attempts'));
    expect(auth.isSignedIn, isFalse);
  });
}
