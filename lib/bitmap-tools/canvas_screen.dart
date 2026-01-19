import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:bitmatrix/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:m3e_design/m3e_design.dart';
import 'package:app_bar_m3e/app_bar_m3e.dart';
import 'package:button_m3e/button_m3e.dart';
import 'package:icon_button_m3e/icon_button_m3e.dart';
import 'package:fab_m3e/fab_m3e.dart';
import 'package:loading_indicator_m3e/loading_indicator_m3e.dart';
import 'package:provider/provider.dart';

class PixelArtEditorScreen extends StatefulWidget {
  const PixelArtEditorScreen({
    super.key,
    this.initialWidth = 32,
    this.initialHeight = 32,
    this.initialPixels,
  });

  final int initialWidth;
  final int initialHeight;
  final List<List<Color?>>? initialPixels;

  @override
  State<PixelArtEditorScreen> createState() => _PixelArtEditorScreenState();
}

class _PixelArtEditorScreenState extends State<PixelArtEditorScreen> {
  late List<List<Color?>> pixels;
  Color selectedColor = Colors.white;

  final GlobalKey _repaintKey = GlobalKey();
  final TransformationController _transformationController = TransformationController();

  // Undo / Redo
  final List<List<List<Color?>>> _undoStack = [];
  final List<List<List<Color?>>> _redoStack = [];
  static const int _maxHistory = 64;
  bool _showGrid = true;
  bool _isLoading = false;

  late double _pixelScale;

  @override
  void initState() {
    super.initState();
    _pixelScale = _calculatePixelScale(widget.initialWidth, widget.initialHeight);

    if (widget.initialPixels != null) {
      pixels = widget.initialPixels!;
    } else {
      _initEmptyCanvas();
    }

    _saveStateForUndo();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  // Вычисление адаптивного pixelScale в зависимости от размера холста
  double _calculatePixelScale(int width, int height) {
    // Целевой размер canvas в логических пикселях (примерно)
    const double targetSize = 384.0;

    final int maxDimension = math.max(width, height);
    double scale = targetSize / maxDimension;

    // Ограничиваем масштаб в разумных пределах
    // Для маленьких холстов - больше, для больших - меньше
    return scale.clamp(4.0, 24.0);
  }

  void _initEmptyCanvas() {
    pixels = List.generate(
      widget.initialHeight,
          (_) => List<Color?>.filled(widget.initialWidth, null),
    );
  }

  void _saveStateForUndo() {
    final snapshot = pixels.map((row) => List<Color?>.from(row)).toList();

    _undoStack.add(snapshot);
    if (_undoStack.length > _maxHistory) {
      _undoStack.removeAt(0);
    }

    _redoStack.clear();
  }

  void _undo() {
    if (_undoStack.length <= 1) return;

    final current = pixels.map((row) => List<Color?>.from(row)).toList();
    _redoStack.add(current);

    setState(() {
      pixels = _undoStack.removeLast();
    });
  }

  void _redo() {
    if (_redoStack.isEmpty) return;

    final current = pixels.map((row) => List<Color?>.from(row)).toList();
    _undoStack.add(current);

    setState(() {
      pixels = _redoStack.removeLast();
    });
  }

  Future<String?> _getProjectsDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<void> _saveProject() async {
    setState(() => _isLoading = true);

    final basePath = await _getProjectsDirectory();
    if (basePath == null) {
      setState(() => _isLoading = false);
      return;
    }

    final now = DateTime.now().toUtc().toIso8601String();

    final projectData = {
      "width": widget.initialWidth,
      "height": widget.initialHeight,
      "version": 1,
      "created": now,
      "lastModified": now,
      "pixels": pixels.map((row) => row.map((c) => c?.value).toList()).toList(),
    };
    String? jsonPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: 'bitmap.json',
    );

    if (jsonPath == null) {
      _showFileSaveAlternativeDialog(basePath, projectData);
    } else {
      _saveToFile(jsonPath, projectData);
    }
  }

