import 'package:flutter/material.dart';
import 'package:geo_spots/features/places/presentation/route/route_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/design_system/design_system.dart';
import '../../../domain/entity/place_entity.dart';
import '../../view_model/place_details_view_model.dart';
import 'navigation_options_dialog.dart';

class PlaceDetailsActions extends StatelessWidget {
  const PlaceDetailsActions({
    super.key,
    required this.place,
    required this.placeId,
    this.readOnly = false,
  });

  final PlaceEntity place;
  final String placeId;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: GSSpacing.xl),
      child: GSPremiumPanel(
        padding: const EdgeInsets.all(GSSpacing.xl),
        borderColor: GSColors.neutral150,
        child: Column(
          children: [
            _PrimaryActionsRow(
              placeId: placeId,
              place: place,
              readOnly: readOnly,
            ),
            const SizedBox(height: GSSpacing.xl),
            _SecondaryActionsRow(
              placeId: placeId,
              place: place,
              readOnly: readOnly,
            ),
          ],
        ),
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
            icon: Icons.directions_outlined,
            fullWidth: true,
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (context) => NavigationOptionsDialog(place: place),
              );
            },
          ),
        ),
        const SizedBox(width: GSSpacing.l),
        Expanded(
          child: readOnly
              ? GSOutlinedButton(
                  text: 'Lecture seule',
                  icon: Icons.lock_outline,
                  fullWidth: true,
                  onPressed: () {},
                )
              : GSOutlinedButton(
                  text: 'Modifier',
                  icon: Icons.edit_outlined,
                  fullWidth: true,
                  onPressed: () {
                    UpsertPlaceRouteData(placeId: placeId).push<void>(context);
                  },
                ),
        ),
      ],
    );
  }
}

class _SecondaryActionsRow extends ConsumerWidget {
  const _SecondaryActionsRow({
    required this.placeId,
    required this.place,
    required this.readOnly,
  });

  final String placeId;
  final bool readOnly;
  final PlaceEntity place;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.share_outlined,
            label: 'Partager',
            onPressed: () async {
              await ref
                  .read(placeDetailsViewModelProvider(placeId).notifier)
                  .sharePlace();
            },
          ),
        ),
        const SizedBox(width: GSSpacing.s),
        Expanded(
          child: _ActionButton(
            icon: Icons.favorite_border_rounded,
            label: 'Favoris',
            onPressed: () {
              // TODO(dev): Add to favorites.
            },
          ),
        ),
        if (!readOnly) ...[
          const SizedBox(width: GSSpacing.s),
          Expanded(
            child: _ActionButton(
              icon: Icons.delete_outline,
              label: 'Supprimer',
              color: GSColors.danger600,
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => const _DeleteConfirmDialog(),
                );

                if (confirmed ?? false) {
                  final deleted = await ref
                      .read(placeDetailsViewModelProvider(placeId).notifier)
                      .deletePlace();
                  if (deleted && context.mounted) {
                    GSScaffoldSnackbar.showSuccess(
                      context,
                      message: 'Lieu supprimé',
                    );
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? GSColors.neutral700;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(GSRadius.l),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: GSSpacing.l,
            vertical: GSSpacing.xl,
          ),
          decoration: BoxDecoration(
            color: GSColors.neutral050,
            borderRadius: BorderRadius.circular(GSRadius.l),
            border: Border.all(
              color: color == null ? GSColors.neutral150 : GSColors.danger200,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: effectiveColor, size: 24),
              const SizedBox(height: GSSpacing.s),
              Text(
                label,
                style: GSTypography.captionDefault.copyWith(
                  color: effectiveColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GSRadius.l),
      ),
      title: Text(
        'Supprimer ce lieu ?',
        style: GSTypography.headingSmall.copyWith(color: GSColors.neutral900),
      ),
      content: Text(
        'Cette action est irréversible.',
        style: GSTypography.bodyDefaultMedium.copyWith(
          color: GSColors.neutral700,
        ),
      ),
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
