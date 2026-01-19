import 'dart:math' as math;
import 'package:flutter/material.dart';

/// КОЛЬЦО ПРОГРЕССА БЕЗ ГРАДИЕНТА
class AnimatedProgressIndicator extends StatelessWidget {
  final double progress;        // внешнее кольцо 0..1
  final double? innerProgress;  // внутреннее кольцо 0..1

  final double size;
  final double strokeWidth;
  final double innerStrokeWidth;

  final String? label;
  final String? subLabel;

  // цвет внешнего кольца
  final Color? outerColor;
  final Color? outerBackgroundColor;

  // цвет внутреннего кольца
  final Color? innerColor;
  final Color? innerBackgroundColor;

  const AnimatedProgressIndicator({
    Key? key,
    required this.progress,
    this.innerProgress,
    this.size = 160,
    this.strokeWidth = 14,
    this.innerStrokeWidth = 10,
    this.label,
    this.subLabel,
    this.outerColor,
    this.outerBackgroundColor,
    this.innerColor,
    this.innerBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final clampedOuter = progress.clamp(0.0, 1.0);
    final clampedInner = innerProgress?.clamp(0.0, 1.0);

    final outerProgressColor = outerColor ?? colorScheme.primary;
    final innerProgressColor = innerColor ?? colorScheme.secondary;

    final outerBg =
        outerBackgroundColor ?? colorScheme.onSurface.withAlpha((Theme.of(context).brightness == Brightness.dark ? 48 : 16));
    final innerBg =
        innerBackgroundColor ?? colorScheme.onSurface.withAlpha((Theme.of(context).brightness == Brightness.dark ? 32 : 10));

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Внутреннее кольцо
          if (clampedInner != null)
            CustomPaint(
              size: Size.square(size * 0.78),
              painter: _AnimatedProgressIndicatorPainter(
                progress: clampedInner,
                strokeWidth: innerStrokeWidth,
                backgroundColor: innerBg,
                progressColor: innerProgressColor,
              ),
            ),

          // Внешнее кольцо
          CustomPaint(
            size: Size.square(size),
            painter: _AnimatedProgressIndicatorPainter(
              progress: clampedOuter,
              strokeWidth: strokeWidth,
              backgroundColor: outerBg,
              progressColor: outerProgressColor,
            ),
          ),

          // Текст
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
              if (subLabel != null) ...[
                const SizedBox(height: 4),
                Text(
                  subLabel!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.outline,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _AnimatedProgressIndicatorPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  _AnimatedProgressIndicatorPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (size.shortestSide - strokeWidth) / 2;

    // Фоновый круг
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    if (progress <= 0) return;

    // Дуга прогресса (СПЛОШНОЙ ЦВЕТ, БЕЗ ГРАДИЕНТА)
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = progressColor;

    final startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _AnimatedProgressIndicatorPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor;
  }
}




class GoogleFitLikeProgress extends StatelessWidget {
  final double progress; // 0.0–1.0
  final double size;
  final double strokeWidth;
  final String? label;
  final String? subLabel;

  const GoogleFitLikeProgress({
    Key? key,
    required this.progress,
    this.size = 160,
    this.strokeWidth = 14,
    this.label,
    this.subLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(size),
            painter: _GoogleFitRingPainter(
              progress: clamped,
              strokeWidth: strokeWidth,
              colorScheme: Theme.of(context).colorScheme,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
              if (subLabel != null) ...[
                const SizedBox(height: 4),
                Text(
                  subLabel!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _GoogleFitRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final ColorScheme colorScheme;

  _GoogleFitRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.colorScheme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (size.shortestSide - strokeWidth) / 2;

    // Фоновый круг
    final backgroundPaint = Paint()
      ..color = colorScheme.onSurface.withAlpha(10) //surfaceVariant.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    if (progress <= 0) return;

    // Прогресс-дуга
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + 2 * math.pi * progress,
        colors: [
          colorScheme.primary,
          colorScheme.tertiary,
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    final startAngle = -math.pi / 2; // сверху
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GoogleFitRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.colorScheme != colorScheme;
  }
}
