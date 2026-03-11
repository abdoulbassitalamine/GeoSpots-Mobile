import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../snackbar/gs_snackbar_type.dart';

class GSAlertBanner extends StatelessWidget {
  const GSAlertBanner({
    super.key,
    required this.type,
    required this.message,
    this.onDismiss,
  });

  final GSSnackbarType type;
  final String message;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final config = switch (type) {
      GSSnackbarType.error => _AlertBannerConfig(
        backgroundColor: GSColors.danger100,
        accentColor: GSColors.danger500,
        textColor: GSColors.danger700,
        icon: Icons.error_outline_rounded,
      ),
      GSSnackbarType.warning => _AlertBannerConfig(
        backgroundColor: GSColors.warning100,
        accentColor: GSColors.warning500,
        textColor: GSColors.warning700,
        icon: Icons.warning_amber_rounded,
      ),
      GSSnackbarType.info => _AlertBannerConfig(
        backgroundColor: GSColors.info100,
        accentColor: GSColors.info500,
        textColor: GSColors.info700,
        icon: Icons.info_outline_rounded,
      ),
      GSSnackbarType.success => _AlertBannerConfig(
        backgroundColor: GSColors.success100,
        accentColor: GSColors.success500,
        textColor: GSColors.success700,
        icon: Icons.check_circle_outline_rounded,
      ),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(GSRadius.m),
        border: Border.all(color: config.accentColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: GSSpacing.xl3,
          vertical: GSSpacing.xl,
        ),
        child: Row(
          children: [
            Icon(config.icon, color: config.accentColor, size: 20),
            const SizedBox(width: GSSpacing.l),
            Expanded(
              child: Text(
                message,
                style: GSTypography.bodyDefaultMedium.copyWith(
                  color: config.textColor,
                ),
              ),
            ),
            if (onDismiss != null) ...[
              const SizedBox(width: GSSpacing.m),
              InkWell(
                borderRadius: BorderRadius.circular(GSRadius.full),
                onTap: onDismiss,
                child: Padding(
                  padding: const EdgeInsets.all(GSSpacing.xs),
                  child: Icon(
                    Icons.close_rounded,
                    color: config.textColor,
                    size: 18,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AlertBannerConfig {
  const _AlertBannerConfig({
    required this.backgroundColor,
    required this.accentColor,
    required this.textColor,
    required this.icon,
  });

  final Color backgroundColor;
  final Color accentColor;
  final Color textColor;
  final IconData icon;
}
