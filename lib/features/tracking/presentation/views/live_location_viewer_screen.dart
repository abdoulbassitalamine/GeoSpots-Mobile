import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_spots/features/settings/presentation/route/route_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../shared/design_system/design_system.dart';
import '../view_model/live_location_view_model.dart';

class LiveLocationViewerScreen extends HookConsumerWidget {
  const LiveLocationViewerScreen({super.key, required this.token});

  final String token;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(liveLocationViewModelProvider(token));
    final notifier = ref.read(liveLocationViewModelProvider(token).notifier);
    final mapController = useMemoized(MapController.new);
    final isMapReady = useState(false);
    final hasCenteredOnLocation = useState(false);

    useEffect(() {
      if (state.location != null &&
          isMapReady.value &&
          !hasCenteredOnLocation.value) {
        hasCenteredOnLocation.value = true;
        final pos = LatLng(state.location!.latitude, state.location!.longitude);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          mapController.move(pos, 15);
        });
      }
      return null;
    }, [state.location, isMapReady.value]);

    final location = state.location;
    final markerPoint = location != null
        ? LatLng(location.latitude, location.longitude)
        : const LatLng(48.8566, 2.3522);

    void closeViewer() {
      final navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.pop();
        return;
      }
      const SettingsRouteData().go(context);
    }

    return Scaffold(
      backgroundColor: GSColors.neutral050,
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: markerPoint,
              initialZoom: 5,
              onMapReady: () => isMapReady.value = true,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.geo_spots',
              ),
              if (location != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: markerPoint,
                      width: 60,
                      height: 60,
                      child: _LiveMarker(ageSeconds: location.ageSeconds),
                    ),
                  ],
                ),
            ],
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(GSSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App bar card
                  GSCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: GSSpacing.l,
                      vertical: GSSpacing.m,
                    ),
                    borderRadius: BorderRadius.circular(GSRadius.l),
                    child: Row(
                      children: [
                        GSBackButton(
                          color: GSColors.neutral900,
                          onPressed: closeViewer,
                        ),
                        const SizedBox(width: GSSpacing.m),
                        const Icon(
                          Icons.share_location,
                          color: GSColors.primary600,
                          size: 20,
                        ),
                        const SizedBox(width: GSSpacing.s),
                        Expanded(
                          child: Text(
                            'Position en temps réel',
                            style: GSTypography.bodyAccentMedium.copyWith(
                              color: GSColors.neutral900,
                            ),
                          ),
                        ),
                        if (!state.isExpired)
                          _LiveBadge(isConnected: state.errorMessage == null),
                      ],
                    ),
                  ),

                  // Error banner
                  if (state.errorMessage != null && !state.isExpired) ...[
                    const SizedBox(height: GSSpacing.m),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: GSSpacing.l,
                        vertical: GSSpacing.m,
                      ),
                      decoration: BoxDecoration(
                        color: GSColors.warning100,
                        borderRadius: BorderRadius.circular(GSRadius.m),
                        border: Border.all(color: GSColors.warning600),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.wifi_off,
                            size: 16,
                            color: GSColors.warning600,
                          ),
                          const SizedBox(width: GSSpacing.s),
                          Expanded(
                            child: Text(
                              state.errorMessage!,
                              style: GSTypography.bodyDefaultSmall.copyWith(
                                color: GSColors.warning600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Loading overlay (first load only)
          if (state.isLoading && location == null)
            ColoredBox(
              color: GSColors.neutral000.withValues(alpha: 0.85),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GSCircularLoader(),
                    SizedBox(height: GSSpacing.l),
                    Text('Récupération de la position...'),
                  ],
                ),
              ),
            ),

          // Expired overlay
          if (state.isExpired)
            ColoredBox(
              color: GSColors.neutral000.withValues(alpha: 0.92),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(GSSpacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(GSSpacing.xl),
                        decoration: BoxDecoration(
                          color: GSColors.neutral100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.link_off,
                          size: 48,
                          color: GSColors.neutral500,
                        ),
                      ),
                      const SizedBox(height: GSSpacing.xl),
                      Text(
                        'Lien expiré',
                        style: GSTypography.headingSmall.copyWith(
                          color: GSColors.neutral900,
                        ),
                      ),
                      const SizedBox(height: GSSpacing.s),
                      Text(
                        'Ce lien de partage n\'est plus actif.',
                        textAlign: TextAlign.center,
                        style: GSTypography.bodyDefaultMedium.copyWith(
                          color: GSColors.neutral600,
                        ),
                      ),
                      const SizedBox(height: GSSpacing.xl),
                      GSOutlinedButton(onPressed: closeViewer, text: 'Retour'),
                    ],
                  ),
                ),
              ),
            ),

          // Bottom info card
          if (location != null)
            Positioned(
              left: GSSpacing.xl,
              right: GSSpacing.xl,
              bottom: GSSpacing.xl + MediaQuery.of(context).padding.bottom,
              child: GSCard(
                padding: const EdgeInsets.all(GSSpacing.l),
                borderRadius: BorderRadius.circular(GSRadius.l),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: GSColors.primary600,
                        ),
                        const SizedBox(width: GSSpacing.s),
                        Expanded(
                          child: Text(
                            '${location.latitude.toStringAsFixed(5)}, '
                            '${location.longitude.toStringAsFixed(5)}',
                            style: GSTypography.bodyDefaultSmall.copyWith(
                              color: GSColors.neutral700,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        if (location.ageSeconds != null)
                          Text(
                            _formatAge(location.ageSeconds!),
                            style: GSTypography.bodyDefaultSmall.copyWith(
                              color: GSColors.neutral500,
                            ),
                          ),
                      ],
                    ),
                    if (location.accuracy != null) ...[
                      const SizedBox(height: GSSpacing.s),
                      Row(
                        children: [
                          const Icon(
                            Icons.gps_fixed,
                            size: 14,
                            color: GSColors.neutral400,
                          ),
                          const SizedBox(width: GSSpacing.xs),
                          Text(
                            'Précision ±${location.accuracy!.toStringAsFixed(0)} m',
                            style: GSTypography.bodyDefaultSmall.copyWith(
                              color: GSColors.neutral500,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              if (isMapReady.value) {
                                mapController.move(markerPoint, 15);
                              }
                            },
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.center_focus_strong,
                                  size: 14,
                                  color: GSColors.primary600,
                                ),
                                const SizedBox(width: GSSpacing.xs),
                                Text(
                                  'Centrer',
                                  style: GSTypography.bodyDefaultSmall.copyWith(
                                    color: GSColors.primary600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

          // Refresh FAB
          if (location != null)
            Positioned(
              right: GSSpacing.xl,
              bottom: 120 + MediaQuery.of(context).padding.bottom,
              child: FloatingActionButton.small(
                onPressed: notifier.refresh,
                backgroundColor: GSColors.neutral000,
                foregroundColor: GSColors.primary600,
                elevation: 2,
                child: const Icon(Icons.refresh, size: 20),
              ),
            ),
        ],
      ),
    );
  }

  String _formatAge(int ageSeconds) {
    if (ageSeconds < 60) return 'Il y a ${ageSeconds}s';
    final minutes = ageSeconds ~/ 60;
    if (minutes < 60) return 'Il y a ${minutes}min';
    return 'Il y a ${minutes ~/ 60}h';
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge({required this.isConnected});

  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GSSpacing.m,
        vertical: GSSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isConnected ? GSColors.success100 : GSColors.warning100,
        borderRadius: BorderRadius.circular(GSRadius.s),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isConnected ? GSColors.success600 : GSColors.warning600,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: GSSpacing.xs),
          Text(
            'LIVE',
            style: GSTypography.bodyAccentSmall.copyWith(
              color: isConnected ? GSColors.success600 : GSColors.warning600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveMarker extends StatefulWidget {
  const _LiveMarker({this.ageSeconds});

  final int? ageSeconds;

  @override
  State<_LiveMarker> createState() => _LiveMarkerState();
}

class _LiveMarkerState extends State<_LiveMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulsing ring
            Transform.scale(
              scale: 1.0 + _controller.value * 1.2,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: GSColors.primary600.withValues(
                    alpha: (1.0 - _controller.value) * 0.3,
                  ),
                ),
              ),
            ),
            // Core dot
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: GSColors.primary600,
                border: Border.all(color: GSColors.neutral000, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: GSColors.primary600.withValues(alpha: 0.4),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
