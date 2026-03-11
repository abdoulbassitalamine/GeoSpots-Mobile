part of 'upsert_place_location_step.dart';

class _MapDisplay extends HookWidget {
  const _MapDisplay({
    required this.position,
    required this.isLoading,
    required this.onSetPosition,
    required this.onGetCurrentPosition,
  });

  final LatLng? position;
  final bool isLoading;
  final ValueChanged<LatLng> onSetPosition;
  final VoidCallback onGetCurrentPosition;

  @override
  Widget build(BuildContext context) {
    final mapController = useMemoized(MapController.new);
    final isMapReady = useState(false);

    useEffect(() {
      if (isMapReady.value && position != null) {
        // Keep marker visible when coordinates change from manual inputs or GPS.
        mapController.move(position!, mapController.camera.zoom);
      }
      return null;
    }, [isMapReady.value, position?.latitude, position?.longitude]);

    if (isLoading) {
      return Container(
        height: 280,
        decoration: BoxDecoration(
          color: GSColors.neutral100,
          borderRadius: BorderRadius.circular(GSRadius.m),
        ),
        child: const Center(child: GSCircularLoader()),
      );
    }

    final center = position ?? LatLng(48.8566, 2.3522);

    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(GSRadius.m),
        border: Border.all(color: GSColors.neutral300),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: 15,
              onMapReady: () {
                isMapReady.value = true;
              },
              onTap: (_, pos) => onSetPosition(pos),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.geo_spots',
              ),
              if (position != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: position!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: GSColors.danger600,
                        size: 40,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            right: GSSpacing.l,
            bottom: GSSpacing.l,
            child: GSFilledButton(
              onPressed: () {
                // Ensure manual fields can sync with GPS values immediately.
                FocusScope.of(context).unfocus();
                onGetCurrentPosition();
              },
              text: 'Ma position',
              icon: Icons.my_location,
              padding: const EdgeInsets.symmetric(
                horizontal: GSSpacing.xl,
                vertical: GSSpacing.m,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
