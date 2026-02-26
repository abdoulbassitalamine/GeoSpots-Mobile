import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/domain/entity/user/user_entity.dart';
import 'package:geo_spots/features/authentication/domain/use_case/me_use_case.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'package:geo_spots/features/collections/domain/use_cases/collections_use_cases.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:geo_spots/features/places/domain/use_case/places_use_cases.dart';
import 'package:geo_spots/features/tracking/domain/use_case/tracking_use_cases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_use_cases.g.dart';

@riverpod
ProfileUseCases profileUseCases(Ref ref) => ProfileUseCases(ref: ref);

class ProfileSnapshot {
  const ProfileSnapshot({
    required this.user,
    required this.totalPlaces,
    required this.totalCollections,
    required this.sharedPlaces,
    required this.isTrackingEnabled,
  });

  final UserEntity? user;
  final int totalPlaces;
  final int totalCollections;
  final int sharedPlaces;
  final bool isTrackingEnabled;
}

class ProfileUseCases {
  ProfileUseCases({required this.ref});

  final Ref ref;

  Future<Result<ProfileSnapshot>> loadProfile() async {
    final userResult = await ref.read(meInUseCaseProvider.future);
    final user = switch (userResult) {
      Ok(:final value) => value,
      Err() => null,
    };

    final allPlacesResult = await ref
        .read(placesUseCasesProvider)
        .getAllPlaces();
    late final List<PlaceEntity> allPlaces;
    switch (allPlacesResult) {
      case Ok(value: final value):
        allPlaces = value;
      case Err(error: final error, stackTrace: final stackTrace):
        return Err(error, stackTrace);
    }

    final ownedCollectionsResult = await ref
        .read(collectionsUseCasesProvider)
        .getOwnedCollections();
    late final List<CollectionEntity> ownedCollections;
    switch (ownedCollectionsResult) {
      case Ok(value: final value):
        ownedCollections = value;
      case Err(error: final error, stackTrace: final stackTrace):
        return Err(error, stackTrace);
    }

    final sharedCollectionsResult = await ref
        .read(collectionsUseCasesProvider)
        .getSharedCollections();
    late final List<CollectionEntity> sharedCollections;
    switch (sharedCollectionsResult) {
      case Ok(value: final value):
        sharedCollections = value;
      case Err(error: final error, stackTrace: final stackTrace):
        return Err(error, stackTrace);
    }
    final sharedPlaces = sharedCollections.fold<int>(
      0,
      (int sum, CollectionEntity collection) => sum + collection.placesCount,
    );

    final isTrackingEnabledResult = await ref
        .read(trackingUseCasesProvider)
        .isTrackingEnabled();
    late final bool isTrackingEnabled;
    switch (isTrackingEnabledResult) {
      case Ok(value: final value):
        isTrackingEnabled = value;
      case Err(error: final error, stackTrace: final stackTrace):
        return Err(error, stackTrace);
    }

    return Ok(
      ProfileSnapshot(
        user: user,
        totalPlaces: allPlaces.length,
        totalCollections: ownedCollections.length,
        sharedPlaces: sharedPlaces,
        isTrackingEnabled: isTrackingEnabled,
      ),
    );
  }

  Future<Result<void>> enableTracking() =>
      ref.read(trackingUseCasesProvider).enableTracking();

  Future<Result<void>> disableTracking() =>
      ref.read(trackingUseCasesProvider).disableTracking();
}
