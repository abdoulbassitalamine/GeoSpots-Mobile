import 'package:dio/dio.dart';
import '../../domain/entity/place_entity.dart';
import 'places_remote_datasource.dart';

class PlacesRemoteDatasourceImpl implements IPlacesRemoteDatasource {
  PlacesRemoteDatasourceImpl();
  // : _placesApi = PlacesApi(placesClient);

  // final PlacesApi _placesApi;

  // Données mockées pour le développement
  static final List<PlaceEntity> _mockPlaces = [
    const PlaceEntity(
      id: '1',
      title: 'Tour Eiffel',
      description: 'Monument emblématique de Paris',
      tags: ['Monument', 'Paris'],
      date: '15 janvier 2026',
      city: 'Paris',
      country: 'France',
      latitude: 48.8584,
      longitude: 2.2945,
    ),
    const PlaceEntity(
      id: '2',
      title: 'Mont Saint-Michel',
      description: 'Abbaye au sommet d\'un îlot rocheux',
      tags: ['Historique', 'Normandie'],
      date: '12 janvier 2026',
      city: 'Le Mont-Saint-Michel',
      country: 'France',
      latitude: 48.6361,
      longitude: -1.5115,
    ),
    const PlaceEntity(
      id: '3',
      title: 'Château de Versailles',
      description: 'Résidence royale historique',
      tags: ['Château', 'UNESCO'],
      date: '8 janvier 2026',
      city: 'Versailles',
      country: 'France',
      latitude: 48.8049,
      longitude: 2.1204,
    ),
    const PlaceEntity(
      id: '4',
      title: 'Cathédrale Notre-Dame de Paris',
      description: 'Chef-d\'œuvre de l\'architecture gothique',
      tags: ['Religion', 'Architecture'],
      date: '5 janvier 2026',
      city: 'Paris',
      country: 'France',
      latitude: 48.8530,
      longitude: 2.3499,
    ),
    const PlaceEntity(
      id: '5',
      title: 'Palais des Papes',
      description: 'Plus grand palais gothique du monde',
      tags: ['Histoire', 'Avignon'],
      date: '2 janvier 2026',
      city: 'Avignon',
      country: 'France',
      latitude: 43.9509,
      longitude: 4.8075,
    ),
    const PlaceEntity(
      id: '6',
      title: 'Arc de Triomphe',
      description: 'Monument commémoratif des victoires de Napoléon',
      tags: ['Monument', 'Paris'],
      date: '28 décembre 2025',
      city: 'Paris',
      country: 'France',
      latitude: 48.8738,
      longitude: 2.2950,
    ),
    const PlaceEntity(
      id: '7',
      title: 'Pont du Gard',
      description: 'Aqueduc romain exceptionnel',
      tags: ['Historique', 'UNESCO', 'Architecture'],
      date: '20 décembre 2025',
      city: 'Vers-Pont-du-Gard',
      country: 'France',
      latitude: 43.9475,
      longitude: 4.5353,
    ),
    const PlaceEntity(
      id: '8',
      title: 'Basilique du Sacré-Cœur',
      description: 'Basilique située au sommet de la butte Montmartre',
      tags: ['Religion', 'Paris', 'Architecture'],
      date: '15 décembre 2025',
      city: 'Paris',
      country: 'France',
      latitude: 48.8867,
      longitude: 2.3431,
    ),
  ];

  @override
  Future<List<PlaceEntity>> fetchAllPlaces() async {
    try {
      // TODO(dev): Replace with an API call.
      // final result = await _placesApi.getAllPlaces();
      // if (result.data == null) throw Exception('No places found');
      // return result.data!.map((dto) => PlaceEntity.fromDto(dto)).toList();

      await Future<void>.delayed(const Duration(milliseconds: 500));
      return _mockPlaces;
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<PlaceEntity>> fetchPlacesByTag(String tag) async {
    try {
      // TODO(dev): Replace with an API call.
      // final result = await _placesApi.getPlacesByTag(tag: tag);
      // if (result.data == null) throw Exception('No places found');
      // return result.data!.map((dto) => PlaceEntity.fromDto(dto)).toList();

      await Future<void>.delayed(const Duration(milliseconds: 500));
      return _mockPlaces.where((place) => place.hasTag(tag)).toList();
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<PlaceEntity>> searchPlaces(String query) async {
    try {
      // TODO(dev): Replace with an API call.
      // final result = await _placesApi.searchPlaces(query: query);
      // if (result.data == null) throw Exception('No places found');
      // return result.data!.map((dto) => PlaceEntity.fromDto(dto)).toList();

      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (query.isEmpty) return _mockPlaces;
      return _mockPlaces.where((place) => place.matchesSearch(query)).toList();
    } on DioException catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<PlaceEntity?> fetchPlaceById(String id) async {
    try {
      // TODO(dev): Replace with an API call.
      // final result = await _placesApi.getPlaceById(id: id);
      // if (result.data == null) return null;
      // return PlaceEntity.fromDto(result.data!);

      await Future<void>.delayed(const Duration(milliseconds: 300));
      return _mockPlaces.firstWhere((place) => place.id == id);
    } on DioException catch (e) {
      throw Exception(e);
    } on Exception {
      return null;
    }
  }
}
