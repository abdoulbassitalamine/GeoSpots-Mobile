import 'package:geo_spots/features/places/domain/entity/place_entity.dart';

class CollectionImportResultEntity {
  const CollectionImportResultEntity({
    required this.imported,
    required this.skipped,
    this.errors = const <String>[],
    this.places = const <PlaceEntity>[],
  });

  final int imported;
  final int skipped;
  final List<String> errors;
  final List<PlaceEntity> places;
}
