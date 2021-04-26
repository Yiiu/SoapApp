import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:soap_app/config/theme.dart';

part 'app_store.g.dart';

class AppStore = _AppStoreBase with _$AppStore;

abstract class _AppStoreBase with Store {
  @observable
  int _mode = 2;

  @action
  void setDark() => _mode = 1;

  @action
  void setLight() => _mode = 0;

  @action
  void setSystem() => _mode = 2;

  @computed
  ThemeMode get themeMode {
    if (_mode == 1) {
      return ThemeMode.dark;
    }
    if (_mode == 2) {
      return ThemeMode.system;
    }
    return ThemeMode.light;
  }

  @computed
  ThemeData get themeData {
    if (_mode == 1) {
      return ThemeConfig.darkTheme;
    }
    return ThemeConfig.lightTheme;
  }
}
