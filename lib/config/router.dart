import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/model/user.dart';
import 'package:soap_app/screens/account/login.dart';
import 'package:soap_app/screens/picture_detail/index.dart';
import 'package:soap_app/screens/user/index.dart';

import '../screens/home/index.dart';

class RouteName {
  static const String home = '/';
  static const String test = 'test';
  static const String picture_detail = 'picture_detail';
  static const String login = 'login';
  static const String user = 'user';
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.home:
        return MaterialWithModalsPageRoute<void>(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case RouteName.picture_detail:
        return MaterialPageRoute<void>(
          builder: (_) => PictureDetail(picture: settings.arguments as Picture),
        );
      case RouteName.login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginView(),
        );
      case RouteName.user:
        return CupertinoPageRoute<void>(
          builder: (_) => UserView(user: settings.arguments as User),
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
