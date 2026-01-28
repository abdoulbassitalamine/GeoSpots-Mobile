import 'package:flutter/material.dart';
import 'package:geo_spots/features/home/presentation/home/view/home_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/design_system/widgets/scaffold/gs_refresh_scaffold.dart';
import '../../domain/domain.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GSRefreshScaffold(
      onRefresh: () async {
        await HomeDomain.invalidate(ref);
      },
      padding: EdgeInsets.zero,
      child: const HomeView(),
    );
  }
}