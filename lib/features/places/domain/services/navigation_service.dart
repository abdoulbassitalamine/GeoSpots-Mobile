import 'package:geo_spots/features/places/data/services/navigation_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../entity/place_entity.dart';

final navigationServiceProvider = Provider<INavigationService>(
  (ref) => NavigationServiceImpl(),
);

abstract interface class INavigationService {
  Future<void> openInGoogleMaps(PlaceEntity place);
  Future<void> openInWaze(PlaceEntity place);
  Future<void> openInAppleMaps(PlaceEntity place);
  Future<void> showNavigationOptions(PlaceEntity place);
}
