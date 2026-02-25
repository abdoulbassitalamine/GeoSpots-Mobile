import 'package:geo_spots/core/utils/exception/http_exception.dart';
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/data/exception/auth_exception.dart';
import 'package:geo_spots/features/authentication/domain/entity/user/user_entity.dart';
import 'package:geo_spots/features/authentication/domain/repository/authentication_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_with_mail_and_password_usecase.g.dart';

@riverpod
Future<Result<UserEntity>> Function({
  required String mail,
  required String password,
})
signInWithMailAndPasswordUseCase(Ref ref) {
  return ({required mail, required password}) async {
    final result = await ref
        .read(authenticationRepositoryProvider)
        .signIn(mail: mail, password: password);

    return switch (result) {
      Err(error: UnauthorizedException(), stackTrace: final stackTrace) => Err(
        WrongEmailOrPasswordException(),
        stackTrace,
      ),
      Err(:final error, :final stackTrace) => Err(error, stackTrace),
      Ok(:final value) => Ok(value),
    };
  };
}
