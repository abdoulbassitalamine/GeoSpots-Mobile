import 'package:flutter/material.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../tokens/color_tokens.dart';
import '../../tokens/typography_tokens.dart';

class GSOutlinedButton extends StatelessWidget {
  const GSOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.enabled = true,
    this.borderColor,
    this.textColor,
    this.padding,
    this.fullWidth = false,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final bool enabled;
  final Color? borderColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = !enabled
        ? GSColorTokens.textDisabled
        : textColor ?? GSColorTokens.textPrimary;

    final border = !enabled
        ? BorderSide(color: GSColorTokens.borderPrimary, width: 2)
        : BorderSide(color: borderColor ?? GSColorTokens.textPrimary, width: 2);

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: enabled && !isLoading ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor,
          disabledForegroundColor: GSColorTokens.textDisabled,
          side: border,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          padding: padding ??
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