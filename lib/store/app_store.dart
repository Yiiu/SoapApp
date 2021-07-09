import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:mobx/mobx.dart';
import 'package:soap_app/config/theme.dart';
import 'package:soap_app/utils/storage.dart';

part 'app_store.g.dart';

class AppStore = _AppStoreBase with _$AppStore;

enum localeType { en, zhCN }

const Map<localeType, Locale> localeObj = {
  localeType.en: Locale('en'),
  localeType.zhCN: Locale('zh', 'CN'),
};

final List<Locale> supportedLocales =
    localeObj.entries.map((MapEntry<localeType, Locale> e) => e.value).toList();

abstract class _AppStoreBase with Store {
  @observable
  int mode = 2;

  // 1 大图 2 小图
  @observable
  int imgMode = 1;

  @observable
  localeType? locale;

  @observable
  int? displayMode;

  @observable
  List<DisplayMode> modeList = ObservableList<DisplayMode>();

  @computed
  Locale? get localeMode {
    return localeObj[locale];
  }

  @computed
  String get localeString {
    if (locale == null) {
      return 'system';
    }
    return EnumToString.convertToString(locale);
  }

  @computed
  ThemeMode get themeMode {
    if (mode == 1) {
      return ThemeMode.dark;
    }
    if (mode == 2) {
      return ThemeMode.system;
    }
    return ThemeMode.light;
  }

  @computed
  ThemeData get themeData {
    if (mode == 1) {
      return ThemeConfig.darkTheme;
    }
    return ThemeConfig.lightTheme;
  }

  void setDark() => setMode(1);
  void setLight() => setMode(0);
  void setSystem() => setMode(2);

  @action
  void setMode(int value) {
    StorageUtil.preferences!.setInt('app.mode', value);
    mode = value;
  }

  @action
  void setImgMode(int value) {
    StorageUtil.preferences!.setInt('app.img_mode', value);
    imgMode = value;
  }

  @action
  void setLocale({localeType? value}) {
    if (value != null) {
      StorageUtil.preferences!
          .setString('app.locale', EnumToString.convertToString(value));
    } else {
      StorageUtil.preferences!.remove('app.locale');
    }
    locale = value;
  }

  @action
  void setDisplayMode(int value) {
    StorageUtil.preferences!.setInt('app.display_mode', value);
    displayMode = value;
  }

  @action
  Future<void> initialize() async {
    mode = StorageUtil.preferences!.getInt('app.mode') ?? 2;
    displayMode = StorageUtil.preferences!.getInt('app.display_mode');
    imgMode = StorageUtil.preferences!.getInt('app.img_mode') ?? 1;
    if (StorageUtil.preferences!.getString('app.locale') != null) {
      locale = EnumToString.fromString(
          localeType.values, StorageUtil.preferences!.getString('app.locale')!);
    }
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
}
