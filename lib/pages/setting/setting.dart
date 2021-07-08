import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/pages/setting/widgets/setting_item.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/filesize.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:soap_app/widget/avatar.dart';
import 'package:soap_app/widget/modal_bottom_sheet.dart';
import 'package:soap_app/widget/more_handle_modal/more_handle_modal.dart';
import 'package:soap_app/widget/select_list.dart';
import 'package:soap_app/widget/soap_toast.dart';

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
    return Material(
      child: FixedAppBarWrapper(
        appBar: SoapAppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          border: true,
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
                          children: [
                            Avatar(
                              image: accountStore.userInfo!.avatarUrl,
                              size: 32,
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
              const SizedBox(height: 12),
              SettingItem(
                title: FlutterI18n.translate(context, 'setting.label.theme'),
                actionIcon: true,
                action: Observer(
                  builder: (_) {
                    if (appStore.themeMode == ThemeMode.dark)
                      return Text(
                        FlutterI18n.translate(
                            context, 'setting.value.theme.black'),
                      );
                    if (appStore.themeMode == ThemeMode.system)
                      return Text(FlutterI18n.translate(
                          context, 'setting.value.theme.system'));
                    return Text(FlutterI18n.translate(
                        context, 'setting.value.theme.light'));
                  },
                ),
                onPressed: () {
                  showBasicModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return MoreHandleModal(
                        title: FlutterI18n.translate(
                            context, 'setting.title.theme'),
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
                      );
                    },
                  );
                },
              ),
              SettingItem(
                title:
                    FlutterI18n.translate(context, 'setting.label.image_cache'),
                actionIcon: true,
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
                    confirmText: Text(FlutterI18n.translate(
                        context, 'setting.btn.clean_cache')),
                    confirm: () async {
                      await clearDiskCachedImages();
                      getImageCached();
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              if (isAndroid)
                Observer(
                  builder: (_) => SettingItem(
                    title: '刷新率选择',
                    actionIcon: true,
                    border: true,
                    action: appStore.displayMode != null
                        ? Text(
                            appStore.modeList[appStore.displayMode!].toString())
                        : Text(''),
                    onPressed: () async {
                      showBasicModalBottomSheet(
                        context: context,
                        builder: (_) => MoreHandleModal(
                          title: '刷新率和分辨率选择',
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Observer(builder: (_) {
                              return SoapSelectList<int?>(
                                value: appStore.displayMode,
                                onChange: (int? value) async {
                                  if (value != null) {
                                    await FlutterDisplayMode.setPreferredMode(
                                      appStore.modeList[value],
                                    );
                                    appStore.setDisplayMode(
                                        appStore.modeList[value].id);
                                    Navigator.of(context).pop();
                                  }
                                },
                                config: appStore.modeList
                                    .map(
                                      (e) => SelectTileConfig<int>(
                                          title: e.toString(), value: e.id),
                                    )
                                    .toList(),
                              );
                            }),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              // SettingItem(
              //   title: '关于肥皂',
              //   actionIcon: true,
              //   border: false,
              //   onPressed: () async {
              //     Navigator.of(context).pushNamed(RouteName.about);
              //   },
              // ),

              SettingItem(
                title: FlutterI18n.translate(context, 'setting.label.img_mode'),
                action: Observer(builder: (_) {
                  return Text(appStore.imgMode == 1
                      ? FlutterI18n.translate(
                          context, 'setting.value.img_mode.big')
                      : FlutterI18n.translate(
                          context, 'setting.value.img_mode.small'));
                }),
                actionIcon: true,
                onPressed: () {
                  showBasicModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return MoreHandleModal(
                        title: FlutterI18n.translate(
                            context, 'setting.title.img_mode'),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Observer(builder: (_) {
                            return SoapSelectList<int>(
                              value: appStore.imgMode,
                              onChange: (int value) => setState(() {
                                appStore.setImgMode(value);
                                Navigator.of(context).pop();
                              }),
                              config: <SelectTileConfig<int>>[
                                SelectTileConfig<int>(
                                  title: FlutterI18n.translate(
                                      context, 'setting.value.img_mode.big'),
                                  subtitle: FlutterI18n.translate(
                                      context, 'setting.message.img_mode.big'),
                                  value: 1,
                                ),
                                SelectTileConfig<int>(
                                  title: FlutterI18n.translate(
                                      context, 'setting.value.img_mode.small'),
                                  subtitle: FlutterI18n.translate(context,
                                      'setting.message.img_mode.small'),
                                  value: 2,
                                ),
                              ],
                            );
                          }),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
