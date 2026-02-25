import 'package:flutter/material.dart';

import '../../theme/shadows.dart';
import '../../theme/spacing.dart';
import '../../tokens/color_tokens.dart';
import '../../tokens/spacing_tokens.dart';

class GSCard extends StatelessWidget {
  const GSCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation = 0,
    this.borderRadius,
    this.border,
    this.onTap,
    this.shadows,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double elevation;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      padding: padding ??
          const EdgeInsets.all(GSSpacingTokens.cardPaddingHorizontal),
      decoration: BoxDecoration(
        color: color ?? GSColorTokens.cardBackground,
        borderRadius: borderRadius ?? BorderRadius.circular(GSRadius.m),
        border: border,
        boxShadow: shadows ??
            (elevation > 0
                ? [
              GSShadows.s(),
            ]
                : null),
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(GSRadius.m),
        child: card,
      );
    }

    return card;
  }
}
