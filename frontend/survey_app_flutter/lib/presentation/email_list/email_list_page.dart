import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/domain/entities/email_contact_entity.dart';
import 'package:survey_app_flutter/domain/entities/email_list_entity.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_event.dart';
import 'package:survey_app_flutter/presentation/email_list/email_list_builder/bloc/email_list_builder_bloc.dart';
import 'package:survey_app_flutter/presentation/email_list/email_list_builder/bloc/email_list_builder_event.dart';
import 'package:survey_app_flutter/presentation/email_list/email_list_builder/bloc/email_list_builder_state.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// View for the email list page.
class EmailListPage extends StatefulWidget {
  /// Constructs an [EmailListPage].
  const EmailListPage({required this.emailList, super.key});

  /// Email list to display.
  final EmailListEntity emailList;

  @override
  State<EmailListPage> createState() => _EmailListPageState();
}

class _EmailListPageState extends State<EmailListPage> {
  late List<EmailContactEntity> _contacts;
  final Set<String> _deletingContactIds = <String>{};

  @override
  void initState() {
    super.initState();
    _contacts = List<EmailContactEntity>.of(widget.emailList.contacts);
  }

  Future<void> _deleteContact(EmailContactEntity contact) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: const Text(AppStrings.emailListPageDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(AppStrings.noOption),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(AppStrings.yesOption),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    setState(() {
      _deletingContactIds.add(contact.id);
    });

    AppBlocs.emailListBuilderBloc.add(
      EmailListContactDeleteRequested(
        listId: widget.emailList.id,
        contactId: contact.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<EmailListBuilderBloc, EmailListBuilderState>(
      bloc: AppBlocs.emailListBuilderBloc,
      listenWhen: (previous, current) =>
          previous.deletedContactId != current.deletedContactId ||
          previous.deleteFailedContactId != current.deleteFailedContactId ||
          previous.contactDeleteErrorMessage !=
              current.contactDeleteErrorMessage,
      listener: (context, state) {
        if (state.deletedContactId != null &&
            _deletingContactIds.contains(state.deletedContactId)) {
          setState(() {
            _contacts.removeWhere((item) => item.id == state.deletedContactId);
            _deletingContactIds.remove(state.deletedContactId);
          });

          AppBlocs.adminBloc.add(const AdminEmailListsRefreshed());
        }

        if (state.deleteFailedContactId != null &&
            _deletingContactIds.contains(state.deleteFailedContactId)) {
          setState(() {
            _deletingContactIds.remove(state.deleteFailedContactId);
          });

          if (state.contactDeleteErrorMessage != null &&
              state.contactDeleteErrorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.contactDeleteErrorMessage!)),
            );
          }
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.emailList.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  AppStrings.emailListPageContactsSummary(_contacts.length),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _contacts.isEmpty
                      ? Center(
                          child: Text(
                            AppStrings.emailListPageEmptyState,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _contacts.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final contact = _contacts[index];
                            final isDeleting = _deletingContactIds.contains(
                              contact.id,
                            );

                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: colorScheme.outline),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          contact.name.trim().isNotEmpty
                                              ? contact.name
                                              : AppStrings
                                                    .emailListPageNameMissing,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${AppStrings.csvImportEmailLabel}: ${contact.email}',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  CustomButton(
                                    onPressed: isDeleting
                                        ? null
                                        : () => _deleteContact(contact),

                                    child: Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: colorScheme.error,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
