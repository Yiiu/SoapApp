import 'package:shared_preferences/shared_preferences.dart';

mixin StorageUtil {
  static SharedPreferences _preferences;

  static Future<void> inicializar() async {
    if (_preferences != null) {
      return;
    }
    _preferences = await SharedPreferences.getInstance();
  }

  static String getString(String key, {String defValue}) {
    if (_preferences == null) {
      return null;
    }
    return _preferences.getString(key) ?? defValue;
  }

  static void setString(String key, String value) {
    if (_preferences == null) {
      return;
    }
    _preferences.setString(key, value);
  }

  static void remove(String key) {
    if (_preferences == null) {
      return;
    }
    _preferences.remove(key);
  }
}
