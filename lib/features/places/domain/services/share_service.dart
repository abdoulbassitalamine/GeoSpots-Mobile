import 'package:geo_spots/features/places/data/services/share_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../entity/place_entity.dart';

final shareServiceProvider = Provider<IShareService>((ref) => ShareServiceImpl());

abstract interface class IShareService {
  Future<void> sharePlace(PlaceEntity place);
  Future<void> sharePlaceWithCoordinates(PlaceEntity place);
  Future<void> sharePlaceAsText(PlaceEntity place);
}
