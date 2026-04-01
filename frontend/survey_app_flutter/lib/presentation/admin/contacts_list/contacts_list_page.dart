import 'package:flutter/material.dart';
import 'package:survey_app_flutter/data/entities_impl/email_list_entity_impl.dart';
import 'package:survey_app_flutter/domain/entities/email_list_entity.dart';
import 'package:survey_app_flutter/presentation/admin/contacts_list/widgets/contact_list_preview.dart';
import 'package:survey_app_flutter/presentation/email_list_builder/csv_import/csv_import_page.dart';

final List<EmailListEntity> _mockEmailLists = <EmailListEntity>[
  EmailListEntityImpl(
    id: 'list-001',
    ownerId: 'owner-001',
    name: 'Weekly Product Updates',
    createdAt: DateTime(2026, 1, 12),
    contacts: [],
  ),
  EmailListEntityImpl(
    id: 'list-002',
    ownerId: 'owner-001',
    name: 'New User Onboarding',
    createdAt: DateTime(2026, 1, 20),
    contacts: [],
  ),
];

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
    return Column(
      children: [
        ..._mockEmailLists.map(
          (emailList) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ContactListPreview(
              emailList: emailList,
              onView: () {},
              onImportCsv: () {
                _openCsvImportModal(context);
              },
              onDelete: () {},
            ),
          ),
        ),
      ],
    );
  }
}
