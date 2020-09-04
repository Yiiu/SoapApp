import 'package:flutter/material.dart';
import 'package:soap_app/utils/storage.dart';

class AppProvider with ChangeNotifier {
  AppProvider() {
    setup();
  }

  bool _darkMode = StorageUtil.getBool(DARK_MODE_KEY, defValue: false);

  static const String DARK_MODE_KEY = 'setting.darkMode';

  void setup() {}

  bool get isDarkMode {
    return _darkMode;
  }

  void changeMode(bool darkMode) {
    _darkMode = darkMode;

    notifyListeners();
    StorageUtil.setBool(DARK_MODE_KEY, darkMode);
  }
}
