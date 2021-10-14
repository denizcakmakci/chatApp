import 'package:flutter/material.dart';
import '../../core/init/cache/locale_manager.dart';
import '../../core/init/theme/dark_theme.dart';
import '../../core/init/theme/light_theme.dart';
import '../enums/local_manager_keys.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = getDarkTheme();
  static final ThemeProvider _instance = ThemeProvider();
  static ThemeProvider get instance => _instance;

  ThemeData get theme => _instance._themeData;

  set theme(ThemeData themeData) {
    _instance._themeData = themeData;
    notifyListeners();
  }

  Future<void> fetchLocale() async {
    var isDark =
        await LocaleManager.instance.getBoolValue(LocalManagerKeys.darkMode);
    if (!isDark) {
      _instance._themeData = getLightTheme();
      _themeData = getLightTheme();
    }
  }

  bool isDark() {
    return _instance.theme == getDarkTheme();
  }
}
