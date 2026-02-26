class CurrentLocationEntity {
  const CurrentLocationEntity({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
    required this.isShared,
    this.updatedAt,
  });

  final String id;
  final double latitude;
  final double longitude;
  final double? accuracy;
  final DateTime? timestamp;
  final bool isShared;
  final DateTime? updatedAt;
}
