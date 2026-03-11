import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../shared/design_system/design_system.dart';

class MapControlButton extends StatelessWidget {
  const MapControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.isPrimary = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isPrimary
        ? GSColors.neutral000.withValues(alpha: 0.92)
        : GSColors.neutral000.withValues(alpha: 0.84);
    final foregroundColor = isPrimary
        ? GSColors.primary700
        : GSColors.primary700;

    return Tooltip(
      message: tooltip ?? '',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(GSRadius.l),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(GSRadius.l),
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(GSRadius.l),
                  border: Border.all(
                    color: isPrimary
                        ? GSColors.primary100
                        : GSColors.neutral000.withValues(alpha: 0.70),
                  ),
                  boxShadow: [
                    GSShadows.s(
                      color: GSColors.neutral1000.withValues(alpha: 0.12),
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: isPrimary ? 30 : 26,
                    height: isPrimary ? 30 : 26,
                    decoration: BoxDecoration(
                      color: isPrimary
                          ? GSColors.primary600
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: isPrimary ? GSColors.neutral000 : foregroundColor,
                      size: isPrimary ? 18 : 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
