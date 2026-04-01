import 'package:flutter/material.dart';
import 'package:survey_app_flutter/domain/entities/email_list_entity.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A preview widget for a contact list item in the admin area.
class ContactListPreview extends StatelessWidget {
  /// Constructs a [ContactListPreview].
  const ContactListPreview({
    required this.emailList,

    required this.onView,
    required this.onImportCsv,
    required this.onDelete,
    super.key,
  });

  /// The email list entity to display in this preview.
  final EmailListEntity emailList;

  /// Callback for the visualize action.
  final VoidCallback onView;

  /// Callback for importing CSV contacts.
  final VoidCallback onImportCsv;

  /// Callback for deleting this list.
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  emailList.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.contactsListPreviewMeta(
                    emailList.contacts.length,
                    emailList.createdAt,
                  ),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                onPressed: onView,
                text: AppStrings.contactListPreviewViewButton,
              ),
              const SizedBox(width: 8),
              CustomButton(
                onPressed: onImportCsv,
                text: '📥 ${AppStrings.contactListPreviewImportCsvButton}',
              ),
              const SizedBox(width: 8),
              CustomButton(
                onPressed: onDelete,
                child: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
