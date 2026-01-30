import 'package:geo_spots/features/tracking/data/datasource/tracking_remote_datasource_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/network/dio_client.dart';

final trackingRemoteDatasourceProvider = Provider<ITrackingRemoteDatasource>(
  (ref) => TrackingRemoteDatasourceImpl(client: ref.watch(dioClientProvider)),
);

abstract interface class ITrackingRemoteDatasource {
  Future<void> sendPositionUpdate({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
  });
}
