import 'package:flutter/material.dart';

class AppColor {
  static Color hintColor = const Color(0x47232323);




  static ColorScheme lightTheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFACC7F8),
      onPrimary: Color(0xff001833),
      secondary: Color(0xFF000000),
      onSecondary: Colors.black,
      error: Color(0xFFAC0000),
      onError: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xff020156),
    );
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
