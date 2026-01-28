import '../../domain/entity/place_entity.dart';
import '../../domain/repository/places_repository.dart';
import '../datasource/places_remote_datasource.dart';

class PlacesRepositoryImpl implements IPlacesRepository {
  PlacesRepositoryImpl({
    required IPlacesRemoteDatasource placesRemoteDatasource,
  }) : _placesRemoteDatasource = placesRemoteDatasource;

  final IPlacesRemoteDatasource _placesRemoteDatasource;

  @override
  Future<List<PlaceEntity>> getAllPlaces() async {
    return await _placesRemoteDatasource.fetchAllPlaces();
  }

  @override
  Future<List<PlaceEntity>> getPlacesByTag(String tag) async {
    return await _placesRemoteDatasource.fetchPlacesByTag(tag);
  }

  @override
  Future<List<PlaceEntity>> searchPlaces(String query) async {
    return await _placesRemoteDatasource.searchPlaces(query);
  }

  @override
  Future<PlaceEntity?> getPlaceById(String id) async {
    return await _placesRemoteDatasource.fetchPlaceById(id);
  }

  @override
  Future<List<PlaceEntity>> getRecentPlaces({int limit = 5}) async {
    final allPlaces = await _placesRemoteDatasource.fetchAllPlaces();
    return allPlaces.take(limit).toList();
  }
}
