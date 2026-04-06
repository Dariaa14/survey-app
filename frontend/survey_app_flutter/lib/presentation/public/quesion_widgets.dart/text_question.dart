import 'package:flutter/material.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/shared/custom_textfield.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Widget for rendering a text question in the survey form.
class TextQuestion extends StatefulWidget {
  /// Constructs a [TextQuestion] widget.
  const TextQuestion({
    required this.question,
    this.initialText = '',
    this.onTextChanged,
    super.key,
  });

  /// The question entity containing the data for this question.
  final QuestionEntity question;

  /// Current text value provided by parent state.
  final String initialText;

  /// Callback when the text input changes.
  final ValueChanged<String>? onTextChanged;

  @override
  State<TextQuestion> createState() => _TextQuestionState();
}

class _TextQuestionState extends State<TextQuestion> {
  late final TextEditingController _controller;

  int get _maxCharacters {
    final maxLength = widget.question.maxLength;
    if (maxLength == null || maxLength <= 0) {
      return 500;
    }

    return maxLength;
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void didUpdateWidget(covariant TextQuestion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialText != widget.initialText &&
        _controller.text != widget.initialText) {
      _controller.value = TextEditingValue(
        text: widget.initialText,
        selection: TextSelection.collapsed(offset: widget.initialText.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    if (value.length <= _maxCharacters) {
      widget.onTextChanged?.call(value);
      setState(() {});
      return;
    }

    final trimmedValue = value.substring(0, _maxCharacters);
    _controller.value = TextEditingValue(
      text: trimmedValue,
      selection: TextSelection.collapsed(offset: trimmedValue.length),
    );
    widget.onTextChanged?.call(trimmedValue);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final writtenCharacters = _controller.text.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        border: Border.all(color: colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: AppStrings.publicQuestionTitle(
                widget.question.order,
                widget.question.title,
              ),
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              children: [
                if (widget.question.required)
                  TextSpan(
                    text: ' *',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          CustomTextfield(
            controller: _controller,
            onChanged: _onTextChanged,
            hintText: AppStrings.publicTextQuestionHint,
            minLines: 6,
            maxLines: 6,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppStrings.publicTextQuestionCharacters(
                writtenCharacters,
                _maxCharacters,
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
