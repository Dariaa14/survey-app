import 'package:flutter/material.dart';
import 'package:survey_app_flutter/utils/theme.dart';

/// The visual variant used by [CustomButton].
enum CustomButtonVariant {
  /// Filled primary style.
  primary,

  /// Default outlined neutral style.
  normal,

  /// Secondary tinted outlined style.
  secondary,

  /// Destructive outlined red style.
  red,

  /// Gray outlined style.
  gray,
}

/// A generic custom button widget for the Survey App.
class CustomButton extends StatelessWidget {
  /// Constructs a [CustomButton].
  const CustomButton({
    required this.onPressed,
    required this.text,
    this.variant = CustomButtonVariant.normal,
    super.key,
  });

  /// Callback when the button is pressed.
  final VoidCallback onPressed;

  /// The text displayed on the button.
  final String text;

  /// The visual style variant for the button.
  final CustomButtonVariant variant;

  Color? _backgroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case CustomButtonVariant.primary:
        return colorScheme.primary;
      case CustomButtonVariant.normal:
        return null;
      case CustomButtonVariant.secondary:
        return colorScheme.secondaryContainer;
      case CustomButtonVariant.red:
        return redContainer;
      case CustomButtonVariant.gray:
        return colorScheme.surfaceContainer;
    }
  }

  Color _borderColor(ColorScheme colorScheme) {
    switch (variant) {
      case CustomButtonVariant.primary:
        return colorScheme.primary;
      case CustomButtonVariant.normal:
        return colorScheme.outline;
      case CustomButtonVariant.secondary:
        return colorScheme.secondary;
      case CustomButtonVariant.red:
        return colorScheme.error;
      case CustomButtonVariant.gray:
        return colorScheme.outline;
    }
  }

  Color _textColor(ColorScheme colorScheme) {
    switch (variant) {
      case CustomButtonVariant.primary:
        return colorScheme.onPrimary;
      case CustomButtonVariant.normal:
        return colorScheme.onSurfaceVariant;
      case CustomButtonVariant.secondary:
        return colorScheme.secondary;
      case CustomButtonVariant.red:
        return colorScheme.error;
      case CustomButtonVariant.gray:
        return colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: _backgroundColor(colorScheme),
        side: BorderSide(color: _borderColor(colorScheme)),
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _textColor(colorScheme),
        ),
      ),
    );
  }
}
