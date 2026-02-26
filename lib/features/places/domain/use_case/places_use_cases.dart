import 'package:geo_spots/core/utils/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entity/place_entity.dart';
import '../entity/place_search_params.dart';
import '../entity/place_share_result_entity.dart';
import '../entity/place_upsert_payload.dart';
import '../repository/places_repository.dart';

part 'places_use_cases.g.dart';

@riverpod
PlacesUseCases placesUseCases(Ref ref) => PlacesUseCases(ref: ref);

class PlacesUseCases {
  PlacesUseCases({required this.ref});

  final Ref ref;

  IPlacesRepository get _repository => ref.read(placesRepositoryProvider);

  Future<Result<List<PlaceEntity>>> getAllPlaces() =>
      _execute(() => _repository.getAllPlaces());

  Future<Result<List<PlaceEntity>>> getPlacesByTag(String tag) =>
      _execute(() => _repository.getPlacesByTag(tag));

  Future<Result<List<PlaceEntity>>> searchPlaces(String query) {
    return _execute(
      () => _repository.searchPlaces(
        PlaceSearchParams(query: query.trim().isEmpty ? null : query.trim()),
      ),
    );
  }

  Future<Result<List<PlaceEntity>>> searchWithParams(
    PlaceSearchParams params,
  ) => _execute(() => _repository.searchPlaces(params));

  Future<Result<List<PlaceEntity>>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    double radiusKm = 5,
    String? tag,
  }) {
    return _execute(
      () => _repository.getNearbyPlaces(
        PlaceSearchParams(
          latitude: latitude,
          longitude: longitude,
          radiusKm: radiusKm,
          tag: tag,
        ),
      ),
    );
  }

  Future<Result<List<String>>> getPlaceTags() =>
      _execute(() => _repository.getPlaceTags());

  Future<Result<PlaceEntity?>> getPlaceById(String id, {String? token}) =>
      _execute(() => _repository.getPlaceById(id, token: token));

  Future<Result<PlaceEntity>> createPlace(PlaceUpsertPayload payload) =>
      _execute(() => _repository.createPlace(payload));

  Future<Result<PlaceEntity>> updatePlace(
    String id,
    PlaceUpsertPayload payload,
  ) => _execute(() => _repository.updatePlace(id, payload));

  Future<Result<void>> deletePlace(String id) =>
      _execute(() => _repository.deletePlace(id));

  Future<Result<PlaceEntity>> addTag(String id, String tag) =>
      _execute(() => _repository.addTag(id, tag));

  Future<Result<PlaceEntity>> removeTag(String id, String tag) =>
      _execute(() => _repository.removeTag(id, tag));

  Future<Result<PlaceShareResultEntity>> sharePlace({
    required String id,
    required bool canWrite,
    DateTime? expiresAt,
    String? label,
  }) {
    return _execute(
      () => _repository.sharePlace(
        id: id,
        permission: canWrite ? 'WRITE' : 'READ',
        expiresAt: expiresAt,
        label: label,
      ),
    );
  }

  Future<Result<PlaceEntity>> uploadPlaceImage({
    required String id,
    required String imagePath,
  }) => _execute(() => _repository.uploadPlaceImage(id, imagePath));

  Future<Result<PlaceEntity>> deletePlaceImage(String id) =>
      _execute(() => _repository.deletePlaceImage(id));

  Future<Result<List<int>>> getImageBytes(String id, {String? token}) =>
      _execute(() => _repository.getImageBytes(id, token: token));

  Future<Result<void>> deleteImage(String id) =>
      _execute(() => _repository.deleteImage(id));

  Future<Result<T>> _execute<T>(Future<T> Function() action) async {
    try {
      return Ok(await action());
    } on Exception catch (e, st) {
      return Err(e, st);
    }
  }
}
