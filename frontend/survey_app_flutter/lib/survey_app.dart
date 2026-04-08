import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:survey_app_flutter/core/dependency_injection.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_event.dart';
import 'package:survey_app_flutter/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:survey_app_flutter/presentation/authentication/bloc/authentication_state.dart';

import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_routes.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';
import 'package:survey_app_flutter/utils/theme.dart';

final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  usePathUrlStrategy();
  loadDependencies();

  runApp(const SurveyApp());
}

/// The main application widget.
class SurveyApp extends StatelessWidget {
  /// Constructs a [SurveyApp].
  const SurveyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: AppBlocs.authenticationBloc,
      listenWhen: (previous, current) {
        return current.status == AuthenticationStatus.unauthenticated &&
            previous.status != AuthenticationStatus.unauthenticated &&
            previous.token.isNotEmpty;
      },
      listener: (context, state) {
        AppBlocs.adminBloc.add(const AdminStateReset());

        final message = state.logoutMessage;
        if (message != null && message.trim().isNotEmpty) {
          final messenger = _scaffoldMessengerKey.currentState;
          messenger
            ?..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(message),
                behavior: SnackBarBehavior.floating,
              ),
            );
        }

        while (appRouter.canPop()) {
          appRouter.pop();
        }
      },
      child: MaterialApp.router(
        title: AppStrings.appTitle,
        scaffoldMessengerKey: _scaffoldMessengerKey,
        theme: darkThemeData,
        routerConfig: appRouter,
      ),
    );
  }
}
