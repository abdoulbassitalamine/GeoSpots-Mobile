import 'package:geo_spots/core/network/dio_client.dart';
import 'package:geo_spots/features/collections/data/dto/collections_api_dto.dart';
import 'package:geo_spots/features/collections/domain/enums/export_format.dart';
import 'package:geo_spots/features/collections/domain/enums/share_resource_type.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'collections_remote_datasource_impl.dart';

final collectionsRemoteDatasourceProvider =
    Provider<ICollectionsRemoteDatasource>(
      (ref) =>
          CollectionsRemoteDatasourceImpl(client: ref.watch(dioClientProvider)),
    );

abstract interface class ICollectionsRemoteDatasource {
  Future<List<CollectionDto>> fetchCollections();

  Future<CollectionDto?> fetchCollectionById(String id, {String? token});

  Future<List<PlaceEntity>> fetchCollectionPlaces(
    String id, {
    String? token,
    int page = 0,
    int size = 200,
    String sort = 'createdAt,desc',
  });

  Future<String> exportCollection(String id, {required ExportFormat format});

  Future<CollectionShareResponseDto> shareCollection({
    required String id,
    required String permission,
    DateTime? expiresAt,
    String? label,
  });

  Future<List<AccessTokenDto>> fetchTokens();

  Future<AccessTokenDto> createToken({
    required ShareResourceType resourceType,
    required String resourceId,
    required String permission,
    DateTime? expiresAt,
    String? label,
  });

  Future<AccessTokenDto?> fetchTokenById(String id);

  Future<AccessTokenDto?> updateTokenExpiration({
    required String id,
    required DateTime expiration,
  });

  Future<void> revokeTokenById(String id);

  Future<DiscoverResponseDto> discoverToken(String token);

  Future<ImportResultDto> importFile({
    required String filePath,
    required ExportFormat format,
    List<String> defaultTags,
    bool skipDuplicates,
  });

  Future<ImportResultDto> importRawContent({
    required String content,
    required ExportFormat format,
    List<String> defaultTags,
    bool skipDuplicates,
  });
}
