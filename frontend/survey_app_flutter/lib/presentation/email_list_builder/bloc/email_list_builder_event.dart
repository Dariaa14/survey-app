/// This file contains the events for the email list builder feature
abstract class EmailListBuilderEvent {
	/// Creates an [EmailListBuilderEvent].
	const EmailListBuilderEvent();
}

/// Triggered when the email list name text changes.
class EmailListNameChanged extends EmailListBuilderEvent {
	/// The updated name value.
	final String name;

	/// Creates [EmailListNameChanged].
	const EmailListNameChanged(this.name);
}

/// Triggered when user requests creating a new email list.
class EmailListCreateRequested extends EmailListBuilderEvent {
	/// Creates [EmailListCreateRequested].
	const EmailListCreateRequested();
}

/// Triggered to clear transient success/error status while keeping form values.
class EmailListBuilderStatusReset extends EmailListBuilderEvent {
	/// Creates [EmailListBuilderStatusReset].
	const EmailListBuilderStatusReset();
}

/// Triggered when user wants to pick a CSV file for import.
class CsvImportFilePickRequested extends EmailListBuilderEvent {
  /// Target email list id.
  final String listId;

	/// Creates [CsvImportFilePickRequested].
	const CsvImportFilePickRequested(this.listId);
}

/// Triggered when user requests importing currently selected CSV.
class CsvImportRequested extends EmailListBuilderEvent {
	/// Target email list id.
	final String listId;

	/// Whether import should run in preview mode only.
	final bool preview;

	/// Creates [CsvImportRequested].
	const CsvImportRequested(this.listId, {required this.preview});
}

/// Triggered to clear CSV import transient state.
class CsvImportStateReset extends EmailListBuilderEvent {
	/// Creates [CsvImportStateReset].
	const CsvImportStateReset();
}
