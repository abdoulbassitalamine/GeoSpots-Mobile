import 'package:flutter/material.dart';
import '../../theme/spacing.dart';
import '../../tokens/color_tokens.dart';

/// Size variants for dividers
class GSDividerSize {
  const GSDividerSize._({required this.thickness});

  factory GSDividerSize.small() => const GSDividerSize._(thickness: 1);
  factory GSDividerSize.medium() => const GSDividerSize._(thickness: 2);
  factory GSDividerSize.large() => const GSDividerSize._(thickness: 8);
  factory GSDividerSize.custom(double thickness) => GSDividerSize._(thickness: thickness);

  final double thickness;
}

/// Color variants for dividers (for compatibility with old system)
class GSDividerColors {
  GSDividerColors._({required this.borderColor});

  /// Primary divider color
  factory GSDividerColors.primaryColors(
      BuildContext context, {
        Color? borderColor,
      }) =>
      GSDividerColors._(
        borderColor: borderColor ?? GSColorTokens.dividerPrimary,
      );

  /// Secondary divider color
  factory GSDividerColors.secondaryColors(
      BuildContext context, {
        Color? borderColor,
      }) =>
      GSDividerColors._(
        borderColor: borderColor ?? GSColorTokens.dividerSecondary,
      );

  /// Tertiary divider color
  factory GSDividerColors.tertiaryColors(
      BuildContext context, {
        Color? borderColor,
      }) =>
      GSDividerColors._(
        borderColor: borderColor ?? GSColorTokens.dividerTertiary,
      );

  /// Inverse divider color
  factory GSDividerColors.inverseColors(
      BuildContext context, {
        Color? borderColor,
      }) =>
      GSDividerColors._(
        borderColor: borderColor ?? GSColorTokens.dividerInverse,
      );

  final Color borderColor;
}

/// Divider widget (horizontal or vertical)
class GSDivider extends StatelessWidget {
  /// Horizontal divider
  const GSDivider.horizontal({
    super.key,
    this.color,
    this.size,
    this.indent,
    this.endIndent,
    this.height,
  }) : isVertical = false;

  /// Vertical divider
  const GSDivider.vertical({
    super.key,
    this.color,
    this.size,
    this.indent,
    this.endIndent,
    this.height,
  }) : isVertical = true;

  final dynamic color; // Can be Color or GSDividerColors
  final GSDividerSize? size;
  final double? indent;
  final double? endIndent;
  final double? height;
  final bool isVertical;

  double get _thickness {
    return size?.thickness ?? 1.0;
  }

  double get _indent {
    return indent ?? GSSpacing.m;
  }

  double get _endIndent {
    return endIndent ?? GSSpacing.m;
  }

  Color _getColor() {
    if (color is GSDividerColors) {
      return (color as GSDividerColors).borderColor;
    }
    if (color is Color) {
      return color as Color;
    }
    return GSColorTokens.dividerPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final dividerColor = _getColor();

    return isVertical
        ? VerticalDivider(
      thickness: _thickness,
      color: dividerColor,
      indent: _indent,
      endIndent: _endIndent,
      width: height ?? (_thickness + GSSpacing.none),
    )
        : Divider(
      thickness: _thickness,
      color: dividerColor,
      indent: _indent,
      endIndent: _endIndent,
      height: height ?? (_thickness + GSSpacing.none),
    );
  }
}