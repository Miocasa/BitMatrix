import 'package:bitmatrix/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bitmatrix/generated/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Helper method to show a confirmation dialog
  Future<bool?> _showLogoutConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.settingsConfirmLogoutTitle),
          content: Text(AppLocalizations.of(context)!.settingsConfirmLogoutBody),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.settingsCancel),
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // Return false
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error, // Make it red or distinct
              ),
              child: Text(AppLocalizations.of(context)!.settingsLogout),
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // Return true
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    // final authService = Provider.of<AuthService>(context, listen: false); // Get AuthService
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        children: <Widget>[
          // --- Theme Mode Section ---
          _buildSectionTitle(context, 'Appearance'),
          Card(
            // ... (existing theme mode RadioListTiles) ...
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text(AppLocalizations.of(context)!.settingsLightMode, style: textTheme.titleMedium,),
                    value: ThemeMode.light,
                    groupValue: themeProvider.themeMode,
                    onChanged: (ThemeMode? value) {
                      if (value != null) themeProvider.setThemeMode(value);
                    },
                    secondary: const Icon(Icons.light_mode_outlined),
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(AppLocalizations.of(context)!.settingsDarkMode, style: textTheme.titleMedium,),
                    value: ThemeMode.dark,
                    groupValue: themeProvider.themeMode,
                    onChanged: (ThemeMode? value) {
                      if (value != null) themeProvider.setThemeMode(value);
                    },
                    secondary: const Icon(Icons.dark_mode_outlined),
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(AppLocalizations.of(context)!.settingsSystemMode, style: textTheme.titleMedium,),
                    value: ThemeMode.system,
                    groupValue: themeProvider.themeMode,
                    onChanged: (ThemeMode? value) {
                      if (value != null) themeProvider.setThemeMode(value);
                    },
                    secondary: const Icon(Icons.brightness_auto_outlined),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24.0),

          // --- Primary Color Section ---
          _buildSectionTitle(context, AppLocalizations.of(context)!.settingsPrimaryColorSection,),
          Card(
            // ... (existing primary color selection Wrap) ...
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.settingsPrimaryColorHint,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16.0),
                  Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children: appColorChoices.entries.map((entry) {
                      final colorName = entry.key;
                      final colorValue = entry.value;
                      final bool isSelected = themeProvider.primaryColorName == colorName;
                      
                      return GestureDetector(
                        onTap: () {
                          themeProvider.setPrimaryColor(colorName);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: colorValue,
                            borderRadius: BorderRadius.circular(25),
                            border: isSelected
                                ? Border.all(color: colorScheme.outlineVariant, width: 3)
                                : Border.all(color: colorValue.withAlpha(128), width: 1),
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: colorValue.withAlpha(128),
                                blurRadius: 6.0,
                                offset: const Offset(0, 2),
                              )
                            ]
                                : [],
                          ),
                          child: isSelected
                              ? Icon(Icons.check, color: ThemeData.estimateBrightnessForColor(colorValue) == Brightness.dark ? Colors.white : Colors.black, size: 28)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24.0),

          // --- Account Section ---
          _buildSectionTitle(context, AppLocalizations.of(context)!.settingsAccountSection),
          Card(
            child: ListTile(
              leading: Icon(Icons.logout, color: colorScheme.error), // Distinct color for logout
              title: Text(
                AppLocalizations.of(context)!.settingsLogout,
                style: textTheme.titleMedium?.copyWith(
                color: colorScheme.error, 
              ), 
            ),

// ... inside SettingsScreen
              onTap: () async {
                // final confirmLogout = await _showLogoutConfirmationDialog(context);
                // if (confirmLogout == true) {
                //   try {
                //     await authService.signOut();
                //     // After successful sign out, pop all routes until the user is back at the AuthGate/LoginScreen.
                //     // AuthGate will then rebuild due to authStateChanges and show the LoginScreen.
                //     if (mounted) { // Ensure the widget is still in the tree
                //       Navigator.of(context).popUntil((route) => route.isFirst);
                //     }
                //   } catch (e) {
                //     if (mounted) {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(content: Text(AppLocalizations.of(context)!.settingsLogoutFailedWithReason(e.toString())))
                //       );
                //     }
                //   }
                // }
              },
// ...

            ),
          ),
          const SizedBox(height: 24.0),


          // --- About Section ---
         _buildSectionTitle(context, AppLocalizations.of(context)!.settingsAboutSection),
          Card(
            // ... (existing About ListTile) ...
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(AppLocalizations.of(context)!.settingsAboutAppTitle, style: textTheme.titleMedium),
              subtitle: Text(AppLocalizations.of(context)!.settingsAboutAppSubtitle(AppLocalizations.of(context)!.settingsAboutAppVersion), style: textTheme.bodyMedium),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: AppLocalizations.of(context)!.settingsAboutAppName,
                  applicationVersion: AppLocalizations.of(context)!.settingsAboutAppVersion,
                  applicationLegalese: AppLocalizations.of(context)!.settingsAboutAppLegalese(DateTime.now().year.toInt()),
                  applicationIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.school, size: 40, color: colorScheme.primary),
                  ),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(AppLocalizations.of(context)!.settingsAboutAppDescription),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    // ... (existing _buildSectionTitle method) ...
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

