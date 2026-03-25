import 'package:flutter/material.dart';

/// A custom inverted gray button widget for the Survey App.
class CustomInvertedGrayButton extends StatelessWidget {
  /// Constructs a [CustomInvertedGrayButton].
  const CustomInvertedGrayButton({
    required this.onPressed,
    required this.text,
    super.key,
  });

  /// Callback when the button is pressed
  final VoidCallback onPressed;

  /// The text displayed on the button
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainer,
        side: BorderSide(color: colorScheme.outline),
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
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
