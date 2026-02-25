import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/domain/entity/user/user_entity.dart';
import 'package:geo_spots/features/authentication/domain/repository/authentication_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auto_sign_use_case.g.dart';

typedef AutoSignInResult = ({UserEntity? user, bool? isTokenValid});

@riverpod
Future<Result<AutoSignInResult>> autoSignInUseCase(Ref ref) async {
  final repo = ref.read(authenticationRepositoryProvider);

  final userResult = await repo.autoSignIn();
  final user = switch (userResult) {
    Ok(:final value) => value,
    Err() => null,
  };

  if (user == null) {
    return const Ok((user: null, isTokenValid: false));
  }

  final tokenResult = await repo.getStoredAuthUserToken();
  final token = switch (tokenResult) {
    Ok(:final value) => value,
    Err() => null,
  };

  if (token == null) {
    await repo.setTokenValidity(false);
    return Ok((user: user, isTokenValid: false));
  }

  final tokenValidityResult = await repo.getTokenValidity();
  final isTokenValid = switch (tokenValidityResult) {
    Ok(:final value) => value ?? false,
    Err() => false,
  };

  return Ok((user: user, isTokenValid: isTokenValid));
}
