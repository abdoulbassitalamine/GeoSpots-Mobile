import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../entity/collection_entity.dart';
import '../enums/export_format.dart';
import '../services/export_import_service.dart';

class ExportCollectionUseCase {
  ExportCollectionUseCase(this._ref);

  final Ref _ref;

  Future<String> call(CollectionEntity collection, ExportFormat format) async {
    switch (format) {
      case ExportFormat.gpx:
        return _ref.read(gpxServiceProvider).export(collection);
      case ExportFormat.kml:
        return _ref.read(kmlServiceProvider).export(collection);
      case ExportFormat.geoJSON:
        return _ref.read(geoJsonServiceProvider).export(collection);
    }
  }
}

final exportCollectionUseCaseProvider = Provider<ExportCollectionUseCase>(
      ExportCollectionUseCase.new,
);
