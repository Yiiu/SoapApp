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
  static Color lightTextColor = const Color(0xff3f3d56);
  static Color darkTextColor = const Color(0xffffffff);

  static final TextTheme _lightTextTheme = TextTheme(
    headline4: TextStyle(
      fontSize: 32,
      color: lightTextColor,
      fontWeight: FontWeight.w600,
    ),
    headline5: TextStyle(
      fontSize: 24,
      color: lightTextColor,
      fontWeight: FontWeight.w600,
    ),
    bodyText2: TextStyle(fontSize: 16, color: lightTextColor),
  );

  static final TextTheme _darkTextTheme = TextTheme(
    headline4: TextStyle(
      fontSize: 32,
      color: darkTextColor,
      fontWeight: FontWeight.w600,
    ),
    headline5: TextStyle(
      fontSize: 24,
      color: darkTextColor,
      fontWeight: FontWeight.w600,
    ),
    bodyText2: TextStyle(fontSize: 16, color: darkTextColor),
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
    cardColor: const Color(0xffffffff),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColorBrightness: Brightness.dark,
    brightness: Brightness.dark,
    fontFamily: 'Rubik',
    backgroundColor: const Color(0xff27282a),
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    cursorColor: darkAccent,
    textTheme: _darkTextTheme,
    errorColor: const Color(0xffff4757),
    cardColor: const Color(0xff2d3132),
  );
}
