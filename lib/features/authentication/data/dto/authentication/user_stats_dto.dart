class UserStatsDto {
  const UserStatsDto({
    required this.collectionCount,
    required this.ownedPlaceCount,
    required this.sharedCollectionCount,
  });

  factory UserStatsDto.fromJson(Map<String, dynamic> json) {
    int asInt(Object? value) {
      if (value is int) return value;
      if (value is num) return value.toInt();
      return 0;
    }

    return UserStatsDto(
      collectionCount: asInt(json['collectionCount']),
      ownedPlaceCount: asInt(json['ownedPlaceCount']),
      sharedCollectionCount: asInt(json['sharedCollectionCount']),
    );
  }

  final int collectionCount;
  final int ownedPlaceCount;
  final int sharedCollectionCount;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'collectionCount': collectionCount,
      'ownedPlaceCount': ownedPlaceCount,
      'sharedCollectionCount': sharedCollectionCount,
    };
  }
}
