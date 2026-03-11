import 'package:geo_spots/core/utils/result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entity/place_entity.dart';
import '../entity/place_search_params.dart';
import '../entity/place_share_result_entity.dart';
import '../entity/place_upsert_payload.dart';
import '../repository/places_repository.dart';

part 'places_use_cases.g.dart';

@riverpod
Future<Result<List<PlaceEntity>>> Function() getAllPlacesUseCase(Ref ref) {
  final repository = ref.watch(placesRepositoryProvider);
  return () => _execute(repository.getAllPlaces);
}

@riverpod
Future<Result<List<PlaceEntity>>> Function(String tag) getPlacesByTagUseCase(
  Ref ref,
) {
  final repository = ref.watch(placesRepositoryProvider);
  return (tag) => _execute(() => repository.getPlacesByTag(tag));
}

@riverpod
Future<Result<List<PlaceEntity>>> Function(String query) searchPlacesUseCase(
  Ref ref,
) {
  final repository = ref.watch(placesRepositoryProvider);
  return (query) => _execute(
    () => repository.searchPlaces(
      PlaceSearchParams(query: query.trim().isEmpty ? null : query.trim()),
    ),
  );
}

@riverpod
Future<Result<List<PlaceEntity>>> Function(PlaceSearchParams params)
searchWithParamsUseCase(Ref ref) {
  final repository = ref.watch(placesRepositoryProvider);
  return (params) => _execute(() => repository.searchPlaces(params));
}

@riverpod
Future<Result<List<PlaceEntity>>> Function({
  required double latitude,
  required double longitude,
  double radiusKm,
  String? tag,
})
getNearbyPlacesUseCase(Ref ref) {
  final repository = ref.watch(placesRepositoryProvider);
  return ({
    required double latitude,
    required double longitude,
    double radiusKm = 5,
    String? tag,
  }) => _execute(
    () => repository.getNearbyPlaces(
      PlaceSearchParams(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
        tag: tag,
      ),
    ),
  );
}

@riverpod
Future<Result<List<String>>> Function() getPlaceTagsUseCase(Ref ref) {
  final repository = ref.watch(placesRepositoryProvider);
  return () => _execute(repository.getPlaceTags);
}

@riverpod
Future<Result<PlaceEntity?>> Function(String id, {String? token})
getPlaceByIdUseCase(Ref ref) {
  final repository = ref.watch(placesRepositoryProvider);
  return (id, {String? token}) =>
      _execute(() => repository.getPlaceById(id, token: token));
}

@riverpod
Future<Result<PlaceEntity>> Function(PlaceUpsertPayload payload)
createPlaceUseCase(Ref ref) {
  final repository = ref.read(placesRepositoryProvider);
  return (payload) => _execute(() => repository.createPlace(payload));
}

@riverpod
Future<Result<PlaceEntity>> Function(String id, PlaceUpsertPayload payload)
updatePlaceUseCase(Ref ref) {
  final repository = ref.read(placesRepositoryProvider);
  return (id, payload) => _execute(() => repository.updatePlace(id, payload));
}

@riverpod
Future<Result<void>> Function(String id) deletePlaceUseCase(Ref ref) {
  final repository = ref.read(placesRepositoryProvider);
  return (id) => _execute(() => repository.deletePlace(id));
}

@riverpod
Future<Result<PlaceEntity>> Function(String id, String tag) addPlaceTagUseCase(
  Ref ref,
) {
  final repository = ref.read(placesRepositoryProvider);
  return (id, tag) => _execute(() => repository.addTag(id, tag));
}

@riverpod
Future<Result<PlaceEntity>> Function(
  String id,
  String tag,
)
removePlaceTagUseCase(Ref ref) {
  final repository = ref.read(placesRepositoryProvider);
  return (id, tag) => _execute(() => repository.removeTag(id, tag));
}

@riverpod
Future<Result<PlaceShareResultEntity>> Function({
  required String id,
  required bool canWrite,
  DateTime? expiresAt,
  String? label,
})
sharePlaceUseCase(Ref ref) {
  final repository = ref.read(placesRepositoryProvider);
  return ({
    required String id,
    required bool canWrite,
    DateTime? expiresAt,
    String? label,
  }) => _execute(
    () => repository.sharePlace(
      id: id,
      permission: canWrite ? 'WRITE' : 'READ',
      expiresAt: expiresAt,
      label: label,
    ),
  );
}

@riverpod
Future<Result<PlaceEntity>> Function({
  required String id,
  required String imagePath,
})
uploadPlaceImageUseCase(Ref ref) {
  final repository = ref.read(placesRepositoryProvider);
  return ({
    required String id,
    required String imagePath,
  }) => _execute(() => repository.uploadPlaceImage(id, imagePath));
}

@riverpod
Future<Result<PlaceEntity>> Function(String id) deletePlaceImageUseCase(
  Ref ref,
) {
  final repository = ref.read(placesRepositoryProvider);
  return (id) => _execute(() => repository.deletePlaceImage(id));
}

@riverpod
Future<Result<List<int>>> Function(String id, {String? token})
getPlaceImageBytesUseCase(Ref ref) {
  final repository = ref.watch(placesRepositoryProvider);
  return (id, {String? token}) =>
      _execute(() => repository.getImageBytes(id, token: token));
}

@riverpod
Future<Result<void>> Function(String id) deleteImageUseCase(Ref ref) {
  final repository = ref.read(placesRepositoryProvider);
  return (id) => _execute(() => repository.deleteImage(id));
}

Future<Result<T>> _execute<T>(Future<T> Function() action) async {
  try {
    return Ok(await action());
  } on Exception catch (e, st) {
    return Err(e, st);
  }
}
