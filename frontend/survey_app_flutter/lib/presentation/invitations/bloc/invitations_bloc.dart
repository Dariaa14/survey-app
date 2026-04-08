import 'package:bloc/bloc.dart';
import 'package:survey_app_flutter/domain/entities/invitation_entity.dart';
import 'package:survey_app_flutter/domain/use_cases/survey_use_case.dart';
import 'package:survey_app_flutter/domain/use_cases/user_use_case.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_event.dart';
import 'package:survey_app_flutter/presentation/invitations/bloc/invitations_event.dart';
import 'package:survey_app_flutter/presentation/invitations/bloc/invitations_state.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';

/// Bloc for managing the state of the invitations page.
class InvitationsBloc extends Bloc<InvitationsEvent, InvitationsState> {
  /// Constructs an [InvitationsBloc] with the required use cases.
  InvitationsBloc(this._surveyUseCase, this._userUseCase)
    : super(const InvitationsState()) {
    on<InvitationsContactListSelected>(_onInvitationsContactListSelected);
    on<LoadSurveyInvitations>(_onLoadSurveyInvitations);
    on<LoadInvitationPreview>(_onLoadInvitationPreview);
    on<SendInvitations>(_onSendInvitations);
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
    final isFilteredRequest =
        event.query != null && event.query!.trim().isNotEmpty;

    final token = await _userUseCase.getAuthToken();
    if (token == null || token.isEmpty) {
      emit(
        state.copyWith(
          invitations: const <InvitationEntity>[],
          totalInvitationsCount: isFilteredRequest
              ? state.totalInvitationsCount
              : 0,
        ),
      );
      return;
    }

    final invitations = await _surveyUseCase.getInvitations(
      token: token,
      surveyId: event.survey.id,
      query: event.query,
    );

    emit(
      state.copyWith(
        invitations: invitations,
        totalInvitationsCount: isFilteredRequest
            ? state.totalInvitationsCount
            : invitations.length,
      ),
    );
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

  /// Sends invitations for the currently selected email list.
  Future<void> _onSendInvitations(
    SendInvitations event,
    Emitter<InvitationsState> emit,
  ) async {
    final selectedEmailList = state.selectedEmailList;
    if (selectedEmailList == null || state.invitationPreview == null) {
      return;
    }

    final token = await _userUseCase.getAuthToken();
    if (token == null || token.isEmpty) {
      return;
    }

    emit(state.copyWith(isSendingInvitations: true));

    try {
      await _surveyUseCase.sendInvitations(
        token: token,
        surveyId: event.survey.id,
        listId: selectedEmailList.id,
      );

      final invitations = await _surveyUseCase.getInvitations(
        token: token,
        surveyId: event.survey.id,
      );

      emit(
        state
            .copyWith(
              invitations: invitations,
              totalInvitationsCount: invitations.length,
            )
            .copyWithNull(
              nullInvitationPreview: true,
              nullIsSendingInvitations: true,
            ),
      );

      AppBlocs.adminBloc.add(const AdminSurveysRefreshed());
    } finally {
      emit(state.copyWith(isSendingInvitations: false));
    }
  }
}
