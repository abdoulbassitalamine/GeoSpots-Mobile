import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/domain/repository/authentication_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_password_use_case.g.dart';

@riverpod
Future<Result<void>> Function({
  required String currentPassword,
  required String newPassword,
})
changePasswordUseCase(Ref ref) {
  return ({required String currentPassword, required String newPassword}) {
    return ref
        .read(authenticationRepositoryProvider)
        .changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
  };
}
