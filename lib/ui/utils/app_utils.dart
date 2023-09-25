import 'package:flutter/cupertino.dart';

enum Language {
  English,
  Hebrew
}

getScreenHeight(BuildContext context){
  final screenHeight = MediaQuery.of(context).size.height;
  return screenHeight;
}

getScreenWidth(BuildContext context){
  final screenWidth = MediaQuery.of(context).size.width;
  return screenWidth;
}
