import 'package:dio/dio.dart';
import 'package:geo_spots/core/utils/exception/dio_exception.dart';
import 'package:geo_spots/core/utils/exception/exception.dart';
import 'package:geo_spots/features/places/data/dto/places_response_dto.dart';

import '../../domain/entity/place_entity.dart';
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
  Future<List<PlaceEntity>> fetchPlacesByTag(String tag) async {
    try {
      final response = await _placesClient.get<Object>(
        '/api/places/search',
        queryParameters: {
          'tag': tag,
          'page': _defaultPage,
          'size': _defaultSize,
          'sort': _defaultSort,
        },
      );

      final json = response.asJsonMap();
      if (json == null) {
        throw const ParsingException('Invalid places-by-tag response payload');
      }

      final dto = ApiResponsePagePlaceDto.fromJson(json);
      return dto.data?.content?.map(_mapPlaceDtoToEntity).toList() ?? const [];
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<List<PlaceEntity>> searchPlaces(String query) async {
    if (query.trim().isEmpty) {
      return fetchAllPlaces();
    }

    try {
      final response = await _placesClient.get<Object>(
        '/api/places/search',
        queryParameters: {
          'q': query.trim(),
          'page': _defaultPage,
          'size': _defaultSize,
          'sort': _defaultSort,
        },
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
  Future<PlaceEntity?> fetchPlaceById(String id) async {
    try {
      final response = await _placesClient.get<Object>('/api/places/$id');
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

  PlaceEntity _mapPlaceDtoToEntity(PlaceDto placeDto) {
    return PlaceEntity(
      id: placeDto.id?.toString() ?? '0',
      title: placeDto.title ?? 'Lieu sans titre',
      description: placeDto.description ?? '',
      tags: placeDto.tags ?? const [],
      date: _formatDate(placeDto.createdAt),
      imageUrl: placeDto.imageUrl,
      latitude: placeDto.latitude,
      longitude: placeDto.longitude,
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
