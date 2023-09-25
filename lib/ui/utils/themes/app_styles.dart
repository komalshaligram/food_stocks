import 'package:flutter/material.dart';
class AppStyles{
  static const String _fontFamily = "Rubik";
  static TextStyle rkRegularTextStyle(
      {Color color = const Color(0xFF929DAA), required double size, FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(
        fontFamily: _fontFamily,
        color: color,
        fontSize: size,
        fontWeight: fontWeight,

    );
  }
}
