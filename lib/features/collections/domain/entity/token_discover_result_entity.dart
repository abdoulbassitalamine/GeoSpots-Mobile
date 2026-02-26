import 'package:geo_spots/features/places/domain/entity/place_entity.dart';

import 'collection_entity.dart';

class TokenDiscoverResultEntity {
  const TokenDiscoverResultEntity({
    required this.serverUrl,
    required this.tokenLabel,
    required this.collections,
    required this.places,
    required this.locationAvailable,
  });

  final String serverUrl;
  final String tokenLabel;
  final List<CollectionEntity> collections;
  final List<PlaceEntity> places;
  final bool locationAvailable;
}
