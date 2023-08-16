import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData appThemData() {
  return ThemeData(
    primaryColor: const Color(0xFF52B45F),
    focusColor: const Color(0xFF588EE5),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF52B45F),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF52B45F),
    ),
    fontFamily: 'Roboto',
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Color(0xFF282B39),
        fontWeight: FontWeight.w500,
        fontSize: 36,
      ),
      displayMedium: TextStyle(
        color: Color(0xFF282B39),
        fontWeight: FontWeight.w500,
        fontSize: 28,
      ),
      displaySmall: TextStyle(
        color: Color(0xFF282B39),
        fontWeight: FontWeight.w500,
        fontSize: 24,
      ),
      headlineLarge: TextStyle(
        color: Color(0xFF282B39),
        fontWeight: FontWeight.w600,
        fontSize: 22,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF282B39),
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      headlineSmall: TextStyle(
        color: Color(0xFF282B39),
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      titleLarge: TextStyle(
        color: Color(0xFF282B39),
        fontWeight: FontWeight.w500,
        fontSize: 20,
      ),
      titleMedium: TextStyle(
        color: Color(0xFF282B39),
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
      titleSmall: TextStyle(
        color: Color(0xFF282B39),
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF282B39),
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF282B39),
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        color: Color(0xFF282B39),
        fontSize: 12,
      ),
      labelLarge: TextStyle(
        color: Color(0xFF282B39),
        fontSize: 12,
      ),
      labelMedium: TextStyle(color: Color(0xFF282B39), fontSize: 11),
      labelSmall: TextStyle(color: Color(0xFF282B39), fontSize: 10),
    ),
  );
}

@immutable
class AppTheme {
  //  App Theme Config
  static const colors = AppColor();

  const AppTheme._();

  static ThemeData define() {
    return ThemeData();
  }
}
