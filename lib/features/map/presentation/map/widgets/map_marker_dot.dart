import 'package:flutter/material.dart';

import '../../../../../shared/design_system/design_system.dart';

class MapMarkerDot extends StatelessWidget {
  const MapMarkerDot({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: isSelected ? 38 : 32,
        height: isSelected ? 38 : 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? GSColors.primary600 : GSColors.primary500,
          boxShadow: [GSShadows.s()],
          border: Border.all(color: GSColors.neutral000, width: 2),
        ),
        child: Icon(
          Icons.location_on,
          size: isSelected ? 18 : 16,
          color: GSColors.neutral000,
        ),
      ),
    );
  }
}
