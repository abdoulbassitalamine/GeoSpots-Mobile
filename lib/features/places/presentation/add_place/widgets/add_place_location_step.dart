import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../../shared/design_system/design_system.dart';
import '../../view_model/add_place_view_model.dart';

class AddPlaceLocationStepView extends HookConsumerWidget {
  const AddPlaceLocationStepView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final current = ref.read(addPlaceViewModelProvider);
        if (current.position == null && !current.isLoading) {
          ref.read(addPlaceViewModelProvider.notifier).getCurrentPosition();
        }
      });
      return null;
    }, const []);

    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(),
        SizedBox(height: GSSpacing.xl3),
        _LocationSection(),
        SizedBox(height: GSSpacing.xl3),
        _TagsSection(),
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

class _LocationSection extends ConsumerWidget {
  const _LocationSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addPlaceViewModelProvider);
    final notifier = ref.read(addPlaceViewModelProvider.notifier);

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
        _MapDisplay(state: state, notifier: notifier),
        const SizedBox(height: GSSpacing.m),
        if (state.position != null)
          _GpsCoordinatesStatus(position: state.position!),
      ],
    );
  }
}

class _MapDisplay extends StatelessWidget {
  final dynamic state;
  final AddPlaceViewModel notifier;

  const _MapDisplay({required this.state, required this.notifier});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return Container(
        height: 280,
        decoration: BoxDecoration(
          color: GSColors.neutral100,
          borderRadius: BorderRadius.circular(GSRadius.m),
        ),
        child: const Center(child: GSCircularLoader()),
      );
    }

    final center = state.position ?? LatLng(48.8566, 2.3522);

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
              onTap: (_, position) => notifier.setPosition(position),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.geo_spots',
              ),
              if (state.position != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: state.position!,
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
              onPressed: notifier.getCurrentPosition,
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
  final LatLng position;

  const _GpsCoordinatesStatus({required this.position});

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

class _TagsSection extends HookConsumerWidget {
  const _TagsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addPlaceViewModelProvider);
    final notifier = ref.read(addPlaceViewModelProvider.notifier);
    final tagController = useTextEditingController();

    void onAddTag() {
      final v = tagController.text.trim();
      if (v.isEmpty) return;
      final updated = state.copyWith(tags: [...state.tags, v]);
      notifier.updateState(updated);
      tagController.clear();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Étiquettes (tags)', style: GSTypography.labelDefault),
        const SizedBox(height: GSSpacing.m),
        if (state.tags.isNotEmpty) ...[
          Wrap(
            spacing: GSSpacing.s,
            runSpacing: GSSpacing.s,
            children: state.tags.map((tag) => _TagChip(tag: tag)).toList(),
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

class _TagChip extends ConsumerWidget {
  final String tag;

  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(addPlaceViewModelProvider.notifier);

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
            onTap: () {
              final current = notifier.state;
              final updated = current.copyWith(
                tags: current.tags.where((t) => t != tag).toList(),
              );
              notifier.updateState(updated);
            },
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
