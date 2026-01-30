import 'package:dio/dio.dart';
import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geo_spots/features/tracking/data/datasource/tracking_remote_datasource.dart';

class TrackingRemoteDatasourceImpl implements ITrackingRemoteDatasource {
  TrackingRemoteDatasourceImpl({required this.client});

  final Dio client;

  @override
  Future<void> sendPositionUpdate({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
  }) async {
    try {
      GsLogger().d('Sending position update: $latitude, $longitude');
    } on DioException catch (e) {
      throw Exception('Failed to send position update: $e');
    }
  }
}
