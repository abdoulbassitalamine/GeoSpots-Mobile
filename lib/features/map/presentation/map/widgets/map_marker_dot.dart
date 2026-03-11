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
        width: isSelected ? 42 : 34,
        height: isSelected ? 42 : 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [GSColors.primary500, GSColors.primary700]
                : [GSColors.primary400, GSColors.primary600],
          ),
          boxShadow: [
            GSShadows.s(color: GSColors.primary900.withValues(alpha: 0.28)),
          ],
          border: Border.all(
            color: GSColors.neutral000,
            width: isSelected ? 3 : 2,
          ),
        ),
        child: Icon(
          Icons.location_on,
          size: isSelected ? 20 : 16,
          color: GSColors.neutral000,
        ),
      ),
    );
  }
}
