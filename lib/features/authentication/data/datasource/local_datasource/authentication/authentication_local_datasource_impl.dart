import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geo_spots/core/utils/extensions/string_ext.dart';
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/data/datasource/local_datasource/authentication/authentication_local_datasource.dart';
import 'package:geo_spots/features/authentication/domain/entity/user/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _authUserTokenSecureStorageKey = 'authUserToken';
const _authUserRefreshTokenSecureStorage = 'authUserRefreshToken';
const _authUserSecureStorageKey = 'authUser';
const _authUserDataSecureStorageKey = 'authUserData';
const _authUserValidityStorageKey = 'authTokenValidity';
const _authUserRoleStorageKey = 'authUserRole';

class AuthenticationLocalDatasourceImpl
    implements AuthenticationLocalDataSource {
  AuthenticationLocalDatasourceImpl({
    required FlutterSecureStorage secureStorage,
    required SharedPreferences sharedPreferences,
  }) : _secureStorage = secureStorage,
       _sharedPreferences = sharedPreferences;

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  @override
  Future<Result<String?>> getAuthUserToken() async {
    try {
      final token = await _secureStorage.read(
        key: _authUserTokenSecureStorageKey,
      );
      return Ok(token);
    } on Exception catch (e, st) {
      GsLogger().e('getAuthUserToken', e, st);
      return Err(e, st);
    }
  }

  @override
  Future<Result<String?>> getAuthUserRefreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(
        key: _authUserRefreshTokenSecureStorage,
      );
      return Ok(refreshToken);
    } on Exception catch (e, st) {
      GsLogger().e('getAuthUserRefreshToken', e, st);
      return Err(e, st);
    }
  }

  @override
  Future<Result<bool?>> getTokenValidity() async {
    try {
      final value = _sharedPreferences.getBool(_authUserValidityStorageKey);
      return Ok(value);
    } on Exception catch (e, st) {
      GsLogger().e('getTokenValidity', e, st);
      return Err(e, st);
    }
  }

  @override
  Future<Result<void>> setTokenValidity(bool validity) async {
    try {
      await _sharedPreferences.setBool(_authUserValidityStorageKey, validity);
      return const Ok(null);
    } on Exception catch (e, st) {
      GsLogger().e('setTokenValidity', e, st);
      return Err(e, st);
    }
  }

  @override
  Future<Result<UserEntity?>> getAuthUser() async {
    try {
      final data = await _secureStorage.read(key: _authUserSecureStorageKey);
      if (data.isNullOrEmpty) return const Ok(null);
      return Ok(UserEntity.fromJson(jsonDecode(data!)));
    } on Exception catch (e, st) {
      GsLogger().e('getAuthUser', e, st);
      return Err(e, st);
    }
  }

  @override
  Future<Result<String?>> getUserAuthData() async {
    try {
      final data = await _secureStorage.read(
        key: _authUserDataSecureStorageKey,
      );
      return Ok(data);
    } on Exception catch (e, st) {
      GsLogger().e('getUserAuthData', e, st);
      return Err(e, st);
    }
  }

  @override
  Future<Result<void>> upsertAuthUser(
    String token,
    String refreshToken,
    UserEntity user,
  ) async {
    try {
      await _secureStorage.write(
        key: _authUserTokenSecureStorageKey,
        value: token,
      );
      await _secureStorage.write(
        key: _authUserSecureStorageKey,
        value: jsonEncode(user),
      );
      await _secureStorage.write(
        key: _authUserRefreshTokenSecureStorage,
        value: refreshToken,
      );
      return const Ok(null);
    } on Exception catch (e, st) {
      GsLogger().e('upsertAuthUser', e, st);
      return Err(e, st);
    }
  }

  @override
  Future<Result<void>> deleteAuthUser() async {
    try {
      await _secureStorage.delete(key: _authUserTokenSecureStorageKey);
      await _secureStorage.delete(key: _authUserSecureStorageKey);
      await _secureStorage.delete(key: _authUserRefreshTokenSecureStorage);
      return const Ok(null);
    } on Exception catch (e, st) {
      GsLogger().e('deleteAuthUser', e, st);
      return Err(e, st);
    }
  }

  @override
  Future<Result<void>> setUserRole(String role) async {
    try {
      await _sharedPreferences.setString(_authUserRoleStorageKey, role);
      return const Ok(null);
    } on Exception catch (e, st) {
      GsLogger().e('setUserRole', e, st);
      return Err(e, st);
    }
  }

  @override
  Future<Result<String?>> getUserRole() async {
    try {
      final role = _sharedPreferences.getString(_authUserRoleStorageKey);
      return Ok(role);
    } on Exception catch (e, st) {
      GsLogger().e('getUserRole', e, st);
      return Err(e, st);
    }
  }

  @override
  Future<Result<void>> removeUserRole() async {
    try {
      await _sharedPreferences.remove(_authUserRoleStorageKey);
      return const Ok(null);
    } on Exception catch (e, st) {
      GsLogger().e('removeUserRole', e, st);
      return Err(e, st);
    }
  }
}
