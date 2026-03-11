import 'package:geo_spots/core/utils/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entity/current_location_entity.dart';
import '../entity/location_share_session_entity.dart';
import '../entity/public_location_entity.dart';
import '../repository/tracking_repository.dart';

part 'tracking_use_cases.g.dart';

@riverpod
Future<Result<void>> Function({
  required double latitude,
  required double longitude,
  required DateTime timestamp,
})
updatePositionUseCase(Ref ref) {
  final repository = ref.read(trackingRepositoryProvider);
  return ({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
  }) => _execute(
    () => repository.updatePosition(
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp,
    ),
  );
}

@riverpod
Future<Result<CurrentLocationEntity?>> Function() getCurrentLocationUseCase(
  Ref ref,
) {
  final repository = ref.watch(trackingRepositoryProvider);
  return () => _execute(repository.getCurrentLocation);
}

@riverpod
Future<Result<void>> Function() deleteCurrentLocationUseCase(Ref ref) {
  final repository = ref.read(trackingRepositoryProvider);
  return () => _execute(repository.deleteCurrentLocation);
}

@riverpod
Future<Result<LocationShareSessionEntity>> Function()
startLocationSharingUseCase(Ref ref) {
  final repository = ref.read(trackingRepositoryProvider);
  return () => _execute(repository.startLocationSharing);
}

@riverpod
Future<Result<void>> Function() stopLocationSharingUseCase(Ref ref) {
  final repository = ref.read(trackingRepositoryProvider);
  return () => _execute(repository.stopLocationSharing);
}

@riverpod
Future<Result<PublicLocationEntity?>> Function(String shareToken)
getPublicLocationUseCase(Ref ref) {
  final repository = ref.watch(trackingRepositoryProvider);
  return (shareToken) => _execute(() => repository.getPublicLocation(shareToken));
}

@riverpod
Future<Result<void>> Function() enableTrackingUseCase(Ref ref) {
  final repository = ref.read(trackingRepositoryProvider);
  return () => _execute(repository.enableTracking);
}

@riverpod
Future<Result<void>> Function() disableTrackingUseCase(Ref ref) {
  final repository = ref.read(trackingRepositoryProvider);
  return () => _execute(repository.disableTracking);
}

@riverpod
Future<Result<bool>> Function() isTrackingEnabledUseCase(Ref ref) {
  final repository = ref.watch(trackingRepositoryProvider);
  return () => _execute(repository.isTrackingEnabled);
}

Future<Result<T>> _execute<T>(Future<T> Function() action) async {
  try {
    return Ok(await action());
  } on Exception catch (e, st) {
    return Err(e, st);
  }
}
