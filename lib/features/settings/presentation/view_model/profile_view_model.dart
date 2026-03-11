import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/authentication.dart';
import 'package:geo_spots/features/authentication/domain/use_case/me_stats_use_case.dart';
import 'package:geo_spots/features/authentication/domain/use_case/me_use_case.dart';
import 'package:geo_spots/features/authentication/presentation/view_model/authentication_view_model.dart';
import 'package:geo_spots/features/tracking/data/services/location_tracking_service.dart';
import 'package:geo_spots/features/tracking/domain/entity/location_share_session_entity.dart';
import 'package:geo_spots/features/tracking/domain/use_case/tracking_use_cases.dart';
import 'package:geo_spots/shared/design_system/widgets/snackbar/snackbar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'profile_state.dart';

part 'profile_view_model.g.dart';

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  @override
  ProfileState build() {
    final authStatus = ref.watch(authGuardProvider);
    if (authStatus is! AuthenticationStatusAuthenticated) {
      return const ProfileState(isLoading: false);
    }

    Future.microtask(_loadProfile);
    return const ProfileState(isLoading: true);
  }

  Future<void> _loadProfile() async {
    final authStatus = ref.read(authGuardProvider);
    if (authStatus is! AuthenticationStatusAuthenticated) {
      if (!ref.mounted) {
        return;
      }
      state = const ProfileState(isLoading: false);
      return;
    }

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
      snackbarMessage: null,
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
        snackbarMessage: const GSSnackbarMessage(
          message: 'Erreur lors de la mise à jour du suivi',
          type: GSSnackbarType.error,
        ),
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
      state = state.copyWith(
        isTrackingEnabled: value,
        snackbarMessage: GSSnackbarMessage(
          message: value
              ? 'Suivi de position activé'
              : 'Suivi de position désactivé',
          presentation: GSSnackbarPresentation.scaffold,
        ),
      );
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
        snackbarMessage: const GSSnackbarMessage(
          message: 'Erreur lors de la mise à jour du suivi',
          type: GSSnackbarType.error,
        ),
      );
    }
  }

  Future<LocationShareSessionEntity?> startSharing() async {
    state = state.copyWith(isSharingLoading: true, errorMessage: null);
    final startLocationSharing = ref.read(startLocationSharingUseCaseProvider);
    final result = await startLocationSharing();

    if (!ref.mounted) return null;

    switch (result) {
      case Ok(value: final session):
        state = state.copyWith(
          isSharing: true,
          isSharingLoading: false,
          activeShareSession: session,
        );
        return session;
      case Err(error: final error, stackTrace: final stackTrace):
        GsLogger().e(
          '[ProfileViewModel] startSharing failed',
          error,
          stackTrace,
        );
        state = state.copyWith(
          isSharingLoading: false,
          snackbarMessage: const GSSnackbarMessage(
            message: 'Erreur lors du démarrage du partage en direct',
            type: GSSnackbarType.error,
          ),
        );
        return null;
    }
  }

  Future<void> stopSharing() async {
    final stopLocationSharing = ref.read(stopLocationSharingUseCaseProvider);
    final result = await stopLocationSharing();

    if (!ref.mounted) return;

    if (result case Err(error: final error, stackTrace: final stackTrace)) {
      GsLogger().e('[ProfileViewModel] stopSharing failed', error, stackTrace);
      state = state.copyWith(
        snackbarMessage: const GSSnackbarMessage(
          message:
              'Le partage a été arrêté localement, mais la session distante n\'a pas pu être fermée',
          type: GSSnackbarType.warning,
        ),
      );
    }

    // Reset sharing state regardless of error (best-effort stop)
    state = state.copyWith(
      isSharing: false,
      isSharingLoading: false,
      activeShareSession: null,
      snackbarMessage: result is Ok<void>
          ? const GSSnackbarMessage(
              message: 'Partage en direct arrêté',
              presentation: GSSnackbarPresentation.scaffold,
            )
          : state.snackbarMessage,
    );
  }

  Future<void> logout() async {
    await ref.read(authenticationViewModelProvider.notifier).logOut();
  }

  Future<void> refresh() async {
    await _loadProfile();
  }

  void consumeSnackbar() {
    if (state.snackbarMessage != null) {
      state = state.copyWith(snackbarMessage: null);
    }
  }
}
