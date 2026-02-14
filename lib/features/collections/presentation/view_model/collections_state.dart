import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geo_spots/features/collections/domain/entity/shared_access_token_entity.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import '../../domain/entity/collection_entity.dart';

part 'collections_state.freezed.dart';

enum CollectionsTab { owned, sharedWithMe, sharedByMe }

@freezed
sealed class CollectionsState with _$CollectionsState {
  const factory CollectionsState({
    @Default([]) List<CollectionEntity> ownedCollections,
    @Default([]) List<CollectionEntity> sharedCollections,
    @Default([]) List<SharedAccessTokenEntity> sharedTokens,
    @Default([]) List<SharedAccessTokenEntity> ownedShareTokens,
    @Default([]) List<PlaceEntity> allPlaces,
    @Default(0) int totalPlaces,
    @Default(CollectionsTab.owned) CollectionsTab selectedTab,
    @Default(false) bool isLoading,
    @Default(false) bool isImporting,
    @Default(false) bool isExporting,
    @Default(false) bool isImportingSharedAccess,
    @Default(false) bool isRevokingSharedAccess,
    String? error,
  }) = _CollectionsState;
}
