import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_bloc.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_event.dart';
import 'package:survey_app_flutter/presentation/admin/bloc/admin_state.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A filter widget for the surveys tab in the admin surveys list page.
class SurveysFilter extends StatelessWidget {
  /// Constructs a [SurveysFilter].
  const SurveysFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<AdminBloc, AdminState>(
      bloc: AppBlocs.adminBloc,
      buildWhen: (previous, current) =>
          previous.selectedFilter != current.selectedFilter,
      builder: (context, state) {
        return Row(
          children: [
            Text(
              AppStrings.mySurveysTitle,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 12,
                runSpacing: 12,
                children: [
                  CustomButton(
                    onPressed: () {
                      AppBlocs.adminBloc.add(
                        const AdminSurveyFilterChanged(AdminSurveyFilter.all),
                      );
                    },
                    text: AppStrings.allFilterButton,
                    variant: state.selectedFilter == AdminSurveyFilter.all
                        ? CustomColorVariant.primary
                        : CustomColorVariant.gray,
                  ),
                  CustomButton(
                    onPressed: () {
                      AppBlocs.adminBloc.add(
                        const AdminSurveyFilterChanged(AdminSurveyFilter.draft),
                      );
                    },
                    text: AppStrings.draftFilterButton,
                    variant: state.selectedFilter == AdminSurveyFilter.draft
                        ? CustomColorVariant.primary
                        : CustomColorVariant.gray,
                  ),
                  CustomButton(
                    onPressed: () {
                      AppBlocs.adminBloc.add(
                        const AdminSurveyFilterChanged(
                          AdminSurveyFilter.published,
                        ),
                      );
                    },
                    text: AppStrings.publishedFilterButton,
                    variant: state.selectedFilter == AdminSurveyFilter.published
                        ? CustomColorVariant.primary
                        : CustomColorVariant.gray,
                  ),
                  CustomButton(
                    onPressed: () {
                      AppBlocs.adminBloc.add(
                        const AdminSurveyFilterChanged(
                          AdminSurveyFilter.closed,
                        ),
                      );
                    },
                    text: AppStrings.closedFilterButton,
                    variant: state.selectedFilter == AdminSurveyFilter.closed
                        ? CustomColorVariant.primary
                        : CustomColorVariant.gray,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
