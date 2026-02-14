import 'package:flutter/material.dart';
import '../../tokens/color_tokens.dart';

class GSSwitch extends StatelessWidget {
  const GSSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeThumbColor: activeColor ?? GSColorTokens.textAccent,
      activeTrackColor: (activeColor ?? GSColorTokens.textAccent).withValues(
        alpha: 0.3,
      ),
      inactiveThumbColor: inactiveColor ?? GSColorTokens.textSecondary,
      inactiveTrackColor: (inactiveColor ?? GSColorTokens.textSecondary)
          .withValues(alpha: 0.3),
    );
  }
}

/// Switch with label
class GSSwitchListTile extends StatelessWidget {
  const GSSwitchListTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      value: value,
      onChanged: enabled ? onChanged : null,
      activeThumbColor: GSColorTokens.textAccent,
      activeTrackColor: GSColorTokens.textAccent.withValues(alpha: 0.3),
      inactiveThumbColor: GSColorTokens.textSecondary,
      inactiveTrackColor: GSColorTokens.textSecondary.withValues(alpha: 0.3),
    );
  }
}
