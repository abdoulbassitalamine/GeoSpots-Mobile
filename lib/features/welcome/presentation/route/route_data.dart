import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/route_names.dart';
import '../welcome_page.dart';

final welcomeMainNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'authentication',
);
final welcomeRoutesProvider = Provider(
  (ref) => [
    GoRoute(
      path: RouteNames.welcome,
      name: RouteNames.welcomeName,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: WelcomePage()),
    ),
  ],
);
