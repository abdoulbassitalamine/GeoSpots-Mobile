import 'package:flutter/material.dart';

import '../../../../../shared/design_system/design_system.dart';

class MapControlButton extends StatelessWidget {
  const MapControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return GSCard(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(GSRadius.l),
      shadows: [GSShadows.s()],
      child: SizedBox(
        width: 48,
        height: 48,
        child: GSIconButton(
          icon: icon,
          tooltip: tooltip,
          color: GSColors.primary600,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
