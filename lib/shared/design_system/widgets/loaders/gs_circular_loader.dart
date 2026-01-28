import 'package:flutter/material.dart';
import '../../tokens/color_tokens.dart';

class GSCircularLoader extends StatelessWidget {
  const GSCircularLoader({
    super.key,
    this.size = 40.0,
    this.strokeWidth = 4.0,
    this.color,
    this.backgroundColor,
  });

  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? GSColorTokens.textAccent,
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }
}

/// Circular loader with animation (for determinate progress)
class GSCircularLoaderAnimated extends StatelessWidget {
  const GSCircularLoaderAnimated({
    super.key,
    required this.value,
    this.size = 40.0,
    this.strokeWidth = 4.0,
    this.color,
    this.backgroundColor,
  });

  final double value;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: value),
        duration: const Duration(milliseconds: 300),
        builder: (context, value, child) {
          return CircularProgressIndicator(
            value: value,
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? GSColorTokens.textAccent,
            ),
            backgroundColor: backgroundColor ?? GSColorTokens.borderPrimary,
          );
        },
      ),
    );
  }
}
