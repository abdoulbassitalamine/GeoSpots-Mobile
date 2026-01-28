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
  }) = _PlaceEntity;

// Décommenter plus tard quand le backend sera prêt
// factory PlaceEntity.fromDto(PlaceResourceDto dto) => PlaceEntity(
//   id: dto.id ?? '',
//   title: dto.title ?? '',
//   description: dto.description ?? '',
//   tags: dto.tags ?? [],
//   date: dto.date ?? '',
//   imageUrl: dto.imageUrl,
//   userId: dto.userId,
//   latitude: dto.latitude,
//   longitude: dto.longitude,
//   address: dto.address,
//   city: dto.city,
//   country: dto.country,
// );
}