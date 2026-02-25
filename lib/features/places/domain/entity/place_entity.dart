import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_entity.freezed.dart';

@Freezed(fromJson: false)
sealed class PlaceEntity with _$PlaceEntity {
  const factory PlaceEntity({
    required String id,
    required String title,
    required String description,
    required List<String> tags,
    required String date,
    String? imageUrl,
    String? userId,
    double? latitude,
    double? longitude,
    String? address,
    String? city,
    String? country,
    @Default(false) bool isShared,
    String? sharedToken,
  }) = _PlaceEntity;

  const PlaceEntity._();

  bool hasTag(String tag) => tags.contains(tag);

  bool matchesSearch(String query) {
    final lowerQuery = query.toLowerCase();
    return title.toLowerCase().contains(lowerQuery) ||
        description.toLowerCase().contains(lowerQuery) ||
        tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
  }

  String get fullLocation {
    final parts = [address, city, country].where((e) => e != null && e.isNotEmpty);
    return parts.join(', ');
  }

  bool get hasCoordinates => latitude != null && longitude != null;
}
