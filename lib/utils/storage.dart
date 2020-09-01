import 'package:shared_preferences/shared_preferences.dart';

mixin StorageUtil {
  static SharedPreferences _preferences;

  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static String getString(String key, {String defValue}) {
    return _preferences.getString(key) ?? defValue;
  }

  static void setString(String key, String value) {
    _preferences.setString(key, value);
  }

  static void remove(String key) {
    _preferences.remove(key);
  }
}
