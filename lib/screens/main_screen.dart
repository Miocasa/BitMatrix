import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bitmatrix/bitmap-tools/canvas_screen.dart';
import 'package:bitmatrix/generated/app_localizations.dart';
import 'package:bitmatrix/providers/settings_provider.dart';
import 'package:bitmatrix/screens/home_tab.dart';
import 'package:bitmatrix/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../models/bitmap_card.dart';
import 'package:path/path.dart' as p;

// Placeholder-функция для тестовых данных


List<BitmapFile> getPlaceholderBitmapFiles() {

  return [
    BitmapFile(
      title: 'Test Bitmap 1',
      description: 'This is a sample bitmap file for drawing.',
      filePath: 'assets/bitmaps/test1.png',
      createdAt: DateTime.now(),
      editedAt: DateTime.now(),
    ),
    BitmapFile(
      title: 'Test Bitmap 2',
      description: 'Another sample bitmap file for demonstration.',
      filePath: 'assets/bitmaps/test2.png',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      editedAt: DateTime.now(),
    ),
  ];
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;
  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

typedef LabelBuilder = String Function(AppLocalizations l10n);

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  String _searchQuery = "";
  List<BitmapFile> _allBitmaps = [];
  List<BitmapFile> _filteredBitmaps = [];
  bool _isLoading = true;
  bool _isSearching = false;

  int _selectedIndex = 0;

  // Состояние NavigationRail
  // NavigationRailM3EType _railType = (800 > width) ? NavigationRailM3EType.alwaysCollapse : NavigationRailM3EType.collapsed;

  // Определение пунктов навигации для BottomNavigationBar
  final List<({
  IconData icon,
  IconData selectedIcon,
  LabelBuilder label,
  })> _bottomDestinations = [
    (
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    label: (l10n) => l10n.tabHome,
    ),
    (
    icon: Icons.favorite_border,
    selectedIcon: Icons.favorite,
    label: (l10n) => l10n.tabFavourite,
    ),
    (
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    label: (l10n) => l10n.tabSettings,
    ),
  ];

  // Пункты для NavigationRailM3E (можно сделать другими, если нужно)
  static const List<NavigationRailM3ESection> _railSections = [
    NavigationRailM3ESection(
      header: Text('Основное'),
      destinations: [
        NavigationRailM3EDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Главная',
        ),
        NavigationRailM3EDestination(
          icon: Icon(Icons.favorite_border_outlined),
          selectedIcon: Icon(Icons.favorite),
          label: 'Мои курсы',
        ),
        NavigationRailM3EDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Профиль',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadBitmapFiles();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  Future<List<String>> _listFilesInFolder() async {
    if (!mounted) return [];

    final settings = context.read<SettingsProvider>();
    final folderPath = settings.storageFolder.isNotEmpty
        ? settings.storageFolder
        : (await getApplicationDocumentsDirectory()).path;

    final dir = Directory(folderPath);
    if (!await dir.exists()) return [];

    final List<String> validFiles = [];

    await for (final entity in dir.list(followLinks: false)) {
      if (entity is! File) continue;

      final path = entity.path;
      final name = p.basename(path);

      // Optional: stricter filter by extension
      if (!name.endsWith('.json') && !name.endsWith('.bitmap')) continue;

      try {
        final content = await entity.readAsString();
        final json = jsonDecode(content) as Map<String, dynamic>;

        if (json.containsKey('pixels') &&
            json.containsKey('width') &&
            json.containsKey('height')) {
          validFiles.add(path);   // ← full path!
        }
      } catch (e) {
        // silently skip invalid / broken files
      }
    }

    return validFiles;
  }
  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  void _loadBitmapFiles() async {
    setState(() => _isLoading = true);
    final bitmapFiles = await _listFilesInFolder();
    String _filePath;
    List<BitmapFile> _bitmaps = [];

    for (final path in bitmapFiles) {   // ← path is already absolute
      final file = File(path);
      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;

      _bitmaps.add(BitmapFile(
        filePath: path,                    // full path
        title: json['title'] as String? ?? "Untitled",
        description: json['description'] as String? ?? "",
        createdAt: _parseDate(json['created']),
        editedAt: _parseDate(json['lastModified']),
      ));
    }

    if (mounted) {
      setState(() {
        _allBitmaps = _bitmaps;
        _filteredBitmaps = _bitmaps;
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    _debouncer.run(() {
      if (!mounted) return;
      final query = _searchController.text.toLowerCase().trim();
      if (query != _searchQuery) {
        setState(() {
          _searchQuery = query;
          _filterBitmapFiles();
        });
      }
    });
  }

  void _filterBitmapFiles() {
    if (_searchQuery.isEmpty) {
      _filteredBitmaps = List.from(_allBitmaps);
    } else {
      _filteredBitmaps = _allBitmaps.where((bitmap) {
        final titleMatch = bitmap.title.toLowerCase().contains(_searchQuery);
        final descriptionMatch =
        bitmap.description.toLowerCase().contains(_searchQuery);
        return titleMatch || descriptionMatch;
      }).toList();
    }
  }

  void _startSearch() {
    setState(() => _isSearching = true);
    Future.delayed(const Duration(milliseconds: 100), () {
      _searchFocusNode.requestFocus();
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
    _searchFocusNode.unfocus();
  }

  Widget _buildSearchField() {
    final l10n = AppLocalizations.of(context)!;

    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      autofocus: true,
      decoration: InputDecoration(
        hintText: l10n.homeSearchHint,
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Theme.of(context).hintColor.withAlpha((252 * 0.8).toInt()),
        ),
      ),
      style: TextStyle(
        color: Theme.of(context).appBarTheme.foregroundColor ??
            Theme.of(context).colorScheme.onSurface,
        fontSize: 18,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isSearching) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _stopSearch,
          tooltip: l10n.homeSearchCloseTooltip,
        ),
        title: _buildSearchField(),
        actions: [
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: l10n.homeSearchClearTooltip,
              onPressed: () => _searchController.clear(),
            ),
        ],
      );
    }

    return AppBar(
      title: Text(l10n.appTitle),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: l10n.homeSearchTooltip,
          onPressed: _startSearch,
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: l10n.homeSettingsTooltip,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final useRail = width >= 600;

    NavigationRailM3EType _railType = (800 > width) ? NavigationRailM3EType.alwaysCollapse : NavigationRailM3EType.collapsed;

    final homeScreen = HomeScreen(
      isLoading: _isLoading,
      isSearching: _isSearching,
      allBitmapFiles: _allBitmaps,
      searchQuery: _searchQuery,
      filteredBitmapFiles: _filteredBitmaps,
    );

    final screens = [
      homeScreen,
      const PixelArtEditorScreen(),
      const SettingsScreen(),
    ];

    Widget bodyContent;

    if (useRail) {
      bodyContent = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NavigationRailM3E(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            sections: _railSections,
            type: _railType,
            onTypeChanged: (newType) => setState(() => _railType = newType),
            modality: NavigationRailM3EModality.standard,
            labelBehavior: NavigationRailM3ELabelBehavior.alwaysShow,
            hideWhenCollapsed: false,


            // Опционально: можно добавить FAB
            // fab: NavigationRailM3EFabSlot(...),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: screens[_selectedIndex]),
        ],
      );
    } else {
      bodyContent = screens[_selectedIndex];
    }
    
    final settings = context.read<SettingsProvider>();
    
    List<FabMenuItem> fabItems = [
      FabMenuItem(
        icon: Icon(Icons.close),
        label: Text("Close"),
        onPressed: () => {}
      ),
      FabMenuItem(
          icon: Icon(Icons.find_replace),
          label: Text("Find"),
          onPressed: () => {}
      ),
      FabMenuItem(
          icon: Icon(Icons.add),
          label: Text("Set path"),
          onPressed: () async { await settings.setStorageFolder("/home/miocasa/Documents"); }
      ),
    ];
    return Scaffold(
      appBar: _buildAppBar(context),
      body: bodyContent,
      floatingActionButton: FabMenuM3E(
        primaryFab: FabM3E(
          icon: Icon(Icons.settings)),
        items: fabItems,
      ),
      bottomNavigationBar: !useRail
        ? NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) => setState(() => _selectedIndex = index),
          height: 64,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: _bottomDestinations.map(
                (dest) => NavigationDestination(
              icon: Icon(dest.icon),
              selectedIcon: Icon(dest.selectedIcon),
              label: dest.label(AppLocalizations.of(context)!),
            ),
          ).toList(),
          )
        : null,
    );
  }
}