import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasource/places_remote_datasource.dart';
import '../../data/repository/places_repository_impl.dart';
import '../entity/place_entity.dart';
import '../entity/place_search_params.dart';
import '../entity/place_share_result_entity.dart';
import '../entity/place_upsert_payload.dart';

part 'places_repository.g.dart';

@Riverpod(keepAlive: true)
IPlacesRepository placesRepository(Ref ref) => PlacesRepositoryImpl(
  placesRemoteDatasource: ref.watch(placesRemoteDatasourceProvider),
);

abstract interface class IPlacesRepository {
  Future<List<PlaceEntity>> getAllPlaces();

  Future<List<PlaceEntity>> getPlacesByTag(String tag);

  Future<List<PlaceEntity>> searchPlaces(PlaceSearchParams params);

  Future<List<PlaceEntity>> getNearbyPlaces(PlaceSearchParams params);

  Future<List<String>> getPlaceTags();

  Future<PlaceEntity?> getPlaceById(String id, {String? token});

  Future<PlaceEntity> createPlace(PlaceUpsertPayload payload);

  Future<PlaceEntity> updatePlace(String id, PlaceUpsertPayload payload);

  Future<void> deletePlace(String id);

  Future<PlaceEntity> addTag(String id, String tag);

  Future<PlaceEntity> removeTag(String id, String tag);

  Future<PlaceShareResultEntity> sharePlace({
    required String id,
    required String permission,
    DateTime? expiresAt,
    String? label,
  });

  Future<PlaceEntity> uploadPlaceImage(String id, String imagePath);

  Future<PlaceEntity> deletePlaceImage(String id);

  Future<List<int>> getImageBytes(String id, {String? token});

  Future<void> deleteImage(String id);

  Future<List<PlaceEntity>> getRecentPlaces({int limit = 5});
}
