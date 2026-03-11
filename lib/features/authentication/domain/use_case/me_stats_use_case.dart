import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/domain/entity/user/user_stats_entity.dart';
import 'package:geo_spots/features/authentication/domain/repository/authentication_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'me_stats_use_case.g.dart';

@riverpod
class MeStatsUseCase extends _$MeStatsUseCase {
  @override
  Future<Result<UserStatsEntity>> build() {
    return ref.watch(authenticationRepositoryProvider).meStats();
  }
}
