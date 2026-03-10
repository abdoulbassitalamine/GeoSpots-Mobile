part of 'upsert_place_location_step.dart';

class _StepHeader extends StatelessWidget {
  const _StepHeader();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Localisez et catégorisez',
      style: GSTypography.bodyDefaultMedium.copyWith(
        color: GSColors.neutral600,
      ),
    );
  }
}

class _LocationSection extends StatelessWidget {
  const _LocationSection({
    required this.state,
    required this.notifier,
    required this.position,
    required this.isLoading,
    required this.onSetPosition,
    required this.onGetCurrentPosition,
  });

  final UpsertPlaceState state;
  final UpsertPlaceViewModel notifier;
  final LatLng? position;
  final bool isLoading;
  final ValueChanged<LatLng> onSetPosition;
  final VoidCallback onGetCurrentPosition;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Localisation GPS', style: GSTypography.labelDefault),
            Text(
              ' *',
              style: GSTypography.labelDefault.copyWith(
                color: GSColors.danger600,
              ),
            ),
          ],
        ),
        const SizedBox(height: GSSpacing.m),
        _MapDisplay(
          position: position,
          isLoading: isLoading,
          onSetPosition: onSetPosition,
          onGetCurrentPosition: onGetCurrentPosition,
        ),
        const SizedBox(height: GSSpacing.m),
        _ManualCoordinatesInput(state: state, notifier: notifier),
        const SizedBox(height: GSSpacing.m),
        if (position != null) _GpsCoordinatesStatus(position: position!),
      ],
    );
  }
}

class _GpsCoordinatesStatus extends StatelessWidget {
  const _GpsCoordinatesStatus({required this.position});

  final LatLng position;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: GSColors.success600, size: 16),
        const SizedBox(width: GSSpacing.xs),
        Text(
          'GPS : ${position.latitude.toStringAsFixed(4)}° N, ${position.longitude.toStringAsFixed(4)}° E',
          style: GSTypography.captionDefault.copyWith(
            color: GSColors.success600,
          ),
        ),
      ],
    );
  }
}
