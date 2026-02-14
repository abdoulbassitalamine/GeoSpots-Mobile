import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geo_spots/core/utils/utils/debounce.dart';
import 'package:geo_spots/features/places/presentation/view_model/upsert_place_state.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../../shared/design_system/design_system.dart';
import '../../view_model/upsert_place_view_model.dart';

class UpsertPlaceLocationStepView extends HookWidget {
  const UpsertPlaceLocationStepView({
    super.key,
    required this.state,
    required this.notifier,
  });

  final UpsertPlaceState state;
  final UpsertPlaceViewModel notifier;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (state.position == null && !state.isLoading && state.isCreateMode) {
          notifier.getCurrentPosition();
        }
      });
      return null;
    }, const []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(),
        const SizedBox(height: GSSpacing.xl3),
        _LocationSection(
          position: state.position,
          isLoading: state.isLoading,
          onSetPosition: notifier.setPosition,
          onGetCurrentPosition: notifier.getCurrentPosition,
        ),
        const SizedBox(height: GSSpacing.xl3),
        _TagsSection(
          tags: state.tags,
          onTagsChanged: (newTags) {
            notifier.updateState(state.copyWith(tags: newTags));
          },
        ),
      ],
    );
  }
}

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
    required this.position,
    required this.isLoading,
    required this.onSetPosition,
    required this.onGetCurrentPosition,
  });

  final LatLng? position;
  final bool isLoading;
  final Function(LatLng) onSetPosition;
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
        _ManualCoordinatesInput(
          position: position,
          onSetPosition: onSetPosition,
        ),
        const SizedBox(height: GSSpacing.m),
        if (position != null) _GpsCoordinatesStatus(position: position!),
      ],
    );
  }
}

class _ManualCoordinatesInput extends HookWidget {
  const _ManualCoordinatesInput({
    required this.position,
    required this.onSetPosition,
  });

  final LatLng? position;
  final Function(LatLng) onSetPosition;

