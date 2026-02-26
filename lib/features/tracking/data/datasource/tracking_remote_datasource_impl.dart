import 'package:dio/dio.dart';
import 'package:geo_spots/core/utils/exception/dio_exception.dart';
import 'package:geo_spots/core/utils/exception/exception.dart';
import 'package:geo_spots/features/tracking/data/datasource/tracking_remote_datasource.dart';
import 'package:geo_spots/features/tracking/data/dto/location_api_dto.dart';
import 'package:geo_spots/features/tracking/domain/entity/current_location_entity.dart';
import 'package:geo_spots/features/tracking/domain/entity/location_share_session_entity.dart';
import 'package:geo_spots/features/tracking/domain/entity/public_location_entity.dart';

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
      await client.post<Object>(
        '/api/location/update',
        data: UpdateLocationRequestDto(
          latitude: latitude,
          longitude: longitude,
          timestamp: timestamp,
        ).toJson(),
      );
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<CurrentLocationEntity?> getCurrentLocation() async {
    try {
      final response = await client.get<Object>('/api/location/current');
      final json = response.asJsonMap();
      if (json == null) {
        throw const ParsingException('Invalid current location payload');
      }
      final dto = ApiResponseCurrentLocationDto.fromJson(json);
      final data = dto.data;
      if (data == null) {
        return null;
      }
      return CurrentLocationEntity(
        id: '${data.id ?? ''}',
        latitude: data.latitude ?? 0,
        longitude: data.longitude ?? 0,
        accuracy: data.accuracy,
        timestamp: data.timestamp,
        isShared: data.isShared ?? false,
        updatedAt: data.updatedAt,
      );
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<void> deleteCurrentLocation() async {
    try {
      await client.delete<Object>('/api/location/current');
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<LocationShareSessionEntity> startSharing() async {
    try {
      final response = await client.post<Object>('/api/location/share');
      final json = response.asJsonMap();
      if (json == null) {
        throw const ParsingException('Invalid start location share payload');
      }
      final dto = ApiResponseShareLocationResponseDto.fromJson(json);
      final data = dto.data;
      if (data == null) {
        throw const ParsingException('Missing location share payload');
      }
      return LocationShareSessionEntity(
        token: data.token ?? '',
        url: data.url ?? '',
        expiresAt: data.expiresAt,
      );
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<void> stopSharing() async {
    try {
      await client.delete<Object>('/api/location/share');
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<PublicLocationEntity?> getPublicLocation(String shareToken) async {
    try {
      final response = await client.get<Object>(
        '/api/location/public/$shareToken',
      );
      final json = response.asJsonMap();
      if (json == null) {
        throw const ParsingException('Invalid public location payload');
      }
      final dto = ApiResponsePublicLocationDto.fromJson(json);
      final data = dto.data;
      if (data == null) {
        return null;
      }
      return PublicLocationEntity(
        latitude: data.latitude ?? 0,
        longitude: data.longitude ?? 0,
        accuracy: data.accuracy,
        timestamp: data.timestamp,
        updatedAt: data.updatedAt,
        ageSeconds: data.ageSeconds,
      );
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
}
