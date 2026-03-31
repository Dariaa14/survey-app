import 'dart:async';

import 'package:flutter/material.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_textfield.dart';

/// A widget for building individual options in a multiple choice question.
/// Displays a text field with a delete button at the end.
class OptionsBuilder extends StatefulWidget {
  /// Constructs an [OptionsBuilder].
  const OptionsBuilder({
    required this.onDelete,
    required this.onOptionChanged,
    this.initialValue = '',
    super.key,
  });

  /// Callback when the option text changes.
  final Function(String) onOptionChanged;

  /// Callback when the delete button is pressed.
  final VoidCallback onDelete;

  /// The initial text displayed in the option field.
  final String initialValue;

  @override
  State<OptionsBuilder> createState() => _OptionsBuilderState();
}

class _OptionsBuilderState extends State<OptionsBuilder> {
  late final TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant OptionsBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onDebouncedChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      widget.onOptionChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextfield(
              controller: _controller,
              hintText: 'Option text',
              onChanged: (value) {
                _onDebouncedChanged(value);
              },
            ),
          ),
          const SizedBox(width: 12),
          CustomButton(
            onPressed: widget.onDelete,
            child: Icon(
              Icons.delete,
              size: 20,
              color: colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
