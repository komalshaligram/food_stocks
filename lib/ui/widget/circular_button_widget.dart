import 'package:flutter/material.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';

class CircularButtonWidget extends StatelessWidget {

  final String buttonName;
  final String buttonValue;

   const CircularButtonWidget({super.key, required this.buttonValue , required this.buttonName
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
              Radius.circular(AppConstants.radius_100)),
          border: Border.all(
            color: AppColors.borderColor.withOpacity(0.6),
            width: 1,
          ),
        ),
        child: Container(

          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.padding_10,
              vertical: AppConstants.padding_5),
          decoration: BoxDecoration(
            color: AppColors.lightGreyColor,
            borderRadius: const BorderRadius.all(
                Radius.circular(AppConstants.radius_100)),
            border: Border.all(
              color: AppColors.whiteColor,
              width: 1,
            ),
          ),
       child:
          RichText(
            textDirection: TextDirection.ltr,
            locale: const Locale(AppStrings.hebrewLocal),
            text: TextSpan(
              text: buttonName,
              style: TextStyle(
                  color: AppColors.whiteColor, fontSize: AppConstants.font_14,fontWeight: FontWeight.w400),
              children: <TextSpan>[
                TextSpan(
                    text:':$buttonValue',

                    style: TextStyle(
                        color: AppColors.whiteColor, fontSize: AppConstants.font_14,fontWeight: FontWeight.w700,)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}