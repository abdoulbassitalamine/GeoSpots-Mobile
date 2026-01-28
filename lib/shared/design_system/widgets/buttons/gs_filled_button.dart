import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../tokens/color_tokens.dart';
import '../../tokens/typography_tokens.dart';

class GSFilledButton extends StatelessWidget {
  const GSFilledButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.enabled = true,
    this.color,
    this.textColor,
    this.padding,
    this.fullWidth = false,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final bool enabled;
  final Color? color;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = !enabled
        ? GSColorTokens.backgroundDisabled
        : color ?? GSColorTokens.backgroundAccent;

    final foregroundColor = !enabled
        ? GSColorTokens.textDisabled
        : textColor ?? GSColors.neutral1000;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: FilledButton(
        onPressed: enabled && !isLoading ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: GSColorTokens.backgroundDisabled,
          disabledForegroundColor: GSColorTokens.textDisabled,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          padding:
              padding ??
              const EdgeInsets.symmetric(
                horizontal: GSSpacing.xl4,
                vertical: GSSpacing.xl,
              ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            : Text(
                text[0].toUpperCase() + text.substring(1).toLowerCase(),
                style: GSTypographyTokens.buttonMedium.copyWith(
                  color: foregroundColor,
                  fontSize: GSFontScale.sf03,
                ),
              ),
      ),
    );
  }
}
