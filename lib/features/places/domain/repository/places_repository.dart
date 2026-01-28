import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/datasource/places_remote_datasource.dart';
import '../../data/repository/places_repository_impl.dart';
import '../entity/place_entity.dart';

final placesRepositoryProvider = Provider<IPlacesRepository>(
      (ref) => PlacesRepositoryImpl(
    placesRemoteDatasource: ref.watch(placesRemoteDatasourceProvider),
  ),
);

abstract interface class IPlacesRepository {
  Future<List<PlaceEntity>> getAllPlaces();

  Future<List<PlaceEntity>> getPlacesByTag(String tag);

  Future<List<PlaceEntity>> searchPlaces(String query);

  Future<PlaceEntity?> getPlaceById(String id);

  Future<List<PlaceEntity>> getRecentPlaces({int limit = 5});
}