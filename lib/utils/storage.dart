import 'package:shared_preferences/shared_preferences.dart';

mixin StorageUtil {
  static SharedPreferences _preferences;

  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static String getString(String key, {String defValue}) {
    return _preferences.getString(key) ?? defValue;
  }

  static Future<bool> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  static int getInt(String key, {int defValue}) {
    return _preferences.getInt(key) ?? defValue;
  }

  static Future<bool> setInt(String key, int value) {
    return _preferences.setInt(key, value);
  }

  static bool getBool(String key, {bool defValue}) {
    return _preferences.getBool(key) ?? defValue;
  }

  static Future<bool> setBool(String key, bool value) {
    return _preferences.setBool(key, value);
  }

  static void remove(String key) {
    _preferences.remove(key);
  }
}
