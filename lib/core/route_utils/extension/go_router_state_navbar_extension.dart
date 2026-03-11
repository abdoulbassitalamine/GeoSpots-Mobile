import 'package:geo_spots/core/router/route_names.dart';
import 'package:go_router/go_router.dart';


const _routesWithNavBar = <String>{
  RouteNames.mapName,
  RouteNames.collectionsName,
  RouteNames.settingsName,
};

extension GoRouterStateNavBar on GoRouterState {
  bool get showNavBar => _routesWithNavBar.contains(topRoute?.name);
}