  @override
  Widget build(BuildContext context) {
    final debouncer = useMemoized(() => Debouncer(milliseconds: 450));
    final latitudeController = useTextEditingController();
    final longitudeController = useTextEditingController();
    final latitudeError = useState<String?>(null);
    final longitudeError = useState<String?>(null);

    useEffect(() {
      if (position == null) {
        return null;
      }

      final nextLat = position!.latitude.toStringAsFixed(6);
      final nextLon = position!.longitude.toStringAsFixed(6);

      if (latitudeController.text != nextLat) {
        latitudeController.text = nextLat;
      }
      if (longitudeController.text != nextLon) {
        longitudeController.text = nextLon;
      }

      return null;
    }, [position?.latitude, position?.longitude]);

    void applyManualCoordinates() {
      final hasLatitude = latitudeController.text.trim().isNotEmpty;
      final hasLongitude = longitudeController.text.trim().isNotEmpty;

      if (!hasLatitude || !hasLongitude) {
        latitudeError.value = null;
        longitudeError.value = null;
        return;
      }

      final lat = _parseCoordinate(latitudeController.text);
      final lon = _parseCoordinate(longitudeController.text);

      latitudeError.value = _latitudeErrorMessage(lat);
      longitudeError.value = _longitudeErrorMessage(lon);

      if (latitudeError.value == null &&
          longitudeError.value == null &&
          lat != null &&
          lon != null) {
        onSetPosition(LatLng(lat, lon));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Saisie manuelle des coordonnees', style: GSTypography.labelDefault),
        const SizedBox(height: GSSpacing.s),
        Text(
          'Entrez latitude et longitude si vous ne souhaitez pas utiliser le GPS.',
          style: GSTypography.captionDefault.copyWith(
            color: GSColors.neutral600,
          ),
        ),
        const SizedBox(height: GSSpacing.m),
        Row(
          children: [
            Expanded(
              child: GSTextField(
                controller: latitudeController,
                label: 'Latitude',
                placeholder: 'Ex: 48.8566',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                error: latitudeError.value,
                onValueChange: (_) => debouncer.run(applyManualCoordinates),
                onSubmitted: (_) => applyManualCoordinates(),
              ),
            ),
            const SizedBox(width: GSSpacing.m),
            Expanded(
              child: GSTextField(
                controller: longitudeController,
                label: 'Longitude',
                placeholder: 'Ex: 2.3522',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                error: longitudeError.value,
                onValueChange: (_) => debouncer.run(applyManualCoordinates),
                onSubmitted: (_) => applyManualCoordinates(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static double? _parseCoordinate(String raw) {
    final cleaned = raw.trim().replaceAll(',', '.');
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  static String? _latitudeErrorMessage(double? value) {
    if (value == null) return 'Latitude invalide';
    if (value < -90 || value > 90) return 'Entre -90 et 90';
    return null;
  }

  static String? _longitudeErrorMessage(double? value) {
    if (value == null) return 'Longitude invalide';
    if (value < -180 || value > 180) return 'Entre -180 et 180';
    return null;
  }
}

class _MapDisplay extends StatelessWidget {
  const _MapDisplay({
    required this.position,
    required this.isLoading,
    required this.onSetPosition,
    required this.onGetCurrentPosition,
  });

  final LatLng? position;
  final bool isLoading;
  final Function(LatLng) onSetPosition;
  final VoidCallback onGetCurrentPosition;

  @override
  Widget build(BuildContext context) {
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
            options: MapOptions(
              initialCenter: center,
              initialZoom: 15,
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
              onPressed: onGetCurrentPosition,
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

class _TagsSection extends HookWidget {
  const _TagsSection({required this.tags, required this.onTagsChanged});

  final List<String> tags;
  final Function(List<String>) onTagsChanged;

  @override
  Widget build(BuildContext context) {
    final tagController = useTextEditingController();

    void onAddTag() {
      final v = tagController.text.trim();
      if (v.isEmpty) return;
      onTagsChanged([...tags, v]);
      tagController.clear();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Étiquettes (tags)', style: GSTypography.labelDefault),
        const SizedBox(height: GSSpacing.m),
        if (tags.isNotEmpty) ...[
          Wrap(
            spacing: GSSpacing.s,
            runSpacing: GSSpacing.s,
            children: tags
                .map(
                  (tag) => _TagChip(
                    tag: tag,
                    onRemove: () =>
                        onTagsChanged(tags.where((t) => t != tag).toList()),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: GSSpacing.m),
        ],
        Row(
          children: [
            Expanded(
              child: GSTextField(
                controller: tagController,
                placeholder: 'Ajouter une étiquette...',
                onSubmitted: (_) => onAddTag(),
              ),
            ),
            const SizedBox(width: GSSpacing.m),
            GSIconButton(icon: Icons.add, onPressed: onAddTag),
          ],
        ),
        const SizedBox(height: GSSpacing.m),
        const _TagsInfoRow(),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.tag, required this.onRemove});

  final String tag;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GSSpacing.l,
        vertical: GSSpacing.s,
      ),
      decoration: BoxDecoration(
        color: GSColors.primary100,
        borderRadius: BorderRadius.circular(GSRadius.full),
        border: Border.all(color: GSColors.primary600),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: GSTypography.bodyDefaultSmall.copyWith(
              color: GSColors.primary600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: GSSpacing.xs),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 16,
              color: GSColors.primary600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagsInfoRow extends StatelessWidget {
  const _TagsInfoRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.info_outline, size: 16, color: GSColors.neutral500),
        const SizedBox(width: GSSpacing.xs),
        Expanded(
          child: Text(
            'Les étiquettes créent automatiquement des collections',
            style: GSTypography.captionDefault.copyWith(
              color: GSColors.neutral500,
            ),
          ),
        ),
      ],
    );
  }
}
