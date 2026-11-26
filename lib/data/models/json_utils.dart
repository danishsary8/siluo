import 'dart:ui' show Color;

/// A decoded JSON object.
typedef JsonMap = Map<String, Object?>;

/// Typed, fail-fast readers for decoded JSON.
///
/// Each reader throws a [FormatException] naming the offending field when the
/// payload doesn't match the contract in `docs/API.md`. Repositories catch it
/// and return a `ParseFailure`, so a bad payload never crashes the UI.
extension JsonRead on JsonMap {
  /// Required string field.
  String str(String key) => _req<String>(key);

  /// Optional string field.
  String? strOrNull(String key) => _opt<String>(key);

  /// Required number field as a double (accepts ints).
  double dbl(String key) => _req<num>(key).toDouble();

  /// Optional number field as a double.
  double? dblOrNull(String key) => _opt<num>(key)?.toDouble();

  /// Required integer field (accepts whole doubles like `3.0`).
  int integer(String key) {
    final n = _req<num>(key);
    if (n is int) return n;
    if (n == n.roundToDouble()) return n.toInt();
    throw FormatException('Field "$key" must be an integer, got $n');
  }

  /// Integer field with a default when absent.
  int integerOr(String key, int fallback) => containsKey(key) && this[key] != null ? integer(key) : fallback;

  /// Boolean field with a default when absent.
  bool boolOr(String key, {bool fallback = false}) => _opt<bool>(key) ?? fallback;

  /// Required list of strings.
  List<String> strList(String key) => _req<List<Object?>>(key).map((e) {
        if (e is String) return e;
        throw FormatException('Field "$key" must contain only strings, got $e');
      }).toList(growable: false);

  /// Required list of objects, each converted with [fromJson].
  List<T> objList<T>(String key, T Function(JsonMap json) fromJson) =>
      _req<List<Object?>>(key).map((e) => fromJson(asJsonMap(e, key))).toList(growable: false);

  /// Required ISO-8601 timestamp.
  DateTime dateTime(String key) {
    final raw = str(key);
    return DateTime.tryParse(raw) ?? (throw FormatException('Field "$key" is not an ISO-8601 date: $raw'));
  }

  T _req<T>(String key) {
    final value = this[key];
    if (value is T) return value;
    throw FormatException(
      value == null ? 'Missing required field "$key"' : 'Field "$key" must be $T, got ${value.runtimeType}',
    );
  }

  T? _opt<T>(String key) {
    final value = this[key];
    if (value == null || value is T) return value as T?;
    throw FormatException('Field "$key" must be $T, got ${value.runtimeType}');
  }
}

/// Casts a decoded JSON value to a [JsonMap], or throws a [FormatException]
/// mentioning [context] (e.g. the field or endpoint it came from).
JsonMap asJsonMap(Object? value, String context) {
  if (value is Map<String, Object?>) return value;
  if (value is Map) return value.cast<String, Object?>();
  throw FormatException('Expected a JSON object in "$context", got ${value.runtimeType}');
}

/// Casts a decoded JSON value to a list of [JsonMap]s.
List<JsonMap> asJsonList(Object? value, String context) {
  if (value is! List) throw FormatException('Expected a JSON array in "$context", got ${value.runtimeType}');
  return value.map((e) => asJsonMap(e, context)).toList(growable: false);
}

/// Parses `#RRGGBB` or `#AARRGGBB` into a [Color].
Color colorFromHex(String hex) {
  final cleaned = hex.replaceFirst('#', '');
  final value = int.tryParse(cleaned.length == 6 ? 'FF$cleaned' : cleaned, radix: 16);
  if (value == null || (cleaned.length != 6 && cleaned.length != 8)) {
    throw FormatException('Invalid colour "$hex"; expected #RRGGBB');
  }
  return Color(value);
}

/// Formats a [Color] as `#RRGGBB` (alpha is dropped; swatches are opaque).
String colorToHex(Color color) =>
    '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
