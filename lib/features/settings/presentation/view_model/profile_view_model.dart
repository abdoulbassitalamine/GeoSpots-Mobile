import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/presentation/view_model/authentication_view_model.dart';
import 'package:geo_spots/features/settings/domain/use_case/profile_use_cases.dart';
import 'package:geo_spots/features/tracking/data/services/location_tracking_service.dart';
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
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await ref.read(profileUseCasesProvider).loadProfile();
    switch (result) {
      case Ok(value: final snapshot):
        state = state.copyWith(
          user: snapshot.user,
          totalPlaces: snapshot.totalPlaces,
          totalCollections: snapshot.totalCollections,
          sharedPlaces: snapshot.sharedPlaces,
          isTrackingEnabled: snapshot.isTrackingEnabled,
          isLoading: false,
        );
      case Err():
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erreur lors du chargement du profil',
        );
    }
  }

  Future<void> toggleTracking(bool value) async {
    final trackingService = ref.read(locationTrackingServiceProvider);
    final useCases = ref.read(profileUseCasesProvider);
    state = state.copyWith(errorMessage: null);

    final result = value
        ? await useCases.enableTracking()
        : await useCases.disableTracking();
    if (result is Err) {
      state = state.copyWith(
        errorMessage: 'Erreur lors de la mise à jour du tracking',
      );
      return;
    }

    try {
      if (value) {
        await trackingService.startTracking();
      } else {
        await trackingService.stopTracking();
      }

      state = state.copyWith(isTrackingEnabled: value);
    } on Exception {
      state = state.copyWith(
        errorMessage: 'Erreur lors de la mise à jour du tracking',
      );
    }
  }

  Future<void> logout() async {
    await ref.read(authenticationViewModelProvider.notifier).logOut();
  }

  Future<void> refresh() async {
    await _loadProfile();
  }
}
