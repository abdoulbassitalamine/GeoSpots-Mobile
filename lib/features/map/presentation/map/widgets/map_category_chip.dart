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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(GSRadius.l),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: GSSpacing.l,
          vertical: GSSpacing.m,
        ),
        decoration: BoxDecoration(
          color: isSelected ? GSColors.primary500 : GSColors.neutral050,
          borderRadius: BorderRadius.circular(GSRadius.l),
          border: Border.all(
            color: isSelected ? GSColors.primary500 : GSColors.neutral300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? GSColors.neutral000 : GSColors.neutral700,
            ),
            const SizedBox(width: GSSpacing.s),
            Text(
              label,
              style: GSTypography.bodyAccentSmall.copyWith(
                color: isSelected ? GSColors.neutral000 : GSColors.neutral700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
