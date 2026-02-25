import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/domain/repository/authentication_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'log_out_use_case.g.dart';

@riverpod
Future<Result<void>> Function() logOutUseCase(Ref ref) {
  return ref.read(authenticationRepositoryProvider).logout;
}
