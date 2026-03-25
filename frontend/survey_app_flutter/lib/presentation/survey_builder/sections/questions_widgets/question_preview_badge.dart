import 'package:flutter/material.dart';
import 'package:survey_app_flutter/presentation/survey_builder/sections/questions_widgets/question_preview_data.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';
import 'package:survey_app_flutter/shared/custom_labeled_container.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Badge variants used in question preview.
enum QuestionPreviewBadgeType {
  /// Question type badge for multiple-choice questions.
  multiChoice,

  /// Question type badge for free-text questions.
  text,

  /// Requirement badge for required questions.
  required,

  /// Requirement badge for optional questions.
  optional,
}

/// A question preview badge with theme-based colors.
class QuestionPreviewBadge extends StatelessWidget {
  /// Constructs a [QuestionPreviewBadge] from an explicit badge type.
  const QuestionPreviewBadge({
    required this.type,
    super.key,
  });

  /// Factory for creating a type badge from [QuestionType].
  factory QuestionPreviewBadge.forQuestionType(QuestionType questionType) {
    return QuestionPreviewBadge(
      type: questionType == QuestionType.multipleChoice
          ? QuestionPreviewBadgeType.multiChoice
          : QuestionPreviewBadgeType.text,
    );
  }

  /// Factory for creating required/optional badge.
  factory QuestionPreviewBadge.forRequirement({required bool isRequired}) {
    return QuestionPreviewBadge(
      type: isRequired
          ? QuestionPreviewBadgeType.required
          : QuestionPreviewBadgeType.optional,
    );
  }

  /// The badge type used to determine label and colors.
  final QuestionPreviewBadgeType type;

  @override
  Widget build(BuildContext context) {
    final (label, variant) = switch (type) {
      QuestionPreviewBadgeType.multiChoice => (
        AppStrings.multiChoiceTab.toLowerCase(),
        CustomColorVariant.invertedTertiary,
      ),
      QuestionPreviewBadgeType.text => (
        AppStrings.freeTextTab.toLowerCase(),
        CustomColorVariant.invertedSecondary,
      ),
      QuestionPreviewBadgeType.required => (
        AppStrings.requiredLabel.toLowerCase(),
        CustomColorVariant.inversePrimary,
      ),
      QuestionPreviewBadgeType.optional => (
        AppStrings.optionalLabel.toLowerCase(),
        CustomColorVariant.gray,
      ),
    };

    return CustomLabeledContainer(
      text: label,
      variant: variant,
    );
  }
}
