import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class GSTopSnackbar {
  const GSTopSnackbar._();

  static const Duration _animationDuration = Duration(milliseconds: 500);
  static const Duration _displayDuration = Duration(milliseconds: 1500);
  static const Duration _reverseAnimationDuration = Duration(milliseconds: 300);
  static const SnackBarPosition _defaultPosition = SnackBarPosition.bottom;

  static void showError(
    BuildContext context, {
    required String message,
    SnackBarPosition position = _defaultPosition,
    Duration animationDuration = _animationDuration,
    Duration displayDuration = _displayDuration,
    Duration reverseAnimationDuration = _reverseAnimationDuration,
  }) {
    _show(
      context,
      position: position,
      animationDuration: animationDuration,
      displayDuration: displayDuration,
      reverseAnimationDuration: reverseAnimationDuration,
      bar: CustomSnackBar.error(message: message),
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
    _show(
      context,
      position: position,
      animationDuration: animationDuration,
      displayDuration: displayDuration,
      reverseAnimationDuration: reverseAnimationDuration,
      bar: CustomSnackBar.success(message: message),
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
    _show(
      context,
      position: position,
      animationDuration: animationDuration,
      displayDuration: displayDuration,
      reverseAnimationDuration: reverseAnimationDuration,
      bar: CustomSnackBar.info(message: message),
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
    _show(
      context,
      position: position,
      animationDuration: animationDuration,
      displayDuration: displayDuration,
      reverseAnimationDuration: reverseAnimationDuration,
      bar: CustomSnackBar.info(message: message),
    );
  }

  static void _show(
    BuildContext context, {
    required Widget bar,
    required SnackBarPosition position,
    required Duration animationDuration,
    required Duration displayDuration,
    required Duration reverseAnimationDuration,
  }) {
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) {
      return;
    }

    showTopSnackBar(
      overlay,
      snackBarPosition: position,
      animationDuration: animationDuration,
      displayDuration: displayDuration,
      reverseAnimationDuration: reverseAnimationDuration,
      bar,
    );
  }
}
