import 'package:flutter/material.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';

/// A reusable label container with configurable color variant.
class CustomLabeledContainer extends StatelessWidget {
  /// Constructs a [CustomLabeledContainer].
  const CustomLabeledContainer({
    required this.text,
    this.variant = CustomColorVariant.normal,
    super.key,
  });

  /// Label text shown inside the container.
  final String text;

  /// Color variant used by this container.
  final CustomColorVariant variant;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor(colorScheme, variant),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor(colorScheme, variant)),
      ),
      child: Text(
        text,
        style: textTheme.bodySmall?.copyWith(
          color: textColor(colorScheme, variant),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
