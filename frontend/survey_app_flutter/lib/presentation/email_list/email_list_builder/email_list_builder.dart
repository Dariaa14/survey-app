import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/presentation/bloc_listeners/bloc_providers.dart';
import 'package:survey_app_flutter/presentation/email_list/email_list_builder/bloc/email_list_builder_bloc.dart';
import 'package:survey_app_flutter/presentation/email_list/email_list_builder/bloc/email_list_builder_event.dart';
import 'package:survey_app_flutter/presentation/email_list/email_list_builder/bloc/email_list_builder_state.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';
import 'package:survey_app_flutter/shared/custom_textfield.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A widget that builds the email list management interface.
class EmailListBuilder extends StatefulWidget {
  /// Constructs an [EmailListBuilder].
  const EmailListBuilder({super.key});

  @override
  State<EmailListBuilder> createState() => _EmailListBuilderState();
}

class _EmailListBuilderState extends State<EmailListBuilder> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProviders(
      child: BlocConsumer<EmailListBuilderBloc, EmailListBuilderState>(
        listener: (context, state) {
          if (state.status == EmailListBuilderStatus.success) {
            Navigator.of(context).pop(state.createdList);
          }
        },
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.addContactListTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextfield(
                  controller: _nameController,
                  hintText: AppStrings.addContactListNameHint,
                  onChanged: (value) {
                    context.read<EmailListBuilderBloc>().add(
                      EmailListNameChanged(value),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: AppStrings.cancelButton,
                    ),
                    const SizedBox(width: 8),
                    CustomButton(
                      onPressed: () {
                        context.read<EmailListBuilderBloc>().add(
                          const EmailListCreateRequested(),
                        );
                      },
                      text: AppStrings.saveButton,
                      variant: CustomColorVariant.primary,
                      isEnabled: state.canSave,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
