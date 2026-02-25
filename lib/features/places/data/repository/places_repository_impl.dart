import '../../domain/entity/place_entity.dart';
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
    return _placesRemoteDatasource.fetchPlacesByTag(tag);
  }

  @override
  Future<List<PlaceEntity>> searchPlaces(String query) {
    return _placesRemoteDatasource.searchPlaces(query);
  }

  @override
  Future<PlaceEntity?> getPlaceById(String id) {
    return _placesRemoteDatasource.fetchPlaceById(id);
  }

  @override
  Future<List<PlaceEntity>> getRecentPlaces({int limit = 5}) async {
    final allPlaces = await _placesRemoteDatasource.fetchAllPlaces();
    return allPlaces.take(limit).toList();
  }
}
