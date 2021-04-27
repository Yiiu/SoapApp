import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/config/router.dart' as RouterConfig;
import 'package:soap_app/config/theme.dart';
import 'package:soap_app/store/index.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerBuilder: () => ClassicHeader(),
      footerBuilder: () => ClassicFooter(),
      headerTriggerDistance: 80.0,
      springDescription: SpringDescription(
        stiffness: 170,
        damping: 16,
        mass: 1.9,
      ), // 自定义回弹动画,三个属性值意义请查询flutter api
      enableScrollWhenRefreshCompleted:
          true, //这个属性不兼容PageView和TabBarView,如果你特别需要TabBarView左右滑动,你需要把它设置为true
      enableLoadingWhenFailed: true, //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
      child: Observer(
        builder: (_) => MaterialApp(
          localizationsDelegates: [
            // 这行是关键
            RefreshLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('zh'),
          ],
          localeResolutionCallback:
              (Locale? locale, Iterable<Locale> supportedLocales) {
            //print("change language");

            return locale ?? const Locale('zh');
          },
          debugShowCheckedModeBanner: false,
          initialRoute: RouterConfig.RouteName.home,
          onGenerateRoute: RouterConfig.Router.generateRoute,
          themeMode: appStore.themeMode,
          theme: ThemeConfig.lightTheme,
          darkTheme: ThemeConfig.darkTheme,
          title: Constants.appName,
        ),
      ),
    );
  }
}
