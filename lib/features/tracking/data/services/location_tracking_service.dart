import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/logger/gs_logger.dart';
import '../../domain/repository/tracking_repository.dart';

final locationTrackingServiceProvider = Provider<LocationTrackingService>(
  LocationTrackingService.new,
);

class LocationTrackingService {
  LocationTrackingService(this.ref);

  final Ref ref;
  StreamSubscription<Position>? _positionStream;
  Timer? _updateTimer;

  /// Demande les permissions de localisation
  Future<bool> requestPermissions() async {
    try {
      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        GsLogger().w('Location permission denied by user');
        return false;
      }

      if (permission == LocationPermission.deniedForever) {
        GsLogger().e(
          'Location permission denied forever - user must enable in settings',
        );
        return false;
      }

      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } on Exception catch (e) {
      GsLogger().e('Error requesting permissions: $e');
      return false;
    }
  }

  Future<void> startTracking({
    Duration updateInterval = const Duration(minutes: 5),
  }) async {
    try {
      // Demander les permissions avant de démarrer
      final hasPermission = await requestPermissions();
      if (!hasPermission) {
        GsLogger().e('Cannot start tracking: location permission not granted');
        return;
      }

      await ref.read(trackingRepositoryProvider).enableTracking();

      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      _positionStream =
          Geolocator.getPositionStream(
            locationSettings: locationSettings,
          ).listen(
            _handlePositionUpdate,
            onError: (Object error) {
              GsLogger().e('Position stream error: $error');
            },
          );

      // Timer de backup
      _updateTimer = Timer.periodic(updateInterval, (_) async {
        try {
          final position = await Geolocator.getCurrentPosition();
          _handlePositionUpdate(position);
        } on Exception catch (e) {
          GsLogger().e('Timer position update error: $e');
        }
      });

      GsLogger().d('Location tracking started');
    } on Exception catch (e) {
      GsLogger().e('Error starting tracking: $e');
    }
  }

  void _handlePositionUpdate(Position position) {
    try {
      GsLogger().d(
        'Position update: ${position.latitude}, ${position.longitude}',
      );

      ref
          .read(trackingRepositoryProvider)
          .updatePosition(
            latitude: position.latitude,
            longitude: position.longitude,
            timestamp: position.timestamp,
          );
    } on Exception catch (e) {
      GsLogger().e('Error handling position update: $e');
    }
  }

  Future<void> stopTracking() async {
    try {
      await _positionStream?.cancel();
      _updateTimer?.cancel();
      _positionStream = null;
      _updateTimer = null;

      await ref.read(trackingRepositoryProvider).disableTracking();
      GsLogger().d('Location tracking stopped');
    } on Exception catch (e) {
      GsLogger().e('Error stopping tracking: $e');
    }
  }

  bool get isTracking => _positionStream != null;

  /// Restaure le tracking uniquement si les permissions sont accordées
  Future<void> restoreTrackingIfEnabled() async {
    try {
      final shouldTrack = await ref
          .read(trackingRepositoryProvider)
          .isTrackingEnabled();

      if (!shouldTrack) {
        GsLogger().d('Tracking not enabled in settings');
        return;
      }

      if (isTracking) {
        GsLogger().d('Tracking already active');
        return;
      }

      // Vérifier les permissions SANS les demander
      final permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        // Permissions OK, on peut restaurer automatiquement
        await startTracking();
        GsLogger().d('✅ Tracking restored from saved state');
      } else {
        // Permissions non accordées - ne pas restaurer automatiquement
        // L'utilisateur devra manuellement activer le tracking via l'UI
        GsLogger().w(
          'Tracking was enabled but location permission not granted. '
          'User must manually start tracking.',
        );
        // Optionnel : désactiver le tracking puisqu'on ne peut pas l'utiliser
        await ref.read(trackingRepositoryProvider).disableTracking();
      }
    } on Exception catch (e, stackTrace) {
      GsLogger().e('Error restoring tracking: $e');
      GsLogger().e(stackTrace);
    }
  }
}
