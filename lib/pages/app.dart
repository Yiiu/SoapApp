import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/config/router.dart' as RouterConfig;
import 'package:soap_app/config/theme.dart';
import 'package:soap_app/store/index.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: RouterConfig.RouteName.home,
        onGenerateRoute: RouterConfig.Router.generateRoute,
        themeMode: appStore.themeMode,
        theme: ThemeConfig.lightTheme,
        darkTheme: ThemeConfig.darkTheme,
        title: Constants.appName,
      ),
    );
  }
}
