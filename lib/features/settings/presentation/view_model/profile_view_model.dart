import 'package:geo_spots/features/authentication/domain/entity/user/user_entity.dart'
    show UserEntity;
import 'package:geo_spots/features/authentication/presentation/view_model/authentication_view_model.dart';
import 'package:geo_spots/features/tracking/data/services/location_tracking_service.dart';
import 'package:geo_spots/features/tracking/domain/repository/tracking_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'profile_state.dart';

part 'profile_view_model.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  ProfileState build() {
    Future.microtask(_loadProfile);
    return const ProfileState(isLoading: true);
  }

  Future<void> _loadProfile() async {
    state = state.copyWith(isLoading: true);

    try {
      final dummyUser = const UserEntity(
        id: '123',
        firstName: 'Jean',
        lastName: 'Dupont',
        email: 'jean@test.com',
      );

      final isTracking = await ref
          .read(trackingRepositoryProvider)
          .isTrackingEnabled();



      state = state.copyWith(
        user: dummyUser,
        totalPlaces: 42,
        totalCollections: 8,
        sharedPlaces: 15,
        isTrackingEnabled: isTracking,
        isLoading: false,
      );
      return;
      // ============================================================
      // FIN DUMMY DATA
      // ============================================================

      // Code original (commenté pour l'instant)
      /*
      final authState = ref.read(authGuardProvider);
      final user = authState.whenOrNull(authenticated: (user) => user);

      if (user == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Utilisateur non connecté',
        );
        return;
      }

      final places = await ref.read(placesRepositoryProvider).getAllPlaces();

      final collections = places.generateCollectionsFromTags();

      final isTracking = await ref
          .read(trackingRepositoryProvider)
          .isTrackingEnabled();

      // TODO: Calculer les lieux partagés (à implémenter plus tard)
      final sharedPlaces = 0;

      state = state.copyWith(
        user: user,
        totalPlaces: places.length,
        totalCollections: collections.length - 1, // -1 pour exclure "all"
        sharedPlaces: sharedPlaces,
        isTrackingEnabled: isTracking,
        isLoading: false,
      );
      */
    } on Exception {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors du chargement du profil',
      );
    }
  }

  Future<void> toggleTracking(bool value) async {

    final trackingService = ref.read(locationTrackingServiceProvider);
    final trackingRepository = ref.read(trackingRepositoryProvider);


    if (value) {
      await trackingRepository.enableTracking();
      await trackingService.startTracking();
    } else {
      await trackingRepository.disableTracking();
      await trackingService.stopTracking();
    }

    state = state.copyWith(isTrackingEnabled: value);
  }

  Future<void> logout() async {
    await ref.read(authenticationViewModelProvider.notifier).logOut();
  }

  Future<void> refresh() async {
    await _loadProfile();
  }
}
