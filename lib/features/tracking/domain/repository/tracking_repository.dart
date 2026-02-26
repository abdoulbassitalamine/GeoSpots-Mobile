import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/storage/shared_preferences/gs_shared_preferences.dart';
import '../../data/datasource/tracking_remote_datasource.dart';
import '../entity/current_location_entity.dart';
import '../entity/location_share_session_entity.dart';
import '../entity/public_location_entity.dart';

part 'tracking_repository.g.dart';

@Riverpod(keepAlive: true)
ITrackingRepository trackingRepository(Ref ref) => TrackingRepositoryImpl(
  remoteDatasource: ref.watch(trackingRemoteDatasourceProvider),
  sharedPreferences: ref.watch(sharedPreferencesDataSourceProvider),
);

abstract interface class ITrackingRepository {
  Future<void> updatePosition({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
  });

  Future<CurrentLocationEntity?> getCurrentLocation();

  Future<void> deleteCurrentLocation();

  Future<LocationShareSessionEntity> startLocationSharing();

  Future<void> stopLocationSharing();

  Future<PublicLocationEntity?> getPublicLocation(String shareToken);

  Future<void> enableTracking();
  Future<void> disableTracking();
  Future<bool> isTrackingEnabled();
}

class TrackingRepositoryImpl implements ITrackingRepository {
  TrackingRepositoryImpl({
    required this.remoteDatasource,
    required this.sharedPreferences,
  });

  final ITrackingRemoteDatasource remoteDatasource;
  final SharedPreferences sharedPreferences;

  static const String _trackingEnabledKey = 'tracking_enabled';

  @override
  Future<void> updatePosition({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
  }) async {
    await remoteDatasource.sendPositionUpdate(
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp,
    );
  }

  @override
  Future<CurrentLocationEntity?> getCurrentLocation() {
    return remoteDatasource.getCurrentLocation();
  }

  @override
  Future<void> deleteCurrentLocation() {
    return remoteDatasource.deleteCurrentLocation();
  }

  @override
  Future<LocationShareSessionEntity> startLocationSharing() {
    return remoteDatasource.startSharing();
  }

  @override
  Future<void> stopLocationSharing() {
    return remoteDatasource.stopSharing();
  }

  @override
  Future<PublicLocationEntity?> getPublicLocation(String shareToken) {
    return remoteDatasource.getPublicLocation(shareToken);
  }

  @override
  Future<void> enableTracking() async {
    await sharedPreferences.setBool(_trackingEnabledKey, true);
  }

  @override
  Future<void> disableTracking() async {
    await sharedPreferences.setBool(_trackingEnabledKey, false);
  }

  @override
  Future<bool> isTrackingEnabled() async {
    return sharedPreferences.getBool(_trackingEnabledKey) ?? false;
  }
}
