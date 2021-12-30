import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const double appBarHeight = 58.0;

const double activeOpacity = 0.8;

const Radius radius = Radius.circular(12);

mixin ThemeConfig {
  static String appName = 'Soap';

  //Colors for theme
  static Color lightPrimary = const Color(0xff1A5CFF);
  static Color darkPrimary = const Color(0xff1A5CFF);
  static Color lightAccent = Colors.blueGrey[900]!;
  static Color darkAccent = Colors.white;
  static Color lightBG = const Color(0xffFAFAFA);
  static Color darkBG = const Color(0xff0d0d0f);
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
    bodyText1: TextStyle(
      fontSize: 16,
      color: lightTextColor,
    ),
    bodyText2: TextStyle(
      fontSize: 16,
      color: lightTextColor,
    ),
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
    bodyText1: TextStyle(
      fontSize: 16,
      color: darkTextColor,
    ),
    bodyText2: TextStyle(
      fontSize: 16,
      color: darkTextColor,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    fontFamily: '江城圆体',
    brightness: Brightness.light,
    backgroundColor: const Color(0xfff9fafa),
    primaryColorBrightness: Brightness.light,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBG,
    errorColor: const Color(0xffff4757),
    textTheme: _lightTextTheme,
    appBarTheme: const AppBarTheme(
      brightness: Brightness.dark,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    primaryIconTheme: IconThemeData(color: lightTextColor.withOpacity(.8)),
    dialogBackgroundColor: const Color(0xff000000),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedLabelStyle: const TextStyle(
        color: Color(0xffffffff),
      ),
      selectedItemColor: lightTextColor,
    ),
    cardColor: const Color(0xffffffff),
  );

  static ThemeData darkTheme = ThemeData(
    fontFamily: '江城圆体',
    primaryColorBrightness: Brightness.dark,
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBG,
    textTheme: _darkTextTheme,
    primaryIconTheme: IconThemeData(color: darkTextColor.withOpacity(.8)),
    errorColor: const Color(0xffff4757),
    cardColor: const Color(0xff19181e),
    appBarTheme: const AppBarTheme(
      brightness: Brightness.light,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    dialogBackgroundColor: const Color(0xff000000),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedLabelStyle: TextStyle(
        color: darkTextColor,
      ),
      selectedItemColor: const Color(0xff141414),
    ),
  );
}
