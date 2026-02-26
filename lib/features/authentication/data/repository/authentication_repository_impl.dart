import 'package:geo_spots/core/utils/exception/exception.dart';
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/data/datasource/local_datasource/authentication/authentication_local_datasource.dart';
import 'package:geo_spots/features/authentication/data/datasource/remote/authentication/authentication_remote_datasource.dart';
import 'package:geo_spots/features/authentication/domain/entity/user/user_entity.dart';
import 'package:geo_spots/features/authentication/domain/entity/user/user_stats_entity.dart';
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
  Future<Result<UserStatsEntity>> meStats() async {
    final result = await _authenticationRemoteDatasource.getCurrentUserStats();
    return switch (result) {
      Ok(:final value) => Ok(UserStatsEntity.fromDto(value)),
      Err(:final error, :final stackTrace) => Err(error, stackTrace),
    };
  }

  @override
  Future<Result<UserEntity>> updateMe({
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    final result = await _authenticationRemoteDatasource.updateCurrentUser(
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
    return switch (result) {
      Ok(:final value) => Ok(UserEntity.fromDto(value)),
      Err(:final error, :final stackTrace) => Err(error, stackTrace),
    };
  }

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _authenticationRemoteDatasource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _authenticationRemoteDatasource.logout();
    } on Exception {
      // Local cleanup must always happen even if remote logout fails/401.
    }
    await _authenticationLocalDataSource.setTokenValidity(false);
    return _authenticationLocalDataSource.deleteAuthUser();
  }

  @override
  Future<Result<String>> refreshToken() async {
    final storedRefreshTokenResult = await _authenticationLocalDataSource
        .getAuthUserRefreshToken();

    String? storedRefreshToken;
    switch (storedRefreshTokenResult) {
      case Ok(:final value):
        storedRefreshToken = value;
      case Err(:final error, :final stackTrace):
        return Err(error, stackTrace);
    }

    if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
      await _authenticationLocalDataSource.setTokenValidity(false);
      return Err(ServerException('Missing refresh token'));
    }

    final refreshResult = await _authenticationRemoteDatasource.refreshToken(
      refreshToken: storedRefreshToken,
    );

    switch (refreshResult) {
      case Ok(:final value):
        final accessToken = value.accessToken;
        final refreshToken = value.refreshToken;

        if (accessToken == null || accessToken.isEmpty) {
          return Err(
            ServerException('Missing access token in refresh response'),
          );
        }
        if (refreshToken == null || refreshToken.isEmpty) {
          return Err(
            ServerException('Missing refresh token in refresh response'),
          );
        }

        final storedUserResult = await _authenticationLocalDataSource
            .getAuthUser();
        final storedUser = switch (storedUserResult) {
          Ok(:final value) => value,
          Err() => null,
        };

        final fallbackEntity = UserEntity(
          id: value.userId?.toString() ?? value.username ?? value.email ?? '0',
          firstName: value.username,
          email: value.email,
        );

        await _authenticationLocalDataSource.upsertAuthUser(
          accessToken,
          refreshToken,
          storedUser ?? fallbackEntity,
        );

        final meResult = await _authenticationRemoteDatasource.getCurrentUser();
        final user = switch (meResult) {
          Ok(:final value) => UserEntity.fromDto(value),
          Err() => storedUser ?? fallbackEntity,
        };

        await _authenticationLocalDataSource.upsertAuthUser(
          accessToken,
          refreshToken,
          user,
        );
        await _authenticationLocalDataSource.setTokenValidity(true);
        return Ok(accessToken);
      case Err(:final error, :final stackTrace):
        await _authenticationLocalDataSource.setTokenValidity(false);
        return Err(error, stackTrace);
    }
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
        final accessToken = value.accessToken;
        final refreshToken = value.refreshToken;
        if (accessToken == null || accessToken.isEmpty) {
          return Err(
            ServerException('Missing access token in sign-in response'),
          );
        }
        if (refreshToken == null || refreshToken.isEmpty) {
          return Err(
            ServerException('Missing refresh token in sign-in response'),
          );
        }

        final fallbackEntity = UserEntity(
          id: value.userId?.toString() ?? value.username ?? value.email ?? '0',
          firstName: value.username,
          email: value.email,
        );
        await _authenticationLocalDataSource.upsertAuthUser(
          accessToken,
          refreshToken,
          fallbackEntity,
        );

        final meResult = await _authenticationRemoteDatasource.getCurrentUser();
        final entity = switch (meResult) {
          Ok(:final value) => UserEntity.fromDto(value),
          Err() => fallbackEntity,
        };

        await _authenticationLocalDataSource.upsertAuthUser(
          accessToken,
          refreshToken,
          entity,
        );
        await _authenticationLocalDataSource.setTokenValidity(true);
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
      Ok(:final value) => Ok(value.accessToken),
      Err(:final error, :final stackTrace) => Err(error, stackTrace),
    };
  }
}
