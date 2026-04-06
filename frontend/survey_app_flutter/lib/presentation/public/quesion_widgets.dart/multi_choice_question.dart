import 'package:flutter/material.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Widget for displaying a multiple choice question in the survey builder.
class MultiChoiceQuestion extends StatefulWidget {
  /// Constructs a [MultiChoiceQuestion].
  const MultiChoiceQuestion({
    required this.question,
    this.onSelectionChanged,
    super.key,
  });

  /// The question entity containing the data for this question.
  final QuestionEntity question;

  /// Callback when the selected options change.
  final ValueChanged<Set<int>>? onSelectionChanged;

  @override
  State<MultiChoiceQuestion> createState() => _MultiChoiceQuestionState();
}

class _MultiChoiceQuestionState extends State<MultiChoiceQuestion> {
  final Set<int> _selectedIndexes = <int>{};

  void _onOptionToggled(int index, bool selected) {
    final int maxSelections = widget.question.maxSelections ?? 1;

    setState(() {
      if (selected) {
        if (_selectedIndexes.length >= maxSelections) {
          return;
        }

        _selectedIndexes.add(index);
      } else {
        _selectedIndexes.remove(index);
      }

      widget.onSelectionChanged?.call(Set<int>.from(_selectedIndexes));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final options = widget.question.options ?? const [];
    final maxSelections = widget.question.maxSelections ?? 1;
    final selectedCount = _selectedIndexes.length;

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
          const SizedBox(height: 6),
          Text(
            maxSelections == 1
                ? AppStrings.publicSelectSingleOption(maxSelections)
                : AppStrings.publicSelectMaxOptions(maxSelections),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          Column(
            children: List.generate(options.length, (index) {
              final option = options[index];
              final isSelected = _selectedIndexes.contains(index);
              final isDisabled = !isSelected && selectedCount >= maxSelections;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: isDisabled
                      ? null
                      : () => _onOptionToggled(index, !isSelected),
                  borderRadius: BorderRadius.circular(10),
                  child: Opacity(
                    opacity: isDisabled ? 0.5 : 1.0,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.secondaryContainer
                            : colorScheme.surfaceContainer,
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.secondary
                              : colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: isDisabled
                                ? null
                                : (value) =>
                                      _onOptionToggled(index, value ?? false),
                            activeColor: colorScheme.secondary,
                            checkColor: colorScheme.onSecondary,
                            fillColor: WidgetStateProperty.resolveWith<Color>(
                              (states) {
                                if (states.contains(WidgetState.disabled)) {
                                  return colorScheme.surfaceContainerHighest;
                                }

                                if (states.contains(WidgetState.selected)) {
                                  return colorScheme.secondary;
                                }

                                return colorScheme.surface;
                              },
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? colorScheme.secondary
                                  : colorScheme.outline,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              option.label,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          if (selectedCount > 0) ...[
            const SizedBox(height: 4),
            Text(
              AppStrings.publicSelectionsUsed(selectedCount, maxSelections),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
