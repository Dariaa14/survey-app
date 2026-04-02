import 'package:bloc/bloc.dart';
import 'package:survey_app_flutter/domain/entities/invitation_entity.dart';
import 'package:survey_app_flutter/domain/use_cases/survey_use_case.dart';
import 'package:survey_app_flutter/domain/use_cases/user_use_case.dart';
import 'package:survey_app_flutter/presentation/invitations/bloc/invitations_event.dart';
import 'package:survey_app_flutter/presentation/invitations/bloc/invitations_state.dart';

/// Bloc for managing the state of the invitations page.
class InvitationsBloc extends Bloc<InvitationsEvent, InvitationsState> {
  /// Constructs an [InvitationsBloc] with the required use cases.
  InvitationsBloc(this._surveyUseCase, this._userUseCase)
    : super(const InvitationsState()) {
    on<InvitationsContactListSelected>(_onInvitationsContactListSelected);
    on<LoadSurveyInvitations>(_onLoadSurveyInvitations);
    on<LoadInvitationPreview>(_onLoadInvitationPreview);
  }

  final SurveyUseCase _surveyUseCase;
  final UserUseCase _userUseCase;

  /// Handler for the [InvitationsContactListSelected] event, updates the selected email list in the state.
  void _onInvitationsContactListSelected(
    InvitationsContactListSelected event,
    Emitter<InvitationsState> emit,
  ) {
    if (event.emailList == null) {
      emit(
        state.copyWithNull(
          nullInvitationPreview: true,
          nullSelectedEmailList: true,
        ),
      );
      return;
    }
    emit(
      state
          .copyWith(
            selectedEmailList: event.emailList,
          )
          .copyWithNull(nullInvitationPreview: true),
    );
  }

  /// Loads invitations for the provided survey.
  Future<void> _onLoadSurveyInvitations(
    LoadSurveyInvitations event,
    Emitter<InvitationsState> emit,
  ) async {
    final token = await _userUseCase.getAuthToken();
    if (token == null || token.isEmpty) {
      emit(state.copyWith(invitations: const <InvitationEntity>[]));
      return;
    }

    final invitations = await _surveyUseCase.getInvitations(
      token: token,
      surveyId: event.survey.id,
    );

    emit(state.copyWith(invitations: invitations));
  }

  /// Loads a preview for the currently selected email list.
  Future<void> _onLoadInvitationPreview(
    LoadInvitationPreview event,
    Emitter<InvitationsState> emit,
  ) async {
    final selectedEmailList = state.selectedEmailList;
    if (selectedEmailList == null) {
      emit(state.copyWithNull(nullInvitationPreview: true));
      return;
    }

    final token = await _userUseCase.getAuthToken();
    if (token == null || token.isEmpty) {
      emit(state.copyWithNull(nullInvitationPreview: true));
      return;
    }

    final preview = await _surveyUseCase.previewInvitations(
      token: token,
      surveyId: event.survey.id,
      listId: selectedEmailList.id,
    );

    emit(state.copyWith(invitationPreview: preview));
  }
}
