import '../theme/spacing.dart';

/// Semantic spacing tokens for common use cases
class GSSpacingTokens {
  GSSpacingTokens._();

  // Page margins
  static const double pagePaddingHorizontal = GSSpacing.xl;
  static const double pagePaddingVertical = GSSpacing.xl;

  // Card padding
  static const double cardPaddingHorizontal = GSSpacing.xl;
  static const double cardPaddingVertical = GSSpacing.xl;

  // List item spacing
  static const double listItemSpacing = GSSpacing.m;
  static const double listItemPaddingHorizontal = GSSpacing.xl;
  static const double listItemPaddingVertical = GSSpacing.l;

  // Button padding
  static const double buttonPaddingHorizontal = GSSpacing.xl4;
  static const double buttonPaddingVertical = GSSpacing.xl;
  static const double buttonSmallPaddingHorizontal = GSSpacing.xl;
  static const double buttonSmallPaddingVertical = GSSpacing.m;

  // Input field padding
  static const double fieldPaddingHorizontal = GSSpacing.xl;
  static const double fieldPaddingVertical = GSSpacing.xl;

  // Section spacing
  static const double sectionSpacing = GSSpacing.xl3;
  static const double sectionHeaderSpacing = GSSpacing.xl;

  // Icon spacing
  static const double iconTextSpacing = GSSpacing.m;
  static const double iconPadding = GSSpacing.m;

  // Bottom sheet
  static const double bottomSheetPadding = GSSpacing.xl3;
  static const double bottomSheetHandleSpacing = GSSpacing.l;

  // Dialog
  static const double dialogPadding = GSSpacing.xl3;
  static const double dialogContentSpacing = GSSpacing.xl;
}

/// Border radius tokens for common use cases
class GSRadiusTokens {
  GSRadiusTokens._();

  // Cards
  static const double card = GSRadius.m;
  static const double cardSmall = GSRadius.s;

  // Buttons
  static const double button = GSRadius.s;
  static const double buttonRound = GSRadius.full;

  // Fields
  static const double field = GSRadius.s;

  // Dialogs
  static const double dialog = GSRadius.l;
  static const double bottomSheet = GSRadius.l;

  // Images
  static const double imageSmall = GSRadius.s;
  static const double imageMedium = GSRadius.m;
  static const double imageLarge = GSRadius.l;
  static const double imageCircular = GSRadius.full;

  // Badges
  static const double badge = GSRadius.full;
}
