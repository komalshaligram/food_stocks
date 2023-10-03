import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';

class ButtonWidget extends StatelessWidget {
 final String buttonText;
 final void Function()? onPressed;
 final Color bGColor;
 final  Color fontColors;
 final double height;
 final double? width;
 final  double fontSize;
 final  double radius;
 final Color borderColor;
  ButtonWidget({super.key, required this.buttonText , this.onPressed , this.bGColor = Colors.white,
     this.fontColors = Colors.white , this.width,this.height = 50, this.fontSize = 18,
    this.radius = 10, this.borderColor = Colors.white
   });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          color: bGColor,
          borderRadius: BorderRadius.all(Radius.circular(radius))),
      child: MaterialButton(
        height: height,
        elevation: 0,
        minWidth: width,
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
