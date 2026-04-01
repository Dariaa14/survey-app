import 'package:equatable/equatable.dart';
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

/// Bloc state for the email list builder feature.
class EmailListBuilderState extends Equatable {
	/// Creates an [EmailListBuilderState].
	const EmailListBuilderState({
		this.status = EmailListBuilderStatus.initial,
		this.name = '',
		this.createdList,
		this.errorMessage,
	});

	/// Current operation status.
	final EmailListBuilderStatus status;

	/// Current name value for the email list.
	final String name;

	/// Created email list after a successful save.
	final EmailListEntity? createdList;

	/// Optional failure message.
	final String? errorMessage;

	/// Whether the current form values are valid.
	bool get isFormValid => name.trim().isNotEmpty;

	/// Whether save action can be triggered.
	bool get canSave => isFormValid && status != EmailListBuilderStatus.saving;

	/// Returns a copy with updated values.
	EmailListBuilderState copyWith({
		EmailListBuilderStatus? status,
		String? name,
		EmailListEntity? createdList,
		String? errorMessage,
	}) {
		return EmailListBuilderState(
			status: status ?? this.status,
			name: name ?? this.name,
			createdList: createdList ?? this.createdList,
			errorMessage: errorMessage ?? this.errorMessage,
		);
	}

	/// Returns a copy with specified nullable fields cleared.
	EmailListBuilderState copyWithNull({
		bool nullCreatedList = false,
		bool nullErrorMessage = false,
	}) {
		return EmailListBuilderState(
			status: status,
			name: name,
			createdList: nullCreatedList ? null : createdList,
			errorMessage: nullErrorMessage ? null : errorMessage,
		);
	}

	@override
	List<Object?> get props => [status, name, createdList, errorMessage];
}
