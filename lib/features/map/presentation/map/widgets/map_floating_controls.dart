import 'package:flutter/material.dart';

import '../../../../../shared/design_system/design_system.dart';
import 'map_control_button.dart';

class MapFloatingControls extends StatelessWidget {
  const MapFloatingControls({
    super.key,
    required this.onCenterTap,
    required this.onZoomInTap,
    required this.onZoomOutTap,
  });

  final VoidCallback onCenterTap;
  final VoidCallback onZoomInTap;
  final VoidCallback onZoomOutTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MapControlButton(
          icon: Icons.my_location_rounded,
          tooltip: 'Centrer',
          onPressed: onCenterTap,
          isPrimary: true,
        ),
        const SizedBox(height: GSSpacing.m),
        MapControlButton(
          icon: Icons.add_rounded,
          tooltip: 'Zoom +',
          onPressed: onZoomInTap,
        ),
        const SizedBox(height: GSSpacing.m),
        MapControlButton(
          icon: Icons.remove_rounded,
          tooltip: 'Zoom -',
          onPressed: onZoomOutTap,
        ),
      ],
    );
  }
}
