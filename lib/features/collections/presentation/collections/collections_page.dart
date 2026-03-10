import 'package:flutter/material.dart';
import 'package:geo_spots/core/constants/app_constants.dart';
import 'package:geo_spots/features/authentication/domain/entity/authentication_status/authentication_status.dart';
import 'package:geo_spots/features/authentication/domain/navigator/authentication_notifier.dart';
import 'package:geo_spots/features/collections/presentation/collections/view/collections_view.dart';
import 'package:geo_spots/features/places/presentation/route/route_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/design_system/widgets/scaffold/gs_refresh_scaffold.dart';
import '../../domain/domain.dart';

class CollectionsPage extends ConsumerWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStatus = ref.watch(authGuardProvider);
    final isAuthenticated = authStatus is AuthenticationStatusAuthenticated;

    return GSRefreshScaffold(
      onRefresh: () async {
        await CollectionsDomain.invalidate(ref);
      },
      padding: EdgeInsets.zero,
      floatingActionButton: isAuthenticated
          ? FloatingActionButton.extended(
              onPressed: () => UpsertPlaceRouteData(
                placeId: kPlaceCreationId,
              ).push<void>(context),
              icon: const Icon(Icons.add),
              label: const Text('Nouveau lieu'),
            )
          : null,
      child: const CollectionsView(),
    );
  }
}
