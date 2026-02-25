import 'package:flutter/material.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../tokens/color_tokens.dart';

class GSActionButton extends StatelessWidget {
  const GSActionButton._({
    super.key,
    required this.text,
    this.onTap,
    required this.backgroundColor,
    required this.textColor,
    this.border,
  });

  factory GSActionButton.outlined({
    Key? key,
    required String text,
    VoidCallback? onTap,
  }) {
    return GSActionButton._(
      key: key,
      text: text,
      onTap: onTap,
      backgroundColor: Colors.transparent,
      textColor: GSColorTokens.textPrimary,
      border: Border.all(
        color: GSColorTokens.textPrimary,
        width: GSBorderWidth.s,
      ),
    );
  }

  factory GSActionButton.filled({
    Key? key,
    required String text,
    VoidCallback? onTap,
  }) {
    return GSActionButton._(
      key: key,
      text: text,
      onTap: onTap,
      backgroundColor: GSColorTokens.backgroundAccent,
      textColor: GSColorTokens.textPrimary,
    );
  }

  final String text;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: GSSpacing.l,
          vertical: GSSpacing.s,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: border,
        ),
        child: Text(
          text,
          style: GSTypography.bodyDefaultSmall.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: GSFontScale.sf02,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
