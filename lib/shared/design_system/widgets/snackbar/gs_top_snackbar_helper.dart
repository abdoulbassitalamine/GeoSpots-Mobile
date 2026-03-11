import 'package:flutter/material.dart';
import 'package:geo_spots/shared/design_system/theme/spacing.dart';
import 'package:geo_spots/shared/design_system/tokens/color_tokens.dart';
import 'package:geo_spots/shared/design_system/tokens/spacing_tokens.dart';
import 'package:geo_spots/shared/design_system/tokens/typography_tokens.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'gs_scaffold_snackbar.dart';
import 'gs_snackbar_type.dart';

class GSTopSnackbar {
  const GSTopSnackbar._();

  static const Duration _animationDuration = Duration(milliseconds: 500);
  static const Duration _displayDuration = Duration(milliseconds: 1500);
  static const Duration _reverseAnimationDuration = Duration(milliseconds: 300);
  static const SnackBarPosition _defaultPosition = SnackBarPosition.bottom;

  static void show(
    BuildContext context, {
    required String message,
    GSSnackbarType type = GSSnackbarType.info,
    SnackBarPosition position = _defaultPosition,
    Duration animationDuration = _animationDuration,
    Duration displayDuration = _displayDuration,
    Duration reverseAnimationDuration = _reverseAnimationDuration,
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) {
      GSScaffoldSnackbar.show(
        context,
        message: message,
        type: type,
        duration: displayDuration,
      );
      return;
    }

    showTopSnackBar(
      overlay,
      _GSTopSnackbarCard(
        message: message,
        style: _GSSnackbarStyle.fromType(type),
      ),
      snackBarPosition: position,
      animationDuration: animationDuration,
      displayDuration: displayDuration,
      reverseAnimationDuration: reverseAnimationDuration,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    SnackBarPosition position = _defaultPosition,
    Duration animationDuration = _animationDuration,
    Duration displayDuration = _displayDuration,
    Duration reverseAnimationDuration = _reverseAnimationDuration,
  }) {
    show(
      context,
      message: message,
      type: GSSnackbarType.error,
      position: position,
      animationDuration: animationDuration,
      displayDuration: displayDuration,
      reverseAnimationDuration: reverseAnimationDuration,
    );
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
    SnackBarPosition position = _defaultPosition,
    Duration animationDuration = _animationDuration,
    Duration displayDuration = _displayDuration,
    Duration reverseAnimationDuration = _reverseAnimationDuration,
  }) {
    show(
      context,
      message: message,
      type: GSSnackbarType.success,
      position: position,
      animationDuration: animationDuration,
      displayDuration: displayDuration,
      reverseAnimationDuration: reverseAnimationDuration,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    SnackBarPosition position = _defaultPosition,
    Duration animationDuration = _animationDuration,
    Duration displayDuration = _displayDuration,
    Duration reverseAnimationDuration = _reverseAnimationDuration,
  }) {
    show(
      context,
      message: message,
      type: GSSnackbarType.warning,
      position: position,
      animationDuration: animationDuration,
      displayDuration: displayDuration,
      reverseAnimationDuration: reverseAnimationDuration,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    SnackBarPosition position = _defaultPosition,
    Duration animationDuration = _animationDuration,
    Duration displayDuration = _displayDuration,
    Duration reverseAnimationDuration = _reverseAnimationDuration,
  }) {
    show(
      context,
      message: message,
      type: GSSnackbarType.info,
      position: position,
      animationDuration: animationDuration,
      displayDuration: displayDuration,
      reverseAnimationDuration: reverseAnimationDuration,
    );
  }
}

class _GSTopSnackbarCard extends StatelessWidget {
  const _GSTopSnackbarCard({required this.message, required this.style});

  final String message;
  final _GSSnackbarStyle style;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: GSSpacing.xl),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: GSSpacingTokens.cardPaddingHorizontal,
              vertical: GSSpacing.l,
            ),
            decoration: BoxDecoration(
              color: style.backgroundColor,
              borderRadius: BorderRadius.circular(GSRadiusTokens.card),
              border: Border.all(color: style.borderColor),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(style.icon, color: style.foregroundColor, size: 22),
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
        ),
      ),
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
