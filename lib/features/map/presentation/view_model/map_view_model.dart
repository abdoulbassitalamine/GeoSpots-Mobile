import 'package:flutter/foundation.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:geo_spots/features/places/domain/repository/places_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'map_state.dart';

part 'map_view_model.g.dart';

@riverpod
class MapViewModel extends _$MapViewModel {
  @override
  MapState build() {
    Future.microtask(loadPlaces);
    return const MapState(isLoading: true);
  }

  Future<void> loadPlaces() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final places = await ref.read(placesRepositoryProvider).getAllPlaces();
      final categories = _buildCategories(places);
      final visiblePlaces = _filterPlaces(
        places: places,
        category: state.selectedCategory,
        query: state.searchQuery,
      );

      state = state.copyWith(
        allPlaces: places,
        categories: categories,
        visiblePlaces: visiblePlaces,
        selectedCategory:
            categories.contains(state.selectedCategory) ? state.selectedCategory : 'Tous',
        selectedPlaceId: _resolveSelectedPlaceId(
          preferred: state.selectedPlaceId,
          visiblePlaces: visiblePlaces,
        ),
        isLoading: false,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors du chargement de la carte',
      );
    }
  }

  void updateSearchQuery(String query) {
    _logSearchInput(query);
    _applyFilters(
      searchQuery: query,
      selectedCategory: query.trim().isNotEmpty ? 'Tous' : state.selectedCategory,
    );
  }

  void selectCategory(String category) {
    _applyFilters(selectedCategory: category);
  }

  void selectPlace(String placeId) {
    state = state.copyWith(selectedPlaceId: placeId);
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }

  void _applyFilters({
    String? searchQuery,
    String? selectedCategory,
  }) {
    final nextQuery = searchQuery ?? state.searchQuery;
    final nextCategory = selectedCategory ?? state.selectedCategory;
    final effectiveCategory = nextQuery.trim().isNotEmpty ? 'Tous' : nextCategory;
    final nextVisiblePlaces = _filterPlaces(
      places: state.allPlaces,
      category: effectiveCategory,
      query: nextQuery,
    );
    _logSearchResult(
      rawQuery: nextQuery,
      normalizedQuery: _normalize(nextQuery),
      effectiveCategory: effectiveCategory,
      resultsCount: nextVisiblePlaces.length,
    );

    state = state.copyWith(
      searchQuery: nextQuery,
      selectedCategory: effectiveCategory,
      visiblePlaces: nextVisiblePlaces,
      selectedPlaceId: _resolveSelectedPlaceId(
        preferred: state.selectedPlaceId,
        visiblePlaces: nextVisiblePlaces,
      ),
    );
  }

  List<String> _buildCategories(List<PlaceEntity> places) {
    final tags = <String>{};
    for (final place in places) {
      tags.addAll(place.tags.where((tag) => tag.trim().isNotEmpty));
    }
    final sorted = tags.toList()..sort();
    return ['Tous', ...sorted];
  }

  List<PlaceEntity> _filterPlaces({
    required List<PlaceEntity> places,
    required String category,
    required String query,
  }) {
    final normalizedQuery = _normalize(query);
    final queryTerms =
        normalizedQuery.split(' ').where((term) => term.isNotEmpty).toList();

    final filtered = places.where((place) {
      if (place.latitude == null || place.longitude == null) {
        return false;
      }

      final categoryMatches =
          category == 'Tous' ||
          place.tags.any((tag) => _normalize(tag) == _normalize(category));

      if (!categoryMatches) {
        return false;
      }

      if (queryTerms.isEmpty) {
        return true;
      }

      final title = _normalize(place.title);
      final description = _normalize(place.description);
      final city = _normalize(place.city ?? '');
      final country = _normalize(place.country ?? '');
      final tags = place.tags.map(_normalize).toList();

      return queryTerms.every((term) {
        return _matchesTerm(title, term) ||
            _matchesTerm(description, term) ||
            _matchesTerm(city, term) ||
            _matchesTerm(country, term) ||
            tags.any((tag) => _matchesTerm(tag, term));
      });
    }).toList();

    if (queryTerms.isEmpty) {
      return filtered;
    }

    filtered.sort((a, b) {
      final scoreA = _searchScore(a, queryTerms);
      final scoreB = _searchScore(b, queryTerms);
      return scoreB.compareTo(scoreA);
    });

    return filtered;
  }

  int _searchScore(PlaceEntity place, List<String> queryTerms) {
    final title = _normalize(place.title);
    final tags = place.tags.map(_normalize).toList();
    final city = _normalize(place.city ?? '');
    final country = _normalize(place.country ?? '');
    final description = _normalize(place.description);

    var score = 0;
    for (final term in queryTerms) {
      if (_startsWithWord(title, term)) {
        score += 120;
      } else if (_matchesTerm(title, term)) {
        score += 90;
      }

      if (tags.any((tag) => _startsWithWord(tag, term))) {
        score += 70;
      } else if (tags.any((tag) => _matchesTerm(tag, term))) {
        score += 50;
      }

      if (_startsWithWord(city, term) || _startsWithWord(country, term)) {
        score += 30;
      } else if (_matchesTerm(city, term) || _matchesTerm(country, term)) {
        score += 20;
      }

      if (_matchesTerm(description, term)) {
        score += 10;
      }
    }
    return score;
  }

  bool _matchesTerm(String value, String term) {
    if (value.isEmpty || term.isEmpty) {
      return false;
    }
    return _startsWithWord(value, term) || value.contains(term);
  }

  bool _startsWithWord(String value, String term) {
    if (value.isEmpty || term.isEmpty) {
      return false;
    }
    for (final word in value.split(RegExp(r'[^a-z0-9]+'))) {
      if (word.isNotEmpty && word.startsWith(term)) {
        return true;
      }
    }
    return false;
  }

  void _logSearchInput(String query) {
    if (!kDebugMode) {
      return;
    }
    debugPrint('[MapSearch] input="$query"');
  }

  void _logSearchResult({
    required String rawQuery,
    required String normalizedQuery,
    required String effectiveCategory,
    required int resultsCount,
  }) {
    if (!kDebugMode) {
      return;
    }
    debugPrint(
      '[MapSearch] query="$rawQuery" normalized="$normalizedQuery" '
      'category="$effectiveCategory" results=$resultsCount',
    );
  }

  String _normalize(String value) {
    return value
        .replaceAll(RegExp(r'[\u200B-\u200F\u202A-\u202E\u2066-\u2069\uFEFF]'), '')
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll('à', 'a')
        .replaceAll('á', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ä', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('å', 'a')
        .replaceAll('ç', 'c')
        .replaceAll('è', 'e')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('ë', 'e')
        .replaceAll('ì', 'i')
        .replaceAll('í', 'i')
        .replaceAll('î', 'i')
        .replaceAll('ï', 'i')
        .replaceAll('ñ', 'n')
        .replaceAll('ò', 'o')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('ö', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ù', 'u')
        .replaceAll('ú', 'u')
        .replaceAll('û', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ý', 'y')
        .replaceAll('ÿ', 'y');
  }

  String? _resolveSelectedPlaceId({
    required String? preferred,
    required List<PlaceEntity> visiblePlaces,
  }) {
    if (visiblePlaces.isEmpty) {
      return null;
    }

    if (preferred != null && visiblePlaces.any((place) => place.id == preferred)) {
      return preferred;
    }

    return visiblePlaces.first.id;
  }
}
