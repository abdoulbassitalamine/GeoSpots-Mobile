import 'package:geo_spots/core/utils/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../entity/collection_entity.dart';
import '../enums/export_format.dart';
import '../repository/collections_repository.dart';

part 'export_collection_use_case.g.dart';

class ExportCollectionUseCase {
  ExportCollectionUseCase(this._ref);

  final Ref _ref;

  Future<Result<String>> call(
    CollectionEntity collection,
    ExportFormat format,
  ) async {
    try {
      final content = await _ref
          .read(collectionsRepositoryProvider)
          .exportCollection(collection: collection, format: format);
      return Ok(content);
    } on Exception catch (e, st) {
      return Err(e, st);
    }
  }
}

@riverpod
ExportCollectionUseCase exportCollectionUseCase(Ref ref) =>
    ExportCollectionUseCase(ref);
