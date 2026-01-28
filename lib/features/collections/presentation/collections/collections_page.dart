import 'package:flutter/material.dart';
import 'package:geo_spots/features/collections/presentation/collections/view/collections_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/design_system/widgets/scaffold/gs_refresh_scaffold.dart';
import '../../domain/domain.dart';

class CollectionsPage extends ConsumerWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GSRefreshScaffold(
      onRefresh: () async {
        await CollectionsDomain.invalidate(ref);
      },
      padding: EdgeInsets.zero,
      child: const CollectionsView(),
    );
  }
}
