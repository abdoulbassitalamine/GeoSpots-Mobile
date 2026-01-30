import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:geo_spots/features/places/domain/services/navigation_service.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationServiceImpl implements INavigationService {
  @override
  Future<void> openInGoogleMaps(PlaceEntity place) async {
    if (!place.hasCoordinates) return;

    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Future<void> openInWaze(PlaceEntity place) async {
    if (!place.hasCoordinates) return;

    final url = Uri.parse(
      'https://waze.com/ul?ll=${place.latitude},${place.longitude}&navigate=yes',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Future<void> openInAppleMaps(PlaceEntity place) async {
    if (!place.hasCoordinates) return;

    final url = Uri.parse(
      'https://maps.apple.com/?q=${place.latitude},${place.longitude}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Future<void> showNavigationOptions(PlaceEntity place) async {
    // Cette méthode sera appelée depuis le widget pour afficher les options
    throw UnimplementedError('Use widget to show options');
  }
}
