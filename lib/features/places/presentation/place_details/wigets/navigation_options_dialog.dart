import 'package:flutter/material.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:geo_spots/features/places/domain/services/navigation_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/design_system/design_system.dart';

class NavigationOptionsDialog extends ConsumerWidget {

  const NavigationOptionsDialog({super.key, required this.place});
  final PlaceEntity place;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationService = ref.read(navigationServiceProvider);

    return AlertDialog(
      title: Text('Ouvrir avec', style: GSTypography.headingSmall),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _NavigationOption(
            icon: Icons.map,
            label: 'Google Maps',
            onTap: () async {
              Navigator.of(context).pop();
              await navigationService.openInGoogleMaps(place);
            },
          ),
          const SizedBox(height: GSSpacing.m),
          _NavigationOption(
            icon: Icons.navigation,
            label: 'Waze',
            onTap: () async {
              Navigator.of(context).pop();
              await navigationService.openInWaze(place);
            },
          ),
          const SizedBox(height: GSSpacing.m),
          _NavigationOption(
            icon: Icons.apple,
            label: 'Apple Maps',
            onTap: () async {
              Navigator.of(context).pop();
              await navigationService.openInAppleMaps(place);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}

class _NavigationOption extends StatelessWidget {

  const _NavigationOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GSCard(
      onTap: onTap,
      padding: const EdgeInsets.all(GSSpacing.l),
      child: Row(
        children: [
          Icon(icon, color: GSColors.primary600),
          const SizedBox(width: GSSpacing.l),
          Text(label, style: GSTypography.bodyDefaultMedium),
        ],
      ),
    );
  }
}
