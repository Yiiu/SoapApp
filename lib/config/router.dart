import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/home/index.dart';
import '../screens/test.dart';
import '../ui/widget/route_animation.dart';

class RouteName {
  static const home = '/';
  static const test = 'test';
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.home:
        return NoAnimRouteBuilder(
          HomePage(
            title: 'test',
          ),
        );
      case RouteName.test:
        return CupertinoPageRoute(
          // fullscreenDialog: true,
          builder: (_) => Test(),
        );
      default:
        return CupertinoPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
