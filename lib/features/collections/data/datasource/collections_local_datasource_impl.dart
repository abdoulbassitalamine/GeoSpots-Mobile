import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geo_spots/features/collections/data/datasource/collections_local_datasource.dart';
import 'package:geo_spots/features/collections/domain/entity/shared_access_token_entity.dart';
import 'package:geo_spots/shared/storage/secure_storage/constants/secure_storage_constants.dart'
    show kSecureStorageSharedAccessTokensKey;

class CollectionsLocalDatasourceImpl implements ICollectionsLocalDatasource {
  CollectionsLocalDatasourceImpl({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage;

  final FlutterSecureStorage _secureStorage;

  @override
  Future<List<SharedAccessTokenEntity>> getSharedAccessTokens() {
    return _readTokens(kSecureStorageSharedAccessTokensKey);
  }

  @override
  Future<void> saveSharedAccessTokens(List<SharedAccessTokenEntity> tokens) {
    return _writeTokens(kSecureStorageSharedAccessTokensKey, tokens);
  }

  @override
  Future<void> upsertSharedAccessToken(SharedAccessTokenEntity token) {
    return _upsertToken(kSecureStorageSharedAccessTokensKey, token);
  }

  @override
  Future<void> removeSharedAccessToken(String token) {
    return _removeToken(kSecureStorageSharedAccessTokensKey, token);
  }

  @override
  Future<void> clearSharedAccessTokens() {
    return _secureStorage.delete(key: kSecureStorageSharedAccessTokensKey);
  }

  Future<List<SharedAccessTokenEntity>> _readTokens(String key) async {
    final raw = await _secureStorage.read(key: key);
    if (raw == null || raw.trim().isEmpty) {
      return const <SharedAccessTokenEntity>[];
    }

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return const <SharedAccessTokenEntity>[];
    }

    return decoded
        .whereType<Map<Object?, Object?>>()
        .map(
          (entry) => SharedAccessTokenEntity.fromJson(
            Map<String, dynamic>.from(entry),
          ),
        )
        .toList();
  }

  Future<void> _writeTokens(String key, List<SharedAccessTokenEntity> tokens) {
    final encoded = jsonEncode(tokens.map((token) => token.toJson()).toList());
    return _secureStorage.write(key: key, value: encoded);
  }

  Future<void> _upsertToken(String key, SharedAccessTokenEntity token) async {
    final existing = await _readTokens(key);
    final index = existing.indexWhere((item) => item.token == token.token);
    if (index == -1) {
      existing.add(token);
    } else {
      existing[index] = token;
    }
    await _writeTokens(key, existing);
  }

  Future<void> _removeToken(String key, String token) async {
    final existing = await _readTokens(key);
    existing.removeWhere((item) => item.token == token);
    await _writeTokens(key, existing);
  }
}
