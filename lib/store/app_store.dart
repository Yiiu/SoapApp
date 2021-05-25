import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:mobx/mobx.dart';
import 'package:soap_app/config/theme.dart';
import 'package:soap_app/utils/storage.dart';

part 'app_store.g.dart';

class AppStore = _AppStoreBase with _$AppStore;

abstract class _AppStoreBase with Store {
  @observable
  int _mode = 2;

  @observable
  int? displayMode;

  @observable
  List<DisplayMode> modeList = ObservableList<DisplayMode>();

  void setDark() => _setMode(1);
  void setLight() => _setMode(0);
  void setSystem() => _setMode(2);

  @action
  void _setMode(int value) {
    StorageUtil.preferences!.setInt('app.mode', value);
    _mode = value;
  }

  @action
  void setDisplayMode(int value) {
    StorageUtil.preferences!.setInt('app.display_mode', value);
    displayMode = value;
  }

  @action
  Future<void> initialize() async {
    _mode = StorageUtil.preferences!.getInt('app.mode') ?? 2;
    displayMode = StorageUtil.preferences!.getInt('app.display_mode');
    await _initializeDisplayMode();
  }

  @action
  Future<void> _initializeDisplayMode() async {
    try {
      if (Platform.isAndroid) {
        modeList = await FlutterDisplayMode.supported;
        if (displayMode != null && modeList.length > displayMode!) {
          await FlutterDisplayMode.setPreferredMode(modeList[displayMode!]);
        } else {
          // ignore: unnecessary_statements
          (() async {
            await Future<void>.delayed(const Duration(milliseconds: 2000));
            await FlutterDisplayMode.setHighRefreshRate();
            await Future<void>.delayed(const Duration(milliseconds: 500));
            final DisplayMode active = await FlutterDisplayMode.active;
            displayMode = active.id;
          })();
        }
        // ignore: empty_catches
      }
    } catch (e) {}
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
