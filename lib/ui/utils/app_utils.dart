import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';

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


void SnackBarShow(BuildContext context , String title  ,Color color) {
  final snackBar = SnackBar(
    content: Text(title,
      style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont , color: AppColors.whiteColor,fontWeight: FontWeight.w400),
    ),
    backgroundColor: color,
    padding: EdgeInsets.all(AppConstants.padding_20),
    behavior: SnackBarBehavior.floating,

  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}