import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart';

// import 'section_card.dart';

class NavigationSection extends StatefulWidget {
  const NavigationSection({super.key});

  @override
  State<NavigationSection> createState() => _NavigationSectionState();
}

class _NavigationSectionState extends State<NavigationSection> {
  int _barIndex = 0;
  int _railIndex = 0;

  // Controls for the rail demo
  NavigationRailM3EType _railType = NavigationRailM3EType.collapsed;
  NavigationRailM3EModality _modality = NavigationRailM3EModality.standard;
  bool _hideWhenCollapsed = false;

  double _navigationBarWidth = 450;

  List<NavigationRailM3ESection> get _railSections => const [
    NavigationRailM3ESection(
      header: Text('Main'),
      destinations: [
        NavigationRailM3EDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'Dash',
        ),
        NavigationRailM3EDestination(
          icon: Icon(Icons.analytics_outlined),
          selectedIcon: Icon(Icons.analytics),
          label: 'Reports',
          badgeCount: 0,
        ),
        NavigationRailM3EDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
          badgeCount: 2,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final m3e =
        theme.extension<M3ETheme>() ?? M3ETheme.defaults(theme.colorScheme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: m3e.shapes.round.lg,
          ),
          height: 600,
          child: Row(
            children: [
              NavigationRailM3E(
                type: _railType,
                modality: _modality,
                sections: _railSections,
                selectedIndex: _railIndex,
                onDestinationSelected: (i) => setState(() => _railIndex = i),
                onTypeChanged: (t) => setState(() => _railType = t),
                fab: NavigationRailM3EFabSlot(
                  icon: const Icon(Icons.add),
                  label: 'New',
                  // onPressed: () {},
                ),
                hideWhenCollapsed: _hideWhenCollapsed,
                onDismissModal: () => setState(
                      () => _modality = NavigationRailM3EModality.standard,
                ),
              ),
              const VerticalDivider(width: 1, color: Color.fromARGB(0,0,0,0),),


            ],
          ),
        ),
      ],
    );
  }
}
