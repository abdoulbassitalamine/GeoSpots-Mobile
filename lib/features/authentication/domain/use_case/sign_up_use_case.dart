import 'package:geo_spots/core/utils/exception/http_exception.dart';
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/data/exception/auth_exception.dart';
import 'package:geo_spots/features/authentication/domain/repository/authentication_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_use_case.g.dart';

@riverpod
Future<Result<String?>> Function({
  required String firstName,
  required String lastName,
  required String mail,
  required String password,
  required String passwordConfirmation,
})
signUpUseCase(Ref ref) {
  return ({
    required firstName,
    required lastName,
    required mail,
    required password,
    required passwordConfirmation,
  }) async {
    final result = await ref
        .read(authenticationRepositoryProvider)
        .signUp(
          firstName: firstName,
          lastName: lastName,
          mail: mail,
          password: password,
          passwordConfirmation: passwordConfirmation,
        );

    return switch (result) {
      Err(error: BadRequestException(), stackTrace: final stackTrace) => Err(
        EmailAlreadyExistsException(),
        stackTrace,
      ),
      Err(:final error, :final stackTrace) => Err(error, stackTrace),
      Ok(:final value) => Ok(value),
    };
  };
}
