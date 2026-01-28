import 'package:geo_spots/core/router/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

import '../home/home_page.dart';

final homeMainNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final homeRoutesProvider = Provider(
  (ref) => GoRoute(
    path: RouteNames.home,
    name: RouteNames.homeName,
    pageBuilder: (context, state) {
      return const NoTransitionPage(child: HomePage());
    },
  ),
);
