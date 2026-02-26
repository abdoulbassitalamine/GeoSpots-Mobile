import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entity/collection_entity.dart';
import '../entity/collection_import_result_entity.dart';
import '../entity/collection_share_result_entity.dart';
import '../entity/shared_access_token_entity.dart';
import '../entity/token_discover_result_entity.dart';
import '../enums/export_format.dart';
import '../enums/share_access_right.dart';
import '../enums/share_resource_type.dart';
import '../repository/collections_repository.dart';

part 'collections_use_cases.g.dart';

@riverpod
CollectionsUseCases collectionsUseCases(Ref ref) =>
    CollectionsUseCases(ref: ref);

class CollectionsUseCases {
  CollectionsUseCases({required this.ref});

  final Ref ref;

  CollectionsRepository get _repository =>
      ref.read(collectionsRepositoryProvider);

  Future<Result<List<CollectionEntity>>> getOwnedCollections() =>
      _execute(() => _repository.getOwnedCollections());

  Future<Result<List<CollectionEntity>>> getSharedCollections() =>
      _execute(() => _repository.getSharedCollections());

  Future<Result<List<PlaceEntity>>> getCollectionPlaces({
    required String collectionId,
    String? token,
  }) => _execute(
    () => _repository.getCollectionPlaces(
      collectionId: collectionId,
      token: token,
    ),
  );

  Future<Result<List<SharedAccessTokenEntity>>> getSharedAccessTokens() =>
      _execute(() => _repository.getSharedAccessTokens());

  Future<Result<List<SharedAccessTokenEntity>>> getOwnedShareTokens() =>
      _execute(() => _repository.getOwnedShareTokens());

  Future<Result<String>> exportCollection(
    CollectionEntity collection,
    ExportFormat format,
  ) => _execute(
    () => _repository.exportCollection(collection: collection, format: format),
  );

  Future<Result<CollectionImportResultEntity>> importCollectionFile({
    required String filePath,
    required ExportFormat format,
    List<String> defaultTags = const <String>[],
    bool skipDuplicates = true,
  }) => _execute(
    () => _repository.importCollectionFile(
      filePath: filePath,
      format: format,
      defaultTags: defaultTags,
      skipDuplicates: skipDuplicates,
    ),
  );

  Future<Result<CollectionImportResultEntity>> importRawCollectionContent({
    required String content,
    required ExportFormat format,
    List<String> defaultTags = const <String>[],
    bool skipDuplicates = true,
  }) => _execute(
    () => _repository.importRawCollectionContent(
      content: content,
      format: format,
      defaultTags: defaultTags,
      skipDuplicates: skipDuplicates,
    ),
  );

  Future<Result<CollectionShareResultEntity>> shareCollection({
    required CollectionEntity collection,
    required ShareAccessRight rights,
    DateTime? expiresAt,
    String? label,
  }) => _execute(
    () => _repository.shareCollection(
      collection: collection,
      rights: rights,
      expiresAt: expiresAt,
      label: label,
    ),
  );

  Future<Result<SharedAccessTokenEntity>> importSharedAccess({
    required String baseUrl,
    required String token,
  }) => _execute(
    () => _repository.importSharedAccess(baseUrl: baseUrl, token: token),
  );

  Future<Result<void>> revokeSharedAccess(String token) =>
      _execute(() => _repository.revokeSharedAccess(token));

  Future<Result<void>> revokeOwnedShare(String token) =>
      _execute(() => _repository.revokeOwnedShare(token));

  Future<Result<SharedAccessTokenEntity?>> getTokenForResource({
    required ShareResourceType resourceType,
    required String resourceId,
  }) => _execute(
    () => _repository.getTokenForResource(
      resourceType: resourceType,
      resourceId: resourceId,
    ),
  );

  Future<Result<List<SharedAccessTokenEntity>>> getTokens() =>
      _execute(() => _repository.getTokens());

  Future<Result<SharedAccessTokenEntity>> createToken({
    required ShareResourceType resourceType,
    required String resourceId,
    required ShareAccessRight rights,
    DateTime? expiresAt,
    String? label,
  }) => _execute(
    () => _repository.createToken(
      resourceType: resourceType,
      resourceId: resourceId,
      rights: rights,
      expiresAt: expiresAt,
      label: label,
    ),
  );

  Future<Result<SharedAccessTokenEntity?>> getTokenById(String id) =>
      _execute(() => _repository.getTokenById(id));

  Future<Result<SharedAccessTokenEntity?>> updateTokenExpiration({
    required String id,
    required DateTime expiration,
  }) => _execute(
    () => _repository.updateTokenExpiration(id: id, expiration: expiration),
  );

  Future<Result<void>> revokeTokenById(String id) =>
      _execute(() => _repository.revokeTokenById(id));

  Future<Result<TokenDiscoverResultEntity>> discoverToken(String token) =>
      _execute(() => _repository.discoverToken(token));

  String buildSharedUrl({
    required String baseUrl,
    required String token,
    required ShareAccessRight rights,
  }) {
    return _repository.buildSharedUrl(
      baseUrl: baseUrl,
      token: token,
      rights: rights,
    );
  }

  Future<Result<T>> _execute<T>(Future<T> Function() action) async {
    try {
      return Ok(await action());
    } on Exception catch (e, st) {
      return Err(e, st);
    }
  }
}
