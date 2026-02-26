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
          icon: Icons.navigation,
          tooltip: 'Centrer',
          onPressed: onCenterTap,
        ),
        const SizedBox(height: GSSpacing.m),
        MapControlButton(
          icon: Icons.add,
          tooltip: 'Zoom +',
          onPressed: onZoomInTap,
        ),
        const SizedBox(height: GSSpacing.m),
        MapControlButton(
          icon: Icons.remove,
          tooltip: 'Zoom -',
          onPressed: onZoomOutTap,
        ),
      ],
    );
  }
}
