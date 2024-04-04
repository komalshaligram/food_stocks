import 'package:flutter/material.dart';

import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';

class CommonDropDownButton extends StatelessWidget {
  final String value;
  final List<DropdownMenuItem<String>>? items;
  final void Function(String?)? onChanged;
  const CommonDropDownButton({super.key,required this.value , required this.items,required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: AppColors.blackColor,
      ),
      alignment: Alignment.bottomCenter,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(
            left: AppConstants.padding_10,
            right: AppConstants.padding_10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              AppConstants.radius_3),
          borderSide: BorderSide(
            color: AppColors.borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              AppConstants.radius_3),
          borderSide: BorderSide(
            color: AppColors.borderColor,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              AppConstants.radius_3),
          borderSide: BorderSide(
            color: AppColors.borderColor,
          ),
        ),
      ),
      isExpanded: true,
      elevation: 0,
      style: TextStyle(
        fontSize: AppConstants.smallFont,
        color: AppColors.blackColor,
      ),
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }
}
