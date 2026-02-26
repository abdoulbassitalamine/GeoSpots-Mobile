import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/domain/entity/user/user_entity.dart';
import 'package:geo_spots/features/authentication/domain/repository/authentication_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_profile_use_case.g.dart';

@riverpod
Future<Result<UserEntity>> Function({
  String? firstName,
  String? lastName,
  String? email,
})
updateProfileUseCase(Ref ref) {
  return ({String? firstName, String? lastName, String? email}) {
    return ref
        .read(authenticationRepositoryProvider)
        .updateMe(firstName: firstName, lastName: lastName, email: email);
  };
}
