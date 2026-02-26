import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/domain/entity/authentication_status/authentication_status.dart';
import 'package:geo_spots/features/authentication/domain/entity/user/user_entity.dart';
import 'package:geo_spots/features/authentication/domain/navigator/authentication_notifier.dart';
import 'package:geo_spots/features/authentication/domain/use_case/auto_sign_use_case.dart';
import 'package:geo_spots/features/authentication/domain/use_case/log_out_use_case.dart';
import 'package:geo_spots/features/authentication/domain/use_case/me_use_case.dart';
import 'package:geo_spots/features/authentication/domain/use_case/sign_in_with_mail_and_password_usecase.dart';
import 'package:geo_spots/features/authentication/domain/use_case/sign_up_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication_view_model.g.dart';

@riverpod
class AuthenticationViewModel extends _$AuthenticationViewModel {
  @override
  AuthenticationStatus build() {
    return ref.watch(authGuardProvider);
  }

  Future<void> autoSignIn() async {
    final authUserResult = await ref.read(autoSignInUseCaseProvider.future);

    switch (authUserResult) {
      case Ok(:final value):
        if (value.user != null && (value.isTokenValid ?? false)) {
          state = AuthenticationStatus.authenticated(user: value.user!);
        } else {
          state = const AuthenticationStatus.unauthenticated(false);
        }
      case Err():
        state = const AuthenticationStatus.unauthenticated(false);
    }

    ref.read(authGuardProvider.notifier).updateState(state);
  }

  Future<void> signIn({required String mail, required String password}) async {
    final authGuardNotifier = ref.read(authGuardProvider.notifier);

    final result = await ref.read(signInWithMailAndPasswordUseCaseProvider)(
      mail: mail,
      password: password,
    );

    switch (result) {
      case Ok(:final value):
        final newState = AuthenticationStatus.authenticated(user: value);
        if (ref.mounted) state = newState;
        authGuardNotifier.updateState(newState);
      case Err(:final error, :final stackTrace):
        Error.throwWithStackTrace(error, stackTrace ?? StackTrace.current);
    }
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String mail,
    required String password,
    required String passwordConfirmation,
  }) async {
    final result = await ref.read(signUpUseCaseProvider)(
      firstName: firstName,
      lastName: lastName,
      mail: mail,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    switch (result) {
      case Ok():
        break;
      case Err(:final error, :final stackTrace):
        Error.throwWithStackTrace(error, stackTrace ?? StackTrace.current);
    }
  }

  Future<void> logOut() async {
    final authGuardNotifier = ref.read(authGuardProvider.notifier);
    final result = await ref.read(logOutUseCaseProvider)();

    switch (result) {
      case Ok():
      case Err():
        break;
    }

    const newState = AuthenticationStatus.unauthenticated(false);
    if (ref.mounted) state = newState;
    authGuardNotifier.updateState(newState);
  }

  Future<void> forgottenPassword(String mail) async {}

  Future<Result<UserEntity>> me() async {
    return ref.read(meInUseCaseProvider.future);
  }
}
