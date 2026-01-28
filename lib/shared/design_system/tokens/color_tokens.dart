import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// Functional color tokens for GeoSpots
/// These are semantic colors mapped to the base color palette
class GSColorTokens {
  GSColorTokens._();

  // Text & Icons
  static const Color textPrimary = GSColors.neutral1000;
  static const Color textSecondary = GSColors.neutral600;
  static const Color textTertiary = GSColors.neutral500;
  static const Color textInverse = GSColors.neutral000;
  static const Color textAccent = GSColors.primary600;
  static const Color textDisabled = GSColors.neutral400;

  // Backgrounds
  static const Color backgroundPrimary = GSColors.neutral050;
  static const Color backgroundSecondary = GSColors.neutral000;
  static const Color backgroundSecondaryInverse = GSColors.neutral900;
  static const Color backgroundAccent = GSColors.primary600;
  static const Color backgroundAccentLight = GSColors.primary100;
  static const Color backgroundDisabled = GSColors.neutral200;
  static const Color backgroundGhost = GSColors.transparent;

  // Borders
  static const Color borderPrimary = GSColors.neutral300;
  static const Color borderSecondary = GSColors.neutral600;
  static const Color borderTertiary = GSColors.neutral900;
  static const Color borderAccent = GSColors.primary600;
  static const Color borderInverse = GSColors.neutral000;

  // Status - Info
  static const Color infoText = GSColors.info600;
  static const Color infoBackground = GSColors.info100;
  static const Color infoBorder = GSColors.info500;

  // Status - Success
  static const Color successText = GSColors.success600;
  static const Color successBackground = GSColors.success100;
  static const Color successBorder = GSColors.success500;

  // Status - Warning
  static const Color warningText = GSColors.warning600;
  static const Color warningBackground = GSColors.warning100;
  static const Color warningBorder = GSColors.warning500;

  // Status - Danger
  static const Color dangerText = GSColors.danger600;
  static const Color dangerBackground = GSColors.danger100;
  static const Color dangerBorder = GSColors.danger500;

  // Gradients
  static const LinearGradient primaryGradientVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [GSColors.primary600, GSColors.primary700],
  );

  static const LinearGradient primaryGradientHorizontal = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [GSColors.primary600, GSColors.primary700],
  );

  static const LinearGradient secondaryGradientHorizontal = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [GSColors.amber500, GSColors.primary600],
  );

  // Component specific
  static const Color cardBackground = GSColors.neutral000;
  static const Color drawerBackground = GSColors.neutral050;
  static const Color tabBackground = GSColors.neutral000;

  // Navigation
  static const Color navBarBackground = GSColors.neutral000;
  static const Color navBarIndicator = GSColors.primary100;
  static const Color navBarItemDefault = GSColors.neutral600;
  static const Color navBarItemSelected = GSColors.primary600;
  static const Color navBarItemDisabled = GSColors.neutral400;

  // Field
  static const Color fieldLabel = GSColors.neutral600;
  static const Color fieldBorder = GSColors.neutral300;
  static const Color fieldError = GSColors.danger600;
  static const Color fieldBackground = GSColors.neutral000;

  // Divider
  static const Color dividerPrimary = GSColors.neutral300;
  static const Color dividerSecondary = GSColors.neutral600;
  static const Color dividerTertiary = GSColors.neutral900;
  static const Color dividerInverse = GSColors.neutral000;
}
