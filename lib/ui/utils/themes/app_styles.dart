import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';

class AppStyles {
  static const String _fontFamily = "Rubik";
  static TextStyle rkRegularTextStyle(
      {Color color = Colors.black,
      required double size,
      FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(
      fontFamily: _fontFamily,
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
    );
  }
}
