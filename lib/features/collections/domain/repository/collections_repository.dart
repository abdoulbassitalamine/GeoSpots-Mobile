import 'package:geo_spots/features/collections/data/datasource/collections_local_datasource.dart';
import 'package:geo_spots/features/collections/data/datasource/collections_remote_datasource.dart';
import 'package:geo_spots/features/collections/data/repository/collections_repository_impl.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_import_result_entity.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_share_result_entity.dart';
import 'package:geo_spots/features/collections/domain/entity/shared_access_token_entity.dart';
import 'package:geo_spots/features/collections/domain/entity/token_discover_result_entity.dart';
import 'package:geo_spots/features/collections/domain/enums/export_format.dart';
import 'package:geo_spots/features/collections/domain/enums/share_access_right.dart';
import 'package:geo_spots/features/collections/domain/enums/share_resource_type.dart';
import 'package:geo_spots/features/places/data/datasource/places_remote_datasource.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'collections_repository.g.dart';

@Riverpod(keepAlive: true)
CollectionsRepository collectionsRepository(Ref ref) =>
    CollectionsRepositoryImpl(
      remoteDatasource: ref.watch(collectionsRemoteDatasourceProvider),
      localDatasource: ref.watch(collectionsLocalDatasourceProvider),
      placesDatasource: ref.watch(placesRemoteDatasourceProvider),
    );

abstract interface class CollectionsRepository {
  Future<List<CollectionEntity>> getOwnedCollections();

  Future<List<SharedAccessTokenEntity>> getSharedAccessTokens();

  Future<List<SharedAccessTokenEntity>> getOwnedShareTokens();

  Future<List<CollectionEntity>> getSharedCollections();

  Future<List<PlaceEntity>> getCollectionPlaces({
    required String collectionId,
    String? token,
  });

  Future<String> exportCollection({
    required CollectionEntity collection,
    required ExportFormat format,
  });

  Future<CollectionImportResultEntity> importCollectionFile({
    required String filePath,
    required ExportFormat format,
    List<String> defaultTags,
    bool skipDuplicates,
  });

  Future<CollectionImportResultEntity> importRawCollectionContent({
    required String content,
    required ExportFormat format,
    List<String> defaultTags,
    bool skipDuplicates,
  });

  Future<CollectionShareResultEntity> shareCollection({
    required CollectionEntity collection,
    required ShareAccessRight rights,
    DateTime? expiresAt,
    String? label,
  });

  Future<SharedAccessTokenEntity> importSharedAccess({
    required String baseUrl,
    required String token,
  });

  Future<void> revokeSharedAccess(String token);
  Future<void> revokeOwnedShare(String id);

  Future<SharedAccessTokenEntity?> getTokenForResource({
    required ShareResourceType resourceType,
    required String resourceId,
  });

  Future<List<SharedAccessTokenEntity>> getTokens();

  Future<SharedAccessTokenEntity> createToken({
    required ShareResourceType resourceType,
    required String resourceId,
    required ShareAccessRight rights,
    DateTime? expiresAt,
    String? label,
  });

  Future<SharedAccessTokenEntity?> getTokenById(String id);

  Future<SharedAccessTokenEntity?> updateTokenExpiration({
    required String id,
    required DateTime expiration,
  });

  Future<void> revokeTokenById(String id);

  Future<TokenDiscoverResultEntity> discoverToken(String token);

  String buildSharedUrl({
    required String baseUrl,
    required String token,
    required ShareAccessRight rights,
  });
}
