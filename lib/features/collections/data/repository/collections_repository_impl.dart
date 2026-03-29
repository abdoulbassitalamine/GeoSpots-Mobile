import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geo_spots/core/utils/exception/exception.dart';
import 'package:geo_spots/features/collections/data/datasource/collections_local_datasource.dart';
import 'package:geo_spots/features/collections/data/datasource/collections_remote_datasource.dart';
import 'package:geo_spots/features/collections/data/dto/collections_api_dto.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_import_result_entity.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_share_result_entity.dart';
import 'package:geo_spots/features/collections/domain/entity/shared_access_token_entity.dart';
import 'package:geo_spots/features/collections/domain/entity/token_discover_result_entity.dart';
import 'package:geo_spots/features/collections/domain/enums/export_format.dart';
import 'package:geo_spots/features/collections/domain/enums/share_access_right.dart';
import 'package:geo_spots/features/collections/domain/enums/share_resource_type.dart';
import 'package:geo_spots/features/collections/domain/repository/collections_repository.dart';
import 'package:geo_spots/features/places/data/datasource/places_remote_datasource.dart';
import 'package:geo_spots/features/places/data/dto/places_response_dto.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';

class CollectionsRepositoryImpl implements CollectionsRepository {
  CollectionsRepositoryImpl({
    required ICollectionsRemoteDatasource remoteDatasource,
    required ICollectionsLocalDatasource localDatasource,
    required IPlacesRemoteDatasource placesDatasource,
  }) : _remoteDatasource = remoteDatasource,
       _localDatasource = localDatasource,
       _placesDatasource = placesDatasource;

  final ICollectionsRemoteDatasource _remoteDatasource;
  final ICollectionsLocalDatasource _localDatasource;
  final IPlacesRemoteDatasource _placesDatasource;

  @override
  Future<List<CollectionEntity>> getOwnedCollections() async {
    final collections = await _remoteDatasource.fetchCollections();
    GsLogger().d(
      'Fetched ${collections.length} collections from remote datasource',
    );
    return collections
        .where((summary) => (summary.id?.toString().trim().isNotEmpty ?? false))
        .map(_toCollectionEntity)
        .toList();
  }

  @override
  Future<List<SharedAccessTokenEntity>> getSharedAccessTokens() {
    return _localDatasource.getSharedAccessTokens();
  }

  @override
  Future<List<SharedAccessTokenEntity>> getOwnedShareTokens() async {
    final remoteTokens = await _remoteDatasource.fetchTokens();
    return remoteTokens
        .where(
          (token) => (token.resourceType ?? '').toUpperCase() == 'COLLECTION',
        )
        .map(_toSharedTokenEntity)
        .toList();
  }

  @override
  Future<List<CollectionEntity>> getSharedCollections() async {
    final savedTokens = await _localDatasource.getSharedAccessTokens();
    final sharedCollections = <CollectionEntity>[];

    for (final token in savedTokens) {
      if (ShareResourceType.fromRaw(token.resourceType) !=
          ShareResourceType.collection) {
        continue;
      }

      try {
        final resourceId = token.resourceId.trim();
        if (resourceId.isNotEmpty) {
          final byId = await _remoteDatasource.fetchCollectionById(
            resourceId,
            token: token.token,
          );
          if (byId != null &&
              (byId.id?.toString().trim().isNotEmpty ?? false)) {
            sharedCollections.add(_toCollectionEntity(byId));
            continue;
          }
        }

        final discovered = await _remoteDatasource.discoverToken(token.token);
        final discoveredCollections =
            discovered.collections ?? const <CollectionDto>[];
        for (final discoveredCollection in discoveredCollections) {
          if (discoveredCollection.id?.toString().trim().isEmpty ?? true) {
            continue;
          }
          sharedCollections.add(_toCollectionEntity(discoveredCollection));
        }
      } on Exception {
        continue;
      }
    }

    return _deduplicateCollections(sharedCollections);
  }

  @override
  Future<List<PlaceEntity>> getCollectionPlaces({
    required String collectionId,
    String? token,
  }) {
    if (collectionId == 'all') {
      return _placesDatasource.fetchAllPlaces();
    }
    return _remoteDatasource.fetchCollectionPlaces(collectionId, token: token);
  }

  @override
  Future<String> exportCollection({
    required CollectionEntity collection,
    required ExportFormat format,
  }) {
    final collectionId = _resolveCollectionId(collection);
    return _remoteDatasource.exportCollection(collectionId, format: format);
  }

  @override
  Future<CollectionImportResultEntity> importCollectionFile({
    required String filePath,
    required ExportFormat format,
    List<String> defaultTags = const <String>[],
    bool skipDuplicates = true,
  }) async {
    final result = await _remoteDatasource.importFile(
      filePath: filePath,
      format: format,
      defaultTags: defaultTags,
      skipDuplicates: skipDuplicates,
    );
    return CollectionImportResultEntity(
      imported: result.imported ?? 0,
      skipped: result.skipped ?? 0,
      errors: result.errors ?? const <String>[],
      places:
          result.places?.map(_toPlaceEntityFromDto).toList() ??
          const <PlaceEntity>[],
    );
  }

