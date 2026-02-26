class PlaceUpsertPayload {
  const PlaceUpsertPayload({
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    this.tags = const <String>[],
  });

  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final List<String> tags;
}
