class LocationShareSessionEntity {
  const LocationShareSessionEntity({
    required this.token,
    required this.url,
    this.expiresAt,
  });

  final String token;
  final String url;
  final DateTime? expiresAt;
}
