import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/data/datasource/local_datasource/authentication/authentication_local_datasource.dart';
import 'package:geo_spots/features/authentication/data/datasource/remote/authentication/authentication_remote_datasource.dart';
import 'package:geo_spots/features/authentication/data/repository/authentication_repository_impl.dart';
import 'package:geo_spots/features/authentication/domain/entity/user/user_entity.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authenticationRepositoryProvider = Provider<IAuthenticationRepository>(
  (ref) => AuthenticationRepositoryImpl(
    authenticationRemoteDatasource: ref.watch(
      authenticationRemoteDatasourceProvider,
    ),
    authenticationLocalDatasource: ref.watch(
      authenticationLocalDatasourceProvider,
    ),
  ),
);

abstract interface class IAuthenticationRepository {
  Future<Result<UserEntity>> signIn({
    required String mail,
    required String password,
  });

  Future<Result<String?>> signUp({
    required String firstName,
    required String lastName,
    required String mail,
    required String password,
    required String passwordConfirmation,
  });

  Future<Result<void>> logout();

  Future<Result<String>> refreshToken();

  Future<Result<UserEntity>> me();

  Future<Result<UserEntity?>> autoSignIn();

  Future<Result<String?>> getStoredAuthUserToken();

  Future<Result<bool?>> getTokenValidity();

  Future<Result<void>> setTokenValidity(bool validity);
}
