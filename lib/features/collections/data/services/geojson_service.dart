import 'dart:convert';
import '../../../places/domain/entity/place_entity.dart';
import '../../domain/entity/collection_entity.dart';
import '../../domain/services/export_import_service.dart';

class GeoJSONService implements IExportImportService {
  @override
  String export(CollectionEntity collection) {
    final features = <Map<String, dynamic>>[];

    for (final place in collection.places) {
      if (place.hasCoordinates) {
        features.add({
          'type': 'Feature',
          'geometry': {
            'type': 'Point',
            'coordinates': [place.longitude, place.latitude],
          },
          'properties': {
            'id': place.id,
            'name': place.title,
            'description': place.description,
            'tags': place.tags,
            'date': place.date,
            if (place.city != null) 'city': place.city,
            if (place.country != null) 'country': place.country,
            if (place.address != null) 'address': place.address,
          },
        });
      }
    }

    final geoJson = {
      'type': 'FeatureCollection',
      'name': collection.tag,
      'features': features,
    };

    return const JsonEncoder.withIndent('  ').convert(geoJson);
  }

  @override
  List<PlaceEntity> import(String geoJsonContent) {
    final places = <PlaceEntity>[];

    try {
      final data = jsonDecode(geoJsonContent) as Map<String, dynamic>;

      if (data['type'] != 'FeatureCollection') {
        throw Exception('Invalid GeoJSON: not a FeatureCollection');
      }

      final features = data['features'] as List<dynamic>?;
      if (features == null) return places;

      for (final feature in features) {
        final featureMap = feature as Map<String, dynamic>;

        if (featureMap['type'] != 'Feature') continue;

        final geometry = featureMap['geometry'] as Map<String, dynamic>?;
        if (geometry == null || geometry['type'] != 'Point') continue;

        final coordinates = geometry['coordinates'] as List<dynamic>?;
        if (coordinates == null || coordinates.length < 2) continue;

        final lon = (coordinates[0] as num).toDouble();
        final lat = (coordinates[1] as num).toDouble();

        final properties =
            featureMap['properties'] as Map<String, dynamic>? ?? {};

        final name = properties['name'] as String? ?? 'Sans titre';
        final description = properties['description'] as String? ?? '';
        final tags =
            (properties['tags'] as List<dynamic>?)
                ?.map((t) => t.toString())
                .toList() ??
            [];
        final city = properties['city'] as String?;
        final country = properties['country'] as String?;
        final address = properties['address'] as String?;

        places.add(
          PlaceEntity(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: name,
            description: description,
            tags: tags,
            date: DateTime.now().toString(),
            latitude: lat,
            longitude: lon,
            city: city,
            country: country,
            address: address,
          ),
        );
      }
    } catch (e) {
      throw Exception('Erreur lors du parsing GeoJSON: $e');
    }

    return places;
  }
}
