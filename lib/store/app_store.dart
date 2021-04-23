import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'app_store.g.dart';

class AppStore = _AppStoreBase with _$AppStore;

abstract class _AppStoreBase with Store {
  @observable
  int _mode = 2;

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
}
