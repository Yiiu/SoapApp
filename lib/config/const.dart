import 'dart:ui';

import 'package:flutter/material.dart';

const double appBarHeight = 75.0;

mixin Constants {
  static String appName = 'Soap';

  //Colors for theme
  static Color lightPrimary = const Color(0xfffcfcff);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Colors.blueGrey[900];
  static Color darkAccent = Colors.white;
  static Color lightBG = const Color(0xffFAFAFA);
  static Color darkBG = Colors.black;
  static Color badgeColor = Colors.red;

  static final TextTheme _lightTextTheme = Typography.whiteCupertino.apply(
    bodyColor: const Color.fromRGBO(0, 0, 0, 0.87),
    displayColor: const Color.fromRGBO(0, 0, 0, 0.87),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Rubik',
    backgroundColor: const Color(0xfffbfcfe),
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(),
    ),
    textTheme: _lightTextTheme,
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Rubik',
    brightness: Brightness.dark,
    backgroundColor: const Color.fromRGBO(28, 28, 28, 1),
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(),
    ),
  );
}
