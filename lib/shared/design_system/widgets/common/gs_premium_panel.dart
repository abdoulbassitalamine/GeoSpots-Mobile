import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/shadows.dart';
import '../../theme/spacing.dart';

class GSPremiumPanel extends StatelessWidget {
  const GSPremiumPanel({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.gradient,
    this.borderColor,
    this.borderRadius,
    this.onTap,
    this.shadows,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(GSRadius.l);
    final panel = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(GSSpacing.xl),
      decoration: BoxDecoration(
        color: gradient == null ? backgroundColor ?? GSColors.neutral000 : null,
        gradient: gradient,
        borderRadius: radius,
        border: Border.all(
          color:
              borderColor ??
              GSColors.neutral000.withValues(
                alpha: gradient == null ? 0.0 : 0.14,
              ),
        ),
        boxShadow:
            shadows ??
            [
              GSShadows.xs(color: GSColors.neutral1000.withValues(alpha: 0.08)),
              GSShadows.m(color: GSColors.neutral1000.withValues(alpha: 0.08)),
            ],
      ),
      child: child,
    );

    if (onTap == null) {
      return panel;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, borderRadius: radius, child: panel),
    );
  }
}
