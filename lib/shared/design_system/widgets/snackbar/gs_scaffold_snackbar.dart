import 'package:flutter/material.dart';
import 'package:geo_spots/shared/design_system/theme/colors.dart';

class GSScaffoldSnackbar {
  const GSScaffoldSnackbar._();

  static const Duration _duration = Duration(seconds: 2);

  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = _duration,
  }) {
    _show(
      context,
      message: message,
      duration: duration,
      backgroundColor: GSColors.redStone,
    );
  }

  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = _duration,
  }) {
    _show(
      context,
      message: message,
      duration: duration,
      backgroundColor: GSColors.greenLime,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = _duration,
  }) {
    _show(
      context,
      message: message,
      duration: duration,
      backgroundColor: GSColors.yellowTangerine,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = _duration,
  }) {
    _show(
      context,
      message: message,
      duration: duration,
      backgroundColor: GSColors.electricBlue,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Duration duration,
    required Color backgroundColor,
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        duration: duration,
        content: Text(message),
      ),
    );
  }
}
