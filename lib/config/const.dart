import 'dart:ui';

import 'package:flutter/material.dart';

const double appBarHeight = 75.0;

mixin Constants {
  static String appName = 'Soap';

  //Colors for theme
  static Color lightPrimary = const Color(0xff1A5CFF);
  static Color darkPrimary = Colors.black;
  static Color lightAccent = Colors.blueGrey[900];
  static Color darkAccent = Colors.white;
  static Color lightBG = const Color(0xffFAFAFA);
  static Color darkBG = Colors.black;
  static Color badgeColor = Colors.red;
  static Color textColor = const Color(0xff3f3d56);

  static final TextTheme _lightTextTheme = TextTheme(
    headline5: TextStyle(
      fontSize: 24,
      color: textColor,
      fontWeight: FontWeight.w600,
    ),
    bodyText2: TextStyle(fontSize: 16, color: textColor),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Rubik',
    backgroundColor: const Color(0xfff5f4f9),
    primaryColorBrightness: Brightness.light,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    errorColor: const Color(0xffff4757),
    textTheme: _lightTextTheme,
  );

  static ThemeData darkTheme = ThemeData(
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
