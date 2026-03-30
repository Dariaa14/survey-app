import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_bloc.dart';
import 'package:survey_app_flutter/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';

/// A widget that provides all necessary Bloc providers for the application.
class BlocProviders extends StatelessWidget {
  /// Constructs a [BlocProviders] widget.
  const BlocProviders({required this.child, super.key});

  /// The child widget that will have access to the provided Blocs.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminBloc>.value(
      value: AppBlocs.adminBloc,
      child: BlocProvider<AuthenticationBloc>.value(
        value: AppBlocs.authenticationBloc,
        child: child,
      ),
    );
  }
}
