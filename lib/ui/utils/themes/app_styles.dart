import 'package:flutter/material.dart';

import 'app_constants.dart';

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

  static TextStyle rkBoldTextStyle(
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

  static OutlineInputBorder searchFieldStyle({
    double radius = AppConstants.radius_100,
    Color color = const Color(0xffCED4DA),
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
