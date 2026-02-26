import 'package:geo_spots/features/collections/data/datasource/collections_local_datasource_impl.dart';
import 'package:geo_spots/features/collections/domain/entity/shared_access_token_entity.dart';
import 'package:geo_spots/shared/storage/secure_storage/datasource/secure_storage_datasource.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final collectionsLocalDatasourceProvider =
    Provider<ICollectionsLocalDatasource>(
      (ref) => CollectionsLocalDatasourceImpl(
        secureStorage: ref.watch(secureStorageDataSourceProvider),
      ),
    );

abstract interface class ICollectionsLocalDatasource {
  Future<List<SharedAccessTokenEntity>> getSharedAccessTokens();

  Future<void> saveSharedAccessTokens(List<SharedAccessTokenEntity> tokens);

  Future<void> upsertSharedAccessToken(SharedAccessTokenEntity token);

  Future<void> removeSharedAccessToken(String token);

  Future<void> clearSharedAccessTokens();
}
