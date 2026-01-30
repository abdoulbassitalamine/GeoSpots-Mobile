import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:geo_spots/core/route_utils/route/router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../logger/gs_logger.dart';
import '../router/route_names.dart';
import '../constants/app_constants.dart';

final deepLinkServiceProvider = Provider<DeepLinkService>(
  (ref) => DeepLinkService(ref),
);

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
      onError: (err) {
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

    if (placeId != null) {
      rootNavigatorKey.currentContext?.pushNamed(
        RouteNames.placeDetailsName,
        pathParameters: {kPlaceIdParam: placeId},
      );
    } else {
      final lat = uri.queryParameters[kQueryLat];
      final lon = uri.queryParameters[kQueryLon];

      if (lat != null && lon != null) {
        rootNavigatorKey.currentContext?.pushNamed(
          RouteNames.upsertPlaceName,
          pathParameters: {RouteNames.placeIdParam: kPlaceCreationId},
          extra: {
            kExtraLatitude: double.tryParse(lat),
            kExtraLongitude: double.tryParse(lon),
          },
        );
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
        rootNavigatorKey.currentContext?.pushNamed(
          RouteNames.upsertPlaceName,
          pathParameters: {RouteNames.placeIdParam: kPlaceCreationId},
          extra: {
            kExtraLatitude: lat,
            kExtraLongitude: lon,
            kExtraTitle: uri.queryParameters['q'],
          },
        );
      }
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
