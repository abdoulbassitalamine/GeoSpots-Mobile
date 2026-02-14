import 'package:flutter/material.dart';
import 'package:geo_spots/features/places/presentation/route/route_data.dart';
import 'package:geo_spots/features/collections/presentation/collections/widgets/collection_card.dart';
import 'package:geo_spots/features/collections/presentation/collections/widgets/collections_header.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../view_model/collections_view_model.dart';

class CollectionsView extends ConsumerWidget {
  const CollectionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(collectionsViewModelProvider);

    if (state.isLoading) {
      return const Center(child: GSCircularLoader());
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: CollectionsHeader(
            totalCollections: state.collections.length,
            totalPlaces: state.totalPlaces,
            // onImportPressed: () => _showImportDialog(context, ref),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(GSSpacing.xl),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final collection = state.collections[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: GSSpacing.l),
                child: CollectionCard(
                  collection: collection,
                  onTap: () => const PlacesRouteData().push(context),
                ),
              );
            }, childCount: state.collections.length),
          ),
        ),
      ],
    );
  }
}
