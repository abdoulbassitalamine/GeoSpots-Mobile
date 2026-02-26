class PlaceSearchParams {
  const PlaceSearchParams({
    this.query,
    this.tag,
    this.latitude,
    this.longitude,
    this.radiusKm,
    this.page = 0,
    this.size = 200,
    this.sort = 'createdAt,desc',
  });

  final String? query;
  final String? tag;
  final double? latitude;
  final double? longitude;
  final double? radiusKm;
  final int page;
  final int size;
  final String sort;

  Map<String, Object> toQueryParameters() {
    final normalizedQuery = query?.trim();
    final normalizedTag = tag?.trim();
    final params = <String, Object?>{
      'q': (normalizedQuery?.isNotEmpty ?? false) ? normalizedQuery : null,
      'tag': (normalizedTag?.isNotEmpty ?? false) ? normalizedTag : null,
      'lat': latitude,
      'lon': longitude,
      'radius': radiusKm,
      'page': page,
      'size': size,
      'sort': sort,
    };
    params.removeWhere(
      (_, value) => value == null || (value is String && value.isEmpty),
    );
    return params.cast<String, Object>();
  }
}
