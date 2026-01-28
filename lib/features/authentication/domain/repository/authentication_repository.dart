import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/datasource/local_datasource/authentication/authentication_local_datasource.dart';
import '../../data/datasource/remote/authentication/authentication_remote_datasource.dart';
import '../../data/repository/authentication_repository_impl.dart';
import '../entity/user/user_entity.dart';

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
  Future<UserEntity> signIn({required String mail, required String password});
  Future<String?> signUp({
    required String firstName,
    required String lastName,
    required String mail,
    required String password,
    required String passwordConfirmation,
  });
  Future<String> signInWithLinkedIn(String code);

  Future<void> logout();

  Future<UserEntity> me();

  Future<List<UserEntity>> getSearchUsers(String query);

  Future<UserEntity> updateUser({
    String? firstName,
    String? lastName,
    String? email,
  });

  Future<bool> checkTokenValidity();

  Future<String> sendResetPasswordLink(String email);

  Future<UserEntity?> autoSignIn();
}
