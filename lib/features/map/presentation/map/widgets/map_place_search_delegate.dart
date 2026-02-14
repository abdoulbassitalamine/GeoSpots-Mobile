import 'package:flutter/material.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:latlong2/latlong.dart';

class MapPlaceSearchSelection {
  const MapPlaceSearchSelection({
    required this.query,
    this.placeId,
  });

  final String query;
  final String? placeId;
}

class MapPlaceSearchDelegate extends SearchDelegate<MapPlaceSearchSelection?> {
  MapPlaceSearchDelegate({
    required this.places,
    required this.currentCenter,
    String initialQuery = '',
  }) {
    query = initialQuery;
  }

  final List<PlaceEntity> places;
  final LatLng currentCenter;

  @override
  String? get searchFieldLabel => 'Rechercher un lieu...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    if (query.isEmpty) {
      return null;
    }
    return [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    final results = _filteredPlaces();
    if (results.isEmpty) {
      return const Center(child: Text('Aucun lieu trouvé'));
    }

    final sections = _buildSections(results);
    final tiles = <Widget>[
      _sectionHeader(context, 'Top résultats'),
      ...sections.topResults.map((item) => _placeTile(context, item.place)),
    ];

    if (sections.nearby.isNotEmpty) {
      tiles.add(_sectionHeader(context, 'Lieux proches'));
      tiles.addAll(
        sections.nearby.map(
          (item) => _placeTile(
            context,
            item.place,
            distanceKm: item.distanceKm,
          ),
        ),
      );
    }

    if (sections.byTag.isNotEmpty) {
      for (final entry in sections.byTag.entries) {
        tiles.add(_sectionHeader(context, 'Tag: ${entry.key}'));
        tiles.addAll(entry.value.map((item) => _placeTile(context, item.place)));
      }
    }

    return ListView.separated(
      itemCount: tiles.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) => tiles[index],
    );
  }

  List<PlaceEntity> _filteredPlaces() {
    final withCoordinates = places.where((place) => place.hasCoordinates).toList();
    if (query.trim().isEmpty) {
      withCoordinates.sort((a, b) => a.title.compareTo(b.title));
      return withCoordinates;
    }

    final q = _normalize(query);
    final terms = q.split(' ').where((e) => e.isNotEmpty).toList();

    final filtered = withCoordinates.where((place) {
      final title = _normalize(place.title);
      final tags = place.tags.map(_normalize).toList();
      final city = _normalize(place.city ?? '');
      final country = _normalize(place.country ?? '');
      final description = _normalize(place.description);

      return terms.every((term) {
        return _startsWithWord(title, term) ||
            title.contains(term) ||
            tags.any((tag) => _startsWithWord(tag, term) || tag.contains(term)) ||
            _startsWithWord(city, term) ||
            city.contains(term) ||
            _startsWithWord(country, term) ||
            country.contains(term) ||
            description.contains(term);
      });
    }).toList();

    filtered.sort((a, b) => _score(b, terms).compareTo(_score(a, terms)));
    return filtered;
  }

  _SearchSections _buildSections(List<PlaceEntity> results) {
    final topResults = results.take(6).map((place) => _PlaceMatch(place: place)).toList();

    final nearby = results
        .map(
          (place) => _PlaceMatch(
            place: place,
            distanceKm: Distance().as(
              LengthUnit.Kilometer,
              currentCenter,
              LatLng(place.latitude!, place.longitude!),
            ),
          ),
        )
        .toList()
      ..sort((a, b) => (a.distanceKm ?? 0).compareTo(b.distanceKm ?? 0));

    final byTag = <String, List<_PlaceMatch>>{};
    for (final place in results) {
      final key = place.tags.isEmpty ? 'Sans tag' : place.tags.first;
      byTag.putIfAbsent(key, () => []);
      if (byTag[key]!.length < 3) {
        byTag[key]!.add(_PlaceMatch(place: place));
      }
    }

    return _SearchSections(
      topResults: topResults,
      nearby: nearby.take(6).toList(),
      byTag: byTag,
    );
  }

  int _score(PlaceEntity place, List<String> terms) {
    final title = _normalize(place.title);
    final tags = place.tags.map(_normalize).toList();
    final city = _normalize(place.city ?? '');
    final country = _normalize(place.country ?? '');
    final description = _normalize(place.description);

    var score = 0;
    for (final term in terms) {
      if (_startsWithWord(title, term)) {
        score += 120;
      } else if (title.contains(term)) {
        score += 90;
      }
      if (tags.any((tag) => _startsWithWord(tag, term))) {
        score += 70;
      } else if (tags.any((tag) => tag.contains(term))) {
        score += 50;
      }
      if (_startsWithWord(city, term) || _startsWithWord(country, term)) {
        score += 30;
      } else if (city.contains(term) || country.contains(term)) {
        score += 20;
      }
      if (description.contains(term)) {
        score += 10;
      }
    }
    return score;
  }

  bool _startsWithWord(String value, String term) {
    for (final word in value.split(RegExp(r'[^a-z0-9]+'))) {
      if (word.isNotEmpty && word.startsWith(term)) {
        return true;
      }
    }
    return false;
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: .25),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }

  Widget _placeTile(
    BuildContext context,
    PlaceEntity place, {
    double? distanceKm,
  }) {
    final subtitle = [place.city, place.country]
        .where((e) => e != null && e.isNotEmpty)
        .join(', ');
    final normalizedQuery = query.trim();
    final highlightStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: Theme.of(context).colorScheme.primary,
        );

    return ListTile(
      leading: const Icon(Icons.location_on_outlined),
      title: _highlightedText(
        place.title,
        normalizedQuery,
        baseStyle: Theme.of(context).textTheme.bodyLarge,
        highlightStyle: highlightStyle,
      ),
      subtitle: subtitle.isEmpty
          ? null
          : _highlightedText(
              subtitle,
              normalizedQuery,
              baseStyle: Theme.of(context).textTheme.bodySmall,
              highlightStyle: highlightStyle,
            ),
      trailing: distanceKm != null
          ? Text(
              '${distanceKm.toStringAsFixed(1)} km',
              style: Theme.of(context).textTheme.bodySmall,
            )
          : (place.tags.isEmpty
              ? null
              : _highlightedText(
                  place.tags.first,
                  normalizedQuery,
                  baseStyle: Theme.of(context).textTheme.bodySmall,
                  highlightStyle: highlightStyle,
                )),
      onTap: () {
        close(
          context,
          MapPlaceSearchSelection(
            query: query.trim().isEmpty ? place.title : query,
            placeId: place.id,
          ),
        );
      },
    );
  }

  Widget _highlightedText(
    String source,
    String query, {
    TextStyle? baseStyle,
    TextStyle? highlightStyle,
  }) {
    if (query.isEmpty) {
      return Text(
        source,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: baseStyle,
      );
    }

    final escapedQuery = RegExp.escape(query);
    final matches = RegExp(escapedQuery, caseSensitive: false).allMatches(source);
    if (matches.isEmpty) {
      return Text(
        source,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: baseStyle,
      );
    }

    var start = 0;
    final spans = <TextSpan>[];
    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: source.substring(start, match.start), style: baseStyle));
      }
      spans.add(
        TextSpan(
          text: source.substring(match.start, match.end),
          style: highlightStyle ?? baseStyle,
        ),
      );
      start = match.end;
    }
    if (start < source.length) {
      spans.add(TextSpan(text: source.substring(start), style: baseStyle));
    }

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: spans),
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
}

class _SearchSections {
  const _SearchSections({
    required this.topResults,
    required this.nearby,
    required this.byTag,
  });

  final List<_PlaceMatch> topResults;
  final List<_PlaceMatch> nearby;
  final Map<String, List<_PlaceMatch>> byTag;
}

class _PlaceMatch {
  const _PlaceMatch({
    required this.place,
    this.distanceKm,
  });

  final PlaceEntity place;
  final double? distanceKm;
}
