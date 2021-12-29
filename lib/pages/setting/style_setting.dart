import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../store/index.dart';
import '../../widget/widgets.dart';
import 'widgets/setting_item.dart';

class StyleSettingPage extends StatefulWidget {
  const StyleSettingPage({Key? key}) : super(key: key);

  @override
  _StyleSettingPageState createState() => _StyleSettingPageState();
}

class _StyleSettingPageState extends State<StyleSettingPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
              FlutterI18n.translate(context, 'nav.style_setting'),
            ),
          ),
        ),
        body: Container(
          color: Theme.of(context).backgroundColor,
          child: ListView(
              physics: const RangeMaintainingScrollPhysics(),
              children: <Widget>[
                SettingItem(
                  title: FlutterI18n.translate(
                      context, 'setting.title.home_style'),
                  border: false,
                  action: Observer(
                    builder: (_) {
                      if (appStore.homeStyle == 1) {
                        return Text(FlutterI18n.translate(
                            context, 'setting.value.home_style.single'));
                      }
                      return Text(FlutterI18n.translate(
                          context, 'setting.value.home_style.waterfall'));
                    },
                  ),
                  onPressed: () {
                    showSoapBottomSheet<dynamic>(
                      context,
                      child: MoreHandleModal(
                        title: FlutterI18n.translate(
                            context, 'setting.title.home_style'),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Observer(
                            builder: (_) {
                              return SoapSelectList<int>(
                                value: appStore.homeStyle,
                                onChange: (int value) => setState(() {
                                  appStore.setHomeStyle(value);
                                  Navigator.of(context).pop();
                                }),
                                config: <SelectTileConfig<int>>[
                                  SelectTileConfig<int>(
                                    title: FlutterI18n.translate(context,
                                        'setting.value.home_style.single'),
                                    value: 1,
                                  ),
                                  SelectTileConfig<int>(
                                    title: FlutterI18n.translate(context,
                                        'setting.value.home_style.waterfall'),
                                    value: 2,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SoapDivider(),
                if (Platform.isAndroid) ...[
                  Observer(
                    builder: (_) => SettingItem(
                      title: FlutterI18n.translate(
                          context, 'setting.title.display_mode'),
                      border: false,
                      action: appStore.displayMode != null
                          ? Text(appStore.modeList[appStore.displayMode!]
                              .toString())
                          : const Text(''),
                      onPressed: () async {
                        showSoapBottomSheet<void>(
                          context,
                          child: MoreHandleModal(
                            title: FlutterI18n.translate(
                                context, 'setting.title.display_mode'),
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
                  Container(
                    height: 1,
                    color: theme.cardColor,
                    child: Center(
                      child: Container(
                        height: 0.4,
                        color: theme.textTheme.overline!.color!.withOpacity(.1),
                      ),
                    ),
                  ),
                  const SoapDivider(),
                ],
                SettingItem(
                  title:
                      FlutterI18n.translate(context, 'setting.label.img_mode'),
                  action: Observer(builder: (_) {
                    return Text(appStore.imgMode == 1
                        ? FlutterI18n.translate(
                            context, 'setting.value.img_mode.big')
                        : FlutterI18n.translate(
                            context, 'setting.value.img_mode.small'));
                  }),
                  border: false,
                  onPressed: () {
                    showSoapBottomSheet<void>(
                      context,
                      child: MoreHandleModal(
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
                      ),
                    );
                  },
                ),
              ]),
        ),
      ),
    );
  }
}
