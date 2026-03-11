import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'package:geo_spots/features/collections/domain/entity/shared_access_token_entity.dart';
import 'package:geo_spots/features/collections/domain/use_cases/collections_use_cases.dart';
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
        child: GSPremiumPanel(
          padding: const EdgeInsets.all(GSSpacing.xl3),
          borderColor: GSColors.neutral150,
          child: Text(
            'Collection introuvable.',
            style: GSTypography.bodyDefaultMedium.copyWith(
              color: GSColors.neutral600,
            ),
          ),
        ),
      );
    }

    final tokenForCollection = _findTokenForCollection(state, collection.id);
    final isSharedCollection =
        hasSharedContext ||
        state.sharedCollections.any((item) => item.id == collection.id);
    final effectiveSharedToken = activeSharedToken ?? tokenForCollection?.token;
    final effectiveRights = activeAccessRight ?? tokenForCollection?.rights;
    final getCollectionPlaces = ref.read(getCollectionPlacesUseCaseProvider);
    final placesFuture = useMemoized(
      () => getCollectionPlaces(
        collectionId: collection.id,
        token: isSharedCollection ? effectiveSharedToken : null,
      ),
      [collection.id, isSharedCollection, effectiveSharedToken],
    );
    final placesSnapshot = useFuture(placesFuture);

    if (placesSnapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: GSCircularLoader());
    }

    final placesResult = placesSnapshot.data;
    if (placesResult == null) {
      return Padding(
        padding: const EdgeInsets.only(top: GSSpacing.xl),
        child: GSPremiumPanel(
          padding: const EdgeInsets.all(GSSpacing.xl3),
          borderColor: GSColors.neutral150,
          child: Text(
            'Impossible de charger les lieux de la collection.',
            style: GSTypography.bodyDefaultMedium.copyWith(
              color: GSColors.neutral600,
            ),
          ),
        ),
      );
    }

    final places = switch (placesResult) {
      Ok(value: final value) => value,
      Err() => const <PlaceEntity>[],
    };
    final filteredPlaces = _filterPlaces(places, query.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CollectionDetailsSummary(
          total: places.length,
          filtered: filteredPlaces.length,
          sourceLabel: isSharedCollection
              ? 'Collection partagée'
              : 'Ma collection',
          rightsLabel: isSharedCollection ? effectiveRights?.label : null,
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
            child: GSPremiumPanel(
              padding: const EdgeInsets.all(GSSpacing.xl3),
              borderColor: GSColors.neutral150,
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
                              .read(
                                activeCollectionAccessRightProvider.notifier,
                              )
                              .right =
                          effectiveRights;
                      ref.read(activeSharedAccessTokenProvider.notifier).token =
                          effectiveSharedToken;
                    } else {
                      ref
                              .read(
                                activeCollectionAccessRightProvider.notifier,
                              )
                              .right =
                          null;
                      ref.read(activeSharedAccessTokenProvider.notifier).token =
                          null;
                    }
                    PlaceDetailsRouteData(
                      placeId: place.id,
                    ).push<void>(context);
                  },
                ),
              );
            },
          ),
      ],
    );
  }

  SharedAccessTokenEntity? _findTokenForCollection(
    CollectionsState state,
    String collectionId,
  ) {
    for (final token in state.sharedTokens) {
      if (token.resourceId == collectionId) {
        return token;
      }
    }
    return null;
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
