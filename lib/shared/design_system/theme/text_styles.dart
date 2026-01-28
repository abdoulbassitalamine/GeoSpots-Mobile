import 'package:flutter/material.dart';
import 'typography.dart';

/// Extension to access typography styles from context
extension GSTextStylesExtension on BuildContext {
  // Headings
  TextStyle get headingLarge => GSTypography.headingLarge;
  TextStyle get headingMedium => GSTypography.headingMedium;
  TextStyle get headingSmall => GSTypography.headingSmall;

  // Body - Default
  TextStyle get bodyDefaultLarge => GSTypography.bodyDefaultLarge;
  TextStyle get bodyDefaultMedium => GSTypography.bodyDefaultMedium;
  TextStyle get bodyDefaultSmall => GSTypography.bodyDefaultSmall;

  // Body - Accent
  TextStyle get bodyAccentLarge => GSTypography.bodyAccentLarge;
  TextStyle get bodyAccentMedium => GSTypography.bodyAccentMedium;
  TextStyle get bodyAccentSmall => GSTypography.bodyAccentSmall;

  // Caption
  TextStyle get captionDefault => GSTypography.captionDefault;
  TextStyle get captionAccent => GSTypography.captionAccent;

  // Label
  TextStyle get labelDefault => GSTypography.labelDefault;
  TextStyle get labelAccent => GSTypography.labelAccent;
}
