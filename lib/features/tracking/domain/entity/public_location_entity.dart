class PublicLocationEntity {
  const PublicLocationEntity({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.timestamp,
    this.updatedAt,
    this.ageSeconds,
  });

  final double latitude;
  final double longitude;
  final double? accuracy;
  final DateTime? timestamp;
  final DateTime? updatedAt;
  final int? ageSeconds;
}
