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
    super.key,
  });

  /// Callback when the option text changes.
  final Function(String) onOptionChanged;

  /// Callback when the delete button is pressed.
  final VoidCallback onDelete;

  @override
  State<OptionsBuilder> createState() => _OptionsBuilderState();
}

class _OptionsBuilderState extends State<OptionsBuilder> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                widget.onOptionChanged(value);
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
