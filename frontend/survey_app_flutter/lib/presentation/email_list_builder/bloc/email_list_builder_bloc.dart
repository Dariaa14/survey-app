import 'package:bloc/bloc.dart';
import 'package:survey_app_flutter/presentation/email_list_builder/bloc/email_list_builder_event.dart';
import 'package:survey_app_flutter/presentation/email_list_builder/bloc/email_list_builder_state.dart';

/// Bloc for the email list builder feature
class EmailListBuilderBloc
    extends Bloc<EmailListBuilderEvent, EmailListBuilderState> {
  /// Constructs an [EmailListBuilderBloc] with the initial state of [EmailListBuilderState].
  EmailListBuilderBloc() : super(EmailListBuilderState()) {}
}
