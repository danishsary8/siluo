import 'app_failure.dart';

/// Outcome of an operation that can fail in an expected way (network down,
/// server error, bad payload).
///
/// Repositories return a [Result] instead of throwing, so callers must handle
/// both branches explicitly:
///
/// ```dart
/// switch (await repository.fetchProducts()) {
///   case Success(:final value): products.assignAll(value);
///   case Failure(:final failure): error.value = failure.message;
/// }
/// ```
sealed class Result<T> {
  const Result();

  /// Whether this result holds a value.
  bool get isSuccess => this is Success<T>;

  /// The value when successful, otherwise `null`.
  T? get valueOrNull => switch (this) {
        Success(:final value) => value,
        Failure() => null,
      };

  /// Transforms the success value, leaving a failure untouched.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
        Success(:final value) => Success(transform(value)),
        Failure(:final failure) => Failure(failure),
      };
}

/// A successful [Result] carrying [value].
final class Success<T> extends Result<T> {
  const Success(this.value);

  /// The produced value.
  final T value;
}

/// A failed [Result] carrying a typed [failure].
final class Failure<T> extends Result<T> {
  const Failure(this.failure);

  /// Why the operation failed.
  final AppFailure failure;
}
