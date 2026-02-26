import 'package:geo_spots/features/authentication/data/dto/authentication/user_stats_dto.dart';

class UserStatsEntity {
  const UserStatsEntity({
    required this.collectionCount,
    required this.ownedPlaceCount,
    required this.sharedCollectionCount,
  });

  factory UserStatsEntity.fromDto(UserStatsDto dto) {
    return UserStatsEntity(
      collectionCount: dto.collectionCount,
      ownedPlaceCount: dto.ownedPlaceCount,
      sharedCollectionCount: dto.sharedCollectionCount,
    );
  }

  final int collectionCount;
  final int ownedPlaceCount;
  final int sharedCollectionCount;
}
