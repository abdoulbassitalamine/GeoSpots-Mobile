class PlaceShareResultEntity {
  const PlaceShareResultEntity({
    required this.token,
    required this.url,
    required this.permission,
    required this.resourceType,
    required this.resourceId,
    this.expiresAt,
  });

  final String token;
  final String url;
  final String permission;
  final String resourceType;
  final String resourceId;
  final DateTime? expiresAt;
}