  @override
  Future<CollectionImportResultEntity> importRawCollectionContent({
    required String content,
    required ExportFormat format,
    List<String> defaultTags = const <String>[],
    bool skipDuplicates = true,
  }) async {
    final result = await _remoteDatasource.importRawContent(
      content: content,
      format: format,
      defaultTags: defaultTags,
      skipDuplicates: skipDuplicates,
    );
    return CollectionImportResultEntity(
      imported: result.imported ?? 0,
      skipped: result.skipped ?? 0,
      errors: result.errors ?? const <String>[],
      places:
          result.places?.map(_toPlaceEntityFromDto).toList() ??
          const <PlaceEntity>[],
    );
  }

  @override
  Future<CollectionShareResultEntity> shareCollection({
    required CollectionEntity collection,
    required ShareAccessRight rights,
    DateTime? expiresAt,
    String? label,
  }) async {
    final collectionId = _resolveCollectionId(collection);
    final remoteResult = await _remoteDatasource.shareCollection(
      id: collectionId,
      permission: rights == ShareAccessRight.write ? 'WRITE' : 'READ',
      expiresAt: expiresAt,
      label: label,
    );
    final token = SharedAccessTokenEntity(
      token: remoteResult.token ?? '',
      baseUrl: _baseUrlFromShareUrl(remoteResult.url ?? ''),
      isValid: true,
      rights: _mapPermission(remoteResult.permission ?? ''),
      resourceType: ShareResourceType.fromRaw(
        remoteResult.resourceType,
      ).normalizedValue,
      resourceId: remoteResult.resourceId?.toString() ?? '',
      expiresAt: remoteResult.expiresAt,
    );
    return CollectionShareResultEntity(
      url: remoteResult.url ?? '',
      token: token,
    );
  }

  @override
  Future<SharedAccessTokenEntity> importSharedAccess({
    required String baseUrl,
    required String token,
  }) async {
    final normalizedUrl = baseUrl.trim().replaceAll(RegExp(r'/$'), '');
    final normalizedToken = token.trim();

    if (normalizedUrl.isEmpty || normalizedToken.isEmpty) {
      throw const ServerException('URL et token sont obligatoires');
    }

    final rights = _inferRightsFromToken(normalizedToken);
    final resourceType = ShareResourceType.collection.normalizedValue;
    var resourceId = '';

    try {
      final discovered = await _remoteDatasource.discoverToken(normalizedToken);
      final firstCollection = discovered.collections?.firstWhere(
        (collection) => collection.id != null,
        orElse: () => const CollectionDto(),
      );
      final discoveredId = firstCollection?.id?.toString().trim() ?? '';
      if (discoveredId.isNotEmpty) {
        resourceId = discoveredId;
      }
    } on Exception {
      // Keep fallback values when discovery fails.
    }

    final entity = SharedAccessTokenEntity(
      token: normalizedToken,
      baseUrl: normalizedUrl,
      isValid: true,
      rights: rights,
      resourceType: resourceType,
      resourceId: resourceId,
      expiresAt: null,
    );

    await _localDatasource.upsertSharedAccessToken(entity);
    return entity;
  }

  @override
  Future<void> revokeSharedAccess(String token) async {
    await _localDatasource.removeSharedAccessToken(token);
  }

  @override
  Future<void> revokeOwnedShare(String id) async {
    final normalizedId = id.trim();
    if (normalizedId.isEmpty) {
      throw const ServerException('Identifiant de token manquant');
    }
    await _remoteDatasource.revokeTokenById(normalizedId);
  }

  @override
  Future<SharedAccessTokenEntity?> getTokenForResource({
    required ShareResourceType resourceType,
    required String resourceId,
  }) async {
    final sharedTokens = await _localDatasource.getSharedAccessTokens();
    for (final token in sharedTokens) {
      if (_matchesResource(token, resourceType, resourceId)) {
        return token;
      }
    }

    try {
      final remoteTokens = await _remoteDatasource.fetchTokens();
      for (final remoteToken in remoteTokens) {
        final token = _toSharedTokenEntity(remoteToken);
        if (_matchesResource(token, resourceType, resourceId)) {
          return token;
        }
      }
    } on Exception {
      // Ignore remote failure here and fall back to local shared tokens only.
    }

    return null;
  }

  @override
  Future<List<SharedAccessTokenEntity>> getTokens() async {
    final tokens = await _remoteDatasource.fetchTokens();
    return tokens.map(_toSharedTokenEntity).toList();
  }

