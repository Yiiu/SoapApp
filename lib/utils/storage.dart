import 'package:shared_preferences/shared_preferences.dart';

mixin StorageUtil {
  static SharedPreferences? preferences;

  static Future<void> initialize() async {
    preferences = await SharedPreferences.getInstance();
  }
}
