import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:geo_spots/core/utils/exception/dio_exception.dart';
import 'package:geo_spots/core/utils/exception/exception.dart';
import 'package:geo_spots/features/collections/data/dto/collections_api_dto.dart';
import 'package:geo_spots/features/collections/domain/enums/export_format.dart';
import 'package:geo_spots/features/collections/domain/enums/share_resource_type.dart';
import 'package:geo_spots/features/places/data/dto/places_response_dto.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:path/path.dart' as path;

import 'collections_remote_datasource.dart';

class CollectionsRemoteDatasourceImpl implements ICollectionsRemoteDatasource {
  CollectionsRemoteDatasourceImpl({required Dio client}) : _client = client;

  final Dio _client;

  @override
  Future<List<CollectionDto>> fetchCollections() async {
    try {
      final response = await _client.get<Object>('/api/collections');
      final json = _responseAsJsonMap(response, label: 'collections response');
      final dto = ApiResponseListCollectionDto.fromJson(json);
      final data = dto.data;
      if (data == null) {
        return const <CollectionDto>[];
      }
      return data;
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<CollectionDto?> fetchCollectionById(String id, {String? token}) async {
    try {
      final response = await _client.get<Object>(
        '/api/collections/$id',
        queryParameters: {
          if (token != null && token.trim().isNotEmpty) 'token': token.trim(),
        },
      );
      final json = _responseAsJsonMap(response, label: 'collection response');
      final dto = ApiResponseCollectionDto.fromJson(json);
      final data = dto.data;
      return data;
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<List<PlaceEntity>> fetchCollectionPlaces(
    String id, {
    String? token,
    int page = 0,
    int size = 200,
    String sort = 'createdAt,desc',
  }) async {
    try {
      final response = await _client.get<Object>(
        '/api/collections/$id/places',
        queryParameters: <String, Object>{
          if (token != null && token.trim().isNotEmpty) 'token': token.trim(),
          'page': page,
          'size': size,
          'sort': sort,
        },
      );
      final json = _responseAsJsonMap(
        response,
        label: 'collection places response',
      );
      final dto = ApiResponsePagePlaceDto.fromJson(json);
      final content = dto.data?.content;
      if (content == null) {
        return const <PlaceEntity>[];
      }
      return content.map(_mapPlace).toList();
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<String> exportCollection(
    String id, {
    required ExportFormat format,
  }) async {
    try {
      final response = await _client.get<Object>(
        '/api/collections/$id/export',
        queryParameters: {'format': format.extension.toUpperCase()},
        options: Options(
          responseType: ResponseType.plain,
          headers: {'Accept': format.mimeType},
        ),
      );
      final data = response.data;
      if (data is String) {
        return data;
      }
      if (data is Uint8List) {
        return utf8.decode(data);
      }
      if (data is List<int>) {
        return utf8.decode(data);
      }
      if (data is Map<String, dynamic>) {
        final body = data['data'];
        if (body is String) {
          return body;
        }
        return jsonEncode(data);
      }
      if (data is Map) {
        return jsonEncode(data);
      }
      throw const ParsingException('Invalid collection export payload');
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<CollectionShareResponseDto> shareCollection({
    required String id,
    required String permission,
    DateTime? expiresAt,
    String? label,
  }) async {
    try {
      final response = await _client.post<Object>(
        '/api/collections/$id/share',
        data: CollectionShareTokenRequestDto(
          permission: permission,
          expiresAt: expiresAt,
          label: label?.trim().isEmpty ?? true ? null : label?.trim(),
        ).toJson(),
      );
      final json = _responseAsJsonMap(
        response,
        label: 'share collection response',
      );
      final dto = ApiResponseCollectionShareDto.fromJson(json);
      final data = dto.data;
      if (data == null) {
        throw const ParsingException('Missing collection share payload');
      }
      return data;
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<List<AccessTokenDto>> fetchTokens() async {
    try {
      final response = await _client.get<Object>('/api/tokens');
      final json = _responseAsJsonMap(response, label: 'tokens response');
      final dto = ApiResponseListAccessTokenDto.fromJson(json);
      final data = dto.data;
      if (data == null) {
        return const <AccessTokenDto>[];
      }
      return data;
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<AccessTokenDto> createToken({
    required ShareResourceType resourceType,
    required String resourceId,
    required String permission,
    DateTime? expiresAt,
    String? label,
  }) async {
    try {
      final parsedResourceId = int.tryParse(resourceId);
      if (parsedResourceId == null) {
        throw const ParsingException('Invalid resource id');
      }
      final response = await _client.post<Object>(
        '/api/tokens',
        data: CreateTokenRequestDto(
          resourceType: resourceType.backendValue,
          resourceId: parsedResourceId,
          permission: permission,
          expiresAt: expiresAt,
          label: label?.trim().isEmpty ?? true ? null : label?.trim(),
        ).toJson(),
      );
      final json = _responseAsJsonMap(response, label: 'create token response');
      final dto = ApiResponseAccessTokenDto.fromJson(json);
      final data = dto.data;
      if (data == null) {
        throw const ParsingException('Missing created token payload');
      }
      return data;
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<AccessTokenDto?> fetchTokenById(String id) async {
    try {
      final response = await _client.get<Object>('/api/tokens/$id');
      final json = _responseAsJsonMap(response, label: 'token response');
      final dto = ApiResponseAccessTokenDto.fromJson(json);
      final data = dto.data;
      return data;
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<AccessTokenDto?> updateTokenExpiration({
    required String id,
    required DateTime expiration,
  }) async {
    try {
      final response = await _client.patch<Object>(
        '/api/tokens/$id/expiration',
        data: UpdateTokenExpirationRequestDto(expiresAt: expiration).toJson(),
      );
      final json = _responseAsJsonMap(
        response,
        label: 'update token expiration response',
      );
      final dto = ApiResponseAccessTokenDto.fromJson(json);
      final data = dto.data;
      return data;
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<void> revokeTokenById(String id) async {
    try {
      await _client.delete<Object>('/api/tokens/$id');
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<DiscoverResponseDto> discoverToken(String token) async {
    try {
      final response = await _client.get<Object>(
        '/api/tokens/discover',
        queryParameters: {'token': token},
      );
      final json = _responseAsJsonMap(
        response,
        label: 'discover token response',
      );
      final dto = ApiResponseDiscoverResponseDto.fromJson(json);
      final data = dto.data;
      if (data == null) {
        throw const ParsingException('Missing discover token payload');
      }
      return data;
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<ImportResultDto> importFile({
    required String filePath,
    required ExportFormat format,
    List<String> defaultTags = const <String>[],
    bool skipDuplicates = true,
  }) async {
    try {
      final response = await _client.post<Object>(
        '/api/import',
        queryParameters: <String, Object>{
          'format': format.extension.toUpperCase(),
          if (defaultTags.isNotEmpty) 'defaultTags': defaultTags,
          'skipDuplicates': skipDuplicates,
        },
        data: FormData.fromMap(<String, Object>{
          'file': await MultipartFile.fromFile(
            filePath,
            filename: path.basename(filePath),
          ),
        }),
      );
      return _mapImportResult(response);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<ImportResultDto> importRawContent({
    required String content,
    required ExportFormat format,
    List<String> defaultTags = const <String>[],
    bool skipDuplicates = true,
  }) async {
    try {
      final response = await _client.post<Object>(
        '/api/import',
        data: ImportRequestDto(
          content: content,
          format: format.extension.toUpperCase(),
          defaultTags: defaultTags.isEmpty ? null : defaultTags,
          skipDuplicates: skipDuplicates,
        ).toJson(),
      );
      return _mapImportResult(response);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  ImportResultDto _mapImportResult(Response<Object> response) {
    final json = _responseAsJsonMap(response, label: 'import response');
    final rootDto = ApiResponseImportResultDto.fromJson(json);
    final data = rootDto.data;
    if (data == null) {
      throw const ParsingException('Missing import payload');
    }

    return ImportResultDto(
      imported: data.imported ?? 0,
      skipped: data.skipped ?? 0,
      errors: data.errors ?? const <String>[],
      places: data.places ?? const <PlaceDto>[],
    );
  }

  PlaceEntity _mapPlace(PlaceDto dto) {
    return PlaceEntity(
      id: dto.id?.toString() ?? '0',
      title: dto.title ?? 'Lieu sans titre',
      description: dto.description ?? '',
      tags: dto.tags ?? const <String>[],
      date: _formatDate(dto.updatedAt ?? dto.createdAt),
      imageUrl: dto.imageUrl,
      latitude: dto.latitude,
      longitude: dto.longitude,
      userId: dto.username,
    );
  }

  Map<String, dynamic> _responseAsJsonMap(
    Response<Object> response, {
    required String label,
  }) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    throw ParsingException('Invalid $label');
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
