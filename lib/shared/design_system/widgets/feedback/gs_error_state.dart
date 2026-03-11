import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../buttons/gs_filled_button.dart';

class GSErrorState extends StatelessWidget {
  const GSErrorState({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.retryLabel,
    this.icon = Icons.error_outline_rounded,
  }) : assert(
         onRetry == null || retryLabel != null,
         'retryLabel is required when onRetry is set',
       );

  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(GSSpacing.xl3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: GSColors.primary600),
            const SizedBox(height: GSSpacing.xl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GSTypography.headingSmall.copyWith(
                color: GSColors.neutral900,
                fontSize: GSFontScale.sf07,
              ),
            ),
            const SizedBox(height: GSSpacing.m),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GSTypography.bodyDefaultMedium.copyWith(
                color: GSColors.neutral600,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: GSSpacing.xl2),
              SizedBox(
                width: 180,
                child: GSFilledButton(text: retryLabel!, onPressed: onRetry!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
