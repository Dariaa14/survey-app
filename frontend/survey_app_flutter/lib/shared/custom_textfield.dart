import 'package:flutter/material.dart';

/// A custom text field widget for the Survey App.
class CustomTextfield extends StatefulWidget {
  /// Constructs a [CustomTextfield].
  const CustomTextfield({
    super.key,
    this.hintText = 'Enter text',
    this.controller,
    this.onChanged,
  });

  /// The placeholder text displayed in the text field
  final String hintText;

  /// Controller for the text field
  final TextEditingController? controller;

  /// Callback when text changes
  final Function(String)? onChanged;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      focusNode: _focusNode,
      controller: widget.controller,
      onChanged: widget.onChanged,
      cursorColor: colorScheme.onSurface,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant.withAlpha(180),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.secondary),
        ),
      ),
      style: TextStyle(color: colorScheme.onSurface),
    );
  }
}
