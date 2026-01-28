import 'package:geo_spots/features/authentication/domain/entity/user/user_entity.dart';
import 'package:geo_spots/shared/storage/shared_preferences/datasource/shared_preferences_datasource.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/storage/secure_storage/datasource/secure_storage_datasource.dart';
import 'authentication_local_datasource_impl.dart';

final authenticationLocalDatasourceProvider =
    Provider<AuthenticationLocalDataSource>(
      (ref) => AuthenticationLocalDatasourceImpl(
        secureStorage: ref.read(secureStorageDataSourceProvider),
        sharedPreferences: ref.watch(sharedPreferencesDataSourceProvider),
      ),
    );

abstract interface class AuthenticationLocalDataSource {
  Future<void> upsertAuthUser(String token, UserEntity user);

  Future<void> deleteAuthUser();

  Future<String?> getUserAuthData();

  Future<String?> getAuthUserToken();

  Future<UserEntity?> getAuthUser();

  Future<void> setTokenValidity(bool validity);

  Future<bool?> getTokenValidity();
}
