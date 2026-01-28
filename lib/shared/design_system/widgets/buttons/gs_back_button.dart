import 'package:flutter/material.dart';
import '../../tokens/color_tokens.dart';

const double leadingWidth = 24.0;

class GSBackButton extends StatelessWidget {
  const GSBackButton({
    super.key,
    this.color,
    this.onPressed,
  });

  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      icon: Icon(
        Icons.arrow_back,
        color: color ?? GSColorTokens.textInverse,
      ),
      iconSize: leadingWidth,
      padding: EdgeInsets.zero,
    );
  }
}