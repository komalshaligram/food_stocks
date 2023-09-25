import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import '../utils/themes/app_colors.dart';

class CustomContainerWidget extends StatelessWidget {

  final String name;

  const CustomContainerWidget({super.key,required this.name});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConstants.containerHeight,
      width : MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(top: AppConstants.padding_10,bottom: AppConstants.padding_10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,style: AppStyles.rkRegularTextStyle(size: AppConstants.padding_10, color: AppColors.textColor)),
            Text(' * ',style: AppStyles.rkRegularTextStyle(size: AppConstants.padding_10, color: Colors.red)),
          ],
        ),
      ),
    );
  }
}


