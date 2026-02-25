import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:geo_spots/core/constants/app_constants.dart';
import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geo_spots/core/route_utils/route/router.dart';
import 'package:geo_spots/features/places/presentation/route/route_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final deepLinkServiceProvider = Provider<DeepLinkService>(DeepLinkService.new);

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
    } else if (uri.scheme == kSchemeGeo) {
      _handleGeoLink(uri);
    }
  }

  void _handlePlaceLink(Uri uri) {
    final placeId = uri.queryParameters[kQueryId];
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    if (placeId != null) {
      PlaceDetailsRouteData(placeId: placeId).push<void>(context);
    } else {
      final lat = uri.queryParameters[kQueryLat];
      final lon = uri.queryParameters[kQueryLon];

      if (lat != null && lon != null) {
        UpsertPlaceRouteData(
          placeId: kPlaceCreationId,
          $extra: {
            kExtraLatitude: double.tryParse(lat),
            kExtraLongitude: double.tryParse(lon),
          },
        ).push<void>(context);
      }
    }
  }

  void _handleGeoLink(Uri uri) {
    final path = uri.path;
    final coords = path.split(',');
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    if (coords.length >= 2) {
      final lat = double.tryParse(coords[0]);
      final lon = double.tryParse(coords[1]);

      if (lat != null && lon != null) {
        UpsertPlaceRouteData(
          placeId: kPlaceCreationId,
          $extra: {
            kExtraLatitude: lat,
            kExtraLongitude: lon,
            kExtraTitle: uri.queryParameters['q'],
          },
        ).push<void>(context);
      }
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
