import 'package:flutter/material.dart';
import 'colors.dart';

/// Font families
class GSFontFamily {
  GSFontFamily._();

  static const String primary = 'GSFontFamily';
  static const String display = 'GSPlayfair';
}

/// Font scale
class GSFontScale {
  GSFontScale._();

  static const double sf01 = 10;
  static const double sf02 = 12;
  static const double sf03 = 14;
  static const double sf04 = 16;
  static const double sf05 = 18;
  static const double sf06 = 20;
  static const double sf07 = 24;
  static const double sf08 = 28;
  static const double sf09 = 32;
  static const double sf10 = 36;
  static const double sf11 = 40;
  static const double sf12 = 48;
}

/// Typography system for GeoSpots
class GSTypography {
  GSTypography._();

  // Headings
  static TextStyle get headingLarge => const TextStyle(
    fontFamily: GSFontFamily.display,
    fontSize: GSFontScale.sf12,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: GSColors.neutral1000,
  );

  static TextStyle get headingMedium => const TextStyle(
    fontFamily: GSFontFamily.display,
    fontSize: GSFontScale.sf10,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: GSColors.neutral1000,
  );

  static TextStyle get headingSmall => const TextStyle(
    fontFamily: GSFontFamily.display,
    fontSize: GSFontScale.sf08,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: GSColors.neutral1000,
  );

  // Body - Default
  static TextStyle get bodyDefaultLarge => const TextStyle(
    fontFamily: GSFontFamily.primary,
    fontSize: GSFontScale.sf06,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: GSColors.neutral1000,
  );

  static TextStyle get bodyDefaultMedium => const TextStyle(
    fontFamily: GSFontFamily.primary,
    fontSize: GSFontScale.sf04,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: GSColors.neutral1000,
  );

  static TextStyle get bodyDefaultSmall => const TextStyle(
    fontFamily: GSFontFamily.primary,
    fontSize: GSFontScale.sf03,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: GSColors.neutral1000,
  );

  // Body - Accent
  static TextStyle get bodyAccentLarge => const TextStyle(
    fontFamily: GSFontFamily.primary,
    fontSize: GSFontScale.sf06,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: GSColors.primary600,
  );

  static TextStyle get bodyAccentMedium => const TextStyle(
    fontFamily: GSFontFamily.primary,
    fontSize: GSFontScale.sf04,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: GSColors.primary600,
  );

  static TextStyle get bodyAccentSmall => const TextStyle(
    fontFamily: GSFontFamily.primary,
    fontSize: GSFontScale.sf03,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: GSColors.primary600,
  );

  // Caption
  static TextStyle get captionDefault => const TextStyle(
    fontFamily: GSFontFamily.primary,
    fontSize: GSFontScale.sf02,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: GSColors.neutral600,
  );

  static TextStyle get captionAccent => const TextStyle(
    fontFamily: GSFontFamily.primary,
    fontSize: GSFontScale.sf02,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: GSColors.primary600,
  );

  // Label
  static TextStyle get labelDefault => const TextStyle(
    fontFamily: GSFontFamily.primary,
    fontSize: GSFontScale.sf03,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: GSColors.neutral700,
  );

  static TextStyle get labelAccent => const TextStyle(
    fontFamily: GSFontFamily.primary,
    fontSize: GSFontScale.sf03,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: GSColors.primary600,
  );
}
