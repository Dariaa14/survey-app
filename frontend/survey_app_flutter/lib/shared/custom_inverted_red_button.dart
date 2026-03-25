import 'package:flutter/material.dart';
import 'package:survey_app_flutter/utils/theme.dart';

/// A custom inverted red button widget for the Survey App.
class CustomInvertedRedButton extends StatelessWidget {
  /// Constructs a [CustomInvertedRedButton].
  const CustomInvertedRedButton({
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
        backgroundColor: redContainer,
        side: BorderSide(color: colorScheme.error),
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
          color: colorScheme.error,
        ),
      ),
    );
  }
}
