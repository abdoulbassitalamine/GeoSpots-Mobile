import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:geo_spots/core/constants/app_constants.dart';
import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geo_spots/core/router/app_router.dart';
import 'package:geo_spots/features/places/presentation/route/route_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  final service = DeepLinkService(ref);
  ref.onDispose(service.dispose);
  return service;
});

class DeepLinkService {
  DeepLinkService(this.ref) {
    _initialize();
  }

  final Ref ref;
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  void _initialize() {
    _appLinks.getInitialLink().then((uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });

    _linkSubscription = _appLinks.uriLinkStream.listen(
      _handleDeepLink,
      onError: (Object err) {
        GsLogger().e('Deep link error: $err');
      },
    );
  }

  void _handleDeepLink(Uri uri) {
    GsLogger().d('Deep link received: $uri');

    if (uri.scheme == kSchemeGeoSpots && uri.host == kHostPlace) {
      _handlePlaceLink(uri);
    } else if (_supportsGeoScheme && uri.scheme == kSchemeGeo) {
      _handleGeoLink(uri);
    }
  }

  void _handlePlaceLink(Uri uri) {
    final placeId = uri.queryParameters[kQueryId]?.trim();

    if (placeId != null && placeId.isNotEmpty) {
      _goTo(PlaceDetailsRouteData(placeId: placeId).location);
    } else {
      final lat = double.tryParse(uri.queryParameters[kQueryLat] ?? '');
      final lon = double.tryParse(uri.queryParameters[kQueryLon] ?? '');

      if (lat != null && lon != null) {
        final route = UpsertPlaceRouteData(
          placeId: kPlaceCreationId,
          $extra: {kExtraLatitude: lat, kExtraLongitude: lon},
        );
        _goTo(route.location, extra: route.$extra);
      }
    }
  }

  void _handleGeoLink(Uri uri) {
    final path = uri.path;
    final coords = path.split(',');

    if (coords.length >= 2) {
      final lat = double.tryParse(coords[0]);
      final lon = double.tryParse(coords[1]);

      if (lat != null && lon != null) {
        final route = UpsertPlaceRouteData(
          placeId: kPlaceCreationId,
          $extra: {
            kExtraLatitude: lat,
            kExtraLongitude: lon,
            kExtraTitle: uri.queryParameters[kQueryQuery]?.trim(),
          },
        );
        _goTo(route.location, extra: route.$extra);
      }
    }
  }

  bool get _supportsGeoScheme =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  void _goTo(String location, {Object? extra}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appRouterProvider).go(location, extra: extra);
    });
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
