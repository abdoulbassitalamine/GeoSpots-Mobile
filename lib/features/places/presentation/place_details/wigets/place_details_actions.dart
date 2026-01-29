import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geo_spots/core/router/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../../../shared/services/place_external_links.dart';
import '../../../domain/entity/place_entity.dart';
import '../../view_model/place_details_view_model.dart';

class PlaceDetailsActions extends StatelessWidget {
  final PlaceEntity place;
  final String placeId;

  const PlaceDetailsActions({
    super.key,
    required this.place,
    required this.placeId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: GSSpacing.xl),
      child: Column(
        children: [
          _PrimaryActionsRow(placeId: placeId, place: place),
          const SizedBox(height: GSSpacing.l),
          _SecondaryActionsRow(placeId: placeId, place: place),
        ],
      ),
    );
  }
}

class _PrimaryActionsRow extends StatelessWidget {
  const _PrimaryActionsRow({required this.placeId, required this.place});
  final String placeId;
  final PlaceEntity place;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GSFilledButton(
            text: 'Itinéraire',
            icon: Icons.directions,
            onPressed: () async => _openMapAppPicker(context, place),
          ),
        ),
        const SizedBox(width: GSSpacing.l),
        Expanded(
          child: GSOutlinedButton(
            text: 'Modifier',
            icon: Icons.edit,
            onPressed: () {
              context.pushNamed(
                RouteNames.upsertPlaceName,
                pathParameters: {RouteNames.placeIdParam: placeId},
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SecondaryActionsRow extends ConsumerWidget {
  final String placeId;
  final PlaceEntity place;

  const _SecondaryActionsRow({required this.placeId, required this.place});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final links = PlaceExternalLinks();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionButton(
          icon: Icons.share,
          label: 'Partager',
          onPressed: () async {
            final shareText = links.buildShareText(place);
            await SharePlus.instance.share(
              ShareParams(text: shareText),
            );
          },
        ),
        _ActionButton(
          icon: Icons.open_in_new,
          label: 'Ouvrir',
          onPressed: () async => _openMapAppPicker(context, place),
        ),
        _ActionButton(
          icon: Icons.favorite_border,
          label: 'Favoris',
          onPressed: () {
            // TODO: Ajouter aux favoris
          },
        ),
        _ActionButton(
          icon: Icons.delete_outline,
          label: 'Supprimer',
          color: GSColors.danger600,
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => const _DeleteConfirmDialog(),
            );

            if (confirmed == true) {
              await ref
                  .read(placeDetailsViewModelProvider(placeId).notifier)
                  .deletePlace();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            }
          },
        ),
      ],
    );
  }
}

Future<void> _openMapAppPicker(BuildContext context, PlaceEntity place) async {
  final links = PlaceExternalLinks();
  final apps = _resolveMapApps();
  final selected = await showModalBottomSheet<PlaceMapApp>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: GSSpacing.s),
            Text(
              'Ouvrir avec',
              style: GSTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: GSSpacing.s),
            ...apps.map(
              (option) => ListTile(
                leading: Icon(option.icon, color: GSColors.neutral700),
                title: Text(option.label),
                onTap: () => Navigator.of(context).pop(option.app),
              ),
            ),
            const SizedBox(height: GSSpacing.s),
          ],
        ),
      );
    },
  );

  if (selected == null) return;

  final handled = await links.launchMapApp(selected, place);
  if (!context.mounted) return;
  if (!handled) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: 'Impossible d’ouvrir une autre application.',
      ),
      snackBarPosition: SnackBarPosition.bottom,
    );
  }
}

List<_MapAppOption> _resolveMapApps() {
  final options = <_MapAppOption>[
    const _MapAppOption(
      app: PlaceMapApp.googleMaps,
      label: 'Google Maps',
      icon: Icons.map,
    ),
    const _MapAppOption(
      app: PlaceMapApp.waze,
      label: 'Waze',
      icon: Icons.directions_car,
    ),
  ];

  if (defaultTargetPlatform == TargetPlatform.iOS) {
    options.insert(
      0,
      const _MapAppOption(
        app: PlaceMapApp.appleMaps,
        label: 'Apple Plans',
        icon: Icons.map_outlined,
      ),
    );
  }

  return options;
}

class _MapAppOption {
  const _MapAppOption({
    required this.app,
    required this.label,
    required this.icon,
  });

  final PlaceMapApp app;
  final String label;
  final IconData icon;
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? GSColors.neutral700;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(GSRadius.m),
      child: Padding(
        padding: const EdgeInsets.all(GSSpacing.m),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: effectiveColor, size: 28),
            const SizedBox(height: GSSpacing.xs),
            Text(
              label,
              style: GSTypography.captionDefault.copyWith(
                color: effectiveColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteConfirmDialog extends StatelessWidget {
  const _DeleteConfirmDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Supprimer ce lieu ?'),
      content: const Text('Cette action est irréversible.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: GSColors.danger600),
          child: const Text('Supprimer'),
        ),
      ],
    );
  }
}
