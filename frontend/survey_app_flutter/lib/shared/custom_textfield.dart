import 'package:flutter/material.dart';

/// A custom text field widget for the Survey App.
class CustomTextfield extends StatefulWidget {
  /// Constructs a [CustomTextfield].
  const CustomTextfield({
    super.key,
    this.hintText = 'Enter text',
    this.controller,
    this.onChanged,
    this.readOnly = false,
    this.textColor,
    this.minLines,
    this.maxLines = 1,
    this.showScrollbar = false,
  });

  /// The placeholder text displayed in the text field
  final String hintText;

  /// Controller for the text field
  final TextEditingController? controller;

  /// Callback when text changes
  final Function(String)? onChanged;

  /// Whether the text field can only be read.
  final bool readOnly;

  /// Optional text color for the input content.
  final Color? textColor;

  /// Minimum number of visible lines for the text field.
  final int? minLines;

  /// Maximum number of visible lines for the text field.
  final int? maxLines;

  /// Whether to show a scrollbar for the text field content.
  final bool showScrollbar;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  late FocusNode _focusNode;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      focusNode: _focusNode,
      controller: widget.controller,
      onChanged: widget.readOnly ? null : widget.onChanged,
      readOnly: widget.readOnly,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      scrollController: _scrollController,
      keyboardType: widget.maxLines == null || (widget.maxLines ?? 1) > 1
          ? TextInputType.multiline
          : TextInputType.text,
      textInputAction: widget.maxLines == null || (widget.maxLines ?? 1) > 1
          ? TextInputAction.newline
          : TextInputAction.done,
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
      style: TextStyle(color: widget.textColor ?? colorScheme.onSurface),
    );
  }
}
