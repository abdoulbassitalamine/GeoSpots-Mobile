import 'package:geo_spots/core/utils/exception/exception.dart';
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/data/datasource/local_datasource/authentication/authentication_local_datasource.dart';
import 'package:geo_spots/features/authentication/data/datasource/remote/authentication/authentication_remote_datasource.dart';
import 'package:geo_spots/features/authentication/domain/entity/user/user_entity.dart';
import 'package:geo_spots/features/authentication/domain/repository/authentication_repository.dart';

class AuthenticationRepositoryImpl implements IAuthenticationRepository {
  AuthenticationRepositoryImpl({
    required IAuthenticationRemoteDatasource authenticationRemoteDatasource,
    required AuthenticationLocalDataSource authenticationLocalDatasource,
  }) : _authenticationRemoteDatasource = authenticationRemoteDatasource,
       _authenticationLocalDataSource = authenticationLocalDatasource;

  final IAuthenticationRemoteDatasource _authenticationRemoteDatasource;
  final AuthenticationLocalDataSource _authenticationLocalDataSource;

  @override
  Future<Result<UserEntity?>> autoSignIn() {
    return _authenticationLocalDataSource.getAuthUser();
  }

  @override
  Future<Result<String?>> getStoredAuthUserToken() {
    return _authenticationLocalDataSource.getAuthUserToken();
  }

  @override
  Future<Result<bool?>> getTokenValidity() {
    return _authenticationLocalDataSource.getTokenValidity();
  }

  @override
  Future<Result<void>> setTokenValidity(bool validity) {
    return _authenticationLocalDataSource.setTokenValidity(validity);
  }

  @override
  Future<Result<UserEntity>> me() async {
    final result = await _authenticationRemoteDatasource.getCurrentUser();
    return switch (result) {
      Ok(:final value) => Ok(UserEntity.fromDto(value)),
      Err(:final error, :final stackTrace) => Err(error, stackTrace),
    };
  }

  @override
  Future<Result<void>> logout() async {
    await _authenticationRemoteDatasource.logout();
    await _authenticationLocalDataSource.setTokenValidity(false);
    return _authenticationLocalDataSource.deleteAuthUser();
  }

  @override
  Future<Result<UserEntity>> signIn({
    required String mail,
    required String password,
  }) async {
    final result = await _authenticationRemoteDatasource
        .signInWithEmailAndPassword(mail: mail, password: password);

    switch (result) {
      case Ok(:final value):
        final session = value.data;
        if (session?.data == null || session?.token == null) {
          return Err(ServerException('Invalid sign-in response'));
        }
        final user = session!.data!;
        final entity = UserEntity.fromDto(user);
        await _authenticationLocalDataSource.upsertAuthUser(
          session.token!,
          entity,
        );
        return Ok(entity);
      case Err(:final error, :final stackTrace):
        return Err(error, stackTrace);
    }
  }

  @override
  Future<Result<String?>> signUp({
    required String firstName,
    required String lastName,
    required String mail,
    required String password,
    required String passwordConfirmation,
  }) async {
    final result = await _authenticationRemoteDatasource.signup(
      firstName: firstName,
      lastName: lastName,
      mail: mail,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    return switch (result) {
      Ok(:final value) => Ok(value.token),
      Err(:final error, :final stackTrace) => Err(error, stackTrace),
    };
  }
}
