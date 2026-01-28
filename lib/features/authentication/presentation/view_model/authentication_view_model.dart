import 'package:geo_spots/features/authentication/authentication.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasource/local_datasource/authentication/authentication_local_datasource.dart';
import '../../domain/entity/authentication_status/authentication_status.dart';
import '../../domain/entity/user/user_entity.dart';
import '../../domain/navigator/authentication_notifier.dart';

part 'authentication_view_model.g.dart';

@riverpod
class AuthenticationViewModel extends _$AuthenticationViewModel {
  @override
  AuthenticationStatus build() {
    return ref.watch(authenticationNotifierProvider);
  }

  Future<void> autoSignIn() async {
    try {
      final authUser = await ref
          .read(authenticationRepositoryProvider)
          .autoSignIn();
      final tokenValidity = await ref
          .read(authenticationLocalDatasourceProvider)
          .getTokenValidity();

      if (authUser != null && tokenValidity != null && tokenValidity) {
        state = AuthenticationStatus.authenticated(user: authUser);
      } else {
        state = const AuthenticationStatus.unauthenticated(false);
      }

      ref.read(authenticationNotifierProvider.notifier).updateState(state);
    } on Exception catch (_) {
      state = const AuthenticationStatus.unauthenticated(false);
      ref.read(authenticationNotifierProvider.notifier).updateState(state);
    }
  }

  Future<UserEntity> signIn({
    required String mail,
    required String password,
  }) async {
    final login = await ref
        .read(authenticationRepositoryProvider)
        .signIn(mail: mail, password: password);

    await ref
        .read(authenticationLocalDatasourceProvider)
        .setTokenValidity(true);

    state = AuthenticationStatus.authenticated(user: login);
    ref.read(authenticationNotifierProvider.notifier).updateState(state);

    return login;
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String mail,
    required String password,
    required String passwordConfirmation,
  }) async {
    final _ = await ref
        .read(authenticationRepositoryProvider)
        .signUp(
          firstName: firstName,
          lastName: lastName,
          mail: mail,
          password: password,
          passwordConfirmation: passwordConfirmation,
        );
  }

  Future<void> logOut() async {
    await ref.read(authenticationRepositoryProvider).logout();
    await ref
        .read(authenticationLocalDatasourceProvider)
        .setTokenValidity(false);

    state = const AuthenticationStatus.unauthenticated(false);

    ref.read(authenticationNotifierProvider.notifier).updateState(state);
  }

  Future<void> forgottenPassword(String mail) async {}

  Future<UserEntity> me() async {
    final result = await ref.read(authenticationRepositoryProvider).me();

    if (result == null) {
      await logOut();
    }
    return result!;
  }
}
