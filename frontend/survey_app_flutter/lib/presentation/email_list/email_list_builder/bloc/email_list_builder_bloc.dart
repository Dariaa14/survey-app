import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:survey_app_flutter/domain/use_cases/email_list_use_case.dart';
import 'package:survey_app_flutter/domain/use_cases/user_use_case.dart';
import 'package:survey_app_flutter/presentation/email_list/email_list_builder/bloc/email_list_builder_event.dart';
import 'package:survey_app_flutter/presentation/email_list/email_list_builder/bloc/email_list_builder_state.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Bloc for the email list builder feature
class EmailListBuilderBloc
    extends Bloc<EmailListBuilderEvent, EmailListBuilderState> {
  final EmailListUseCase _emailListUseCase;
  final UserUseCase _userUseCase;

  /// Constructs an [EmailListBuilderBloc] with the initial state of [EmailListBuilderState].
  EmailListBuilderBloc({
    required EmailListUseCase emailListUseCase,
    required UserUseCase userUseCase,
  }) : _emailListUseCase = emailListUseCase,
       _userUseCase = userUseCase,
       super(const EmailListBuilderState()) {
    on<EmailListNameChanged>(_onNameChanged);
    on<EmailListCreateRequested>(_onCreateRequested);
    on<EmailListBuilderStatusReset>(_onStatusReset);
    on<CsvImportFilePickRequested>(_onCsvFilePickRequested);
    on<CsvImportRequested>(_onCsvImportRequested);
    on<CsvImportStateReset>(_onCsvImportStateReset);
    on<EmailListContactDeleteRequested>(_onContactDeleteRequested);
  }

  void _onNameChanged(
    EmailListNameChanged event,
    Emitter<EmailListBuilderState> emit,
  ) {
    emit(
      state
          .copyWith(name: event.name)
          .copyWithNull(nullErrorMessage: true, nullCreatedList: true),
    );
  }

  Future<void> _onCreateRequested(
    EmailListCreateRequested event,
    Emitter<EmailListBuilderState> emit,
  ) async {
    if (!state.isFormValid) {
      emit(
        state.copyWith(
          status: EmailListBuilderStatus.failure,
          errorMessage: 'Email list name is required.',
        ),
      );
      return;
    }

    emit(
      state
          .copyWith(status: EmailListBuilderStatus.saving)
          .copyWithNull(nullErrorMessage: true),
    );

    try {
      final user = await _userUseCase.getCurrentUser();
      final token = await _userUseCase.getAuthToken();

      if (token == null || token.isEmpty) {
        throw Exception('No auth token available.');
      }

      final created = await _emailListUseCase.createEmailList(
        token: token,
        ownerId: user.id,
        name: state.name.trim(),
      );

      emit(
        state
            .copyWith(
              status: EmailListBuilderStatus.success,
              createdList: created,
            )
            .copyWithNull(nullErrorMessage: true),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: EmailListBuilderStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onStatusReset(
    EmailListBuilderStatusReset event,
    Emitter<EmailListBuilderState> emit,
  ) {
    emit(
      state
          .copyWith(status: EmailListBuilderStatus.initial)
          .copyWithNull(nullErrorMessage: true, nullCreatedList: true),
    );
  }

  Future<void> _onCsvFilePickRequested(
    CsvImportFilePickRequested event,
    Emitter<EmailListBuilderState> emit,
  ) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const <String>['csv'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    final file = result.files.single;
    final bytes = file.bytes;

    if (bytes == null) {
      emit(
        state.copyWith(
          csvImportStatus: CsvImportStatus.failure,
          csvImportErrorMessage: AppStrings.csvImportReadFileErrorMessage,
        ),
      );
      return;
    }

    emit(
      state
          .copyWith(
            selectedCsvBytes: bytes,
            selectedCsvName: file.name,
            csvImportStatus: CsvImportStatus.idle,
            csvImportWasPreview: true,
          )
          .copyWithNull(
            nullCsvImportErrorMessage: true,
            nullCsvImportResult: true,
          ),
    );

    add(CsvImportRequested(event.listId, preview: true));
  }

  Future<void> _onCsvImportRequested(
    CsvImportRequested event,
    Emitter<EmailListBuilderState> emit,
  ) async {
    if (!state.canImportCsv) {
      return;
    }

    emit(
      state
          .copyWith(csvImportStatus: CsvImportStatus.uploading)
          .copyWithNull(nullCsvImportErrorMessage: true),
    );

    try {
      final token = await _userUseCase.getAuthToken();
      if (token == null || token.isEmpty) {
        throw Exception(AppStrings.csvImportMissingTokenMessage);
      }

      final result = await _emailListUseCase.importContactsCsv(
        token: token,
        listId: event.listId,
        fileName: state.selectedCsvName!,
        csvBytes: state.selectedCsvBytes!,
        preview: event.preview,
      );

      emit(
        state
            .copyWith(
              csvImportStatus: CsvImportStatus.success,
              csvImportWasPreview: event.preview,
              csvImportResult: result,
            )
            .copyWithNull(nullCsvImportErrorMessage: true),
      );
    } catch (e) {
      emit(
        state.copyWith(
          csvImportStatus: CsvImportStatus.failure,
          csvImportErrorMessage: e.toString(),
        ),
      );
    }
  }

  void _onCsvImportStateReset(
    CsvImportStateReset event,
    Emitter<EmailListBuilderState> emit,
  ) {
    emit(
      state
          .copyWith(
            csvImportStatus: CsvImportStatus.idle,
            csvImportWasPreview: false,
          )
          .copyWithNull(
            nullSelectedCsvName: true,
            nullSelectedCsvBytes: true,
            nullCsvImportErrorMessage: true,
            nullCsvImportResult: true,
          ),
    );
  }

  Future<void> _onContactDeleteRequested(
    EmailListContactDeleteRequested event,
    Emitter<EmailListBuilderState> emit,
  ) async {
    emit(
      state
          .copyWith(deletingContactId: event.contactId)
          .copyWithNull(
            nullDeletedContactId: true,
            nullDeleteFailedContactId: true,
            nullContactDeleteErrorMessage: true,
          ),
    );

    try {
      final token = await _userUseCase.getAuthToken();
      if (token == null || token.isEmpty) {
        throw Exception(AppStrings.csvImportMissingTokenMessage);
      }

      await _emailListUseCase.deleteContact(
        token: token,
        listId: event.listId,
        contactId: event.contactId,
      );

      emit(
        state
            .copyWith(deletedContactId: event.contactId)
            .copyWithNull(
              nullDeletingContactId: true,
              nullDeleteFailedContactId: true,
              nullContactDeleteErrorMessage: true,
            ),
      );
    } catch (e) {
      emit(
        state
            .copyWith(
              deleteFailedContactId: event.contactId,
              contactDeleteErrorMessage: e.toString(),
            )
            .copyWithNull(
              nullDeletingContactId: true,
              nullDeletedContactId: true,
            ),
      );
    }
  }
}
