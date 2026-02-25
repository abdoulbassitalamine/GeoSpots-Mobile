import 'package:flutter/material.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../tokens/color_tokens.dart';

class GSTextBetweenDivider extends StatelessWidget {
  const GSTextBetweenDivider({
    super.key,
    required this.text,
    this.lineHeight = 1.0,
    this.lineColor,
    this.textStyle,
    this.spacing = GSSpacing.xl,
  });

  final String text;
  final double lineHeight;
  final Color? lineColor;
  final TextStyle? textStyle;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final dividerColor = lineColor ?? GSColorTokens.dividerPrimary;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: lineHeight,
            color: dividerColor,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing),
          child: Text(
            text,
            style: textStyle ??
                GSTypography.bodyAccentSmall.copyWith(
                  color: GSColorTokens.textSecondary,
                ),
          ),
        ),
        Expanded(
          child: Container(
            height: lineHeight,
            color: dividerColor,
          ),
        ),
      ],
    );
  }
}
