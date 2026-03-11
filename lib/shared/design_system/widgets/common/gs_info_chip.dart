import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class GSInfoChip extends StatelessWidget {
  const GSInfoChip({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.padding,
  });

  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final textColor = foregroundColor ?? GSColors.neutral700;

    return Container(
      padding:
          padding ??
          const EdgeInsets.symmetric(
            horizontal: GSSpacing.l,
            vertical: GSSpacing.s,
          ),
      decoration: BoxDecoration(
        color: backgroundColor ?? GSColors.neutral100,
        borderRadius: BorderRadius.circular(GSRadius.full),
        border: Border.all(
          color:
              borderColor ??
              backgroundColor?.withValues(alpha: 0.6) ??
              GSColors.neutral200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: GSSpacing.xs),
          ],
          Text(
            label,
            style: GSTypography.captionDefault.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
