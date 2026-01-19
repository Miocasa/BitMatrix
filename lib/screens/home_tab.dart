import 'package:bitmatrix/generated/app_localizations.dart';
import 'package:bitmatrix/models/bitmap_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatelessWidget {  // Changed to StatelessWidget for efficient prop-based rebuilding.
  final bool isLoading;
  final bool isSearching;
  final String searchQuery;
  final List<BitmapFile> filteredBitmapFiles;
  final List<BitmapFile> allBitmapFiles;

  const HomeScreen({  // Updated constructor to use const for optimization.
    super.key,
    required this.isLoading,
    required this.isSearching,
    required this.allBitmapFiles,
    required this.searchQuery,
    required this.filteredBitmapFiles,
  });

  int getCrossAxisCount(double width) {
    if (width < 600)   return 1;   // мобильный
    if (width < 900)   return 2;   // узкий планшет / портретный большой телефон
    if (width < 1200)  return 3;
    if (width < 1500)  return 4;
    if (width < 1800)  return 5;
    if (width < 2100)  return 6;
    if (width < 2400)  return 7;
    return 8;                      // очень широкие экраны
  }
  double getCardAspectRatio(double width) {
    final widget_width = width / getCrossAxisCount(width);
    if (widget_width <= 420)   return 1;   // мобильный
    if (widget_width > 420 && widget_width <= 500)   return 1.2;   // мобильный
    else return 1.3;
  }

  // void _loadAllFiles() async {
  //   // setState(() => {
  //   //
  //   // });
  // }


  // @override
  // void initState() {
  //   super.initState();
  //   _searchController.addListener(_onSearchChanged);
  //   _loadAllCourses();
  //   _listenToEnrollments();
  // }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isLoading) {  // Access props directly via 'this.' (no separate state fields).
      return const Center(
        child: CircularProgressIndicator(key: Key("bitmap_files_loading")),
      );
    }

    if (allBitmapFiles.isEmpty && !isLoading) {
      return Center(
        child: Text(
          l10n.homeNoCourses,
        ), // Адаптируем локализацию под новые данные
      );
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

    // ListView для отображения списка BitmapFileCard
    return LayoutBuilder(
      builder: (context, constraints) {
        // Логика количества колонок в зависимости от ширины экрана
        final Size size = MediaQuery.of(context).size;
        final double width = size.width;
        final double height = size.height;

        return MasonryGridView.count(
          crossAxisCount: getCrossAxisCount(MediaQuery.sizeOf(context).width),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          itemCount: filteredBitmapFiles.length + 1,
          itemBuilder: (context, index) {
            if(index == 2){
              return Text("Width = ${width}, Height = ${height}");
            }
            final bitmapFile = filteredBitmapFiles[index];
            return BitmapFileCard(
              bitmapFile: bitmapFile,
              onTap: () {
                FocusScope.of(context).unfocus();
              },
            );
          },
        );
      },
    );
  }
}
