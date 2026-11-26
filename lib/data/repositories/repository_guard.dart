import 'package:flutter/foundation.dart';

import '../../core/network/api_client.dart';
import '../../core/network/app_failure.dart';
import '../../core/network/result.dart';

/// Runs [request] and converts every error into a typed [Failure], so
/// repositories never throw to the UI.
///
/// * [ApiException] without a status (offline/timeout) becomes [NetworkFailure].
/// * HTTP 404 becomes [NotFoundFailure] for [resource].
/// * Other HTTP errors become [ServerFailure].
/// * Payloads that don't match the contract ([FormatException], [TypeError])
///   become [ParseFailure].
/// * Anything else becomes [UnknownFailure].
///
/// The original error is logged in debug builds for diagnosis.
Future<Result<T>> guardRequest<T>(String resource, Future<T> Function() request) async {
  try {
    return Success(await request());
  } on ApiException catch (e) {
    debugPrint('[api] $resource: $e');
    if (e.isNetworkError) return const Failure(NetworkFailure());
    if (e.statusCode == 404) return Failure(NotFoundFailure(resource));
    return Failure(ServerFailure(e.statusCode!));
  } on FormatException catch (e) {
    debugPrint('[api] $resource: bad payload: ${e.message}');
    return Failure(ParseFailure(e.message));
  } on TypeError catch (e) {
    debugPrint('[api] $resource: bad payload: $e');
    return Failure(ParseFailure(e.toString()));
  } catch (e, stack) {
    debugPrint('[api] $resource: unexpected error: $e\n$stack');
    return Failure(UnknownFailure(e));
  }
}
