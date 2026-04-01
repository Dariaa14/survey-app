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
