import 'package:flutter/material.dart';

class AppTheme {
  static Color hintColor = const Color(0x47232323);
  static Color placeholderColor = Colors.black.withAlpha(8);

  static ThemeData lightTheme() {
    return ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF00AE66),
          onPrimary: Color(0xFFffffff),
          secondary: Color(0xFF000000),
          onSecondary: Colors.black,
          error: Color(0xFFAC0000),
          onError: Color(0xFFFFFFFF),
          surface: Color(0xFFFFFFFF),
          onSurface: Color(0xff020156),
        ),
        textTheme: const TextTheme(
          bodySmall: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Color(0xff000000)),
          bodyMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Color(0xff000000)),
          headlineLarge: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xff001833)),
          bodyLarge: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color(0xff001833)),
        ));
  }

  static ColorScheme darkTheme() {
    // TODO: implement dark theme
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFC3D6FA),
      onPrimary: Color(0xff001833),
      secondary: Color(0xFF000000),
      onSecondary: Colors.black,
      error: Color(0xFFAC0000),
      onError: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xff020156),
    );
  }
}
