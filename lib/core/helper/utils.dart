import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/init/cache/locale_manager.dart';
import '../../core/init/theme/dark_theme.dart';
import '../../core/init/theme/light_theme.dart';
import '../enums/local_manager_keys.dart';
import '../provider/theme_provider.dart';

class Utils {
  static final Utils _instance = Utils();
  static Utils get instance => _instance;

  void setSystemUi(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(isDark ? 0xffffff : 0xff121212),
        statusBarColor: Color(isDark ? 0xff3280c0 : 0xff616161),
        systemNavigationBarIconBrightness:
            isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  Future<void> onThemeChanged(bool isDark, ThemeProvider themeNotifier) async {
    Utils.instance.setSystemUi(themeNotifier.isDark());
    (isDark)
        ? themeNotifier.theme = getDarkTheme()
        : themeNotifier.theme = getLightTheme();
    await LocaleManager.instance
        .setBoolValue(LocalManagerKeys.darkMode, isDark);
  }
}
