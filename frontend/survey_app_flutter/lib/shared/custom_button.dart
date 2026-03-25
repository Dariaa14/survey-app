import 'package:flutter/material.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';

/// A generic custom button widget for the Survey App.
class CustomButton extends StatelessWidget {
  /// Constructs a [CustomButton].
  const CustomButton({
    required this.onPressed,
    this.text,
    this.child,
    this.variant = CustomColorVariant.normal,
    super.key,
  }) : assert(text != null || child != null);

  /// Callback when the button is pressed.
  final VoidCallback onPressed;

  /// The text displayed on the button.
  final String? text;

  /// Optional custom widget displayed in the button.
  final Widget? child;

  /// The visual style variant for the button.
  final CustomColorVariant variant;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor(colorScheme, variant),
        foregroundColor: textColor(colorScheme, variant),
        side: BorderSide(color: borderColor(colorScheme, variant)),
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child:
          child ??
          Text(
            text!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor(colorScheme, variant),
            ),
          ),
    );
  }
}
