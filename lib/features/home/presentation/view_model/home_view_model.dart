import 'package:geo_spots/features/places/domain/repository/places_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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

    final recentPlaces = await ref.watch(placesRepositoryProvider).getRecentPlaces();

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
