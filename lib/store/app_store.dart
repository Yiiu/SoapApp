import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:soap_app/config/theme.dart';
import 'package:soap_app/utils/storage.dart';

part 'app_store.g.dart';

class AppStore = _AppStoreBase with _$AppStore;

abstract class _AppStoreBase with Store {
  @observable
  int _mode = 2;

  void setDark() => _setMode(1);
  void setLight() => _setMode(0);
  void setSystem() => _setMode(2);

  @action
  void _setMode(int value) {
    StorageUtil.preferences!.setInt('app.mode', value);
    _mode = value;
  }

  void initialize() {
    final int mode = StorageUtil.preferences!.getInt('app.mode') ?? 2;
    _setMode(mode);
  }

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
