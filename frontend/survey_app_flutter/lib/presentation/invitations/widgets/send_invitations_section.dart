import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/domain/entities/email_list_entity.dart';
import 'package:survey_app_flutter/domain/entities/survey_entity.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_bloc.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_state.dart';
import 'package:survey_app_flutter/presentation/bloc_listeners/bloc_providers.dart';
import 'package:survey_app_flutter/presentation/invitations/bloc/invitations_bloc.dart';
import 'package:survey_app_flutter/presentation/invitations/bloc/invitations_state.dart';
import 'package:survey_app_flutter/presentation/invitations/bloc/invitations_event.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Section for sending invitations to a survey.
class SendInvitationsSection extends StatelessWidget {
  /// Constructs a [SendInvitationsSection].
  const SendInvitationsSection({required this.survey, super.key});

  /// Survey for which invitations are managed.
  final SurveyEntity survey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProviders(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.sendInvitationsTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AppStrings.selectContactListLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            BlocBuilder<InvitationsBloc, InvitationsState>(
              bloc: AppBlocs.invitationsBloc,
              builder: (context, invitationsState) {
                final preview = invitationsState.invitationPreview;
                final selectedList = invitationsState.selectedEmailList;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<AdminBloc, AdminState>(
                          bloc: AppBlocs.adminBloc,
                          buildWhen: (previous, current) =>
                              previous.emailLists != current.emailLists,
                          builder: (context, state) {
                            return Expanded(
                              child: DropdownButtonFormField<EmailListEntity?>(
                                items: [null, ...state.emailLists]
                                    .map(
                                      (
                                        emailList,
                                      ) => DropdownMenuItem<EmailListEntity?>(
                                        value: emailList,
                                        child: Text(
                                          emailList != null
                                              ? '${emailList.name} (${emailList.contacts.length} ${AppStrings.contactsLabel})'
                                              : AppStrings
                                                    .chooseContactListPlaceholder,
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (emailList) {
                                  AppBlocs.invitationsBloc.add(
                                    InvitationsContactListSelected(emailList),
                                  );
                                },
                                hint: const Text(
                                  AppStrings.chooseContactListPlaceholder,
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: colorScheme.surfaceContainer,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: colorScheme.outline,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 200,
                          child: CustomButton(
                            onPressed: selectedList == null
                                ? null
                                : () {
                                    AppBlocs.invitationsBloc.add(
                                      LoadInvitationPreview(survey),
                                    );
                                  },
                            text: '${AppStrings.previewSendingButton} →',
                            variant: CustomColorVariant.primary,
                            isEnabled: selectedList != null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colorScheme.primary),
                      ),
                      child: Row(
                        children: [
                          const Text(AppStrings.previewWarningEmoji),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              preview == null
                                  ? AppStrings.previewInvitationsHint
                                  : AppStrings.invitationsPreviewText(
                                      preview.newInvitations,
                                      preview.skipped,
                                    ),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 220,
                        child: CustomButton(
                          onPressed:
                              preview == null ||
                                  invitationsState.isSendingInvitations
                              ? null
                              : () {
                                  AppBlocs.invitationsBloc.add(
                                    SendInvitations(survey),
                                  );
                                },
                          variant: CustomColorVariant.primary,
                          isEnabled:
                              preview != null &&
                              !invitationsState.isSendingInvitations,
                          child: invitationsState.isSendingInvitations
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              colorScheme.onPrimary,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      AppStrings.sendInvitationsButton(
                                        preview?.newInvitations ?? 0,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  '✉︎ ${AppStrings.sendInvitationsButton(preview?.newInvitations ?? 0)}',
                                ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
