import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Colors.indigo;
  static const double globalElevation = 0;

  static final ThemeData lightTheme = ThemeData.light().copyWith(
      primaryColor: primaryColor,
      appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          centerTitle: true,
          elevation: globalElevation));

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      primaryColor: Colors.amberAccent,
      appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: globalElevation,
          backgroundColor: primaryColor,
          foregroundColor: Color.fromARGB(221, 19, 13, 15)),
      scaffoldBackgroundColor: Colors.black87);
}
