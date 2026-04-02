import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_event.dart';
import 'package:survey_app_flutter/presentation/email_list/email_list_builder/bloc/email_list_builder_event.dart';
import 'package:survey_app_flutter/presentation/email_list/email_list_builder/email_list_builder.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_routes.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A top bar widget for the surveys list page in the admin section.
class AdminTopBar extends StatelessWidget {
  /// Constructs a [AdminTopBar].
  const AdminTopBar({
    required this.onTabSelected,
    required this.selectedTabIndex,
    super.key,
  });

  /// The index of the currently selected tab.
  final int selectedTabIndex;

  /// Callback when a tab is selected.
  final Function(int) onTabSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 700;

        final Widget title = Text(
          AppStrings.appTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        );

        final Widget tabs = Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _TabItem(
                label: AppStrings.adminSurveysTitle,
                isSelected: selectedTabIndex == 0,
                onTap: () => onTabSelected(0),
              ),
              _TabItem(
                label: AppStrings.contactsListTitle,
                isSelected: selectedTabIndex == 1,
                onTap: () => onTabSelected(1),
              ),
            ],
          ),
        );

        final bool isContactsTab = selectedTabIndex == 1;
        final String primaryButtonText = isContactsTab
            ? AppStrings.createEmailListButton
            : AppStrings.createSurveyButton;

        final VoidCallback onPrimaryButtonPressed = isContactsTab
            ? () {
                AppBlocs.emailListBuilderBloc.add(
                  const EmailListBuilderStatusReset(),
                );
                AppBlocs.emailListBuilderBloc.add(
                  const EmailListNameChanged(''),
                );

                showDialog<Object?>(
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
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: const EmailListBuilder(),
                      ),
                    );
                  },
                ).then((result) {
                  if (result != null) {
                    AppBlocs.adminBloc.add(const AdminEmailListsRefreshed());
                  }
                });
              }
            : () {
                context.push(AppRoutes.adminSurveyCreatePath());
              };

        final Widget createButton = isCompact
            ? SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: onPrimaryButtonPressed,
                  text: primaryButtonText,
                  variant: CustomColorVariant.primary,
                ),
              )
            : CustomButton(
                onPressed: onPrimaryButtonPressed,
                text: primaryButtonText,
                variant: CustomColorVariant.primary,
              );

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: colorScheme.outline),
          ),
          child: isCompact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    const SizedBox(height: 12),
                    tabs,
                    const SizedBox(height: 12),
                    createButton,
                  ],
                )
              : Row(
                  children: [
                    title,
                    const SizedBox(width: 24),
                    tabs,
                    const Spacer(),
                    createButton,
                  ],
                ),
        );
      },
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.surfaceContainer
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
