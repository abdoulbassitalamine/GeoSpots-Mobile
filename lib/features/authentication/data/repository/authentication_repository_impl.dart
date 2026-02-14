import '../../domain/entity/user/user_entity.dart';
import '../../domain/repository/authentication_repository.dart';
import '../datasource/local_datasource/authentication/authentication_local_datasource.dart';
import '../datasource/remote/authentication/authentication_remote_datasource.dart';

class AuthenticationRepositoryImpl implements IAuthenticationRepository {
  AuthenticationRepositoryImpl({
    required IAuthenticationRemoteDatasource authenticationRemoteDatasource,
    required AuthenticationLocalDataSource authenticationLocalDatasource,
  }) : _authenticationRemoteDatasource = authenticationRemoteDatasource,
       _authenticationLocalDataSource = authenticationLocalDatasource;

  final IAuthenticationRemoteDatasource _authenticationRemoteDatasource;
  final AuthenticationLocalDataSource _authenticationLocalDataSource;
  @override
  Future<UserEntity?> autoSignIn() {
    return _authenticationLocalDataSource.getAuthUser();
  }

  @override
  Future<bool> checkTokenValidity() async {
    throw UnimplementedError();
  }

  @override
  Future<List<UserEntity>> getSearchUsers(String query) {
    // TODO: implement getSearchUsers
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> me() async {
    throw UnimplementedError();
  }

  @override
  Future<String> sendResetPasswordLink(String email) async {
    await _authenticationRemoteDatasource.sendResetPasswordLink(email);
    throw UnimplementedError();
  }

  @override
  Future<String> signInWithLinkedIn(String code) {
    // TODO: implement signInWithLinkedIn
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    try {
      await _authenticationRemoteDatasource.logout();
      await _authenticationLocalDataSource.deleteAuthUser();
    } on Exception catch (_) {
      await _authenticationLocalDataSource.deleteAuthUser();
    }
  }

  @override
  Future<UserEntity> updateUser({
    String? firstName,
    String? lastName,
    String? email,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> signIn({
    required String mail,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<String?> signUp({
    required String firstName,
    required String lastName,
    required String mail,
    required String password,
    required String passwordConfirmation,
  }) async {
    final token = await _authenticationRemoteDatasource.signup(
      firstName: firstName,
      lastName: lastName,
      mail: mail,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
    return token;
  }
}
