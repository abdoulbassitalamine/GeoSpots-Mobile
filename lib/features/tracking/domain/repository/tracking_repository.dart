import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/storage/shared_preferences/gs_shared_preferences.dart';
import '../../data/datasource/tracking_remote_datasource.dart';

final trackingRepositoryProvider = Provider<ITrackingRepository>(
  (ref) => TrackingRepositoryImpl(
    remoteDatasource: ref.watch(trackingRemoteDatasourceProvider),
    sharedPreferences: ref.watch(sharedPreferencesDataSourceProvider),
  ),
);

abstract interface class ITrackingRepository {
  Future<void> updatePosition({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
  });

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
