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
import 'package:survey_app_flutter/utils/app_strings.dart';

///// A page that displays the registration screen.
class RegistrationPage extends StatefulWidget {
  /// Constructs a [RegistrationPage].
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

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
        listenWhen: (previous, current) =>
            previous.registrationCompleted != current.registrationCompleted &&
            current.registrationCompleted,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(AppStrings.registrationSuccessMessage),
            ),
          );
          AppBlocs.authenticationBloc
            ..add(const AuthenticationPasswordChanged(''))
            ..add(const AuthenticationRegistrationCleared());
          context.pop();
        },
        child: Scaffold(
          body: SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.registrationTitle,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 24),
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
                        CustomTextfield(
                          hintText: AppStrings.passwordHint,
                          controller: _passwordController,
                          onChanged: (value) {
                            AppBlocs.authenticationBloc.add(
                              AuthenticationPasswordChanged(value),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        BlocBuilder<AuthenticationBloc, AuthenticationState>(
                          bloc: AppBlocs.authenticationBloc,
                          builder: (context, state) {
                            final isLoading =
                                state.status == AuthenticationStatus.loading;

                            return Row(
                              children: [
                                CustomButton(
                                  onPressed: () => context.pop(),
                                  text: AppStrings.registrationBackButton,
                                ),
                                const SizedBox(width: 16),
                                CustomButton(
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          AppBlocs.authenticationBloc.add(
                                            const AuthenticationRegistrationSubmitted(),
                                          );
                                        },
                                  text: isLoading
                                      ? AppStrings.registrationLoadingButton
                                      : AppStrings.registrationButton,
                                  variant: CustomColorVariant.primary,
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<AuthenticationBloc, AuthenticationState>(
                          bloc: AppBlocs.authenticationBloc,
                          builder: (context, state) {
                            if (state.errorMessage == null) {
                              return const SizedBox.shrink();
                            }

                            return Text(
                              state.errorMessage!,
                              style: TextStyle(
                                color: colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            );
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
