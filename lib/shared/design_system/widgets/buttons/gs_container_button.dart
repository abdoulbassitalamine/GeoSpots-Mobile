import 'package:flutter/material.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../tokens/color_tokens.dart';

class GSContainerButton extends StatelessWidget {
  const GSContainerButton._({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    required this.text,
    this.backgroundColor,
    required this.textColor,
    this.gradient,
    this.radius = GSRadius.s,
    this.enabled = true,
    this.padding,
    this.fontSize,
    this.border,
    this.icon,
    this.iconSize,
    this.spacing,
  });

  factory GSContainerButton.filled({
    Key? key,
    required VoidCallback onPressed,
    bool isLoading = false,
    required String text,
    Color? color,
    Color? textColor,
    Gradient? gradient,
    double radius = GSRadius.s,
    bool enabled = true,
    EdgeInsetsGeometry? padding,
    double? fontSize,
    IconData? icon,
    double? iconSize,
    double? spacing,
  }) {
    final hasGradient = gradient != null && enabled;

    return GSContainerButton._(
      key: key,
      onPressed: onPressed,
      isLoading: isLoading,
      text: text,
      radius: radius,
      enabled: enabled,
      padding: padding,
      fontSize: fontSize,
      icon: icon,
      iconSize: iconSize,
      spacing: spacing,
      gradient: hasGradient ? gradient : null,
      backgroundColor: hasGradient
          ? null
          : !enabled
          ? GSColorTokens.backgroundDisabled
          : color ?? GSColorTokens.backgroundAccent,
      textColor: !enabled
          ? GSColorTokens.textDisabled
          : textColor ?? GSColorTokens.textInverse,
    );
  }

  factory GSContainerButton.outline({
    Key? key,
    required VoidCallback onPressed,
    bool isLoading = false,
    required String text,
    Color? color,
    Color? textColor,
    double radius = GSRadius.s,
    bool enabled = true,
    EdgeInsetsGeometry? padding,
    double? fontSize,
    double borderWidth = 1.5,
    IconData? icon,
    double? iconSize,
    double? spacing,
  }) {
    final borderColor = !enabled
        ? GSColorTokens.borderPrimary
        : color ?? GSColorTokens.textAccent;

    return GSContainerButton._(
      key: key,
      onPressed: onPressed,
      isLoading: isLoading,
      text: text,
      radius: radius,
      enabled: enabled,
      padding: padding,
      fontSize: fontSize,
      icon: icon,
      iconSize: iconSize,
      spacing: spacing,
      backgroundColor: Colors.transparent,
      textColor: !enabled
          ? GSColorTokens.textDisabled
          : textColor ?? color ?? GSColorTokens.textAccent,
      border: Border.all(color: borderColor, width: borderWidth),
    );
  }

  final VoidCallback onPressed;
  final bool isLoading;
  final String text;
  final Color? backgroundColor;
  final Color textColor;
  final Gradient? gradient;
  final double radius;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final Border? border;
  final IconData? icon;
  final double? iconSize;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled && !isLoading ? onPressed : null,
      child: Container(
        padding:
            padding ??
            const EdgeInsets.symmetric(
              horizontal: GSSpacing.xl4,
              vertical: GSSpacing.xl3,
            ),
        decoration: BoxDecoration(
          gradient: gradient,
          color: backgroundColor,
          border: border,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(textColor),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: textColor, size: iconSize ?? 20),
                      SizedBox(width: spacing ?? GSSpacing.l),
                    ],
                    Text(
                      text,
                      style: GSTypography.bodyAccentMedium.copyWith(
                        fontSize: fontSize ?? GSFontScale.sf04,
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
