import 'package:flutter/material.dart';

class NoAnimRouteBuilder extends PageRouteBuilder<void> {
  NoAnimRouteBuilder(
    this.page,
  ) : super(
          opaque: false,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionDuration: const Duration(milliseconds: 0),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              child,
        );

  final Widget page;
}
