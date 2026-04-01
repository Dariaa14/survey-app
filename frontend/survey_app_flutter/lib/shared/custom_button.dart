import 'package:flutter/material.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';

/// A generic custom button widget for the Survey App.
class CustomButton extends StatelessWidget {
  /// Constructs a [CustomButton].
  const CustomButton({
    required this.onPressed,
    this.text,
    this.child,
    this.isEnabled = true,
    this.variant = CustomColorVariant.normal,
    super.key,
  }) : assert(text != null || child != null);

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// The text displayed on the button.
  final String? text;

  /// Optional custom widget displayed in the button.
  final Widget? child;

  /// Whether the button is enabled for interaction.
  final bool isEnabled;

  /// The visual style variant for the button.
  final CustomColorVariant variant;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDisabled = !isEnabled;

    final variantBackground = backgroundColor(colorScheme, variant);
    final variantForeground = textColor(colorScheme, variant);
    final variantBorder = borderColor(colorScheme, variant);

    final background = isDisabled && variantBackground != null
        ? _toGrayedColor(variantBackground)
        : variantBackground;
    final foreground = isDisabled
        ? _toGrayedColor(variantForeground)
        : variantForeground;
    final border = isDisabled ? _toGrayedColor(variantBorder) : variantBorder;

    return Opacity(
      opacity: isDisabled ? 0.75 : 1,
      child: OutlinedButton(
        onPressed: isEnabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          disabledForegroundColor: foreground,
          disabledBackgroundColor: background,
          side: BorderSide(color: border),
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
                color: foreground,
              ),
            ),
      ),
    );
  }

  Color _toGrayedColor(Color color) {
    return color.withAlpha(200);
  }
}
