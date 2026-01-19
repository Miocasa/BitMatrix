import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bitmatrix/providers/theme_provider.dart';
import 'package:bitmatrix/screens/main_screen.dart';

// Локализация
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bitmatrix/generated/app_localizations.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Локализация
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      themeMode: themeProvider.themeMode,
      theme: themeProvider.currentLightTheme,
      darkTheme: themeProvider.currentDarkTheme,

      home: const MainScreen(),
    );
  }
}