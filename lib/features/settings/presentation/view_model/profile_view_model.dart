import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/domain/entity/user/user_stats_entity.dart';
import 'package:geo_spots/features/authentication/domain/use_case/me_stats_use_case.dart';
import 'package:geo_spots/features/authentication/domain/use_case/me_use_case.dart';
import 'package:geo_spots/features/authentication/presentation/view_model/authentication_view_model.dart';
import 'package:geo_spots/features/tracking/data/services/location_tracking_service.dart';
import 'package:geo_spots/features/tracking/domain/use_case/tracking_use_cases.dart';
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

    final meFuture = ref.watch(meInUseCaseProvider.future);
    final meStatsFuture = ref.watch(meStatsUseCaseProvider.future);
    final isTrackingEnabledAction = ref.watch(isTrackingEnabledUseCaseProvider);

    final userResult = await meFuture;
    final user = switch (userResult) {
      Ok(:final value) => value,
      Err(error: final error, stackTrace: final stackTrace) => () {
        GsLogger().e(
          '[ProfileViewModel] loadProfile -> me failed',
          error,
          stackTrace,
        );
        return null;
      }(),
    };

    final statsResult = await meStatsFuture;
    late final UserStatsEntity stats;
    switch (statsResult) {
      case Ok(value: final value):
        stats = value;
      case Err(error: final error, stackTrace: final stackTrace):
        GsLogger().e(
          '[ProfileViewModel] loadProfile -> meStats failed',
          error,
          stackTrace,
        );
        if (!ref.mounted) {
          return;
        }
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erreur lors du chargement du profil',
        );
        return;
    }

    final trackingResult = await isTrackingEnabledAction();
    late final bool trackingEnabled;
    switch (trackingResult) {
      case Ok(value: final value):
        trackingEnabled = value;
      case Err(error: final error, stackTrace: final stackTrace):
        GsLogger().e(
          '[ProfileViewModel] loadProfile -> isTrackingEnabled failed',
          error,
          stackTrace,
        );
        if (!ref.mounted) {
          return;
        }
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erreur lors du chargement du profil',
        );
        return;
    }

    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(
      user: user,
      totalPlaces: stats.ownedPlaceCount,
      totalCollections: stats.collectionCount,
      sharedPlaces: stats.sharedCollectionCount,
      isTrackingEnabled: trackingEnabled,
      isLoading: false,
    );
  }

  Future<void> toggleTracking(bool value) async {
    final trackingService = ref.read(locationTrackingServiceProvider);
    final enableTracking = ref.read(enableTrackingUseCaseProvider);
    final disableTracking = ref.read(disableTrackingUseCaseProvider);
    state = state.copyWith(errorMessage: null);

    final result = value ? await enableTracking() : await disableTracking();
    if (!ref.mounted) {
      return;
    }
    if (result case Err(error: final error, stackTrace: final stackTrace)) {
      GsLogger().e(
        '[ProfileViewModel] toggleTracking -> ${value ? 'enable' : 'disable'} failed',
        error,
        stackTrace,
      );
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

      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(isTrackingEnabled: value);
    } on Exception catch (error, stackTrace) {
      GsLogger().e(
        '[ProfileViewModel] toggleTracking -> tracking service failed',
        error,
        stackTrace,
      );
      if (!ref.mounted) {
        return;
      }
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
