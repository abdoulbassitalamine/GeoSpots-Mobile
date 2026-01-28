import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entity/place_entity.dart';
import 'home_state.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  HomeState build() {
    _loadDummyData();
    return const HomeState();
  }

  Future<void> _loadDummyData() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final recentPlaces = [
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
    ];

    state = state.copyWith(
      username: 'Abdoul Bassit',
      totalLocations: 248,
      totalCollections: 12,
      recentPlaces: recentPlaces,
      isLoading: false,
    );
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _loadDummyData();
  }
}
