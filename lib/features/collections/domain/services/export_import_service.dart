import 'package:geo_spots/features/collections/data/services/geojson_service.dart';
import 'package:geo_spots/features/collections/data/services/gpx_service.dart';
import 'package:geo_spots/features/collections/data/services/kml_service.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final gpxServiceProvider = Provider<IExportImportService>(
  (ref) => GPXService(),
);

final kmlServiceProvider = Provider<IExportImportService>(
  (ref) => KMLService(),
);

final geoJsonServiceProvider = Provider<IExportImportService>(
  (ref) => GeoJSONService(),
);

abstract interface class IExportImportService {
  String export(CollectionEntity collection);
  List<PlaceEntity> import(String content);
}
