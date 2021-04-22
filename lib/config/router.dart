import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soap_app/pages/account/login.dart';
import 'package:soap_app/pages/home/index.dart';

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
