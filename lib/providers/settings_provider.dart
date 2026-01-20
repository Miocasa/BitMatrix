import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  String _bitmapFolder = '';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _bitmapFolder = prefs.getString("bitmap_folder") ?? '';
    notifyListeners();
  }

  Future<void> setBitmapFolder(String? path) async {
    final prefs = await SharedPreferences.getInstance();
    if(path == null){
      await prefs.remove("bitmap_folder");
    } else {
      await prefs.setString("bitmap_folder", path);
      _bitmapFolder = path;
    }
  }

  String get storageFolder {
    return _bitmapFolder;
  }

  void set storageFolder(String path) => setStorageFolder(path);

  Future<void> setStorageFolder(String? path) async {
    final prefs = await SharedPreferences.getInstance();
    if (path == null || path.trim().isEmpty) {
      await prefs.remove("bitmap_folder");
      _bitmapFolder = '';
    } else {
      await prefs.setString("bitmap_folder", path);
      _bitmapFolder = path;
    }
    notifyListeners();
  }

  Future<String> get documentsPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

}
