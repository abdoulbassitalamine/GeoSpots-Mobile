import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum GSPageTransitionType {
  fade,
  slideRight,
  slideLeft,
  slideUp,
  slideDown,
  scale,
  none,
}

class GSPageTransition {
  GSPageTransition._();

  /// Build a custom transition page for go_router
  static CustomTransitionPage<dynamic> buildTransition({
    required Widget child,
    GSPageTransitionType type = GSPageTransitionType.slideRight,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return CustomTransitionPage(
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _getTransition(type, animation, child, curve);
      },
    );
  }

  static Widget _getTransition(
    GSPageTransitionType type,
    Animation<double> animation,
    Widget child,
    Curve curve,
  ) {
    final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

    switch (type) {
      case GSPageTransitionType.fade:
        return FadeTransition(opacity: curvedAnimation, child: child);

      case GSPageTransitionType.slideRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case GSPageTransitionType.slideLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case GSPageTransitionType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case GSPageTransitionType.slideDown:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );

      case GSPageTransitionType.scale:
        return ScaleTransition(scale: curvedAnimation, child: child);

      case GSPageTransitionType.none:
        return child;
    }
  }
}
