import 'package:flutter/material.dart';
import 'package:geo_spots/features/places/domain/services/share_service.dart';
import 'package:geo_spots/features/places/presentation/route/route_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../domain/entity/place_entity.dart';
import '../../view_model/place_details_view_model.dart';
import 'navigation_options_dialog.dart';

class PlaceDetailsActions extends StatelessWidget {
  final PlaceEntity place;
  final String placeId;
  final bool readOnly;

  const PlaceDetailsActions({
    super.key,
    required this.place,
    required this.placeId,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: GSSpacing.xl),
      child: Column(
        children: [
          _PrimaryActionsRow(placeId: placeId, place: place, readOnly: readOnly),
          const SizedBox(height: GSSpacing.l),
          _SecondaryActionsRow(placeId: placeId, place: place, readOnly: readOnly),
        ],
      ),
    );
  }
}

class _PrimaryActionsRow extends StatelessWidget {
  const _PrimaryActionsRow({
    required this.placeId,
    required this.place,
    required this.readOnly,
  });
  final String placeId;
  final PlaceEntity place;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GSFilledButton(
            text: 'Itinéraire',
            icon: Icons.directions,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => NavigationOptionsDialog(place: place),
              );
            },
          ),
        ),
        const SizedBox(width: GSSpacing.l),
        if (!readOnly)
          Expanded(
            child: GSOutlinedButton(
              text: 'Modifier',
              icon: Icons.edit,
              onPressed: () {
                UpsertPlaceRouteData(placeId: placeId).push(context);
              },
            ),
          )
        else
          Expanded(
            child: GSOutlinedButton(
              text: 'Lecture seule',
              icon: Icons.lock_outline,
              onPressed: () {},
            ),
          ),
      ],
    );
  }
}

class _SecondaryActionsRow extends ConsumerWidget {
  final String placeId;
  final bool readOnly;

  const _SecondaryActionsRow({
    required this.placeId,
    required this.place,
    required this.readOnly,
  });

  final PlaceEntity place;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionButton(
          icon: Icons.share,
          label: 'Partager',
          onPressed: () async {
            await ref
                .read(shareServiceProvider)
                .sharePlaceWithCoordinates(place);
          },
        ),
        _ActionButton(
          icon: Icons.favorite_border,
          label: 'Favoris',
          onPressed: () {
            // TODO: Ajouter aux favoris
          },
        ),
        if (!readOnly)
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
