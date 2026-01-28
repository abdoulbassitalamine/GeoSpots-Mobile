import 'package:flutter/material.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../theme/shadows.dart';
import '../../tokens/color_tokens.dart';

class GSCheckboxCard extends StatelessWidget {
  const GSCheckboxCard({
    super.key,
    required this.value,
    required this.text,
    required this.onChanged,
  });

  final bool value;
  final String text;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: GSSpacing.xl2,
          vertical: GSSpacing.xl,
        ),
        decoration: BoxDecoration(
          color: GSColorTokens.backgroundPrimary,
          boxShadow: [GSShadows.s()],
          borderRadius: BorderRadius.circular(GSRadius.m),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: GSTypography.bodyAccentMedium.copyWith(
                  color: GSColorTokens.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: GSColorTokens.textAccent,
              checkColor: GSColorTokens.textInverse,
            ),
          ],
        ),
      ),
    );
  }
}
