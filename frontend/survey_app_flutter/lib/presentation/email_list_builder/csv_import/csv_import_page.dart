import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_app_flutter/presentation/bloc_listeners/bloc_providers.dart';
import 'package:survey_app_flutter/presentation/email_list_builder/bloc/email_list_builder_bloc.dart';
import 'package:survey_app_flutter/presentation/email_list_builder/bloc/email_list_builder_event.dart';
import 'package:survey_app_flutter/presentation/email_list_builder/bloc/email_list_builder_state.dart';
import 'package:survey_app_flutter/shared/custom_button.dart';
import 'package:survey_app_flutter/shared/custom_color_variant.dart';
import 'package:survey_app_flutter/utils/app_blocs.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// Page for importing contacts from a CSV file.
class CsvImportPage extends StatefulWidget {
  /// Constructs a [CsvImportPage].
  const CsvImportPage({required this.listId, super.key});

  /// Target email list id where CSV contacts will be imported.
  final String listId;

  @override
  State<CsvImportPage> createState() => _CsvImportPageState();
}

class _CsvImportPageState extends State<CsvImportPage> {
  @override
  void initState() {
    super.initState();
    AppBlocs.emailListBuilderBloc.add(const CsvImportStateReset());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProviders(
      child: BlocConsumer<EmailListBuilderBloc, EmailListBuilderState>(
        listenWhen: (previous, current) =>
            previous.csvImportStatus != current.csvImportStatus ||
            previous.csvImportErrorMessage != current.csvImportErrorMessage,
        listener: (context, state) {
          if (state.csvImportStatus == CsvImportStatus.success) {
            Navigator.of(context).pop(true);
          }

          if (state.csvImportStatus == CsvImportStatus.failure &&
              state.csvImportErrorMessage != null &&
              state.csvImportErrorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.csvImportErrorMessage!)),
            );
          }
        },
        builder: (context, state) {
          final isUploading =
              state.csvImportStatus == CsvImportStatus.uploading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.csvImportTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  runSpacing: 8,
                  children: [
                    Text(
                      AppStrings.csvImportColumnsPrefix,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const _ColumnChip(label: AppStrings.csvImportEmailColumn),
                    Text(
                      AppStrings.csvImportColumnsConnector,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const _ColumnChip(label: AppStrings.csvImportNameColumn),
                    Text(
                      AppStrings.csvImportNameOptionalSuffix,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    AppBlocs.emailListBuilderBloc.add(
                      const CsvImportFilePickRequested(),
                    );
                  },
                  child: CustomPaint(
                    painter: _DashedRoundedRectPainter(
                      color: colorScheme.outline,
                      radius: 10,
                      strokeWidth: 1,
                      dashWidth: 6,
                      dashGap: 4,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 40,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppStrings.csvImportDropzoneFolderEmoji,
                            style: theme.textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              Text(
                                AppStrings.csvImportDropzoneText,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                AppStrings.csvImportChooseFileText,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.csvImportMaxRowsText,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (state.selectedCsvName != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              '${AppStrings.csvImportSelectedFilePrefix} '
                              '${state.selectedCsvName}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: colorScheme.tertiary),
                  ),
                  child: Row(
                    children: [
                      Text(
                        AppStrings.csvImportInfoEmoji,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          AppStrings.csvImportInfoText,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: AppStrings.csvImportCancelButton,
                    ),
                    const SizedBox(width: 8),
                    CustomButton(
                      isEnabled: state.canImportCsv,
                      text: isUploading
                          ? AppStrings.csvImportUploadingButton
                          : AppStrings.csvImportImportButton,
                      variant: CustomColorVariant.primary,
                      onPressed: () {
                        AppBlocs.emailListBuilderBloc.add(
                          CsvImportRequested(widget.listId),
                        );
                      },
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

class _ColumnChip extends StatelessWidget {
  const _ColumnChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: colorScheme.secondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DashedRoundedRectPainter extends CustomPainter {
  const _DashedRoundedRectPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rect = Offset.zero & size;
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final path = Path()..addRRect(rRect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = math.min(distance + dashWidth, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.radius != radius ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashGap != dashGap;
  }
}
