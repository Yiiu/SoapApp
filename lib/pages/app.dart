import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../config/const.dart';

// ignore: library_prefixes
import '../config/router.dart' as RouterConfig;
import '../config/theme.dart';
import '../generated/l10n.dart';
import '../store/app_store.dart';
import '../store/index.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
    return Observer(
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
        builder: (BuildContext context, Widget? widget) {
          return BotToastInit()(
            context,
            RefreshConfiguration(
              headerBuilder: () => ClassicHeader(
                releaseText: FlutterI18n.translate(
                    context, 'common.refresh.release_text'),
                idleText:
                    FlutterI18n.translate(context, 'common.refresh.idle_text'),
                refreshingText: FlutterI18n.translate(
                    context, 'common.refresh.refreshing_text'),
                completeText: FlutterI18n.translate(
                    context, 'common.refresh.complete_text'),
                failedText: FlutterI18n.translate(
                    context, 'common.refresh.failed_text'),
                failedIcon:
                    const Icon(FeatherIcons.alertCircle, color: Colors.red),
                refreshingIcon: const CupertinoActivityIndicator(),
                idleIcon:
                    const Icon(FeatherIcons.arrowDown, color: Colors.grey),
                releaseIcon:
                    const Icon(FeatherIcons.arrowUp, color: Colors.grey),
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
              ),
              // 自定义回弹动画,三个属性值意义请查询flutter api
              enableScrollWhenRefreshCompleted: true,
              //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
              child: widget!,
            ),
          );
        },
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
    );
  }
}
