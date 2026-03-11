import 'package:flutter/material.dart';

import '../../../../../shared/design_system/design_system.dart';

class MapCategoryChip extends StatelessWidget {
  const MapCategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? GSColors.primary600
        : GSColors.neutral000.withValues(alpha: 0.82);
    final foregroundColor = isSelected
        ? GSColors.neutral000
        : GSColors.neutral700;
    final iconBackground = isSelected
        ? GSColors.neutral000.withValues(alpha: 0.18)
        : GSColors.primary50;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(GSRadius.full),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: GSSpacing.m,
          vertical: GSSpacing.s,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(GSRadius.full),
          border: Border.all(
            color: isSelected ? GSColors.primary700 : GSColors.neutral150,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(GSRadius.full),
              ),
              child: Icon(icon, size: 14, color: foregroundColor),
            ),
            const SizedBox(width: GSSpacing.s),
            Text(
              label,
              style: GSTypography.bodyAccentSmall.copyWith(
                color: foregroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
