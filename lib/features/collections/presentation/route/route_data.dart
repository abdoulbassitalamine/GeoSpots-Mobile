import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../../core/router/route_names.dart';
import '../collections/collections_page.dart';

final collectionsMainNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'collections',
);
final collectionsRoutesProvider = Provider(
  (ref) =>  GoRoute(
      path: RouteNames.collections,
      name: RouteNames.collectionsName,
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: CollectionsPage());
      },
    ),

);
