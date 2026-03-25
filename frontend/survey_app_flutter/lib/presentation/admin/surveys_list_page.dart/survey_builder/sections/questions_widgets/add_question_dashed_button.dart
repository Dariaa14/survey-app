import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:survey_app_flutter/utils/app_strings.dart';

/// A dashed-outline button used to add a new question.
class AddQuestionDashedButton extends StatelessWidget {
  /// Constructs an [AddQuestionDashedButton].
  const AddQuestionDashedButton({
    required this.onTap,
    super.key,
  });

  /// Callback triggered when button is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          alignment: Alignment.center,
          child: Text(
            '+   ${AppStrings.addQuestionButton}',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
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
