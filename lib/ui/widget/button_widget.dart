
import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';

class ButtonWidget extends StatelessWidget {
  String buttonText;
  void Function()? onPressed;
  Color bGColor;
  Color fontColors;
  double height;
  double width;
  double fontSize;
  double radius;
  Color borderColor;
  ButtonWidget({super.key, required this.buttonText , this.onPressed , this.bGColor = Colors.white,
     this.fontColors = Colors.white , this.width = double.maxFinite,this.height = 50, this.fontSize = 18,
    this.radius = 10, this.borderColor = Colors.white
   });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration:  BoxDecoration(
        border: Border.all(color: borderColor),
          color: bGColor,
          borderRadius:  BorderRadius.all(
              Radius.circular(radius))),
      child: MaterialButton(
        height: height,
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: AppStyles.rkRegularTextStyle(size: fontSize,color: fontColors,fontWeight: FontWeight.w400 ,
          ),
        ),
      ),
    );
  }
}
