import 'package:bitmatrix/generated/app_localizations.dart';
import 'package:bitmatrix/models/bitmap_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loading_indicator_m3e/loading_indicator_m3e.dart';

class HomeScreen extends StatelessWidget {
  final bool isLoading;
  final bool isSearching;
  final String searchQuery;
  final List<BitmapFile> filteredBitmapFiles;
  final List<BitmapFile> allBitmapFiles;

  const HomeScreen({
    super.key,
    required this.isLoading,
    required this.isSearching,
    required this.allBitmapFiles,
    required this.searchQuery,
    required this.filteredBitmapFiles,
  });

  int _getCrossAxisCount(double width) {
    if (width < 600) return 1;
    if (width < 900) return 2;
    if (width < 1200) return 3;
    if (width < 1500) return 4;
    if (width < 1800) return 5;
    return 6;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;

    if (isLoading) {
      return const Center(
        child: SizedBox(
          width: 96,
          height: 96,
          child: LoadingIndicatorM3E(
            variant: LoadingIndicatorM3EVariant.defaultStyle,
            key: Key("bitmap_files_loading"),
          ),
        ),
      );
    }

    if (allBitmapFiles.isEmpty && !isLoading) {
      return Center(child: Text(l10n.homeNoCourses));
    }

    if (searchQuery.isNotEmpty && filteredBitmapFiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off_rounded, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              l10n.homeNoCoursesForQuery(searchQuery),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.homeTryDifferentTerm,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    final crossCount = _getCrossAxisCount(width);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MasonryGridView.count(
        crossAxisCount: crossCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        itemCount: filteredBitmapFiles.length,
        // ↓ Masonry-эффект работает лучше без itemExtent / без фиксированной высоты
        itemBuilder: (context, index) {
          final bitmap = filteredBitmapFiles[index];

          // Для демонстрации masonry-эффекта можно сделать высоту немного случайной
          // В реальном проекте высота должна определяться содержимым карточки
          final baseHeight = 180.0;
          // Пример: длинные описания → выше карточка
          final extra = bitmap.description.length > 80 ? 60.0 : 0.0;
          // Или полностью динамическая высота через LayoutBuilder / IntrinsicHeight (см. ниже)

          return SizedBox(
            // height: baseHeight + extra + (index % 4) * 30, // ← тестовая вариация
            child: BitmapFileCard(bitmapFile: bitmap),
          );
        },
      ),
    );
  }
}