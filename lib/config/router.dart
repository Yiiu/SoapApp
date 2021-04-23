import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soap_app/model/user.dart';
import 'package:soap_app/pages/account/login.dart';
import 'package:soap_app/pages/home/index.dart';
import 'package:soap_app/pages/setting/setting.dart';
import 'package:soap_app/pages/user/user.dart';

class RouteName {
  static const String home = '/';
  static const String test = 'test';
  static const String picture_detail = 'picture_detail';
  static const String login = 'login';
  static const String user = 'user';
  static const String setting = 'setting';
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.home:
        return CupertinoPageRoute<void>(
          builder: (_) => HomePage(),
          settings: settings,
        );
      case RouteName.login:
        return CupertinoPageRoute<void>(
          builder: (_) => LoginPage(),
          settings: settings,
        );
      case RouteName.user:
        return CupertinoPageRoute<void>(
          builder: (_) => UserPage(user: settings.arguments! as User),
        );
      case RouteName.setting:
        return CupertinoPageRoute<void>(
          builder: (_) => SettingPage(),
        );
      default:
        return CupertinoPageRoute<void>(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
