

import 'package:bitmatrix/bitmap-tools/bitmap_preview_widget.dart';
// import 'package:bitmatrix/bitmap-tools/canvas_screen.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator_m3e/loading_indicator_m3e.dart';
import 'package:m3e_collection/m3e_collection.dart';

class BitmapFile {
  final String filePath;
  final String title;
  final String description;
  final DateTime? createdAt;
  final DateTime? editedAt;

  BitmapFile({
    required this.filePath,
    required this.title,
    required this.description,
    this.createdAt,
    this.editedAt,
  });
}
class BitmapFileCard extends StatelessWidget {
  final BitmapFile bitmapFile;
  // final VoidCallback? onTap;

  const BitmapFileCard({
    super.key,
    required this.bitmapFile,
    // this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Локальная ширина карточки (очень полезно на десктопе)
        // final cardWidth = constraints.maxWidth;

        final _edited = bitmapFile.editedAt;
        final _created = bitmapFile.createdAt;

        return Card(
          elevation: 1.5,
          margin: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            // onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Изображение — занимает основную часть
                Padding(
                  padding: EdgeInsets.all(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
                      child: Card.filled(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Hero(
                          tag: "bitmapImage_${bitmapFile.filePath}",
                          child: PixelArtPreview(
                            filePath: bitmapFile.filePath,
                            fit: BoxFit.contain,
                            // showGrid: true,
                            loadingWidget: Center(child: LoadingIndicatorM3E(variant: LoadingIndicatorM3EVariant.defaultStyle)),
                          )
                        ),
                      ),
                    ),
                  ),
                ),
                // Информационная часть
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child:  Padding(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              bitmapFile.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              bitmapFile.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),

                            if(_edited != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                "Edited: ${_edited.day}.${_edited.month}.${_edited.year}",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            ],
                            if(_created != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                "Created: ${_created.day}.${_created.month}.${_created.year}",
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentGeometry.topRight,
                      child: ButtonM3E(
                        shape: ButtonM3EShape.round,
                        label: Icon(Icons.more_vert),
                        style: ButtonM3EStyle.filled,
                        size: ButtonM3ESize.sm,
                        onPressed: () => {},
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}