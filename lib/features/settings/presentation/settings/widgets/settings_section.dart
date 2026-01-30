import 'package:flutter/material.dart';
import '../../../../../shared/design_system/design_system.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: GSSpacing.s, bottom: GSSpacing.l),
          child: Text(
            title,
            style: GSTypography.bodyAccentMedium.copyWith(
              fontSize: GSFontScale.sf05,
              color: GSColors.neutral700,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}