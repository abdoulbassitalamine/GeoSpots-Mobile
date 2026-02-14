import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geo_spots/features/collections/domain/entity/shared_access_token_entity.dart';
import 'package:geo_spots/shared/storage/secure_storage/constants/secure_storage_constants.dart';
import 'package:geo_spots/shared/storage/secure_storage/datasource/secure_storage_datasource.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sharedAccessSecureDatasourceProvider = Provider<SharedAccessSecureDatasource>(
  (ref) => SharedAccessSecureDatasource(
    secureStorage: ref.read(secureStorageDataSourceProvider),
  ),
);

class SharedAccessSecureDatasource {
  SharedAccessSecureDatasource({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  final FlutterSecureStorage _secureStorage;

  Future<List<SharedAccessTokenEntity>> getAll() async {
    final raw = await _secureStorage.read(key: kSecureStorageSharedAccessTokensKey);
    if (raw == null || raw.trim().isEmpty) {
      return [];
    }

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return [];
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(SharedAccessTokenEntity.fromJson)
        .toList();
  }

  Future<void> saveAll(List<SharedAccessTokenEntity> tokens) async {
    final encoded = jsonEncode(tokens.map((e) => e.toJson()).toList());
    await _secureStorage.write(
      key: kSecureStorageSharedAccessTokensKey,
      value: encoded,
    );
  }

  Future<void> upsert(SharedAccessTokenEntity token) async {
    final existing = await getAll();
    final index = existing.indexWhere((e) => e.token == token.token);
    if (index != -1) {
      existing[index] = token;
    } else {
      existing.add(token);
    }
    await saveAll(existing);
  }

  Future<void> removeByToken(String token) async {
    final existing = await getAll();
    existing.removeWhere((item) => item.token == token);
    await saveAll(existing);
  }

  Future<List<SharedAccessTokenEntity>> getOwnedShares() async {
    final raw = await _secureStorage.read(key: kSecureStorageOwnedShareTokensKey);
    if (raw == null || raw.trim().isEmpty) {
      return [];
    }

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return [];
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(SharedAccessTokenEntity.fromJson)
        .toList();
  }

  Future<void> saveOwnedShares(List<SharedAccessTokenEntity> tokens) async {
    final encoded = jsonEncode(tokens.map((e) => e.toJson()).toList());
    await _secureStorage.write(
      key: kSecureStorageOwnedShareTokensKey,
      value: encoded,
    );
  }

  Future<void> upsertOwnedShare(SharedAccessTokenEntity token) async {
    final existing = await getOwnedShares();
    final index = existing.indexWhere((e) => e.token == token.token);
    if (index != -1) {
      existing[index] = token;
    } else {
      existing.add(token);
    }
    await saveOwnedShares(existing);
  }

  Future<void> removeOwnedShareByToken(String token) async {
    final existing = await getOwnedShares();
    existing.removeWhere((item) => item.token == token);
    await saveOwnedShares(existing);
  }
}
