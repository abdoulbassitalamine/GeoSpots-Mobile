import 'package:geo_spots/core/network/dio_client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entity/place_entity.dart';
import '../../domain/entity/place_search_params.dart';
import '../../domain/entity/place_share_result_entity.dart';
import '../../domain/entity/place_upsert_payload.dart';
import 'places_remote_datasource_impl.dart';

final placesRemoteDatasourceProvider = Provider<IPlacesRemoteDatasource>(
  (ref) =>
      PlacesRemoteDatasourceImpl(placesClient: ref.watch(dioClientProvider)),
);

abstract interface class IPlacesRemoteDatasource {
  Future<List<PlaceEntity>> fetchAllPlaces();
  Future<List<PlaceEntity>> fetchTagsFilteredPlaces(String tag);
  Future<List<PlaceEntity>> searchPlaces(PlaceSearchParams params);
  Future<List<PlaceEntity>> fetchNearbyPlaces(PlaceSearchParams params);
  Future<List<String>> fetchPlaceTags();
  Future<PlaceEntity?> fetchPlaceById(String id, {String? token});
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
  Future<List<int>> fetchImageBytes(String id, {String? token});
  Future<void> deleteImage(String id);
}
