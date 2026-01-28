import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../tokens/color_tokens.dart';

class GSFloatingActionButton extends StatelessWidget {
  const GSFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
  });

  const GSFloatingActionButton.add({
    super.key,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
  }) : icon = Icons.add;

  final VoidCallback? onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      shape: const CircleBorder(),
      backgroundColor: backgroundColor ?? GSColors.primary400,
      onPressed: onPressed,
      child: Icon(icon, color: iconColor ?? GSColorTokens.textPrimary),
    );
  }
}
