import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app_theme.dart';

class ThemeService extends GetxService {
  Rx<ThemeData> _themeData = AppThemes.themeDataLight.obs;
  final _box = GetStorage();

  ThemeData get themeData => _themeData.value;

  bool get isDarkMode => _themeData.value.brightness == Brightness.dark;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  void toggleTheme() {
    _themeData.value = isDarkMode ? AppThemes.themeDataLight : AppThemes.themeDataDark;
    _saveThemeToStorage();
  }

  void _loadThemeFromStorage() {
    final themeIndex = _box.read('themeIndex') ?? 0;
    _themeData.value = themeIndex == 0 ? AppThemes.themeDataLight : AppThemes.themeDataDark;
  }

  void _saveThemeToStorage() {
    final themeIndex = isDarkMode ? 1 : 0;
    _box.write('themeIndex', themeIndex);
  }
}
