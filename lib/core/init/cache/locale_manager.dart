import 'package:shared_preferences/shared_preferences.dart';

import '../../enums/local_manager_keys.dart';

class LocaleManager {
  static final LocaleManager _instance = LocaleManager._init();

  SharedPreferences? _preferences;
  static LocaleManager get instance => _instance;

  LocaleManager._init() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;
    });
  }
  static Future prefrencesInit() async {
    instance._preferences ??= await SharedPreferences.getInstance();
  }

  Future<void> clearAll() async {
    await _preferences?.clear();
  }

  Future<void> setStringValue(LocalManagerKeys key, String value) async {
    await _preferences?.setString(key.toString(), value);
  }

  Future<void> setBoolValue(LocalManagerKeys key, bool value) async {
    await _preferences?.setBool(key.toString(), value);
  }

  Future<void> setIntValue(LocalManagerKeys key, int value) async {
    await _preferences?.setInt(key.toString(), value);
  }

  String getStringValue(LocalManagerKeys key) =>
      _preferences?.getString(key.toString()) ?? 'Not Found';

  bool getBoolValue(LocalManagerKeys key) =>
      _preferences?.getBool(key.toString()) ?? false;

  int getIntValue(LocalManagerKeys key) =>
      _preferences?.getInt(key.toString()) ?? -1;
}
