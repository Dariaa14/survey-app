import 'package:flutter/material.dart';
import 'package:survey_app_flutter/domain/entities/email_list_csv_import_result_entity.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';
import 'package:survey_app_flutter/utils/theme.dart';

/// Displays preview/import information parsed from CSV processing results.
class CsvInformations extends StatelessWidget {
  /// Constructs [CsvInformations].
  const CsvInformations({required this.result, super.key});

  /// CSV processing result used to render valid/invalid sections.
  final EmailListCsvImportResultEntity result;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.csvImportPreviewTitle,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.csvImportSummary(
              result.summary.total,
              result.summary.valid,
              result.summary.invalid,
            ),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          _SectionTitle(
            title: AppStrings.csvImportValidSectionTitle(result.valid.length),
            color: colorScheme.primary,
          ),
          const SizedBox(height: 8),
          if (result.valid.isEmpty)
            const _EmptyText(label: AppStrings.csvImportNoValidContacts)
          else
            ...result.valid.map(
              (contact) => _ValidItem(
                email: contact.email,
                name: contact.name,
              ),
            ),
          const SizedBox(height: 14),
          _SectionTitle(
            title: AppStrings.csvImportInvalidSectionTitle(
              result.invalid.length,
            ),
            color: colorScheme.error,
          ),
          const SizedBox(height: 8),
          if (result.invalid.isEmpty)
            const _EmptyText(label: AppStrings.csvImportNoInvalidContacts)
          else
            ...result.invalid.map(
              (contact) => _InvalidItem(
                row: contact.row,
                email: contact.email,
                reason: contact.error,
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.color});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  const _EmptyText({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _ValidItem extends StatelessWidget {
  const _ValidItem({required this.email, this.name});

  final String email;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppStrings.csvImportEmailLabel}: $email',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 2),
          Text(
            '${AppStrings.csvImportNameLabel}: ${name?.trim().isNotEmpty == true ? name : AppStrings.csvImportNameMissing}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _InvalidItem extends StatelessWidget {
  const _InvalidItem({required this.row, this.email, required this.reason});

  final int row;
  final String? email;
  final String reason;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: redContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppStrings.csvImportRowLabel}: $row',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 2),
          Text(
            '${AppStrings.csvImportEmailLabel}: ${email?.isNotEmpty ?? false ? email : AppStrings.csvImportEmailMissing}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 2),
          Text(
            '${AppStrings.csvImportInvalidReasonLabel}: $reason',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
