import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/domain/entities/invitation_entity.dart';
import 'package:survey_app_flutter/presentation/invitations/bloc/invitations_bloc.dart';
import 'package:survey_app_flutter/presentation/invitations/bloc/invitations_state.dart';
import 'package:survey_app_flutter/shared/custom_textfield.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A widget for the sent invitations section of the invitations page.
class SentInvitationsSection extends StatelessWidget {
  /// Constructs a [SentInvitationsSection].
  const SentInvitationsSection({super.key});

  static const List<String> _headers = [
    AppStrings.invitationsHeaderEmail,
    AppStrings.invitationsHeaderEmailOpen,
    AppStrings.invitationsHeaderSurveyOpen,
    AppStrings.invitationsHeaderStatus,
    AppStrings.invitationsHeaderDate,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvitationsBloc, InvitationsState>(
      bloc: AppBlocs.invitationsBloc,
      buildWhen: (previous, current) =>
          previous.invitations != current.invitations,
      builder: (context, state) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    AppStrings.sentInvitationsTitle(state.invitations.length),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const SizedBox(
                  width: 320,
                  child: CustomTextfield(
                    hintText: AppStrings.searchByEmailPlaceholder,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
                border: Border.all(color: colorScheme.outline),
              ),
              child: Row(
                children: [
                  for (final header in _headers)
                    Expanded(
                      flex: 3,
                      child: Text(
                        header.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (state.invitations.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                  border: Border.all(color: colorScheme.outline),
                ),
                child: Text(
                  AppStrings.sentInvitationsEmptyState,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.invitations.length,
                itemBuilder: (context, index) {
                  return _InvitationTableRow(
                    invitation: state.invitations[index],
                    theme: theme,
                    colorScheme: colorScheme,
                    isLast: index == state.invitations.length - 1,
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

class _InvitationTableRow extends StatelessWidget {
  const _InvitationTableRow({
    required this.invitation,
    required this.theme,
    required this.colorScheme,
    this.isLast = false,
  });

  final InvitationEntity invitation;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: isLast
            ? const BorderRadius.vertical(
                bottom: Radius.circular(10),
              )
            : null,
        border: BorderDirectional(
          end: BorderSide(color: colorScheme.outline),
          start: BorderSide(
            color: colorScheme.outline,
          ),
          top: BorderSide(color: colorScheme.outline, width: 0.5),
          bottom: BorderSide(
            color: colorScheme.outline,
            width: isLast ? 1 : 0.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              invitation.contact.email,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatDate(invitation.emailOpenedAt),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatDate(invitation.surveyOpenedAt),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: _StatusChip(
              label: _statusLabel(invitation),
              colorScheme: colorScheme,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _formatDate(invitation.sentAt),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime? value) {
    if (value == null) {
      return '- -';
    }

    return AppStrings.formatShortRoDate(value);
  }

  static String _statusLabel(InvitationEntity invitation) {
    if (invitation.bouncedAt != null) {
      return AppStrings.invitationStatusBounced;
    }
    if (invitation.submittedAt != null) {
      return AppStrings.invitationStatusSubmitted;
    }
    if (invitation.emailOpenedAt != null) {
      return AppStrings.invitationStatusEmailOpened;
    }
    return AppStrings.invitationStatusSent;
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.colorScheme});

  final String label;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (label) {
      AppStrings.invitationStatusBounced => colorScheme.errorContainer,
      AppStrings.invitationStatusSubmitted => colorScheme.secondaryContainer,
      AppStrings.invitationStatusEmailOpened => colorScheme.tertiaryContainer,
      _ => colorScheme.surfaceContainer,
    };

    final foregroundColor = switch (label) {
      AppStrings.invitationStatusBounced => colorScheme.error,
      AppStrings.invitationStatusSubmitted => colorScheme.secondary,
      AppStrings.invitationStatusEmailOpened => colorScheme.primary,
      _ => colorScheme.onSurfaceVariant,
    };

    final borderColor = switch (label) {
      AppStrings.invitationStatusBounced => colorScheme.error,
      AppStrings.invitationStatusSubmitted => colorScheme.secondary,
      AppStrings.invitationStatusEmailOpened => colorScheme.primary,
      _ => colorScheme.outline,
    };

    return Align(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          label.toLowerCase(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: foregroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
