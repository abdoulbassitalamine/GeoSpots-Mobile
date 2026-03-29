import 'dart:async';

import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/tracking/domain/use_case/tracking_use_cases.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'live_location_state.dart';

part 'live_location_view_model.g.dart';

@riverpod
class LiveLocationViewModel extends _$LiveLocationViewModel {
  Timer? _pollingTimer;
  static const _pollInterval = Duration(seconds: 5);

  @override
  LiveLocationState build(String token) {
    ref.onDispose(() {
      _pollingTimer?.cancel();
    });
    Future.microtask(_fetchAndStartPolling);
    return const LiveLocationState(isLoading: true);
  }

  void _fetchAndStartPolling() {
    _fetch();
    _pollingTimer = Timer.periodic(_pollInterval, (_) => _fetch());
  }

  Future<void> _fetch() async {
    final getPublicLocation = ref.read(getPublicLocationUseCaseProvider);
    final result = await getPublicLocation(token);

    if (!ref.mounted) return;

    switch (result) {
      case Ok(value: final location):
        if (location == null) {
          state = state.copyWith(
            isLoading: false,
            isExpired: true,
            errorMessage: 'Cette position n\'est plus disponible.',
          );
          _pollingTimer?.cancel();
          return;
        }
        state = state.copyWith(
          location: location,
          isLoading: false,
          clearError: true,
        );
      case Err(error: final error, stackTrace: final stackTrace):
        GsLogger().e('[LiveLocationViewModel] fetch failed', error, stackTrace);
        if (!ref.mounted) return;
        // Keep last known position, just show error badge
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Mise à jour impossible. Vérifiez votre connexion.',
        );
    }
  }

  void refresh() {
    state = state.copyWith(isLoading: true, clearError: true);
    _fetch();
  }
}
