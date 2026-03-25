import 'package:flutter/material.dart';

/// A custom primary button widget for the Survey App.
class CustomPrimaryButton extends StatelessWidget {
  /// Constructs a [CustomPrimaryButton].
  const CustomPrimaryButton({
    required this.onPressed,
    required this.text,
    super.key,
  });

  /// The callback function to be called when the button is pressed.
  final VoidCallback onPressed;

  /// The text to be displayed on the button.
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.surface,
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
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}
