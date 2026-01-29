import 'package:geo_spots/features/collections/domain/services/export_import_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../places/domain/entity/place_entity.dart';
import '../enums/export_format.dart';

class ImportCollectionUseCase {
  ImportCollectionUseCase(this._ref);

  final Ref _ref;

  Future<List<PlaceEntity>> call(String content, ExportFormat format) async {
    switch (format) {
      case ExportFormat.gpx:
        return _ref.read(gpxServiceProvider).import(content);
      case ExportFormat.kml:
        return _ref.read(kmlServiceProvider).import(content);
      case ExportFormat.geoJSON:
        return _ref.read(geoJsonServiceProvider).import(content);
    }
  }
}

final importCollectionUseCaseProvider = Provider<ImportCollectionUseCase>(
  (ref) => ImportCollectionUseCase(ref),
);
