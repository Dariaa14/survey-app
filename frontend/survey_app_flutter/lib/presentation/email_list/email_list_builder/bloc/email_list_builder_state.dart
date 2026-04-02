import 'package:equatable/equatable.dart';
import 'package:survey_app_flutter/domain/entities/email_list_csv_import_result_entity.dart';
import 'package:survey_app_flutter/domain/entities/email_list_entity.dart';

/// Save status for the email list builder feature.
enum EmailListBuilderStatus {
	/// Initial idle state.
	initial,

	/// Save request in progress.
	saving,

	/// Save request succeeded.
	success,

	/// Save request failed.
	failure,
}

/// Status for CSV import workflow.
enum CsvImportStatus {
	/// No CSV action yet.
	idle,

	/// CSV upload in progress.
	uploading,

	/// CSV upload succeeded.
	success,

	/// CSV upload failed.
	failure,
}

/// Bloc state for the email list builder feature.
class EmailListBuilderState extends Equatable {
	/// Creates an [EmailListBuilderState].
	const EmailListBuilderState({
		this.status = EmailListBuilderStatus.initial,
		this.name = '',
		this.createdList,
		this.errorMessage,
		this.csvImportResult,
		this.selectedCsvBytes,
		this.selectedCsvName,
		this.csvImportStatus = CsvImportStatus.idle,
		this.csvImportWasPreview = false,
		this.csvImportErrorMessage,
	});

	/// Current operation status.
	final EmailListBuilderStatus status;

	/// Current name value for the email list.
	final String name;

	/// Created email list after a successful save.
	final EmailListEntity? createdList;

	/// Optional failure message.
	final String? errorMessage;

	/// Parsed backend result for CSV import preview/import.
	final EmailListCsvImportResultEntity? csvImportResult;

	/// Selected CSV bytes for import.
	final List<int>? selectedCsvBytes;

	/// Selected CSV file name.
	final String? selectedCsvName;

	/// Current CSV import workflow status.
	final CsvImportStatus csvImportStatus;

	/// Whether the latest CSV import request was run in preview mode.
	final bool csvImportWasPreview;

	/// Optional CSV import failure message.
	final String? csvImportErrorMessage;

	/// Whether the current form values are valid.
	bool get isFormValid => name.trim().isNotEmpty;

	/// Whether save action can be triggered.
	bool get canSave => isFormValid && status != EmailListBuilderStatus.saving;

	/// Whether CSV import action can be triggered.
	bool get canImportCsv =>
			selectedCsvBytes != null &&
			selectedCsvName != null &&
			csvImportStatus != CsvImportStatus.uploading;

	/// Returns a copy with updated values.
	EmailListBuilderState copyWith({
		EmailListBuilderStatus? status,
		String? name,
		EmailListEntity? createdList,
		String? errorMessage,
		EmailListCsvImportResultEntity? csvImportResult,
		List<int>? selectedCsvBytes,
		String? selectedCsvName,
		CsvImportStatus? csvImportStatus,
		bool? csvImportWasPreview,
		String? csvImportErrorMessage,
	}) {
		return EmailListBuilderState(
			status: status ?? this.status,
			name: name ?? this.name,
			createdList: createdList ?? this.createdList,
			errorMessage: errorMessage ?? this.errorMessage,
			csvImportResult: csvImportResult ?? this.csvImportResult,
			selectedCsvBytes: selectedCsvBytes ?? this.selectedCsvBytes,
			selectedCsvName: selectedCsvName ?? this.selectedCsvName,
			csvImportStatus: csvImportStatus ?? this.csvImportStatus,
			csvImportWasPreview: csvImportWasPreview ?? this.csvImportWasPreview,
			csvImportErrorMessage:
					csvImportErrorMessage ?? this.csvImportErrorMessage,
		);
	}

	/// Returns a copy with specified nullable fields cleared.
	EmailListBuilderState copyWithNull({
		bool nullCreatedList = false,
		bool nullErrorMessage = false,
		bool nullCsvImportResult = false,
		bool nullSelectedCsvBytes = false,
		bool nullSelectedCsvName = false,
		bool nullCsvImportErrorMessage = false,
	}) {
		return EmailListBuilderState(
			status: status,
			name: name,
			createdList: nullCreatedList ? null : createdList,
			errorMessage: nullErrorMessage ? null : errorMessage,
			csvImportResult: nullCsvImportResult ? null : csvImportResult,
			selectedCsvBytes: nullSelectedCsvBytes ? null : selectedCsvBytes,
			selectedCsvName: nullSelectedCsvName ? null : selectedCsvName,
			csvImportStatus: csvImportStatus,
			csvImportWasPreview: csvImportWasPreview,
			csvImportErrorMessage: nullCsvImportErrorMessage
					? null
					: csvImportErrorMessage,
		);
	}

	@override
	List<Object?> get props => [
			status,
			name,
			createdList,
			errorMessage,
			csvImportResult,
			selectedCsvName,
			selectedCsvBytes,
			csvImportStatus,
			csvImportWasPreview,
			csvImportErrorMessage,
		];
}
