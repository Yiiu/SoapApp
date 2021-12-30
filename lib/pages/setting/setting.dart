import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../config/config.dart';
import '../../config/router.dart';
import '../../store/app_store.dart';
import '../../store/index.dart';
import '../../utils/utils.dart';
import '../../widget/widgets.dart';
import 'widgets/setting_item.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({
    Key? key,
  }) : super(key: key);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String cached = '0kb';

  bool isAndroid = true;

  @override
  void initState() {
    try {
      if (Platform.isIOS) {
        isAndroid = false;
      }
    } catch (e) {
      // kisweb = true;
    }
    super.initState();
    getImageCached();
  }

  Future<void> getImageCached() async {
    final String data = filesize(await getCachedSizeBytes());
    setState(() {
      cached = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Map<localeType, String> localeLabelString = {
      localeType.en: 'English',
      localeType.zhCN: '中文',
    };
    return Material(
      child: FixedAppBarWrapper(
        appBar: SoapAppBar(
          automaticallyImplyLeading: true,
          elevation: 0.5,
          actionsPadding: const EdgeInsets.only(
            right: 12,
          ),
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              FlutterI18n.translate(context, 'nav.setting'),
            ),
          ),
        ),
        body: Container(
          color: Theme.of(context).backgroundColor,
          child: ListView(
            physics: const RangeMaintainingScrollPhysics(),
            padding: const EdgeInsets.all(0),
            children: <Widget>[
              Observer(
                builder: (_) => accountStore.isLogin
                    ? SettingItem(
                        title: FlutterI18n.translate(
                            context, 'setting.label.edit_profile'),
                        border: false,
                        actionIcon: false,
                        action: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Avatar(
                              image: accountStore.userInfo!.avatarUrl,
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(RouteName.edit_profile);
                        },
                      )
                    : const SizedBox(),
              ),
              const SoapDivider(),
              SettingItem(
                title: FlutterI18n.translate(
                    context, 'setting.label.style_setting'),
                border: false,
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteName.style_setting);
                },
              ),
              const SizedBox(height: 14),
              SettingItem(
                title: FlutterI18n.translate(context, 'setting.label.theme'),
                border: false,
                action: Observer(
                  builder: (_) {
                    if (appStore.themeMode == ThemeMode.dark) {
                      return Text(
                        FlutterI18n.translate(
                            context, 'setting.value.theme.black'),
                      );
                    }
                    if (appStore.themeMode == ThemeMode.system) {
                      return Text(
                        FlutterI18n.translate(
                          context,
                          'setting.value.theme.system',
                        ),
                      );
                    }
                    return Text(
                      FlutterI18n.translate(
                        context,
                        'setting.value.theme.light',
                      ),
                    );
                  },
                ),
                onPressed: () {
                  showSoapBottomSheet<dynamic>(
                    context,
                    child: MoreHandleModal(
                      title:
                          FlutterI18n.translate(context, 'setting.title.theme'),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Observer(builder: (_) {
                          return SoapSelectList<int>(
                            value: appStore.mode,
                            onChange: (int value) => setState(() {
                              appStore.setMode(value);
                              Navigator.of(context).pop();
                            }),
                            config: <SelectTileConfig<int>>[
                              SelectTileConfig<int>(
                                title: FlutterI18n.translate(
                                    context, 'setting.value.theme.light'),
                                value: 0,
                              ),
                              SelectTileConfig<int>(
                                title: FlutterI18n.translate(
                                    context, 'setting.value.theme.black'),
                                value: 1,
                              ),
                              SelectTileConfig<int>(
                                title: FlutterI18n.translate(
                                    context, 'setting.value.theme.system'),
                                value: 2,
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),
              const SoapDivider(),
              SettingItem(
                title:
                    FlutterI18n.translate(context, 'setting.label.image_cache'),
                border: false,
                action: Text(
                  cached,
                  textAlign: TextAlign.end,
                ),
                onPressed: () async {
                  SoapToast.confirm(
                    FlutterI18n.translate(
                        context, 'setting.confirm.image_cache_confirm'),
                    context: context,
                    cancelText: Text(FlutterI18n.translate(
                        context, 'setting.btn.clean_cancel')),
                    confirmText: Text(FlutterI18n.translate(
                        context, 'setting.btn.clean_cache')),
                    confirm: () async {
                      await clearDiskCachedImages();
                      getImageCached();
                    },
                  );
                },
              ),
              const SizedBox(height: 14),
              SettingItem(
                title: FlutterI18n.translate(context, 'setting.label.locale'),
                action: Observer(builder: (_) {
                  return Text(appStore.locale != null
                      ? localeLabelString[appStore.locale!]!
                      : FlutterI18n.translate(
                          context, 'setting.value.locale.system'));
                }),
                border: false,
                onPressed: () {
                  showSoapBottomSheet<void>(
                    context,
                    child: MoreHandleModal(
                      title: FlutterI18n.translate(
                          context, 'setting.title.locale'),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Observer(
                          builder: (_) {
                            return SoapSelectList<String>(
                              value: appStore.localeString,
                              onChange: (String value) => setState(() {
                                if (value == 'system') {
                                  appStore.setLocale();
                                } else {
                                  appStore.setLocale(
                                    value: EnumToString.fromString(
                                      localeType.values,
                                      value,
                                    ),
                                  );
                                }
                                // appStore.setImgMode(value);
                                // Navigator.of(context).pop();
                              }),
                              config: <SelectTileConfig<String>>[
                                SelectTileConfig<String>(
                                  title: FlutterI18n.translate(
                                      context, 'setting.value.locale.system'),
                                  value: 'system',
                                ),
                                ...EnumToString.toList(localeType.values)
                                    .map(
                                      (String e) => SelectTileConfig<String>(
                                        title: localeLabelString[
                                            EnumToString.fromString(
                                          localeType.values,
                                          e,
                                        )]!,
                                        value: e,
                                      ),
                                    )
                                    .toList(),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              // if (accountStore.isLogin) ...<Widget>[
              const SizedBox(height: 14),
              Container(
                color: theme.cardColor,
                child: TouchableOpacity(
                  activeOpacity: activeOpacity,
                  onTap: () async {
                    await accountStore.signup();
                    SoapToast.success('已登出!');
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteName.first_home,
                      (route) => route.isFirst,
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    child: Text(
                      FlutterI18n.translate(context, 'profile.btn.signout'),
                      style: TextStyle(
                        color: theme.errorColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}
