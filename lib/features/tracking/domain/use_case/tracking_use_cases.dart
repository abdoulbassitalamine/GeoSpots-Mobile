import 'package:geo_spots/core/utils/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entity/current_location_entity.dart';
import '../entity/location_share_session_entity.dart';
import '../entity/public_location_entity.dart';
import '../repository/tracking_repository.dart';

part 'tracking_use_cases.g.dart';

@riverpod
TrackingUseCases trackingUseCases(Ref ref) => TrackingUseCases(ref: ref);

class TrackingUseCases {
  TrackingUseCases({required this.ref});

  final Ref ref;

  ITrackingRepository get _repository => ref.read(trackingRepositoryProvider);

  Future<Result<void>> updatePosition({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
  }) => _execute(
    () => _repository.updatePosition(
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp,
    ),
  );

  Future<Result<CurrentLocationEntity?>> getCurrentLocation() =>
      _execute(() => _repository.getCurrentLocation());

  Future<Result<void>> deleteCurrentLocation() =>
      _execute(() => _repository.deleteCurrentLocation());

  Future<Result<LocationShareSessionEntity>> startLocationSharing() =>
      _execute(() => _repository.startLocationSharing());

  Future<Result<void>> stopLocationSharing() =>
      _execute(() => _repository.stopLocationSharing());

  Future<Result<PublicLocationEntity?>> getPublicLocation(String shareToken) =>
      _execute(() => _repository.getPublicLocation(shareToken));

  Future<Result<void>> enableTracking() =>
      _execute(() => _repository.enableTracking());

  Future<Result<void>> disableTracking() =>
      _execute(() => _repository.disableTracking());

  Future<Result<bool>> isTrackingEnabled() =>
      _execute(() => _repository.isTrackingEnabled());

  Future<Result<T>> _execute<T>(Future<T> Function() action) async {
    try {
      return Ok(await action());
    } on Exception catch (e, st) {
      return Err(e, st);
    }
  }
}
