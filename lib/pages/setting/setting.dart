import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/pages/setting/widgets/setting_item.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/filesize.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:soap_app/widget/avatar.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class SettingPage extends StatefulWidget {
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
    String data = filesize(await getCachedSizeBytes());
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
          elevation: 0.2,
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
                    ? Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: SettingItem(
                          title: '个人资料',
                          actionIcon: false,
                          action: Avatar(
                            image: accountStore.userInfo!.avatarUrl,
                            size: 32,
                          ),
                          onPressed: () {},
                        ),
                      )
                    : SizedBox(),
              ),
              const SizedBox(height: 12),
              SettingItem(
                title: '系统模式',
                actionIcon: false,
                action: Observer(
                  builder: (_) {
                    if (appStore.themeMode == ThemeMode.dark)
                      return Text(
                        '黑暗模式',
                      );
                    if (appStore.themeMode == ThemeMode.system)
                      return Text('系统设置');
                    return Text('亮色设置');
                  },
                ),
                onPressed: () {
                  showCustomModalBottomSheet<dynamic>(
                    context: context,
                    containerWidget: (_, animation, child) => Container(
                      child: child,
                    ),
                    builder: (_) {
                      return Material(
                        color: Theme.of(context).cardColor,
                        child: SafeArea(
                          top: false,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '系统模式',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .color,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 6),
                                TouchableOpacity(
                                  activeOpacity: activeOpacity,
                                  onTap: () {
                                    appStore.setLight();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 14),
                                    child: Text('亮色模式'),
                                  ),
                                ),
                                TouchableOpacity(
                                  activeOpacity: activeOpacity,
                                  onTap: () {
                                    appStore.setDark();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 12),
                                    child: Text('暗色模式'),
                                  ),
                                ),
                                TouchableOpacity(
                                  activeOpacity: activeOpacity,
                                  onTap: () {
                                    appStore.setSystem();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 12),
                                    child: Text('系统自动'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(6),
                          topLeft: Radius.circular(6),
                        ),
                      );
                    },
                  );
                },
              ),
              SettingItem(
                title: '图片缓存',
                actionIcon: false,
                action: Text(cached),
                onPressed: () async {
                  await clearDiskCachedImages();
                  getImageCached();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
