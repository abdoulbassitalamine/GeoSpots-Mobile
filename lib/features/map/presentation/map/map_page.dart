import 'package:flutter/material.dart';
import 'package:geo_spots/features/map/presentation/map/view/map_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/design_system/widgets/scaffold/gs_refresh_scaffold.dart';

class MapPage extends ConsumerWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GSRefreshScaffold(
      enableRefresh: false,
      padding: EdgeInsets.zero,
      child: const MapView(),
    );
  }
}
