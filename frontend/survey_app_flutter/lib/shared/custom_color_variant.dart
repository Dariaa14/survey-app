import 'package:flutter/material.dart';
import 'package:survey_app_flutter/utils/theme.dart';

/// The visual variant used by custom widgets.
enum CustomColorVariant {
  /// Filled primary style.
  primary,

  /// Inverted primary outlined style.
  inversePrimary,

  /// Default outlined neutral style.
  normal,

  /// Secondary tinted outlined style.
  invertedSecondary,

  /// Tertiary tinted outlined style.
  invertedTertiary,

  /// Destructive outlined red style.
  invertedRed,

  /// Gray outlined style.
  gray,
}

/// The background color for the given variant, based on the color scheme.
Color? backgroundColor(ColorScheme colorScheme, CustomColorVariant variant) {
  switch (variant) {
    case CustomColorVariant.primary:
      return colorScheme.primary;
    case CustomColorVariant.inversePrimary:
      return colorScheme.primaryContainer;
    case CustomColorVariant.normal:
      return null;
    case CustomColorVariant.invertedSecondary:
      return colorScheme.secondaryContainer;
    case CustomColorVariant.invertedTertiary:
      return colorScheme.tertiaryContainer;
    case CustomColorVariant.invertedRed:
      return redContainer;
    case CustomColorVariant.gray:
      return colorScheme.surfaceContainer;
  }
}

/// The border color for the given variant, based on the color scheme.
Color borderColor(ColorScheme colorScheme, CustomColorVariant variant) {
  switch (variant) {
    case CustomColorVariant.primary:
      return colorScheme.primary;
    case CustomColorVariant.inversePrimary:
      return colorScheme.primary;
    case CustomColorVariant.normal:
      return colorScheme.outline;
    case CustomColorVariant.invertedSecondary:
      return colorScheme.secondary;
    case CustomColorVariant.invertedTertiary:
      return colorScheme.tertiary;
    case CustomColorVariant.invertedRed:
      return colorScheme.error;
    case CustomColorVariant.gray:
      return colorScheme.outline;
  }
}

/// The text color for the given variant, based on the color scheme.
Color textColor(ColorScheme colorScheme, CustomColorVariant variant) {
  switch (variant) {
    case CustomColorVariant.primary:
      return colorScheme.onPrimary;
    case CustomColorVariant.inversePrimary:
      return colorScheme.primary;
    case CustomColorVariant.normal:
      return colorScheme.onSurfaceVariant;
    case CustomColorVariant.invertedSecondary:
      return colorScheme.secondary;
    case CustomColorVariant.invertedTertiary:
      return colorScheme.tertiary;
    case CustomColorVariant.invertedRed:
      return colorScheme.error;
    case CustomColorVariant.gray:
      return colorScheme.onSurfaceVariant;
  }
}