  Future<void> _saveToFile(String jsonPath, Map<String, Object> projectData) async{
    await File(jsonPath).writeAsString(
      const JsonEncoder.withIndent('  ').convert(projectData),
    );

    final pngBytes = await _capturePng();
    if (pngBytes != null) {
      await File(jsonPath.replaceAll('.json', '.png')).writeAsBytes(pngBytes);
    }

    setState(() => _isLoading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Сохранено: ${jsonPath.split('/').last}'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green.shade800,
      ),
    );
  }

  Future<Uint8List?> _capturePng() async {
    try {
      final boundary = _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Capture error: $e');
      return null;
    }
  }

  Future<void> _pickAndLoadProject() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.isEmpty) return;

      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;

      if (!json.containsKey('width') ||
          !json.containsKey('height') ||
          !json.containsKey('pixels')) {
        throw const FormatException('Неверный формат файла');
      }

      final loadedWidth = json['width'] as int;
      final loadedHeight = json['height'] as int;

      // Проверка допустимых размеров
      if (loadedWidth < 1 || loadedWidth > 256 || loadedHeight < 1 || loadedHeight > 256) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Размер файла должен быть от 1×1 до 256×256'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final pixelsJson = json['pixels'] as List<dynamic>;
      final loadedPixels = pixelsJson.map((row) {
        return (row as List<dynamic>).map((v) {
          return v == null ? null : Color(v as int);
        }).toList();
      }).toList();

      // Если размеры отличаются, предложить открыть в новом холсте
      if (loadedWidth != widget.initialWidth || loadedHeight != widget.initialHeight) {
        if (mounted) {
          final shouldOpenNewCanvas = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Размеры отличаются'),
              content: Text(
                'Файл имеет размер $loadedWidth×$loadedHeight, '
                    'а текущий холст ${widget.initialWidth}×${widget.initialHeight}.\n\n'
                    'Открыть файл в новом холсте с правильными размерами?',
              ),
              actions: [
                ButtonM3E(
                  onPressed: () => Navigator.of(context).pop(false),
                  style: ButtonM3EStyle.text,
                  label: const Text('Отмена'),
                ),
                ButtonM3E(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ButtonM3EStyle.filled,
                  label: const Text('Открыть'),
                ),
              ],
            ),
          );

          if (shouldOpenNewCanvas == true) {
            // Открываем в новом холсте с загруженными пикселями
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => PixelArtEditorScreen(
                  initialWidth: loadedWidth,
                  initialHeight: loadedHeight,
                  initialPixels: loadedPixels,
                ),
              ),
            );
            return;
          } else {
            return; // Пользователь отменил
          }
        }
      }

      // Если размеры совпадают, загружаем как обычно
      setState(() {
        pixels = loadedPixels;
      });

      _undoStack.clear();
      _redoStack.clear();
      _saveStateForUndo();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Загружен: ${file.path.split(Platform.pathSeparator).last}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green.shade800,
          ),
        );
      }
    } catch (e) {
      debugPrint('Load error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Не удалось загрузить проект: $e'),
            backgroundColor: Colors.red.shade800,
          ),
        );
      }
    }
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить холст?'),
        content: const Text('Все несохранённые изменения будут потеряны.'),
        actions: [
          ButtonM3E(
            onPressed: () => Navigator.of(context).pop(),
            style: ButtonM3EStyle.text,
            label: const Text('Отмена'),
          ),
          ButtonM3E(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _initEmptyCanvas();
                _undoStack.clear();
                _redoStack.clear();
                _saveStateForUndo();
              });
            },
            style: ButtonM3EStyle.filled,
            label: const Text('Очистить'),
          ),
        ],
      ),
    );
  }

  void _showFileSaveAlternativeDialog(String? basePath,Map<String, Object> projectData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Сохранить файл?'),
        content: const Text('Вы не выбрали файл, хотите сохранить его с названием по умолчанию?'),
        actions: [
          ButtonM3E(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() => _isLoading = false);
            },
            style: ButtonM3EStyle.text,
            label: const Text('Нет'),
          ),
          ButtonM3E(
            onPressed: () {
              Navigator.of(context).pop();
              final jsonPath = '$basePath/pixelart_${DateTime.now().millisecondsSinceEpoch}.json';
              _saveToFile(jsonPath, projectData);
            },
            style: ButtonM3EStyle.filled,
            label: const Text('Да'),
          ),
        ],
      ),
    );
  }

  void _showNewCanvasDialog() {
    final widthController = TextEditingController(text: '32');
    final heightController = TextEditingController(text: '32');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новый холст'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: widthController,
              decoration: const InputDecoration(
                labelText: 'Ширина',
                suffixText: 'px',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: heightController,
              decoration: const InputDecoration(
                labelText: 'Высота',
                suffixText: 'px',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _QuickSizeChip(
                  label: '16×16',
                  onTap: () {
                    widthController.text = '16';
                    heightController.text = '16';
                  },
                ),
                _QuickSizeChip(
                  label: '32×32',
                  onTap: () {
                    widthController.text = '32';
                    heightController.text = '32';
                  },
                ),
                _QuickSizeChip(
                  label: '64×64',
                  onTap: () {
                    widthController.text = '64';
                    heightController.text = '64';
                  },
                ),
                _QuickSizeChip(
                  label: '128×128',
                  onTap: () {
                    widthController.text = '128';
                    heightController.text = '128';
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          ButtonM3E(
            onPressed: () => Navigator.of(context).pop(),
            style: ButtonM3EStyle.text,
            label: const Text('Отмена'),
          ),
          ButtonM3E(
            onPressed: () {
              final width = int.tryParse(widthController.text);
              final height = int.tryParse(heightController.text);

              if (width == null || height == null || width < 1 || height < 1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Введите корректные размеры'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (width > 256 || height > 256) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Максимальный размер 256×256'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => PixelArtEditorScreen(
                    initialWidth: width,
                    initialHeight: height,
                  ),
                ),
              );
            },
            style: ButtonM3EStyle.filled,
            label: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _drawPixel(int x, int y) {
    if (x < 0 || x >= widget.initialWidth || y < 0 || y >= widget.initialHeight) return;
    if (pixels[y][x] == selectedColor) return;

    _saveStateForUndo();

    setState(() {
      pixels[y][x] = selectedColor;
    });
  }

  void _handleDraw(Offset localPosition) {
    final double pixelSize = _pixelScale;

    final int gridX = (localPosition.dx / pixelSize).floor();
    final int gridY = (localPosition.dy / pixelSize).floor();

    _drawPixel(gridX, gridY);
  }

  void _zoomIn() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    final newScale = (currentScale * 1.5).clamp(0.25, 64.0);

    final newMatrix = Matrix4.identity()..scale(newScale);
    _transformationController.value = newMatrix;
  }

  void _zoomOut() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    final newScale = (currentScale / 1.5).clamp(0.25, 64.0);

    final newMatrix = Matrix4.identity()..scale(newScale);
    _transformationController.value = newMatrix;
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBarM3E(
        title: const Text('Pixel Art Editor'),
        density: AppBarM3EDensity.compact,
        shapeFamily: AppBarM3EShapeFamily.round,
        actions: [
          IconButtonM3E(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: _showNewCanvasDialog,
            tooltip: 'Новый холст',
            variant: IconButtonM3EVariant.filled,
          ),
          const SizedBox(width: 8),
          IconButtonM3E(
            icon: const Icon(Icons.undo),
            onPressed: _undoStack.length > 1 ? _undo : null,
            tooltip: 'Отменить',
            variant: IconButtonM3EVariant.standard,
          ),
          IconButtonM3E(
            icon: const Icon(Icons.redo),
            onPressed: _redoStack.isNotEmpty ? _redo : null,
            tooltip: 'Повторить',
            variant: IconButtonM3EVariant.standard,
          ),
          const SizedBox(width: 8),
          IconButtonM3E(
            icon: const Icon(Icons.save_outlined),
            onPressed: _saveProject,
            tooltip: 'Сохранить',
            variant: IconButtonM3EVariant.filled,
          ),
          IconButtonM3E(
            icon: const Icon(Icons.folder_open_outlined),
            onPressed: _pickAndLoadProject,
            tooltip: 'Открыть проект',
            variant: IconButtonM3EVariant.tonal,
          ),
          IconButtonM3E(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: _showClearConfirmation,
            tooltip: 'Очистить',
            variant: IconButtonM3EVariant.outlined,
          ),
          IconButtonM3E(
            icon: Icon(_showGrid ? Icons.grid_on : Icons.grid_off),
            onPressed: () => setState(() => _showGrid = !_showGrid),
            tooltip: 'Переключить сетку',
            variant: IconButtonM3EVariant.standard,
            enableFeedback: true,
            isSelected: _showGrid,
          ),
          IconButtonM3E(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 0.25,
                  maxScale: 64.0,
                  boundaryMargin: const EdgeInsets.all(200),
                  panEnabled: true,
                  scaleEnabled: true,
                  clipBehavior: Clip.none,
                  child: Center(
                    child: Card(
                      elevation: 8,
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                        width: widget.initialWidth * _pixelScale,
                        height: widget.initialHeight * _pixelScale,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanStart: (details) => _handleDraw(details.localPosition),
                          onPanUpdate: (details) => _handleDraw(details.localPosition),
                          onTapDown: (details) => _handleDraw(details.localPosition),
                          onDoubleTap: _undo,
                          child: RepaintBoundary(
                            key: _repaintKey,
                            child: CustomPaint(
                              painter: _PixelPainter(
                                pixels,
                                widget.initialWidth,
                                widget.initialHeight,
                                _showGrid,
                                _pixelScale,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Zoom controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 2,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButtonM3E(
                            icon: const Icon(Icons.zoom_out),
                            onPressed: _zoomOut,
                            tooltip: 'Уменьшить',
                            variant: IconButtonM3EVariant.standard,
                            size: IconButtonM3ESize.md,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ValueListenableBuilder(
                              valueListenable: _transformationController,
                              builder: (context, Matrix4 value, child) {
                                final scale = value.getMaxScaleOnAxis();
                                return Text(
                                  '${(scale * 100).toStringAsFixed(0)}%',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ),
                          IconButtonM3E(
                            icon: const Icon(Icons.zoom_in),
                            onPressed: _zoomIn,
                            tooltip: 'Увеличить',
                            variant: IconButtonM3EVariant.standard,
                            size: IconButtonM3ESize.md,
                          ),
                          const VerticalDivider(indent: 8, endIndent: 8),
                          IconButtonM3E(
                            icon: const Icon(Icons.fit_screen),
                            onPressed: _resetZoom,
                            tooltip: 'Сбросить масштаб',
                            variant: IconButtonM3EVariant.tonal,
                            size: IconButtonM3ESize.md,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Палитра с M3E виджетами
              Card(
                elevation: 4,
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.palette, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Палитра',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          Chip(
                            label: Text('${widget.initialWidth}×${widget.initialHeight}'),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 56,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _colorPalette.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final (color, colorName) = _colorPalette[index];
                            final isSelected = selectedColor == color;

                            return IconButtonM3E(
                              tooltip: colorName,
                              icon: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: color == Colors.transparent
                                      ? Border.all(color: Colors.white24, width: 2)
                                      : null,
                                ),
                                child: color == Colors.transparent
                                    ? const Icon(Icons.block, size: 18, color: Colors.white54)
                                    : null,
                              ),
                              onPressed: () => setState(() => selectedColor = color),
                              variant: isSelected
                                  ? IconButtonM3EVariant.filled
                                  : IconButtonM3EVariant.standard,
                              size: IconButtonM3ESize.lg,
                              enableFeedback: true,
                              isSelected: isSelected,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Loading indicator
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: LoadingIndicatorM3E(
                  variant: LoadingIndicatorM3EVariant.contained,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FabM3E(
        onPressed: _saveProject,
        tooltip: 'Быстрое сохранение',
        icon: const Icon(Icons.save),
      ),
    );
  }

  static const List<(Color, String)> _colorPalette = [
    (Colors.transparent, 'Transparent'),
    (Colors.white, 'White'),
    (Colors.black, 'Black'),
    (Color(0xFFE53935), 'Red'),
    (Color(0xFFD81B60), 'Pink'),
    (Color(0xFF8E24AA), 'Purple'),
    (Color(0xFF5E35B1), 'Deep Purple'),
    (Color(0xFF3949AB), 'Indigo'),
    (Color(0xFF1E88E5), 'Blue'),
    (Color(0xFF039BE5), 'Light Blue'),
    (Color(0xFF00ACC1), 'Cyan'),
    (Color(0xFF00897B), 'Teal'),
    (Color(0xFF43A047), 'Green'),
    (Color(0xFF7CB342), 'Light Green'),
    (Color(0xFFC0CA33), 'Lime'),
    (Color(0xFFFDD835), 'Yellow'),
    (Color(0xFFFFB300), 'Amber'),
    (Color(0xFFFF8F00), 'Orange'),
    (Color(0xFFF4511E), 'Deep Orange'),
    (Color(0xFF6D4C41), 'Brown'),
    (Color(0xFF757575), 'Grey'),
  ];
}

class _PixelPainter extends CustomPainter {
  final List<List<Color?>> pixels;
  final int width;
  final int height;
  final bool showGrid;
  final double pixelScale;

  _PixelPainter(this.pixels, this.width, this.height, this.showGrid, this.pixelScale);

  @override
  void paint(Canvas canvas, Size size) {
    // ИСПРАВЛЕНИЕ: используем pixelScale напрямую вместо вычисления из size
    // Это предотвращает накопление ошибки округления
    final pw = pixelScale;
    final ph = pixelScale;

    // Фон
    canvas.drawColor(const Color(0xFF0F0F0F), BlendMode.src);

    // Пиксели - используем точные координаты для каждого пикселя
    final paint = Paint()..style = PaintingStyle.fill;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final color = pixels[y][x];
        if (color != null) {
          paint.color = color;
          // Точные координаты: каждый пиксель начинается ровно в x*pw, y*ph
          canvas.drawRect(
            Rect.fromLTWH(x * pw, y * ph, pw, ph),
            paint,
          );
        }
      }
    }

    // Сетка
    if (showGrid && pw >= 2.0) {
      final gridPaint = Paint()
        ..color = const Color(0xFF2A2A2A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      // Рисуем линии сетки по точным координатам
      for (int i = 0; i <= height; i++) {
        final yPos = i * ph;
        canvas.drawLine(Offset(0, yPos), Offset(width * pw, yPos), gridPaint);
      }

      for (int i = 0; i <= width; i++) {
        final xPos = i * pw;
        canvas.drawLine(Offset(xPos, 0), Offset(xPos, height * ph), gridPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PixelPainter oldDelegate) => true;
}

class _QuickSizeChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickSizeChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
    );
  }
}