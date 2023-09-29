
import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import '../utils/themes/app_colors.dart';


class ContainerWidget extends StatelessWidget {
  final String name;
   ContainerWidget({super.key,required this.name});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConstants.containerHeight,
      width : MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(top: AppConstants.padding_10,bottom: AppConstants.padding_10),
        child: Text(name,style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont,fontWeight: FontWeight.w400 , color: AppColors.textColor )),
      ),
    );
  }
}


