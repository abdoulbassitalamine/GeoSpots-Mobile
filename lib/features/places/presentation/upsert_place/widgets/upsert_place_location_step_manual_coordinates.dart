part of 'upsert_place_location_step.dart';

class _ManualCoordinatesInput extends HookWidget {
  const _ManualCoordinatesInput({required this.state, required this.notifier});

  final UpsertPlaceState state;
  final UpsertPlaceViewModel notifier;

  @override
  Widget build(BuildContext context) {
    final debouncer = useMemoized(() => Debouncer(milliseconds: 450));
    final latitudeController = useTextEditingController();
    final longitudeController = useTextEditingController();
    final latitudeFocusNode = useFocusNode();
    final longitudeFocusNode = useFocusNode();

    useEffect(() => debouncer.dispose, [debouncer]);

    useEffect(
      () {
        // Avoid overriding the user's typing while a coordinate field is focused.
        if (latitudeFocusNode.hasFocus || longitudeFocusNode.hasFocus) {
          return null;
        }

        final nextLat = state.manualLatitude;
        final nextLon = state.manualLongitude;

        if (latitudeController.text != nextLat) {
          latitudeController.text = nextLat;
        }
        if (longitudeController.text != nextLon) {
          longitudeController.text = nextLon;
        }

        return null;
      },
      [
        state.manualLatitude,
        state.manualLongitude,
        latitudeFocusNode.hasFocus,
        longitudeFocusNode.hasFocus,
      ],
    );

    void applyManualCoordinates() {
      if (!context.mounted) return;
      notifier.updateManualCoordinates(
        latitude: latitudeController.text,
        longitude: longitudeController.text,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saisie manuelle des coordonnees',
          style: GSTypography.labelDefault,
        ),
        const SizedBox(height: GSSpacing.s),
        Text(
          'Entrez latitude et longitude si vous ne souhaitez pas utiliser le GPS.',
          style: GSTypography.captionDefault.copyWith(
            color: GSColors.neutral600,
          ),
        ),
        const SizedBox(height: GSSpacing.m),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GSTextField(
                controller: latitudeController,
                focusNode: latitudeFocusNode,
                label: 'Latitude',
                placeholder: 'Ex: 48.8566',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                error: notifier.latitudeError,
                onValueChange: (_) => debouncer.run(applyManualCoordinates),
                onSubmitted: (_) => applyManualCoordinates(),
              ),
            ),
            const SizedBox(width: GSSpacing.m),
            Expanded(
              child: GSTextField(
                controller: longitudeController,
                focusNode: longitudeFocusNode,
                label: 'Longitude',
                placeholder: 'Ex: 2.3522',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                error: notifier.longitudeError,
                onValueChange: (_) => debouncer.run(applyManualCoordinates),
                onSubmitted: (_) => applyManualCoordinates(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
