import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'package:geo_spots/features/collections/domain/enums/collection_source.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:geo_spots/features/places/presentation/places_list/widgets/place_list_item.dart';
import 'package:geo_spots/features/places/presentation/route/route_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/design_system/design_system.dart';
import '../../view_model/collections_state.dart';
import '../../view_model/collections_view_model.dart';
import '../../view_model/shared_access_session.dart';
import '../widgets/collection_details_summary.dart';
import '../widgets/collection_search_field.dart';

class CollectionDetailsView extends HookConsumerWidget {
  const CollectionDetailsView({super.key, required this.collectionTag});

  final String collectionTag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(collectionsViewModelProvider);
    final activeAccessRight = ref.watch(activeCollectionAccessRightProvider);
    final activeSharedToken = ref.watch(activeSharedAccessTokenProvider);
    final searchController = useTextEditingController();
    final query = useState('');
    final hasSharedContext = activeAccessRight != null;
    final collection = _findCollection(
      state,
      collectionTag,
      preferShared: hasSharedContext,
    );

    if (state.isLoading) {
      return const Center(child: GSCircularLoader());
    }

    if (collection == null) {
      return Padding(
        padding: const EdgeInsets.only(top: GSSpacing.xl),
        child: Text(
          'Collection introuvable.',
          style: GSTypography.bodyDefaultMedium.copyWith(
            color: GSColors.neutral600,
          ),
        ),
      );
    }

    final filteredPlaces = _filterPlaces(collection.places, query.value);
    final isSharedCollection =
        hasSharedContext || collection.source == CollectionSource.shared;
    final effectiveRights = activeAccessRight ?? collection.rights;

    return Column(
      children: [
        CollectionDetailsSummary(
          total: collection.places.length,
          filtered: filteredPlaces.length,
          sourceLabel: isSharedCollection ? 'Collection partagée' : 'Ma collection',
          rightsLabel: isSharedCollection ? effectiveRights.label : null,
        ),
        const SizedBox(height: GSSpacing.m),
        CollectionSearchField(
          controller: searchController,
          onChanged: (value) => query.value = value.trim(),
        ),
        const SizedBox(height: GSSpacing.m),
        if (filteredPlaces.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: GSSpacing.xl),
            child: Center(
              child: Text(
                query.value.isEmpty
                    ? 'Aucun lieu dans cette collection.'
                    : 'Aucun résultat pour "${query.value}".',
                style: GSTypography.bodyDefaultMedium.copyWith(
                  color: GSColors.neutral600,
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredPlaces.length,
            itemBuilder: (context, index) {
              final place = filteredPlaces[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == filteredPlaces.length - 1 ? 0 : GSSpacing.l,
                ),
                child: PlaceListItem(
                  place: place,
                  onTap: () {
                    if (isSharedCollection) {
                      ref
                          .read(activeCollectionAccessRightProvider.notifier)
                          .setRight(effectiveRights);
                      ref
                          .read(activeSharedAccessTokenProvider.notifier)
                          .setToken(collection.sharedToken ?? activeSharedToken);
                    } else {
                      ref
                          .read(activeCollectionAccessRightProvider.notifier)
                          .setRight(null);
                      ref
                          .read(activeSharedAccessTokenProvider.notifier)
                          .setToken(null);
                    }
                    PlaceDetailsRouteData(placeId: place.id).push(context);
                  },
                ),
              );
            },
          ),
      ],
    );
  }

  CollectionEntity? _findCollection(
    CollectionsState state,
    String tag, {
    required bool preferShared,
  }) {
    if (preferShared) {
      for (final collection in state.sharedCollections) {
        if (collection.tag == tag) {
          return collection;
        }
      }
    }

    for (final collection in state.ownedCollections) {
      if (collection.tag == tag) {
        return collection;
      }
    }

    for (final collection in state.sharedCollections) {
      if (collection.tag == tag) {
        return collection;
      }
    }

    return null;
  }

  List<PlaceEntity> _filterPlaces(List<PlaceEntity> places, String query) {
    if (query.isEmpty) {
      return places;
    }
    return places.where((place) => place.matchesSearch(query)).toList();
  }
}
