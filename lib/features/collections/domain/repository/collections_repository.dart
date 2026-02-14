import 'package:geo_spots/features/collections/data/datasource/shared_access_secure_datasource.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'package:geo_spots/features/collections/domain/entity/shared_access_token_entity.dart';
import 'package:geo_spots/features/collections/domain/enums/share_access_right.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:geo_spots/features/collections/data/repository/collections_repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final collectionsRepositoryProvider = Provider<CollectionsRepository>(
  (ref) => CollectionsRepositoryImpl(
    sharedAccessSecureDatasource: ref.read(sharedAccessSecureDatasourceProvider),
  ),
);

abstract interface class CollectionsRepository {
  List<CollectionEntity> getOwnedCollections(List<PlaceEntity> allPlaces);

  Future<List<SharedAccessTokenEntity>> getSharedAccessTokens();
  Future<List<SharedAccessTokenEntity>> getOwnedShareTokens();

  Future<List<CollectionEntity>> getSharedCollections();

  Future<SharedAccessTokenEntity> importSharedAccess({
    required String baseUrl,
    required String token,
  });

  Future<void> revokeSharedAccess(String token);
  Future<void> revokeOwnedShare(String token);

  Future<void> saveOwnedShareToken(SharedAccessTokenEntity token);

  Future<SharedAccessTokenEntity?> getTokenForResource({
    required String resourceType,
    required String resourceId,
  });

  String buildSharedUrl({
    required String baseUrl,
    required String token,
    required ShareAccessRight rights,
  });
}
