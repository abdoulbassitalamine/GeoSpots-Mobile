import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:geo_spots/features/places/domain/services/share_service.dart';
import 'package:share_plus/share_plus.dart';

class ShareServiceImpl implements IShareService {
  @override
  Future<void> sharePlace(PlaceEntity place) async {
    final text = _formatPlaceForSharing(place);
    final shareParam = ShareParams(text: text, subject: place.title);
    await SharePlus.instance.share(shareParam);
  }

  @override
  Future<void> sharePlaceWithCoordinates(PlaceEntity place) async {
    if (!place.hasCoordinates) {
      await sharePlaceAsText(place);
      return;
    }

    final text =
        '''
       ${place.title}

       ${place.description}

      Coordonnées GPS:
      ${place.latitude}, ${place.longitude}

      Google Maps: https://www.google.com/maps/search/?api=1&query=${place.latitude},${place.longitude}
    ''';
    final shareParam = ShareParams(text: text, subject: place.title);

    await SharePlus.instance.share(shareParam);
  }

  @override
  Future<void> sharePlaceAsText(PlaceEntity place) async {
    final text = _formatPlaceForSharing(place);
    final shareParam = ShareParams(text: text, subject: place.title);
    await SharePlus.instance.share(shareParam);
  }

  String _formatPlaceForSharing(PlaceEntity place) {
    final buffer = StringBuffer();
    buffer.writeln(place.title);
    buffer.writeln();
    buffer.writeln(place.description);

    if (place.hasCoordinates) {
      buffer.writeln();
      buffer.writeln('📍 ${place.latitude}, ${place.longitude}');
    }

    if (place.tags.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Tags: ${place.tags.join(", ")}');
    }

    return buffer.toString();
  }
}
