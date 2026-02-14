import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/design_system/design_system.dart';
import '../view_model/collections_view_model.dart';
import 'view/collection_details_view.dart';

class CollectionDetailsPage extends HookConsumerWidget {
  const CollectionDetailsPage({super.key, required this.collectionTag});

  final String collectionTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GSAppBarScaffold(
      title: collectionTag == 'all'
          ? 'Tous les lieux'
          : collectionTag,
      onRefresh: () async {
        await ref.read(collectionsViewModelProvider.notifier).refresh();
      },
      child: CollectionDetailsView(collectionTag: collectionTag),
    );
  }
}
