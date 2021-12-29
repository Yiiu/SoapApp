import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../config/const.dart';
import '../config/router.dart' as RouterConfig;
import '../config/theme.dart';
import '../generated/l10n.dart';
import '../store/app_store.dart';
import '../store/index.dart';
import '../widget/will_pop_soap.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final List<Locale> an = [
      const Locale('en', 'US'),
    ];
    final List<Locale> ios = [
      const Locale('en', 'US'),
    ];
    return RefreshConfiguration(
      headerBuilder: () => const ClassicHeader(
        releaseText: '松开刷新',
        idleText: '下拉刷新',
        refreshingText: '刷新中',
        completeText: '刷新成功',
        failedText: '刷新失败',
        failedIcon: Icon(FeatherIcons.alertCircle, color: Colors.red),
        refreshingIcon: CupertinoActivityIndicator(),
        idleIcon: Icon(FeatherIcons.arrowDown, color: Colors.grey),
        releaseIcon: Icon(FeatherIcons.arrowUp, color: Colors.grey),
        refreshStyle: RefreshStyle.UnFollow,
      ),
      footerBuilder: () => const ClassicFooter(
        loadingText: '加载中',
        canLoadingText: '松手加载',
        idleText: '上拉加载',
        idleIcon: Icon(FeatherIcons.arrowUp, color: Colors.grey),
        canLoadingIcon: Icon(FeatherIcons.loader, color: Colors.grey),
        failedIcon: Icon(FeatherIcons.alertCircle, color: Colors.red),
        failedText: '加载失败,请重试',
        noDataText: '已经到底啦',
        loadingIcon: CupertinoActivityIndicator(),
      ),
      springDescription: const SpringDescription(
        stiffness: 170,
        damping: 16,
        mass: 1.9,
      ), // 自定义回弹动画,三个属性值意义请查询flutter api
      enableScrollWhenRefreshCompleted:
          true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
      child: Observer(
        builder: (_) => MaterialApp(
          localizationsDelegates: [
            S.delegate,
            FlutterI18nDelegate(
              translationLoader: FileTranslationLoader(
                // fallbackFile: 'zh',
                basePath: 'assets/i18n',
              ),
            ),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: supportedLocales,
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver()],
          debugShowCheckedModeBanner: false,
          initialRoute: RouterConfig.RouteName.home,
          onGenerateRoute: RouterConfig.Router.generateRoute,
          themeMode: appStore.themeMode,
          theme: ThemeConfig.lightTheme,
          darkTheme: ThemeConfig.darkTheme,
          title: Constants.appName,
          locale: appStore.localeMode,
        ),
      ),
    );
  }
}
