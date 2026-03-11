import 'package:flutter/material.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../shared/design_system/design_system.dart';

class MapPlaceSearchSelection {
  const MapPlaceSearchSelection({required this.query, this.placeId});

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
  TextStyle? get searchFieldStyle => GSTypography.bodyDefaultLarge.copyWith(
    color: GSColors.neutral900,
    fontWeight: FontWeight.w600,
  );

  @override
  InputDecorationTheme? get searchFieldDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: GSColors.neutral000,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: GSSpacing.l,
      vertical: GSSpacing.l,
    ),
    hintStyle: GSTypography.bodyDefaultLarge.copyWith(
      color: GSColors.neutral450,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(GSRadius.l),
      borderSide: const BorderSide(color: GSColors.neutral200),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(GSRadius.l),
      borderSide: const BorderSide(color: GSColors.neutral200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(GSRadius.l),
      borderSide: const BorderSide(color: GSColors.primary600, width: 2),
    ),
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      scaffoldBackgroundColor: GSColors.neutral050,
      appBarTheme: const AppBarTheme(
        backgroundColor: GSColors.neutral050,
        surfaceTintColor: GSColors.neutral050,
        elevation: 0,
        toolbarHeight: 72,
      ),
      inputDecorationTheme: searchFieldDecorationTheme,
    );
  }

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
      return ColoredBox(
        color: GSColors.neutral050,
        child: Center(
          child: GSPremiumPanel(
            padding: const EdgeInsets.all(GSSpacing.xl3),
            borderColor: GSColors.neutral150,
            child: Text(
              'Aucun lieu trouvé',
              style: GSTypography.bodyAccentMedium.copyWith(
                color: GSColors.neutral800,
              ),
            ),
          ),
        ),
      );
    }

    final sections = _buildSections(results);
    final tiles = <Widget>[
      _sectionHeader('Top résultats'),
      ...sections.topResults.map((item) => _placeTile(context, item.place)),
    ];

    if (sections.nearby.isNotEmpty) {
      tiles.add(_sectionHeader('Lieux proches'));
      tiles.addAll(
        sections.nearby.map(
          (item) =>
              _placeTile(context, item.place, distanceKm: item.distanceKm),
        ),
      );
    }

    if (sections.byTag.isNotEmpty) {
      for (final entry in sections.byTag.entries) {
        tiles.add(_sectionHeader('Tag: ${entry.key}'));
        tiles.addAll(
          entry.value.map((item) => _placeTile(context, item.place)),
        );
      }
    }

    return ColoredBox(
      color: GSColors.neutral050,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: GSSpacing.xl,
          vertical: GSSpacing.l,
        ),
        itemCount: tiles.length,
        separatorBuilder: (_, _) => const SizedBox(height: GSSpacing.s),
        itemBuilder: (context, index) => tiles[index],
      ),
    );
  }

  List<PlaceEntity> _filteredPlaces() {
    final withCoordinates = places
        .where((place) => place.hasCoordinates)
        .toList();
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
            tags.any(
              (tag) => _startsWithWord(tag, term) || tag.contains(term),
            ) ||
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
    final topResults = results
        .take(6)
        .map((place) => _PlaceMatch(place: place))
        .toList();

    final nearby =
        results
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

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        GSSpacing.s,
        GSSpacing.l,
        GSSpacing.s,
        GSSpacing.xs,
      ),
      child: Text(
        title,
        style: GSTypography.labelAccent.copyWith(color: GSColors.primary700),
      ),
    );
  }

  Widget _placeTile(
    BuildContext context,
    PlaceEntity place, {
    double? distanceKm,
  }) {
    final subtitle = [
      place.city,
      place.country,
    ].where((e) => e != null && e.isNotEmpty).join(', ');
    final normalizedQuery = query.trim();
    final highlightStyle = GSTypography.bodyDefaultMedium.copyWith(
      fontWeight: FontWeight.w800,
      color: GSColors.primary700,
    );

    return GSPremiumPanel(
      padding: const EdgeInsets.all(GSSpacing.l),
      borderColor: GSColors.neutral150,
      backgroundColor: GSColors.neutral000,
      onTap: () {
        close(
          context,
          MapPlaceSearchSelection(
            query: query.trim().isEmpty ? place.title : query,
            placeId: place.id,
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: GSColors.primary50,
              borderRadius: BorderRadius.circular(GSRadius.l),
            ),
            child: const Icon(
              Icons.location_on_outlined,
              color: GSColors.primary700,
            ),
          ),
          const SizedBox(width: GSSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _highlightedText(
                  place.title,
                  normalizedQuery,
                  baseStyle: GSTypography.bodyAccentMedium.copyWith(
                    color: GSColors.neutral900,
                  ),
                  highlightStyle: highlightStyle,
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: GSSpacing.xs),
                  _highlightedText(
                    subtitle,
                    normalizedQuery,
                    baseStyle: GSTypography.bodyDefaultSmall.copyWith(
                      color: GSColors.neutral650,
                    ),
                    highlightStyle: highlightStyle,
                  ),
                ],
                if (place.tags.isNotEmpty && distanceKm == null) ...[
                  const SizedBox(height: GSSpacing.s),
                  GSInfoChip(
                    label: place.tags.first,
                    backgroundColor: GSColors.neutral100,
                    borderColor: GSColors.neutral150,
                  ),
                ],
              ],
            ),
          ),
          if (distanceKm != null)
            Padding(
              padding: const EdgeInsets.only(left: GSSpacing.m),
              child: GSInfoChip(
                label: '${distanceKm.toStringAsFixed(1)} km',
                backgroundColor: GSColors.primary50,
                borderColor: GSColors.primary100,
                foregroundColor: GSColors.primary700,
              ),
            ),
        ],
      ),
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
    final matches = RegExp(
      escapedQuery,
      caseSensitive: false,
    ).allMatches(source);
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
        spans.add(
          TextSpan(
            text: source.substring(start, match.start),
            style: baseStyle,
          ),
        );
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
        .replaceAll(
          RegExp(r'[\u200B-\u200F\u202A-\u202E\u2066-\u2069\uFEFF]'),
          '',
        )
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
  const _PlaceMatch({required this.place, this.distanceKm});

  final PlaceEntity place;
  final double? distanceKm;
}
