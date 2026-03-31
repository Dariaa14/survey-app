import 'dart:async';

import 'package:flutter/material.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';
import 'package:survey_app_flutter/presentation/question_builder/bloc/question_builder_event.dart';
import 'package:survey_app_flutter/presentation/question_builder/question_builder_page.dart';
import 'package:survey_app_flutter/presentation/survey_builder/bloc/survey_builder_event.dart';
import 'package:survey_app_flutter/presentation/survey_builder/bloc/survey_builder_state.dart';
import 'package:survey_app_flutter/presentation/survey_builder/sections/questions_widgets/add_question_dashed_button.dart';
import 'package:survey_app_flutter/presentation/survey_builder/sections/questions_widgets/question_preview.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A widget that displays the questions section of the survey builder page.
class SurveyBuilderQuestionsSection extends StatefulWidget {
  /// Constructs a [SurveyBuilderQuestionsSection].
  const SurveyBuilderQuestionsSection({
    required this.questions,
    this.expand = true,
    super.key,
  });

  /// Number of currently added questions.
  final List<QuestionEntity> questions;

  /// Whether the section should occupy remaining horizontal space in a Row.
  final bool expand;

  @override
  State<SurveyBuilderQuestionsSection> createState() =>
      _SurveyBuilderQuestionsSectionState();
}

class _SurveyBuilderQuestionsSectionState
    extends State<SurveyBuilderQuestionsSection> {
  late List<QuestionEntity> _visibleQuestions;
  StreamSubscription<SurveyBuilderState>? _questionsSubscription;
  bool _awaitingBlocReorderSync = false;

  @override
  void initState() {
    super.initState();
    _visibleQuestions = List<QuestionEntity>.from(widget.questions);
    _questionsSubscription = AppBlocs.surveyBuilderBloc.stream.listen((state) {
      if (!mounted) {
        return;
      }

      if (_hasSameIdentityOrder(state.questions, _visibleQuestions)) {
        return;
      }

      setState(() {
        _visibleQuestions = List<QuestionEntity>.from(state.questions);
        _awaitingBlocReorderSync = false;
      });
    });
  }

  @override
  void dispose() {
    _questionsSubscription?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SurveyBuilderQuestionsSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_awaitingBlocReorderSync) {
      if (_hasSameIdentityOrder(widget.questions, _visibleQuestions)) {
        _awaitingBlocReorderSync = false;
      }
      return;
    }

    _visibleQuestions = List<QuestionEntity>.from(widget.questions);
  }

  bool _hasSameIdentityOrder(
    List<QuestionEntity> a,
    List<QuestionEntity> b,
  ) {
    if (a.length != b.length) {
      return false;
    }

    for (var i = 0; i < a.length; i++) {
      if (!identical(a[i], b[i])) {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${AppStrings.questionsTitle} (${_visibleQuestions.length})',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.end,
              children: [
                CustomButton(
                  onPressed: () => _showAddQuestionDialog(context),
                  text: '+ ${AppStrings.multiChoiceTab}',
                ),
                CustomButton(
                  onPressed: () =>
                      _showAddQuestionDialog(context, isMultiChoice: false),
                  text: '+ ${AppStrings.freeTextTab}',
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: _visibleQuestions.length,
          onReorder: (oldIndex, newIndex) {
            var targetIndex = newIndex;
            if (newIndex > oldIndex) {
              targetIndex -= 1;
            }

            if (oldIndex == targetIndex) {
              return;
            }

            setState(() {
              final moved = _visibleQuestions.removeAt(oldIndex);
              _visibleQuestions.insert(targetIndex, moved);
              _awaitingBlocReorderSync = true;
            });

            AppBlocs.surveyBuilderBloc.add(
              ReorderQuestions(oldIndex: oldIndex, newIndex: targetIndex),
            );
          },
          itemBuilder: (context, index) {
            final q = _visibleQuestions[index];
            return Padding(
              key: ObjectKey(q),
              padding: const EdgeInsets.only(bottom: 12),
              child: QuestionPreview(
                question: q,
                onEdit: () => _showAddQuestionDialog(context, question: q),
                dragHandle: ReorderableDragStartListener(
                  index: index,
                  child: Icon(
                    Icons.drag_indicator,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        AddQuestionDashedButton(
          onTap: () => _showAddQuestionDialog(context),
        ),
      ],
    );

    if (!widget.expand) {
      return content;
    }

    return Expanded(child: content);
  }

  Future<void> _showAddQuestionDialog(
    BuildContext context, {
    bool isMultiChoice = true,
    QuestionEntity? question,
  }) async {
    final newQuestion = await showDialog<QuestionEntity?>(
      context: context,
      builder: (context) => QuestionBuilderPage(
        orderNumber: widget.questions.length + 1,
        initialIsMultiChoiceSelected: isMultiChoice,
        question: question,
      ),
    );

    AppBlocs.questionBuilderBloc.add(QuestionBuilderReset());
    if (newQuestion == null) return;

    if (question != null) {
      /// TODO: add edit question functionality instead of just adding a
      /// new question when editing an existing one
      return;
    }
    AppBlocs.surveyBuilderBloc.add(AddQuestion(newQuestion));
  }
}
