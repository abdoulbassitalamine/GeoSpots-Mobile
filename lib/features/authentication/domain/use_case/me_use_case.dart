
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/domain/entity/user/user_entity.dart';
import 'package:geo_spots/features/authentication/domain/repository/authentication_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'me_use_case.g.dart';

@riverpod
class MeInUseCase extends _$MeInUseCase {
  @override
  Future<Result<UserEntity>> build() {
    return ref.watch(authenticationRepositoryProvider).me();
  }
}
