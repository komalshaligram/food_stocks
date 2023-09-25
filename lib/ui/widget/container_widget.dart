
import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import '../utils/themes/app_colors.dart';


class ContainerScreen extends StatelessWidget {
  String name;
   ContainerScreen({super.key,required this.name});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width : MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 10,bottom: 10),
        child: Text(name,style: AppStyles.rkRegularTextStyle(size: 16,fontWeight: FontWeight.w400 , color: AppColors.textColor )),
      ),
    );
  }
}


