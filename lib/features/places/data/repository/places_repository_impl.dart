import '../../domain/entity/place_entity.dart';
import '../../domain/entity/place_search_params.dart';
import '../../domain/entity/place_share_result_entity.dart';
import '../../domain/entity/place_upsert_payload.dart';
import '../../domain/repository/places_repository.dart';
import '../datasource/places_remote_datasource.dart';

class PlacesRepositoryImpl implements IPlacesRepository {
  PlacesRepositoryImpl({
    required IPlacesRemoteDatasource placesRemoteDatasource,
  }) : _placesRemoteDatasource = placesRemoteDatasource;

  final IPlacesRemoteDatasource _placesRemoteDatasource;

  @override
  Future<List<PlaceEntity>> getAllPlaces() {
    return _placesRemoteDatasource.fetchAllPlaces();
  }

  @override
  Future<List<PlaceEntity>> getPlacesByTag(String tag) {
    return _placesRemoteDatasource.fetchTagsFilteredPlaces(tag);
  }

  @override
  Future<List<PlaceEntity>> searchPlaces(PlaceSearchParams params) {
    return _placesRemoteDatasource.searchPlaces(params);
  }

  @override
  Future<List<PlaceEntity>> getNearbyPlaces(PlaceSearchParams params) {
    return _placesRemoteDatasource.fetchNearbyPlaces(params);
  }

  @override
  Future<List<String>> getPlaceTags() {
    return _placesRemoteDatasource.fetchPlaceTags();
  }

  @override
  Future<PlaceEntity?> getPlaceById(String id, {String? token}) {
    return _placesRemoteDatasource.fetchPlaceById(id, token: token);
  }

  @override
  Future<PlaceEntity> createPlace(PlaceUpsertPayload payload) {
    return _placesRemoteDatasource.createPlace(payload);
  }

  @override
  Future<PlaceEntity> updatePlace(String id, PlaceUpsertPayload payload) {
    return _placesRemoteDatasource.updatePlace(id, payload);
  }

  @override
  Future<void> deletePlace(String id) {
    return _placesRemoteDatasource.deletePlace(id);
  }

  @override
  Future<PlaceEntity> addTag(String id, String tag) {
    return _placesRemoteDatasource.addTag(id, tag);
  }

  @override
  Future<PlaceEntity> removeTag(String id, String tag) {
    return _placesRemoteDatasource.removeTag(id, tag);
  }

  @override
  Future<PlaceShareResultEntity> sharePlace({
    required String id,
    required String permission,
    DateTime? expiresAt,
    String? label,
  }) {
    return _placesRemoteDatasource.sharePlace(
      id: id,
      permission: permission,
      expiresAt: expiresAt,
      label: label,
    );
  }

  @override
  Future<PlaceEntity> uploadPlaceImage(String id, String imagePath) {
    return _placesRemoteDatasource.uploadPlaceImage(id, imagePath);
  }

  @override
  Future<PlaceEntity> deletePlaceImage(String id) {
    return _placesRemoteDatasource.deletePlaceImage(id);
  }

  @override
  Future<List<int>> getImageBytes(String id, {String? token}) {
    return _placesRemoteDatasource.fetchImageBytes(id, token: token);
  }

  @override
  Future<void> deleteImage(String id) {
    return _placesRemoteDatasource.deleteImage(id);
  }

  @override
  Future<List<PlaceEntity>> getRecentPlaces({int limit = 5}) async {
    final allPlaces = await _placesRemoteDatasource.fetchAllPlaces();
    return allPlaces.take(limit).toList();
  }
}
