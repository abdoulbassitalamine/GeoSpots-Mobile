import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/data/datasource/local_datasource/authentication/authentication_local_datasource_impl.dart';
import 'package:geo_spots/features/authentication/domain/entity/user/user_entity.dart';
import 'package:geo_spots/shared/storage/secure_storage/datasource/secure_storage_datasource.dart';
import 'package:geo_spots/shared/storage/shared_preferences/datasource/shared_preferences_datasource.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication_local_datasource.g.dart';

@Riverpod(keepAlive: true)
AuthenticationLocalDataSource authenticationLocalDatasource(Ref ref) =>
    AuthenticationLocalDatasourceImpl(
      secureStorage: ref.watch(secureStorageDataSourceProvider),
      sharedPreferences: ref.watch(sharedPreferencesDataSourceProvider),
    );

abstract interface class AuthenticationLocalDataSource {
  Future<Result<void>> upsertAuthUser(
    String token,
    String refreshToken,
    UserEntity user,
  );

  Future<Result<void>> deleteAuthUser();

  Future<Result<String?>> getUserAuthData();

  Future<Result<String?>> getAuthUserToken();

  Future<Result<UserEntity?>> getAuthUser();

  Future<Result<void>> setTokenValidity(bool validity);

  Future<Result<bool?>> getTokenValidity();

  Future<Result<void>> setUserRole(String role);

  Future<Result<String?>> getUserRole();

  Future<Result<void>> removeUserRole();
}
