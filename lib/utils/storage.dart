import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static SharedPreferences? preferences;

  static Future<void> initialize() async {
    preferences = await SharedPreferences.getInstance();
  }
}
