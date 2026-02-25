import 'package:flutter/material.dart';
import '../../tokens/color_tokens.dart';

class GSIconButton extends StatelessWidget {
  const GSIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.size = 24.0,
    this.enabled = true,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;
  final bool enabled;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final iconColor = !enabled
        ? GSColorTokens.textDisabled
        : color ?? GSColorTokens.textSecondary;

    final button = IconButton(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon),
      color: iconColor,
      iconSize: size,
      style: IconButton.styleFrom(
        foregroundColor: iconColor,
        disabledForegroundColor: GSColorTokens.textDisabled,
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip, child: button);
    }

    return button;
  }
}
