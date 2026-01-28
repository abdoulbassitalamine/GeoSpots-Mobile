import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../core/utils/extensions/string_ext.dart';
import '../../../../authentication.dart';
import 'authentication_local_datasource.dart';

const _authUserTokenSecureStorageKey = 'authUserToken';
const _authUserSecureStorageKey = 'authUser';
const _authUserDataSecureStorageKey = 'authUserData';
const _authUserValidityStorageKey = 'authTokenValidity';

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
  Future<String?> getAuthUserToken() async {
    final token = _secureStorage.read(key: _authUserTokenSecureStorageKey);
    return token;
  }

  @override
  Future<bool?> getTokenValidity() async {
    return await _sharedPreferences.getBool(_authUserValidityStorageKey);
  }

  @override
  Future<void> setTokenValidity(bool validity) {
    return _sharedPreferences.setBool(_authUserValidityStorageKey, validity);
  }

  @override
  Future<UserEntity?> getAuthUser() async {
    final data = await _secureStorage.read(key: _authUserSecureStorageKey);
    if (data.isNullOrEmpty) {
      return null;
    }
    return UserEntity.fromJson(jsonDecode(data!));
  }

  @override
  Future<String?> getUserAuthData() {
    return _secureStorage.read(key: _authUserDataSecureStorageKey);
  }

  @override
  Future<void> upsertAuthUser(String token, UserEntity user) async {
    await _secureStorage.write(
      key: _authUserTokenSecureStorageKey,
      value: token,
    );

    await _secureStorage.write(
      key: _authUserSecureStorageKey,
      value: jsonEncode(user),
    );
  }

  @override
  Future<void> deleteAuthUser() async {
    await _secureStorage.delete(key: _authUserTokenSecureStorageKey);
    await _secureStorage.delete(key: _authUserSecureStorageKey);
  }
}
