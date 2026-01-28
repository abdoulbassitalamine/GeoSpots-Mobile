import 'package:flutter/material.dart';
import 'package:geo_spots/features/settings/presentation/settings/view/settings_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/design_system/widgets/scaffold/gs_refresh_scaffold.dart';
import '../../domain/domain.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GSRefreshScaffold(
      onRefresh: () async {
        await SettingsDomain.invalidate(ref);
      },
      child: const SettingsView(),
    );
  }
}
