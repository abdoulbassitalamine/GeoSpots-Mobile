import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:geo_spots/features/collections/domain/use_cases/export_collection_use_case.dart';
import 'package:geo_spots/features/collections/domain/use_cases/import_collection_use_case.dart';
import 'package:geo_spots/features/places/domain/entity/place_list_extension.dart';
import 'package:geo_spots/features/places/domain/repository/places_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entity/collection_entity.dart';
import '../../domain/enums/export_format.dart';
import 'collections_state.dart';

part 'collections_view_model.g.dart';

@riverpod
class CollectionsViewModel extends _$CollectionsViewModel {
  static const _supportedExtensions = ['gpx', 'kml', 'geojson', 'json'];

  @override
  CollectionsState build() {
    Future.microtask(_loadDummyData);
    return const CollectionsState();
  }

  Future<void> _loadDummyData() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    final allPlaces = await ref.watch(placesRepositoryProvider).getAllPlaces();
    final collections = allPlaces.generateCollectionsFromTags();

    state = state.copyWith(
      collections: collections,
      allPlaces: allPlaces,
      totalPlaces: allPlaces.length,
      isLoading: false,
    );
  }

  Future<void> refresh() async {
    await _loadDummyData();
  }

  Future<void> exportCollection(
    CollectionEntity collection,
    ExportFormat format,
  ) async {
    try {
      state = state.copyWith(isExporting: true);

      final content = await ref
          .read(exportCollectionUseCaseProvider)
          .call(collection, format);

      final directory = await getTemporaryDirectory();
      final fileName =
          '${collection.tag}_${DateTime.now().millisecondsSinceEpoch}.${format.extension}';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsString(content);

      final shareParams = ShareParams(
        subject: 'Export collection: ${collection.tag}',
        files: [XFile(filePath)],
      );
      await SharePlus.instance.share(shareParams);

      state = state.copyWith(isExporting: false);
    } catch (e) {
      state = state.copyWith(
        isExporting: false,
        error: 'Erreur lors de l\'export: $e',
      );
    }
  }

  Future<void> importCollection() async {
    try {
      state = state.copyWith(isImporting: true);

      // On iOS, FileType.custom can hide some valid files (notably .gpx/.kml)
      // depending on provider UTType support, so we fallback to `any` and enforce
      // extension validation ourselves.
      final pickerType = Platform.isIOS ? FileType.any : FileType.custom;
      final result = await FilePicker.platform.pickFiles(
        type: pickerType,
        allowedExtensions: pickerType == FileType.custom
            ? _supportedExtensions
            : null,
      );

      if (result == null || result.files.isEmpty) {
        state = state.copyWith(isImporting: false);
        return;
      }

      final file = result.files.first;
      if (file.path == null) {
        state = state.copyWith(
          isImporting: false,
          error: 'Impossible de lire le fichier',
        );
        return;
      }

      // Déterminer le format
      ExportFormat? format;
      final extension = (file.extension ?? '').toLowerCase();
      if (!_supportedExtensions.contains(extension)) {
        state = state.copyWith(
          isImporting: false,
          error:
              'Format non supporte. Utilisez uniquement: .gpx, .kml, .geojson',
        );
        return;
      }

      final content = await File(file.path!).readAsString();

      if (extension == 'gpx') {
        format = ExportFormat.gpx;
      } else if (extension == 'kml') {
        format = ExportFormat.kml;
      } else if (extension == 'geojson' || extension == 'json') {
        format = ExportFormat.geoJSON;
      }

      if (format == null) {
        state = state.copyWith(
          isImporting: false,
          error: 'Format de fichier non supporté',
        );
        return;
      }

      // Importer
      final importedPlaces = await ref
          .read(importCollectionUseCaseProvider)
          .call(content, format);

      final allPlaces = [...state.allPlaces, ...importedPlaces];
      final collections = allPlaces.generateCollectionsFromTags();

      state = state.copyWith(
        collections: collections,
        allPlaces: allPlaces,
        totalPlaces: allPlaces.length,
        isImporting: false,
      );
    } catch (e) {
      state = state.copyWith(
        isImporting: false,
        error: 'Erreur lors de l\'import: $e',
      );
    }
  }
}
