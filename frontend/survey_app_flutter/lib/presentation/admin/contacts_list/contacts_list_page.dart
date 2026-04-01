import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/domain/entities/email_list_entity.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_bloc.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_event.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_state.dart';
import 'package:survey_app_flutter/presentation/admin/contacts_list/widgets/contact_list_preview.dart';
import 'package:survey_app_flutter/presentation/email_list_builder/csv_import/csv_import_page.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// The page displaying the list of contacts in the admin area.
class ContactsListPage extends StatelessWidget {
  /// Constructs a [ContactsListPage].
  const ContactsListPage({super.key});

  Future<void> _openCsvImportModal(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900, maxHeight: 760),
            child: const CsvImportPage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      buildWhen: (previous, current) =>
          previous.emailLists != current.emailLists,
      builder: (context, state) {
        return Column(
          children: [
            ...state.emailLists.map(
              (emailList) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ContactListPreview(
                  emailList: emailList,
                  onView: () {},
                  onImportCsv: () {
                    _openCsvImportModal(context);
                  },
                  onDelete: () {
                    _showDeleteListDialog(context, emailList);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteListDialog(
    BuildContext context,
    EmailListEntity emailList,
  ) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(AppStrings.emailListDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(AppStrings.noOption),
          ),
          TextButton(
            onPressed: () {
              AppBlocs.adminBloc.add(
                AdminEmailListDeleteRequested(emailList.id),
              );
              Navigator.of(context).pop();
            },
            child: const Text(AppStrings.yesOption),
          ),
        ],
      ),
    );
  }
}
