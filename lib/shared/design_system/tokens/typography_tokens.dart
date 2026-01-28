import 'package:flutter/material.dart';
import '../theme/typography.dart';
import '../theme/colors.dart';

/// Semantic typography tokens for common use cases
class GSTypographyTokens {
  GSTypographyTokens._();

  // Page titles
  static TextStyle get pageTitle => GSTypography.headingLarge;
  static TextStyle get sectionTitle => GSTypography.headingMedium;
  static TextStyle get cardTitle => GSTypography.headingSmall;

  // Body text
  static TextStyle get bodyLarge => GSTypography.bodyDefaultLarge;
  static TextStyle get bodyMedium => GSTypography.bodyDefaultMedium;
  static TextStyle get bodySmall => GSTypography.bodyDefaultSmall;

  // Emphasized text
  static TextStyle get emphasizedLarge => GSTypography.bodyAccentLarge;
  static TextStyle get emphasizedMedium => GSTypography.bodyAccentMedium;
  static TextStyle get emphasizedSmall => GSTypography.bodyAccentSmall;

  // Button text
  static TextStyle get buttonLarge => GSTypography.bodyAccentMedium.copyWith(
    fontSize: GSFontScale.sf05,
    fontWeight: FontWeight.w700,
  );
  static TextStyle get buttonMedium =>
      GSTypography.bodyAccentMedium.copyWith(fontWeight: FontWeight.w700);
  static TextStyle get buttonSmall =>
      GSTypography.bodyAccentSmall.copyWith(fontWeight: FontWeight.w700);

  // Link text
  static TextStyle get link => GSTypography.bodyDefaultMedium.copyWith(
    color: GSColors.primary600,
    decoration: TextDecoration.underline,
  );
  static TextStyle get linkSmall => GSTypography.bodyDefaultSmall.copyWith(
    color: GSColors.primary600,
    decoration: TextDecoration.underline,
  );

  // Helper text
  static TextStyle get helperText => GSTypography.captionDefault;
  static TextStyle get errorText =>
      GSTypography.captionDefault.copyWith(color: GSColors.danger600);

  // Labels
  static TextStyle get label => GSTypography.labelDefault;
  static TextStyle get labelAccent => GSTypography.labelAccent;

  // Navigation
  static TextStyle get navItem =>
      GSTypography.captionDefault.copyWith(fontWeight: FontWeight.w500);
  static TextStyle get navItemSelected =>
      GSTypography.captionAccent.copyWith(fontWeight: FontWeight.w600);

  // Tags/Badges
  static TextStyle get tag => GSTypography.captionDefault.copyWith(
    fontSize: GSFontScale.sf02,
    fontWeight: FontWeight.w600,
  );

  // Stats/Numbers
  static TextStyle get statNumber =>
      GSTypography.headingMedium.copyWith(fontWeight: FontWeight.w700);
  static TextStyle get statLabel => GSTypography.captionDefault;
}
