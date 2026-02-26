import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:geo_spots/core/utils/exception/dio_exception.dart';
import 'package:geo_spots/core/utils/exception/exception.dart';
import 'package:geo_spots/features/places/data/dto/place_commands_dto.dart';
import 'package:geo_spots/features/places/data/dto/places_response_dto.dart';
import 'package:path/path.dart' as path;

import '../../domain/entity/place_entity.dart';
import '../../domain/entity/place_search_params.dart';
import '../../domain/entity/place_share_result_entity.dart';
import '../../domain/entity/place_upsert_payload.dart';
import 'places_remote_datasource.dart';

class PlacesRemoteDatasourceImpl implements IPlacesRemoteDatasource {
  PlacesRemoteDatasourceImpl({required Dio placesClient})
    : _placesClient = placesClient;

  final Dio _placesClient;

  static const int _defaultPage = 0;
  static const int _defaultSize = 200;
  static const String _defaultSort = 'createdAt,desc';

  @override
  Future<List<PlaceEntity>> fetchAllPlaces() async {
    try {
      final response = await _placesClient.get<Object>(
        '/api/places',
        queryParameters: const {
          'page': _defaultPage,
          'size': _defaultSize,
          'sort': _defaultSort,
        },
      );

      final json = response.asJsonMap();
      if (json == null) {
        throw const ParsingException('Invalid places response payload');
      }

      final dto = ApiResponsePagePlaceDto.fromJson(json);
      return dto.data?.content?.map(_mapPlaceDtoToEntity).toList() ?? const [];
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<List<PlaceEntity>> fetchTagsFilteredPlaces(String tag) {
    return searchPlaces(
      PlaceSearchParams(
        tag: tag,
        page: _defaultPage,
        size: _defaultSize,
        sort: _defaultSort,
      ),
    );
  }

  @override
  Future<List<PlaceEntity>> searchPlaces(PlaceSearchParams params) async {
    final query = params.query;
    final tag = params.tag;
    if ((query == null || query.trim().isEmpty) &&
        (tag == null || tag.trim().isEmpty)) {
      return fetchAllPlaces();
    }

    try {
      final response = await _placesClient.get<Object>(
        '/api/places/search',
        queryParameters: params.toQueryParameters(),
      );

      final json = response.asJsonMap();
      if (json == null) {
        throw const ParsingException('Invalid place search response payload');
      }

      final dto = ApiResponsePagePlaceDto.fromJson(json);
      return dto.data?.content?.map(_mapPlaceDtoToEntity).toList() ?? const [];
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<List<PlaceEntity>> fetchNearbyPlaces(PlaceSearchParams params) async {
    try {
      final response = await _placesClient.get<Object>(
        '/api/places/nearby',
        queryParameters: params.toQueryParameters(),
      );

      final json = response.asJsonMap();
      if (json == null) {
        throw const ParsingException('Invalid nearby places response payload');
      }

      final dto = ApiResponsePagePlaceWithDistanceDto.fromJson(json);
      return dto.data?.content
              ?.map(_mapPlaceWithDistanceDtoToEntity)
              .toList() ??
          const [];
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<List<String>> fetchPlaceTags() async {
    try {
      final response = await _placesClient.get<Object>('/api/places/tags');
      final json = response.asJsonMap();

      if (json == null) {
        throw const ParsingException('Invalid place tags response payload');
      }

      final dto = ApiResponseListStringDto.fromJson(json);
      return dto.data ?? const [];
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<PlaceEntity?> fetchPlaceById(String id, {String? token}) async {
    try {
      final response = await _placesClient.get<Object>(
        '/api/places/$id',
        queryParameters: {
          if (token != null && token.trim().isNotEmpty) 'token': token.trim(),
        },
      );
      final json = response.asJsonMap();

      if (json == null) {
        throw const ParsingException('Invalid place detail response payload');
      }

      final dto = ApiResponsePlaceDto.fromJson(json);
      final place = dto.data;
      if (place == null) {
        return null;
      }

      return _mapPlaceDtoToEntity(place);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<PlaceEntity> createPlace(PlaceUpsertPayload payload) async {
    try {
      final response = await _placesClient.post<Object>(
        '/api/places',
        data: _toUpsertRequestDto(payload).toJson(),
      );
      return _parseSinglePlaceResponse(response);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<PlaceEntity> updatePlace(String id, PlaceUpsertPayload payload) async {
    try {
      final response = await _placesClient.put<Object>(
        '/api/places/$id',
        data: _toUpsertRequestDto(payload).toJson(),
      );
      return _parseSinglePlaceResponse(response);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<void> deletePlace(String id) async {
    try {
      await _placesClient.delete<Object>('/api/places/$id');
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<PlaceEntity> addTag(String id, String tag) async {
    try {
      final response = await _placesClient.post<Object>(
        '/api/places/$id/tags/$tag',
      );
      return _parseSinglePlaceResponse(response);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<PlaceEntity> removeTag(String id, String tag) async {
    try {
      final response = await _placesClient.delete<Object>(
        '/api/places/$id/tags/$tag',
      );
      return _parseSinglePlaceResponse(response);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<PlaceShareResultEntity> sharePlace({
    required String id,
    required String permission,
    DateTime? expiresAt,
    String? label,
  }) async {
    try {
      final response = await _placesClient.post<Object>(
        '/api/places/$id/share',
        data: ShareTokenRequestDto(
          permission: permission,
          expiresAt: expiresAt,
          label: label?.trim().isEmpty ?? true ? null : label?.trim(),
        ).toJson(),
      );

      final json = response.asJsonMap();
      if (json == null) {
        throw const ParsingException('Invalid place share response payload');
      }
      final dto = ApiResponseShareResponseDto.fromJson(json);
      final data = dto.data;
      if (data == null) {
        throw const ParsingException('Missing place share data');
      }

      return PlaceShareResultEntity(
        token: data.token ?? '',
        url: data.url ?? '',
        permission: (data.permission ?? 'READ').toUpperCase(),
        resourceType: (data.resourceType ?? 'PLACE').toUpperCase(),
        resourceId: '${data.resourceId ?? ''}',
        expiresAt: data.expiresAt,
      );
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<PlaceEntity> uploadPlaceImage(String id, String imagePath) async {
    try {
      final response = await _placesClient.post<Object>(
        '/api/places/$id/image',
        data: FormData.fromMap(<String, Object>{
          'file': await MultipartFile.fromFile(
            imagePath,
            filename: path.basename(imagePath),
          ),
        }),
      );
      return _parseSinglePlaceResponse(response);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<PlaceEntity> deletePlaceImage(String id) async {
    try {
      final response = await _placesClient.delete<Object>(
        '/api/places/$id/image',
      );
      return _parseSinglePlaceResponse(response);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<List<int>> fetchImageBytes(String id, {String? token}) async {
    try {
      final response = await _placesClient.get<Object>(
        '/api/images/$id',
        queryParameters: {
          if (token != null && token.trim().isNotEmpty) 'token': token.trim(),
        },
        options: Options(responseType: ResponseType.bytes),
      );

      final data = response.data;
      if (data is Uint8List) {
        return data.toList();
      }
      if (data is List<int>) {
        return data;
      }
      if (data is List) {
        return data.whereType<int>().toList();
      }
      throw const ParsingException('Invalid image payload');
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<void> deleteImage(String id) async {
    try {
      await _placesClient.delete<Object>('/api/images/$id');
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  PlaceEntity _parseSinglePlaceResponse(Response<Object> response) {
    final json = response.asJsonMap();
    if (json == null) {
      throw const ParsingException('Invalid place response payload');
    }

    final dto = ApiResponsePlaceDto.fromJson(json);
    final placeDto = dto.data;
    if (placeDto == null) {
      throw const ParsingException('Missing place data');
    }
    return _mapPlaceDtoToEntity(placeDto);
  }

  PlaceUpsertRequestDto _toUpsertRequestDto(PlaceUpsertPayload payload) =>
      PlaceUpsertRequestDto(
        title: payload.title.trim(),
        description: payload.description.trim(),
        latitude: payload.latitude,
        longitude: payload.longitude,
        imageUrl: payload.imageUrl?.trim().isEmpty ?? true
            ? null
            : payload.imageUrl?.trim(),
        tags: payload.tags,
      );

  PlaceEntity _mapPlaceDtoToEntity(PlaceDto placeDto) {
    return PlaceEntity(
      id: placeDto.id?.toString() ?? '0',
      title: placeDto.title ?? 'Lieu sans titre',
      description: placeDto.description ?? '',
      tags: placeDto.tags ?? const [],
      date: _formatDate(placeDto.updatedAt ?? placeDto.createdAt),
      imageUrl: placeDto.imageUrl,
      latitude: placeDto.latitude,
      longitude: placeDto.longitude,
      userId: placeDto.username,
    );
  }

  PlaceEntity _mapPlaceWithDistanceDtoToEntity(PlaceWithDistanceDto placeDto) {
    return PlaceEntity(
      id: placeDto.id?.toString() ?? '0',
      title: placeDto.title ?? 'Lieu sans titre',
      description: placeDto.description ?? '',
      tags: placeDto.tags ?? const [],
      date: _formatDate(placeDto.updatedAt ?? placeDto.createdAt),
      imageUrl: placeDto.imageUrl,
      latitude: placeDto.latitude,
      longitude: placeDto.longitude,
      userId: placeDto.username,
    );
  }

  String _formatDate(DateTime? value) {
    if (value == null) {
      return '';
    }
    final date = value.toLocal();
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}
