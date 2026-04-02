import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_bloc.dart';
import 'package:survey_app_flutter/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:survey_app_flutter/presentation/email_list/email_list_builder/bloc/email_list_builder_bloc.dart';
import 'package:survey_app_flutter/presentation/invitations/bloc/invitations_bloc.dart';
import 'package:survey_app_flutter/presentation/question_builder/bloc/question_builder_bloc.dart';
import 'package:survey_app_flutter/presentation/survey_builder/bloc/survey_builder_bloc.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';

/// A widget that provides all necessary Bloc providers for the application.
class BlocProviders extends StatelessWidget {
  /// Constructs a [BlocProviders] widget.
  const BlocProviders({required this.child, super.key});

  /// The child widget that will have access to the provided Blocs.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<QuestionBuilderBloc>.value(
          value: AppBlocs.questionBuilderBloc,
        ),
        BlocProvider<AdminBloc>.value(
          value: AppBlocs.adminBloc,
        ),
        BlocProvider<SurveyBuilderBloc>.value(
          value: AppBlocs.surveyBuilderBloc,
        ),
        BlocProvider<AuthenticationBloc>.value(
          value: AppBlocs.authenticationBloc,
        ),
        BlocProvider<EmailListBuilderBloc>.value(
          value: AppBlocs.emailListBuilderBloc,
        ),
        BlocProvider<InvitationsBloc>.value(
          value: AppBlocs.invitationsBloc,
        ),
      ],
      child: child,
    );
  }
}
