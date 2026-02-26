import 'package:geo_spots/core/utils/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../entity/collection_import_result_entity.dart';
import '../enums/export_format.dart';
import '../repository/collections_repository.dart';

part 'import_collection_use_case.g.dart';

class ImportCollectionUseCase {
  ImportCollectionUseCase(this._ref);

  final Ref _ref;

  Future<Result<CollectionImportResultEntity>> call({
    required String filePath,
    required ExportFormat format,
    List<String> defaultTags = const <String>[],
    bool skipDuplicates = true,
  }) async {
    try {
      final result = await _ref
          .read(collectionsRepositoryProvider)
          .importCollectionFile(
            filePath: filePath,
            format: format,
            defaultTags: defaultTags,
            skipDuplicates: skipDuplicates,
          );
      return Ok(result);
    } on Exception catch (e, st) {
      return Err(e, st);
    }
  }
}

@riverpod
ImportCollectionUseCase importCollectionUseCase(Ref ref) =>
    ImportCollectionUseCase(ref);
