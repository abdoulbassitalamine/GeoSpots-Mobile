import 'package:flutter/material.dart';
import 'package:geo_spots/shared/design_system/theme/spacing.dart';
import 'package:geo_spots/shared/design_system/tokens/color_tokens.dart';
import 'package:geo_spots/shared/design_system/tokens/spacing_tokens.dart';
import 'package:geo_spots/shared/design_system/tokens/typography_tokens.dart';

import 'gs_snackbar_type.dart';

class GSScaffoldSnackbar {
  const GSScaffoldSnackbar._();

  static const Duration _duration = Duration(seconds: 2);

  static void show(
    BuildContext context, {
    required String message,
    GSSnackbarType type = GSSnackbarType.info,
    Duration duration = _duration,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }

    final style = _GSSnackbarStyle.fromType(type);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: behavior,
          duration: duration,
          elevation: 0,
          backgroundColor: style.backgroundColor,
          margin: behavior == SnackBarBehavior.floating
              ? const EdgeInsets.fromLTRB(
                  GSSpacing.xl,
                  GSSpacing.none,
                  GSSpacing.xl,
                  GSSpacing.xl,
                )
              : null,
          padding: const EdgeInsets.symmetric(
            horizontal: GSSpacingTokens.listItemPaddingHorizontal,
            vertical: GSSpacing.l,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GSRadiusTokens.card),
            side: BorderSide(color: style.borderColor),
          ),
          content: Row(
            children: [
              Icon(style.icon, color: style.foregroundColor, size: 20),
              const SizedBox(width: GSSpacingTokens.iconTextSpacing),
              Expanded(
                child: Text(
                  message,
                  style: GSTypographyTokens.bodyMedium.copyWith(
                    color: style.foregroundColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = _duration,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    show(
      context,
      message: message,
      type: GSSnackbarType.error,
      duration: duration,
      behavior: behavior,
    );
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = _duration,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    show(
      context,
      message: message,
      type: GSSnackbarType.success,
      duration: duration,
      behavior: behavior,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = _duration,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    show(
      context,
      message: message,
      type: GSSnackbarType.warning,
      duration: duration,
      behavior: behavior,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = _duration,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    show(
      context,
      message: message,
      type: GSSnackbarType.info,
      duration: duration,
      behavior: behavior,
    );
  }
}

class _GSSnackbarStyle {
  const _GSSnackbarStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.icon,
  });

  factory _GSSnackbarStyle.fromType(GSSnackbarType type) {
    return switch (type) {
      GSSnackbarType.error => const _GSSnackbarStyle(
        backgroundColor: GSColorTokens.dangerBackground,
        foregroundColor: GSColorTokens.dangerText,
        borderColor: GSColorTokens.dangerBorder,
        icon: Icons.error_outline_rounded,
      ),
      GSSnackbarType.success => const _GSSnackbarStyle(
        backgroundColor: GSColorTokens.successBackground,
        foregroundColor: GSColorTokens.successText,
        borderColor: GSColorTokens.successBorder,
        icon: Icons.check_circle_outline_rounded,
      ),
      GSSnackbarType.warning => const _GSSnackbarStyle(
        backgroundColor: GSColorTokens.warningBackground,
        foregroundColor: GSColorTokens.warningText,
        borderColor: GSColorTokens.warningBorder,
        icon: Icons.warning_amber_rounded,
      ),
      GSSnackbarType.info => const _GSSnackbarStyle(
        backgroundColor: GSColorTokens.infoBackground,
        foregroundColor: GSColorTokens.infoText,
        borderColor: GSColorTokens.infoBorder,
        icon: Icons.info_outline_rounded,
      ),
    };
  }

  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final IconData icon;
}
