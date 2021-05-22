import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
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

class SettingPage extends StatefulWidget {
  const SettingPage({
    Key? key,
  }) : super(key: key);
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String cached = '0kb';

  @override
  void initState() {
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
        appBar: const SoapAppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          border: true,
          actionsPadding: EdgeInsets.only(
            right: 12,
          ),
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '设置',
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
                        title: '个人资料',
                        border: false,
                        actionIcon: false,
                        action: Avatar(
                          image: accountStore.userInfo!.avatarUrl,
                          size: 32,
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
                title: '系统模式',
                actionIcon: false,
                action: Observer(
                  builder: (_) {
                    if (appStore.themeMode == ThemeMode.dark)
                      return const Text(
                        '黑暗模式',
                      );
                    if (appStore.themeMode == ThemeMode.system)
                      return const Text('系统设置');
                    return const Text('亮色设置');
                  },
                ),
                onPressed: () {
                  showBasicModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return MoreHandleModal(
                        title: '系统模式',
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: const Text('亮色模式'),
                              onTap: () {
                                appStore.setLight();
                                setState(() {});
                              },
                              selected: appStore.themeMode == ThemeMode.light,
                            ),
                            ListTile(
                              title: const Text('暗色模式'),
                              onTap: () {
                                appStore.setDark();
                                setState(() {});
                              },
                              selected: appStore.themeMode == ThemeMode.dark,
                            ),
                            ListTile(
                              title: const Text('系统自动'),
                              onTap: () {
                                appStore.setSystem();
                                setState(() {});
                              },
                              selected: appStore.themeMode == ThemeMode.system,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              SettingItem(
                title: '图片缓存',
                actionIcon: false,
                border: false,
                action: Text(cached),
                onPressed: () async {
                  await clearDiskCachedImages();
                  getImageCached();
                },
              ),
              const SizedBox(height: 12),
              if (Platform.isAndroid)
                Observer(
                  builder: (_) => SettingItem(
                    title: '刷新率选择',
                    actionIcon: false,
                    border: false,
                    action: appStore.displayMode != null
                        ? Text(
                            appStore.modeList[appStore.displayMode!].toString())
                        : Text(''),
                    onPressed: () async {
                      showBasicModalBottomSheet(
                        context: context,
                        builder: (_) => MoreHandleModal(
                          title: '刷新率和分辨率选择',
                          child: SafeArea(
                            top: false,
                            child: Container(
                              constraints: const BoxConstraints(maxHeight: 320),
                              child: Observer(
                                builder: (_) {
                                  return MediaQuery.removePadding(
                                    removeTop: true,
                                    context: context,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      controller:
                                          ModalScrollController.of(context),
                                      itemCount: appStore.modeList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                          title: Text(
                                            appStore.modeList[index].toString(),
                                          ),
                                          selected:
                                              appStore.displayMode == index,
                                          onTap: () async {
                                            await FlutterDisplayMode
                                                .setPreferredMode(
                                              appStore.modeList[index],
                                            );
                                            appStore.setDisplayMode(
                                                appStore.modeList[index].id);
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
