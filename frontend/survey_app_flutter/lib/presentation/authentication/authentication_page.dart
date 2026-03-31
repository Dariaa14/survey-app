import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survey_app_flutter/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:survey_app_flutter/presentation/authentication/bloc/authentication_event.dart';
import 'package:survey_app_flutter/presentation/authentication/bloc/authentication_state.dart';
import 'package:survey_app_flutter/presentation/bloc_listeners/bloc_providers.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';
import 'package:survey_app_flutter/shared/custom_textfield.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_routes.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A page that displays the authentication screen.
class AuthenticationPage extends StatefulWidget {
  /// Constructs an [AuthenticationPage].
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocProviders(
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        bloc: AppBlocs.authenticationBloc,
        listener: (context, state) {
          AppBlocs.authenticationBloc
            ..add(const AuthenticationEmailChanged(''))
            ..add(const AuthenticationPasswordChanged(''));

          if (AppBlocs.authenticationBloc.state.isAdmin) {
            context.push(AppRoutes.adminSurveys);
          } else {}
        },
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == AuthenticationStatus.authenticated,
        child: Scaffold(
          body: SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          AppStrings.authTitle,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 32),

                        // Email Text Field
                        CustomTextfield(
                          hintText: AppStrings.emailHint,
                          controller: _emailController,
                          onChanged: (value) {
                            AppBlocs.authenticationBloc.add(
                              AuthenticationEmailChanged(value),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password Text Field
                        CustomTextfield(
                          hintText: AppStrings.passwordHint,
                          controller: _passwordController,
                          onChanged: (value) {
                            AppBlocs.authenticationBloc.add(
                              AuthenticationPasswordChanged(value),
                            );
                          },
                        ),
                        const SizedBox(height: 32),

                        Row(
                          children: [
                            // Sign Up Button
                            CustomButton(
                              onPressed: () {},
                              text: AppStrings.noAccountButton,
                            ),

                            const SizedBox(width: 16),
                            // Login Button
                            CustomButton(
                              text: AppStrings.loginButton,
                              onPressed: () {
                                AppBlocs.authenticationBloc.add(
                                  const AuthenticationLoginSubmitted(),
                                );
                              },
                              variant: CustomColorVariant.primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        /// Error message display
                        BlocBuilder<AuthenticationBloc, AuthenticationState>(
                          bloc: AppBlocs.authenticationBloc,
                          builder: (context, state) {
                            if (state.errorMessage != null) {
                              return Text(
                                state.errorMessage ?? 'Login failed',
                                style: TextStyle(
                                  color: colorScheme.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
