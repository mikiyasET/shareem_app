import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = (_loadThemeFromBox() ? true : false);
  }

  final _box = GetStorage();
  final _key = 'isDarkMode';
  final isDarkMode = true.obs;

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  _saveThemeToBox(bool isDark) => _box.write(_key, isDark);

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
    update();
  }

  void changeTheme(bool isDark) {
    isDarkMode.value = isDark;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    _saveThemeToBox(isDark);
    update();
  }
}
