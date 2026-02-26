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
Future<Result<List<CollectionEntity>>> Function() getOwnedCollectionsUseCase(
  Ref ref,
) {
  final repository = ref.read(collectionsRepositoryProvider);
  return () => _execute(repository.getOwnedCollections);
}

@riverpod
Future<Result<List<CollectionEntity>>> Function() getSharedCollectionsUseCase(
  Ref ref,
) {
  final repository = ref.read(collectionsRepositoryProvider);
  return () => _execute(repository.getSharedCollections);
}

@riverpod
Future<Result<List<PlaceEntity>>> Function({
  required String collectionId,
  String? token,
})
getCollectionPlacesUseCase(Ref ref) {
  final repository = ref.read(collectionsRepositoryProvider);
  return ({required String collectionId, String? token}) => _execute(
    () => repository.getCollectionPlaces(
      collectionId: collectionId,
      token: token,
    ),
  );
}

@riverpod
Future<Result<List<SharedAccessTokenEntity>>> Function()
getSharedAccessTokensUseCase(Ref ref) {
  final repository = ref.read(collectionsRepositoryProvider);
  return () => _execute(repository.getSharedAccessTokens);
}

@riverpod
Future<Result<List<SharedAccessTokenEntity>>> Function()
getOwnedShareTokensUseCase(Ref ref) {
  final repository = ref.read(collectionsRepositoryProvider);
  return () => _execute(repository.getOwnedShareTokens);
}

@riverpod
Future<Result<String>> Function(
  CollectionEntity collection,
  ExportFormat format,
)
exportCollectionRepositoryUseCase(Ref ref) {
  final repository = ref.read(collectionsRepositoryProvider);
  return (collection, format) => _execute(
    () => repository.exportCollection(collection: collection, format: format),
  );
}

@riverpod
Future<Result<CollectionImportResultEntity>> Function({
  required String filePath,
  required ExportFormat format,
  List<String> defaultTags,
  bool skipDuplicates,
})
importCollectionFileRepositoryUseCase(Ref ref) {
  final repository = ref.read(collectionsRepositoryProvider);
  return ({
    required String filePath,
    required ExportFormat format,
    List<String> defaultTags = const <String>[],
    bool skipDuplicates = true,
  }) => _execute(
    () => repository.importCollectionFile(
      filePath: filePath,
      format: format,
      defaultTags: defaultTags,
      skipDuplicates: skipDuplicates,
    ),
  );
}

@riverpod
Future<Result<CollectionImportResultEntity>> Function({
  required String content,
  required ExportFormat format,
  List<String> defaultTags,
  bool skipDuplicates,
})
importRawCollectionContentRepositoryUseCase(Ref ref) {
  final repository = ref.read(collectionsRepositoryProvider);
  return ({
    required String content,
    required ExportFormat format,
    List<String> defaultTags = const <String>[],
    bool skipDuplicates = true,
  }) => _execute(
    () => repository.importRawCollectionContent(
      content: content,
      format: format,
      defaultTags: defaultTags,
      skipDuplicates: skipDuplicates,
    ),
  );
}

@riverpod
Future<Result<CollectionShareResultEntity>> Function({
  required CollectionEntity collection,
  required ShareAccessRight rights,
  DateTime? expiresAt,
  String? label,
})
shareCollectionUseCase(Ref ref) {
  final repository = ref.read(collectionsRepositoryProvider);
  return ({
    required CollectionEntity collection,
    required ShareAccessRight rights,
    DateTime? expiresAt,
    String? label,
  }) => _execute(
    () => repository.shareCollection(
      collection: collection,
      rights: rights,
      expiresAt: expiresAt,
      label: label,
    ),
  );
}

@riverpod
Future<Result<SharedAccessTokenEntity>> Function({
  required String baseUrl,
  required String token,
})
importSharedAccessUseCase(Ref ref) {
  final repository = ref.read(collectionsRepositoryProvider);
  return ({required String baseUrl, required String token}) => _execute(
    () => repository.importSharedAccess(baseUrl: baseUrl, token: token),
  );
}

@riverpod
Future<Result<void>> Function(String token) revokeSharedAccessUseCase(Ref ref) {
  final repository = ref.read(collectionsRepositoryProvider);
  return (token) => _execute(() => repository.revokeSharedAccess(token));
}

@riverpod
Future<Result<void>> Function(String id) revokeOwnedShareUseCase(Ref ref) {
  final repository = ref.read(collectionsRepositoryProvider);
  return (id) => _execute(() => repository.revokeOwnedShare(id));
}

@riverpod
Future<Result<SharedAccessTokenEntity?>> Function({
  required ShareResourceType resourceType,
  required String resourceId,
})
getTokenForResourceUseCase(Ref ref) {
  final repository = ref.read(collectionsRepositoryProvider);
  return ({
    required ShareResourceType resourceType,
    required String resourceId,
  }) => _execute(
    () => repository.getTokenForResource(
      resourceType: resourceType,
      resourceId: resourceId,
    ),
  );
}

@riverpod
Future<Result<List<SharedAccessTokenEntity>>> Function() getTokensUseCase(
  Ref ref,
) {
  final repository = ref.read(collectionsRepositoryProvider);
  return () => _execute(repository.getTokens);
}

@riverpod
Future<Result<SharedAccessTokenEntity>> Function({
  required ShareResourceType resourceType,
  required String resourceId,
  required ShareAccessRight rights,
  DateTime? expiresAt,
  String? label,
})
createTokenUseCase(Ref ref) {
  final repository = ref.read(collectionsRepositoryProvider);
  return ({
    required ShareResourceType resourceType,
    required String resourceId,
    required ShareAccessRight rights,
    DateTime? expiresAt,
    String? label,
  }) => _execute(
    () => repository.createToken(
      resourceType: resourceType,
      resourceId: resourceId,
      rights: rights,
      expiresAt: expiresAt,
      label: label,
    ),
  );
}

@riverpod
Future<Result<SharedAccessTokenEntity?>> Function(String id)
getTokenByIdUseCase(Ref ref) {
  final repository = ref.read(collectionsRepositoryProvider);
  return (id) => _execute(() => repository.getTokenById(id));
}

@riverpod
Future<Result<SharedAccessTokenEntity?>> Function({
  required String id,
  required DateTime expiration,
})
updateTokenExpirationUseCase(Ref ref) {
  final repository = ref.read(collectionsRepositoryProvider);
  return ({required String id, required DateTime expiration}) => _execute(
    () => repository.updateTokenExpiration(id: id, expiration: expiration),
  );
}

@riverpod
Future<Result<void>> Function(String id) revokeTokenByIdUseCase(Ref ref) {
  final repository = ref.read(collectionsRepositoryProvider);
  return (id) => _execute(() => repository.revokeTokenById(id));
}

@riverpod
Future<Result<TokenDiscoverResultEntity>> Function(String token)
discoverTokenUseCase(Ref ref) {
  final repository = ref.read(collectionsRepositoryProvider);
  return (token) => _execute(() => repository.discoverToken(token));
}

@riverpod
String Function({
  required String baseUrl,
  required String token,
  required ShareAccessRight rights,
})
buildSharedUrlUseCase(Ref ref) {
  final repository = ref.read(collectionsRepositoryProvider);
  return repository.buildSharedUrl;
}

Future<Result<T>> _execute<T>(Future<T> Function() action) async {
  try {
    return Ok(await action());
  } on Exception catch (e, st) {
    return Err(e, st);
  }
}
