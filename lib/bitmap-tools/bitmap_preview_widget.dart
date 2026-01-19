import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Виджет для отображения пиксель-арт рисунка из JSON файла
class PixelArtPreview extends StatefulWidget {
  final String filePath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Alignment alignment;
  final Color? backgroundColor;
  final bool showGrid;
  final FilterQuality filterQuality;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;

  const PixelArtPreview({
    super.key,
    required this.filePath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.backgroundColor,
    this.showGrid = false,
    this.filterQuality = FilterQuality.none,
    this.loadingWidget,
    this.errorWidget,
    this.borderColor,
    this.borderWidth = 0,
    this.borderRadius = 0,
  });

  @override
  State<PixelArtPreview> createState() => _PixelArtPreviewState();
}

class _PixelArtPreviewState extends State<PixelArtPreview> {
  List<List<Color?>>? _pixels;
  int? _imageWidth;
  int? _imageHeight;
  String? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPixelArt();
  }

  @override
  void didUpdateWidget(PixelArtPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filePath != widget.filePath) {
      _loadPixelArt();
    }
  }

  Future<void> _loadPixelArt() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final file = File(widget.filePath);
      if (!await file.exists()) {
        throw Exception('Файл не найден: ${widget.filePath}');
      }

      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;

      if (!json.containsKey('width') ||
          !json.containsKey('height') ||
          !json.containsKey('pixels')) {
        throw const FormatException('Неверный формат файла');
      }

      final width = json['width'] as int;
      final height = json['height'] as int;
      final pixelsJson = json['pixels'] as List<dynamic>;

      final pixels = pixelsJson.map((row) {
        return (row as List<dynamic>).map((v) {
          return v == null ? null : Color(v as int);
        }).toList();
      }).toList();

      setState(() {
        _pixels = pixels;
        _imageWidth = width;
        _imageHeight = height;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      debugPrint('Ошибка загрузки пиксель-арта: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.loadingWidget ??
          SizedBox(
            width: widget.width,
            height: widget.height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
    }

    if (_error != null) {
      return widget.errorWidget ??
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: widget.borderColor != null && widget.borderWidth > 0
                  ? Border.all(color: widget.borderColor!, width: widget.borderWidth)
                  : null,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                  const SizedBox(height: 8),
                  Text(
                    'Ошибка загрузки',
                    style: TextStyle(color: Colors.red.shade300),
                  ),
                ],
              ),
            ),
          );
    }

    if (_pixels == null || _imageWidth == null || _imageHeight == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: widget.borderColor != null && widget.borderWidth > 0
            ? Border.all(color: widget.borderColor!, width: widget.borderWidth)
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Определяем доступное пространство
            final availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : _imageWidth!.toDouble();
            final availableHeight = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : _imageHeight!.toDouble();

            // Вычисляем размер на основе BoxFit
            final Size imageSize = Size(_imageWidth!.toDouble(), _imageHeight!.toDouble());
            final Size availableSize = Size(availableWidth, availableHeight);
            final FittedSizes sizes = applyBoxFit(
              widget.fit ?? BoxFit.contain,
              imageSize,
              availableSize,
            );

            return Align(
              alignment: widget.alignment,
              child: SizedBox(
                width: sizes.destination.width,
                height: sizes.destination.height,
                child: CustomPaint(
                  painter: _PixelArtPreviewPainter(
                    _pixels!,
                    _imageWidth!,
                    _imageHeight!,
                    widget.showGrid,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PixelArtPreviewPainter extends CustomPainter {
  final List<List<Color?>> pixels;
  final int width;
  final int height;
  final bool showGrid;

  _PixelArtPreviewPainter(this.pixels, this.width, this.height, this.showGrid);

  @override
  void paint(Canvas canvas, Size size) {
    final pw = size.width / width;
    final ph = size.height / height;

    canvas.drawColor(Colors.transparent, BlendMode.src);

    final paint = Paint()..style = PaintingStyle.fill;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final color = pixels[y][x];
        if (color != null && color != Colors.transparent) {
          paint.color = color;
          canvas.drawRect(Rect.fromLTWH(x * pw, y * ph, pw, ph), paint);
        }
      }
    }

    if (showGrid) {
      final gridPaint = Paint()
        ..color = Colors.grey.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;

      for (int i = 0; i <= height; i++) {
        final yPos = i * ph;
        canvas.drawLine(Offset(0, yPos), Offset(size.width, yPos), gridPaint);
      }

      for (int i = 0; i <= width; i++) {
        final xPos = i * pw;
        canvas.drawLine(Offset(xPos, 0), Offset(xPos, size.height), gridPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PixelArtPreviewPainter oldDelegate) {
    return oldDelegate.pixels != pixels || oldDelegate.showGrid != showGrid;
  }
}