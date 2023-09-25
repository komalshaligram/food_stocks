
import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';

class ButtonScreen extends StatelessWidget {
  String buttonText;
  void Function()? onPressed;
  bool enable;
  Color bGColor;
  Color fontColors;
  ButtonScreen({super.key, required this.buttonText , this.onPressed , this.enable = true , this.bGColor = Colors.white,
     this.fontColors = Colors.white
   });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration:  BoxDecoration(
        border: Border.all(color: AppColors.mainColor),
          color: bGColor,
          borderRadius: const BorderRadius.all(
              Radius.circular(10))),
      child: MaterialButton(
        height: 50,
        onPressed: enable ? onPressed :null,
        child: Text(
          buttonText,
          style: AppStyles.rkRegularTextStyle(size: 18,color: fontColors,fontWeight: FontWeight.w400 ,
          ),
        ),
      ),
    );
  }
}
