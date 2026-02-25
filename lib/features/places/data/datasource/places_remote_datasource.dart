import 'package:geo_spots/core/network/dio_client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entity/place_entity.dart';
import 'places_remote_datasource_impl.dart';

final placesRemoteDatasourceProvider = Provider<IPlacesRemoteDatasource>(
  (ref) =>
      PlacesRemoteDatasourceImpl(placesClient: ref.watch(dioClientProvider)),
);

abstract interface class IPlacesRemoteDatasource {
  Future<List<PlaceEntity>> fetchAllPlaces();
  Future<List<PlaceEntity>> fetchPlacesByTag(String tag);
  Future<List<PlaceEntity>> searchPlaces(String query);
  Future<PlaceEntity?> fetchPlaceById(String id);
}
