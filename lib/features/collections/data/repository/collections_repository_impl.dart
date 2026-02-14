import 'dart:math';

import 'package:geo_spots/features/collections/data/datasource/shared_access_secure_datasource.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'package:geo_spots/features/collections/domain/entity/shared_access_token_entity.dart';
import 'package:geo_spots/features/collections/domain/enums/collection_source.dart';
import 'package:geo_spots/features/collections/domain/enums/share_access_right.dart';
import 'package:geo_spots/features/collections/domain/repository/collections_repository.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:geo_spots/features/places/domain/entity/place_list_extension.dart';

class CollectionsRepositoryImpl implements CollectionsRepository {
  CollectionsRepositoryImpl({required SharedAccessSecureDatasource sharedAccessSecureDatasource})
      : _sharedAccessSecureDatasource = sharedAccessSecureDatasource;

  final SharedAccessSecureDatasource _sharedAccessSecureDatasource;

  @override
  List<CollectionEntity> getOwnedCollections(List<PlaceEntity> allPlaces) {
    final collections = allPlaces.generateCollectionsFromTags();
    return collections
        .map(
          (collection) => collection.copyWith(
            source: CollectionSource.owned,
            rights: ShareAccessRight.write,
          ),
        )
        .toList();
  }

  @override
  Future<List<SharedAccessTokenEntity>> getSharedAccessTokens() {
    return _sharedAccessSecureDatasource.getAll();
  }

  @override
  Future<List<SharedAccessTokenEntity>> getOwnedShareTokens() {
    return _sharedAccessSecureDatasource.getOwnedShares();
  }

  @override
  Future<List<CollectionEntity>> getSharedCollections() async {
    final tokens = await _sharedAccessSecureDatasource.getAll();
    return tokens
        .map((token) {
          final places = _buildSharedPlaces(token);
          return CollectionEntity(
            tag: _formatSharedCollectionName(token.resourceId),
            placesCount: places.length,
            places: places,
            source: CollectionSource.shared,
            rights: token.rights,
            sharedToken: token.token,
            sharedResourceId: token.resourceId,
          );
        })
        .toList();
  }

  @override
  Future<SharedAccessTokenEntity> importSharedAccess({
    required String baseUrl,
    required String token,
  }) async {
    final normalizedUrl = baseUrl.trim().replaceAll(RegExp(r'/$'), '');
    final normalizedToken = token.trim();

    if (normalizedUrl.isEmpty || normalizedToken.isEmpty) {
      throw Exception('URL et token sont obligatoires');
    }

    if (normalizedToken.length < 12) {
      throw Exception('Token invalide');
    }

    final rights = _inferRightsFromToken(normalizedToken);
    final metadata = SharedAccessTokenEntity(
      token: normalizedToken,
      baseUrl: normalizedUrl,
      rights: rights,
      resourceType: 'collection',
      resourceId: _buildResourceId(normalizedToken),
      expiresAt: DateTime.now().add(const Duration(days: 30)),
    );

    await _sharedAccessSecureDatasource.upsert(metadata);
    return metadata;
  }

  @override
  Future<void> revokeSharedAccess(String token) {
    return _sharedAccessSecureDatasource.removeByToken(token);
  }

  @override
  Future<void> revokeOwnedShare(String token) {
    return _sharedAccessSecureDatasource.removeOwnedShareByToken(token);
  }

  @override
  Future<void> saveOwnedShareToken(SharedAccessTokenEntity token) {
    return _sharedAccessSecureDatasource.upsertOwnedShare(token);
  }

  @override
  Future<SharedAccessTokenEntity?> getTokenForResource({
    required String resourceType,
    required String resourceId,
  }) async {
    final tokens = await _sharedAccessSecureDatasource.getAll();
    for (final token in tokens) {
      if (token.resourceType == resourceType && token.resourceId == resourceId) {
        return token;
      }
    }
    return null;
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

  ShareAccessRight _inferRightsFromToken(String token) {
    if (token.startsWith('w_') || token.startsWith('W_')) {
      return ShareAccessRight.write;
    }
    return ShareAccessRight.read;
  }

  String _buildResourceId(String token) {
    final demoMatch = RegExp(r'^(w_)?demo_received_([a-zA-Z0-9-]+)').firstMatch(token);
    if (demoMatch != null) {
      return demoMatch.group(2) ?? 'shared-demo';
    }
    final seed = token.codeUnits.fold<int>(0, (acc, c) => acc + c);
    return 'shared-${seed % 100000 + Random(seed).nextInt(500)}';
  }

  String _formatSharedCollectionName(String resourceId) {
    final raw = resourceId.replaceAll('-', ' ').trim();
    if (raw.isEmpty) {
      return 'Collection partagée';
    }
    return raw
        .split(RegExp(r'\s+'))
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  int _estimateSharedPlacesCount(String token) {
    final seed = token.codeUnits.fold<int>(0, (acc, c) => acc + c);
    return seed % 12 + 1;
  }

  List<PlaceEntity> _buildSharedPlaces(SharedAccessTokenEntity token) {
    final count = _estimateSharedPlacesCount(token.token).clamp(2, 8);
    final cityPool = ['Paris', 'Dakar', 'Casablanca', 'Lyon', 'Berlin', 'Rome'];
    final cityCoordinates = <String, (double lat, double lon)>{
      'Paris': (48.8566, 2.3522),
      'Dakar': (14.7167, -17.4677),
      'Casablanca': (33.5731, -7.5898),
      'Lyon': (45.7640, 4.8357),
      'Berlin': (52.5200, 13.4050),
      'Rome': (41.9028, 12.4964),
    };
    final collectionTag = _formatSharedCollectionName(token.resourceId);

    return List<PlaceEntity>.generate(count, (index) {
      final seed = (token.token.hashCode + index).abs();
      final city = cityPool[seed % cityPool.length];
      final base = cityCoordinates[city] ?? (48.8566, 2.3522);
      final latOffset = ((seed % 17) - 8) * 0.0045;
      final lonOffset = ((seed % 19) - 9) * 0.0045;
      return PlaceEntity(
        id: 'shared_${token.resourceId}_$index',
        title: '$collectionTag ${index + 1}',
        description: 'Lieu partagé via token (${token.rights.label}).',
        tags: [collectionTag],
        date: '15 janvier 2026',
        latitude: base.$1 + latOffset,
        longitude: base.$2 + lonOffset,
        city: city,
        country: 'France',
        isShared: true,
        sharedToken: token.token,
      );
    });
  }
}