  @override
  Future<SharedAccessTokenEntity> createToken({
    required ShareResourceType resourceType,
    required String resourceId,
    required ShareAccessRight rights,
    DateTime? expiresAt,
    String? label,
  }) async {
    final token = await _remoteDatasource.createToken(
      resourceType: resourceType,
      resourceId: resourceId,
      permission: rights == ShareAccessRight.write ? 'WRITE' : 'READ',
      expiresAt: expiresAt,
      label: label,
    );
    return _toSharedTokenEntity(token);
  }

  @override
  Future<SharedAccessTokenEntity?> getTokenById(String id) async {
    final token = await _remoteDatasource.fetchTokenById(id);
    if (token == null) {
      return null;
    }
    return _toSharedTokenEntity(token);
  }

  @override
  Future<SharedAccessTokenEntity?> updateTokenExpiration({
    required String id,
    required DateTime expiration,
  }) async {
    final updated = await _remoteDatasource.updateTokenExpiration(
      id: id,
      expiration: expiration,
    );
    if (updated == null) {
      return null;
    }
    return _toSharedTokenEntity(updated);
  }

  @override
  Future<void> revokeTokenById(String id) {
    return _remoteDatasource.revokeTokenById(id);
  }

  @override
  Future<TokenDiscoverResultEntity> discoverToken(String token) async {
    final discovered = await _remoteDatasource.discoverToken(token);
    final collections = (discovered.collections ?? const <CollectionDto>[])
        .map(_toCollectionEntity)
        .toList();

    return TokenDiscoverResultEntity(
      serverUrl: discovered.serverUrl ?? '',
      tokenLabel: discovered.tokenLabel ?? '',
      collections: collections,
      places:
          discovered.places?.map(_toPlaceEntityFromDto).toList() ??
          const <PlaceEntity>[],
      locationAvailable: discovered.locationAvailable ?? false,
    );
  }

  @override
  String buildSharedUrl({
    required String baseUrl,
    required String token,
    required ShareAccessRight rights,
  }) {
    final normalized = baseUrl.replaceAll(RegExp(r'/$'), '');
    return '$normalized/shared/collections?token=$token&rights=${rights.value}';
  }

  CollectionEntity _toCollectionEntity(CollectionDto summary) {
    final id = summary.id?.toString() ?? '';
    final name = summary.name?.trim() ?? '';
    final tagFilter = summary.tagFilter?.trim();
    final effectiveTag = name.isEmpty
        ? (tagFilter?.isNotEmpty ?? false)
              ? tagFilter!
              : 'Collection $id'
        : name;
    final count = summary.placeCount ?? 0;

    return CollectionEntity(id: id, tag: effectiveTag, placesCount: count);
  }

  SharedAccessTokenEntity _toSharedTokenEntity(AccessTokenDto token) {
    final fallbackBaseUrl = dotenv.env['API_BASE_URL'] ?? '';
    return SharedAccessTokenEntity(
      id: token.id?.toString() ?? '',
      token: token.token ?? '',
      baseUrl: fallbackBaseUrl,
      isValid: _resolveTokenValidity(token),
      rights: _mapPermission(token.permission ?? ''),
      resourceType: ShareResourceType.fromRaw(
        token.resourceType,
      ).normalizedValue,
      resourceId: token.resourceId?.toString() ?? '',
      expiresAt: token.expiresAt,
    );
  }

  PlaceEntity _toPlaceEntityFromDto(PlaceDto dto) {
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

  ShareAccessRight _mapPermission(String rawPermission) {
    return rawPermission.toUpperCase() == 'WRITE'
        ? ShareAccessRight.write
        : ShareAccessRight.read;
  }

  ShareAccessRight _inferRightsFromToken(String token) {
    if (token.startsWith('w_') || token.startsWith('W_')) {
      return ShareAccessRight.write;
    }
    return ShareAccessRight.read;
  }

  bool _resolveTokenValidity(AccessTokenDto token) {
    if (token.isValid != null) {
      return token.isValid!;
    }
    if (token.revokedAt != null) {
      return false;
    }
    if (token.expiresAt == null) {
      return true;
    }
    return token.expiresAt!.isAfter(DateTime.now());
  }

  bool _matchesResource(
    SharedAccessTokenEntity token,
    ShareResourceType resourceType,
    String resourceId,
  ) {
    return ShareResourceType.fromRaw(token.resourceType) == resourceType &&
        token.resourceId == resourceId;
  }

  String _resolveCollectionId(CollectionEntity collection) {
    final id = collection.id.trim();
    if (id.isEmpty) {
      throw const ServerException('Identifiant de collection manquant');
    }
    return id;
  }

  String _baseUrlFromShareUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.host.isEmpty) {
      return dotenv.env['API_BASE_URL'] ?? '';
    }
    return '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
  }

  List<CollectionEntity> _deduplicateCollections(List<CollectionEntity> raw) {
    final map = <String, CollectionEntity>{};
    for (final collection in raw) {
      if (collection.id.trim().isEmpty) {
        continue;
      }
      map[collection.id] = collection;
    }
    return map.values.toList();
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
