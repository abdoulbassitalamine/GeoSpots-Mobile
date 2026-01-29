import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/places/domain/entity/place_entity.dart';

enum PlaceMapApp {
  googleMaps,
  waze,
  appleMaps,
}

@immutable
class PlaceExternalLinks {
  const PlaceExternalLinks();

  Uri buildAppDeepLink(PlaceEntity place) {
    return Uri.parse('geospots:///places/${place.id}');
  }

  Uri? buildGoogleMapsUri(PlaceEntity place) {
    final query = _resolveQuery(place);
    if (query == null) return null;
    return Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
    );
  }

  Uri? buildAppleMapsUri(PlaceEntity place) {
    if (place.hasCoordinates) {
      return Uri.parse(
        'http://maps.apple.com/?ll=${place.latitude},${place.longitude}',
      );
    }

    final query = _resolveQuery(place);
    if (query == null) return null;
    return Uri.parse('http://maps.apple.com/?q=${Uri.encodeComponent(query)}');
  }

  Uri? buildWazeUri(PlaceEntity place) {
    if (place.hasCoordinates) {
      return Uri.parse(
        'waze://?ll=${place.latitude},${place.longitude}&navigate=yes',
      );
    }

    final query = _resolveQuery(place);
    if (query == null) return null;
    return Uri.parse(
      'waze://?q=${Uri.encodeComponent(query)}&navigate=yes',
    );
  }

  String buildShareText(PlaceEntity place) {
    final buffer = StringBuffer(place.title);

    if (place.fullLocation.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(place.fullLocation);
    }

    if (place.description.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(place.description);
    }

    final mapsUri = buildGoogleMapsUri(place);
    if (mapsUri != null) {
      buffer.writeln();
      buffer.writeln(mapsUri.toString());
    }

    buffer.writeln();
    buffer.writeln(buildAppDeepLink(place).toString());

    return buffer.toString().trim();
  }

  Future<bool> launchMapApp(PlaceMapApp app, PlaceEntity place) async {
    Uri? primaryUri;
    switch (app) {
      case PlaceMapApp.googleMaps:
        primaryUri = buildGoogleMapsUri(place);
      case PlaceMapApp.waze:
        primaryUri = buildWazeUri(place);
      case PlaceMapApp.appleMaps:
        primaryUri = buildAppleMapsUri(place);
    }

    if (primaryUri == null) {
      return false;
    }

    if (await canLaunchUrl(primaryUri)) {
      return launchUrl(primaryUri, mode: LaunchMode.externalApplication);
    }

    if (app == PlaceMapApp.waze) {
      final fallbackUri = buildGoogleMapsUri(place);
      if (fallbackUri != null && await canLaunchUrl(fallbackUri)) {
        return launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    }

    return false;
  }

  String? _resolveQuery(PlaceEntity place) {
    if (place.hasCoordinates) {
      return '${place.latitude},${place.longitude}';
    }

    final fallback = [place.fullLocation, place.title]
        .map((value) => value.trim())
        .firstWhere(
          (value) => value.isNotEmpty,
          orElse: () => '',
        );

    if (fallback.isEmpty) {
      return null;
    }

    return fallback;
  }
}
