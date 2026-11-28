import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../core/utils/haptic_service.dart';

/// The signed-in shopper. Only non-secret profile fields are kept on the
/// device: passwords are never written to storage.
class AuthUser {
  const AuthUser({required this.name, required this.email});

  final String name;
  final String email;

  String get firstName => name.split(' ').first;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }

  Map<String, dynamic> toJson() => {'name': name, 'email': email};

  static AuthUser? fromJson(Object? json) {
    if (json is! Map) return null;
    final name = json['name'];
    final email = json['email'];
    if (name is! String || email is! String) return null;
    return AuthUser(name: name, email: email);
  }
}

/// Session state: guest or signed in.
///
/// The backend is not live yet, so sign-in is simulated on the device. The
/// validation, throttling and "never store the password" rules below are the
/// same ones the real API client should keep once it is plugged in.
class AuthController extends GetxController {
  AuthController({GetStorage? storage}) : _box = storage ?? GetStorage();

  static AuthController get to => Get.find<AuthController>();

  static const _userKey = 'auth.user';
  static const _namesKey = 'auth.names';
  static const _nudgeKey = 'auth.lastNudge';

  static const maxAttempts = 5;
  static const lockout = Duration(seconds: 30);

  final GetStorage _box;

  final Rxn<AuthUser> user = Rxn<AuthUser>();
  bool get isSignedIn => user.value != null;

  int _failedAttempts = 0;
  DateTime? _lockedUntil;

  @override
  void onInit() {
    super.onInit();
    user.value = AuthUser.fromJson(_box.read(_userKey));
  }

  // ---------------- Validation ----------------

  static final _emailPattern = RegExp(r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+$");

  /// Trims, collapses whitespace and drops control characters.
  static String clean(String input) =>
      input.replaceAll(RegExp(r'[\u0000-\u001F\u007F]'), '').trim().replaceAll(RegExp(r'\s+'), ' ');

  static String? validateName(String? v) {
    final s = clean(v ?? '');
    if (s.isEmpty) return 'Enter your name';
    if (s.length < 2) return 'Name is too short';
    if (s.length > 40) return 'Keep it under 40 characters';
    if (RegExp(r'[<>{}\[\]\\/;$]').hasMatch(s)) return 'Use letters only';
    return null;
  }

  static String? validateEmail(String? v) {
    final s = clean(v ?? '').toLowerCase();
    if (s.isEmpty) return 'Enter your email';
    if (s.length > 254 || !_emailPattern.hasMatch(s)) return 'Enter a valid email';
    return null;
  }

  static String? validatePassword(String? v, {bool strict = false}) {
    final s = v ?? '';
    if (s.isEmpty) return 'Enter your password';
    if (s.length > 128) return 'Password is too long';
    if (!strict) return s.length < 8 ? 'At least 8 characters' : null;
    if (s.length < 8) return 'Use at least 8 characters';
    if (!RegExp(r'[A-Za-z]').hasMatch(s) || !RegExp(r'\d').hasMatch(s)) {
      return 'Mix letters and numbers';
    }
    return null;
  }

  /// 0 (empty) to 4 (strong), for the strength meter.
  static int passwordStrength(String s) {
    if (s.isEmpty) return 0;
    var score = 0;
    if (s.length >= 8) score++;
    if (s.length >= 12) score++;
    if (RegExp(r'[A-Za-z]').hasMatch(s) && RegExp(r'\d').hasMatch(s)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(s) || RegExp(r'(?=.*[a-z])(?=.*[A-Z])').hasMatch(s)) score++;
    return score.clamp(1, 4);
  }

  // ---------------- Session ----------------

  /// Returns an error message, or null on success.
  Future<String?> signIn({required String email, required String password}) async {
    final locked = _lockMessage();
    if (locked != null) return locked;

    final error = validateEmail(email) ?? validatePassword(password);
    if (error != null) {
      _registerFailure();
      return error;
    }

    await Future<void>.delayed(const Duration(milliseconds: 650));
    final cleanEmail = clean(email).toLowerCase();
    final names = _box.read(_namesKey);
    final knownName = names is Map ? names[cleanEmail] as String? : null;
    _startSession(AuthUser(name: knownName ?? _nameFromEmail(cleanEmail), email: cleanEmail));
    return null;
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final error = validateName(name) ?? validateEmail(email) ?? validatePassword(password, strict: true);
    if (error != null) return error;

    await Future<void>.delayed(const Duration(milliseconds: 750));
    final cleanEmail = clean(email).toLowerCase();
    final cleanName = clean(name);
    final names = Map<String, dynamic>.from((_box.read(_namesKey) as Map?) ?? const {});
    names[cleanEmail] = cleanName;
    await _box.write(_namesKey, names);
    _startSession(AuthUser(name: cleanName, email: cleanEmail));
    return null;
  }

  void signOut() {
    user.value = null;
    _box.remove(_userKey);
    HapticService.medium();
  }

  void _startSession(AuthUser u) {
    _failedAttempts = 0;
    _lockedUntil = null;
    user.value = u;
    _box.write(_userKey, u.toJson());
    HapticService.success();
  }

  void _registerFailure() {
    _failedAttempts++;
    if (_failedAttempts >= maxAttempts) {
      _lockedUntil = DateTime.now().add(lockout);
      _failedAttempts = 0;
    }
  }

  String? _lockMessage() {
    final until = _lockedUntil;
    if (until == null) return null;
    final left = until.difference(DateTime.now()).inSeconds;
    if (left <= 0) {
      _lockedUntil = null;
      return null;
    }
    return 'Too many attempts. Try again in ${left}s';
  }

  static String _nameFromEmail(String email) {
    final local = email.split('@').first.replaceAll(RegExp(r'[._\-+0-9]+'), ' ').trim();
    if (local.isEmpty) return 'SILOU Member';
    return local
        .split(' ')
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase() + p.substring(1))
        .join(' ');
  }

  // ---------------- Gentle reminders ----------------

  /// Whether a guest should see the "create an account" reminder: at most
  /// once every 3 days, never for signed-in shoppers.
  bool get shouldNudge {
    if (isSignedIn) return false;
    final last = _box.read(_nudgeKey);
    if (last is! int) return true;
    return DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(last)) > const Duration(days: 3);
  }

  void markNudged() => _box.write(_nudgeKey, DateTime.now().millisecondsSinceEpoch);
}
