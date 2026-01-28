import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';
import 'spacing.dart';

/// Main theme configuration for GeoSpots
class GSAppTheme {
  GSAppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: ColorScheme.light(
        primary: GSColors.primary600,
        onPrimary: GSColors.neutral000,
        primaryContainer: GSColors.primary100,
        onPrimaryContainer: GSColors.primary900,

        secondary: GSColors.neutral700,
        onSecondary: GSColors.neutral000,
        secondaryContainer: GSColors.neutral100,
        onSecondaryContainer: GSColors.neutral900,

        tertiary: GSColors.amber500,
        onTertiary: GSColors.neutral000,
        tertiaryContainer: GSColors.warning100,
        onTertiaryContainer: GSColors.warning900,

        error: GSColors.danger600,
        onError: GSColors.neutral000,
        errorContainer: GSColors.danger100,
        onErrorContainer: GSColors.danger900,

        surface: GSColors.neutral050,
        onSurface: GSColors.neutral1000,
        surfaceContainerHighest: GSColors.neutral100,

        outline: GSColors.neutral300,
        outlineVariant: GSColors.neutral200,

        shadow: GSColors.neutral1000.withValues(alpha: 0.2),
        scrim: GSColors.neutral1000.withValues(alpha: 0.5),
      ),

      // Scaffold
      scaffoldBackgroundColor: GSColors.neutral050,

      // App bar
      appBarTheme: AppBarTheme(
        backgroundColor: GSColors.neutral1000,
        foregroundColor: GSColors.neutral000,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GSTypography.headingSmall.copyWith(
          color: GSColors.neutral000,
        ),
        iconTheme: const IconThemeData(color: GSColors.neutral000),
      ),

      // Card
      cardTheme: CardThemeData(
        color: GSColors.neutral000,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GSRadius.m),
        ),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        fillColor: GSColors.neutral000,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: GSSpacing.xl,
          vertical: GSSpacing.xl,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GSRadius.s),
          borderSide: const BorderSide(color: GSColors.neutral300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GSRadius.s),
          borderSide: const BorderSide(color: GSColors.neutral300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GSRadius.s),
          borderSide: const BorderSide(color: GSColors.primary600, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GSRadius.s),
          borderSide: const BorderSide(color: GSColors.danger600),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(GSRadius.s),
          borderSide: const BorderSide(color: GSColors.danger600, width: 2),
        ),
        labelStyle: GSTypography.bodyDefaultMedium.copyWith(
          color: GSColors.neutral600,
        ),
        hintStyle: GSTypography.bodyDefaultMedium.copyWith(
          color: GSColors.neutral400,
        ),
        errorStyle: GSTypography.bodyDefaultSmall.copyWith(
          color: GSColors.danger600,
        ),
      ),

      // Elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: GSColors.primary600,
          foregroundColor: GSColors.neutral000,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: GSSpacing.xl4,
            vertical: GSSpacing.xl,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GSRadius.s),
          ),
          textStyle: GSTypography.bodyAccentMedium,
        ),
      ),

      // Outlined button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: GSColors.neutral1000,
          side: const BorderSide(color: GSColors.neutral1000, width: 2),
          padding: const EdgeInsets.symmetric(
            horizontal: GSSpacing.xl4,
            vertical: GSSpacing.xl,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GSRadius.s),
          ),
          textStyle: GSTypography.bodyAccentMedium,
        ),
      ),

      // Text button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: GSColors.primary600,
          padding: const EdgeInsets.symmetric(
            horizontal: GSSpacing.xl,
            vertical: GSSpacing.m,
          ),
          textStyle: GSTypography.bodyAccentMedium,
        ),
      ),

      // Icon button
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: GSColors.neutral700,
          iconSize: 24,
        ),
      ),

      // Bottom navigation bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: GSColors.neutral000,
        selectedItemColor: GSColors.primary600,
        unselectedItemColor: GSColors.neutral500,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: GSColors.neutral300,
        thickness: 1,
        space: 1,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GSColors.primary600;
          }
          return GSColors.neutral500;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GSColors.primary600.withValues(alpha: 0.3);
          }
          return GSColors.neutral500.withValues(alpha: 0.3);
        }),
      ),

      // Text theme
      textTheme: TextTheme(
        displayLarge: GSTypography.headingLarge,
        displayMedium: GSTypography.headingMedium,
        displaySmall: GSTypography.headingSmall,
        bodyLarge: GSTypography.bodyDefaultLarge,
        bodyMedium: GSTypography.bodyDefaultMedium,
        bodySmall: GSTypography.bodyDefaultSmall,
        labelLarge: GSTypography.labelDefault,
        labelMedium: GSTypography.labelDefault,
        labelSmall: GSTypography.captionDefault,
      ),

      // Font family
      fontFamily: GSFontFamily.primary,
    );
  }
}

/// Extension to access theme
extension GSThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
