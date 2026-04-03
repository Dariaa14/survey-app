import 'package:bloc/bloc.dart';
import 'package:survey_app_flutter/domain/use_cases/survey_use_case.dart';
import 'package:survey_app_flutter/presentation/public/bloc/public_event.dart';
import 'package:survey_app_flutter/presentation/public/bloc/public_state.dart';

/// Bloc for managing the state of the public survey page.
class PublicBloc extends Bloc<PublicEvent, PublicState> {
  /// Constructs a [PublicBloc] with the required survey use case.
  PublicBloc(this._surveyUseCase) : super(const PublicState()) {
    on<PublicSurveyRequested>(_onPublicSurveyRequested);
  }

  final SurveyUseCase _surveyUseCase;

  Future<void> _onPublicSurveyRequested(
    PublicSurveyRequested event,
    Emitter<PublicState> emit,
  ) async {
    final trimmedSlug = event.slug.trim();
    final trimmedToken = event.token.trim();

    if (trimmedSlug.isEmpty || trimmedToken.isEmpty) {
      emit(
        state
            .copyWith(
              isLoading: false,
              errorMessage: 'Missing survey slug or token.',
            )
            .copyWithNull(nullSurvey: true),
      );
      return;
    }

    emit(
      state.copyWith(isLoading: true).copyWithNull(nullErrorMessage: true),
    );

    try {
      final survey = await _surveyUseCase.getPublicSurveyBySlug(
        slug: trimmedSlug,
        token: trimmedToken,
      );

      emit(
        state
            .copyWith(
              isLoading: false,
              survey: survey,
            )
            .copyWithNull(nullErrorMessage: true),
      );
    } catch (_) {
      emit(
        state
            .copyWith(
              isLoading: false,
              errorMessage: 'Could not load survey. Please check the link.',
            )
            .copyWithNull(nullSurvey: true),
      );
    }
  }
}
