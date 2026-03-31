import 'package:equatable/equatable.dart';
import 'package:survey_app_flutter/domain/entities/option_entity.dart';
import 'package:survey_app_flutter/domain/entities/question_entity.dart';

/// This file defines the state for the QuestionBuilderBloc, which manages
/// the state of the question builder feature in the survey app.
class QuestionBuilderState extends Equatable {
  /// The type of the question being built (e.g., text, multiple choice).
  final QuestionType type;

  /// The current title of the question being built.
  final String title;

  /// Whether the question is required or optional.
  final bool required;

  /// The maximum length of the answer for text questions (optional).
  final int? maxLength;

  /// The maximum number of selections allowed for multiple choice questions
  /// (optional).
  final int? maxSelections;

  /// The list of options for multiple choice questions (optional).
  final List<OptionEntity> options;

  /// Order number of the question being edited, used for display purposes.
  final int orderNumber;

  /// Creates a [QuestionBuilderState] with the given parameters.
  const QuestionBuilderState({
    this.type = QuestionType.text,
    this.title = '',
    this.required = false,
    this.maxLength,
    this.maxSelections,
    this.orderNumber = 0,
    this.options = const [],
  });

  /// Creates a copy of the current state with optional new values.
  QuestionBuilderState copyWith({
    QuestionType? type,
    String? title,
    bool? required,
    int? maxLength,
    int? maxSelections,
    List<OptionEntity>? options,
    int? orderNumber,
  }) {
    return QuestionBuilderState(
      type: type ?? this.type,
      title: title ?? this.title,
      required: required ?? this.required,
      maxLength: maxLength ?? this.maxLength,
      maxSelections: maxSelections ?? this.maxSelections,
      options: options ?? this.options,
      orderNumber: orderNumber ?? this.orderNumber,
    );
  }

  /// Creates a copy of the current state with specified fields set to null.
  QuestionBuilderState copyWithNull({
    bool nullMaxLength = false,
    bool nullMaxSelections = false,
  }) {
    return QuestionBuilderState(
      type: type,
      title: title,
      required: required,
      maxLength: nullMaxLength ? null : maxLength,
      maxSelections: nullMaxSelections ? null : maxSelections,
      options: options,
      orderNumber: orderNumber,
    );
  }

  @override
  List<Object?> get props => [
    type,
    title,
    required,
    maxLength,
    maxSelections,
    options,
    orderNumber,
  ];
}
