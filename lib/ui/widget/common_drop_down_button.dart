import 'package:flutter/material.dart';

import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';

class CommonDropDownButton extends StatelessWidget {
  final String value;
  final List<DropdownMenuItem<String>>? items;
  final void Function(String?)? onChanged;
  final Color color;
  const CommonDropDownButton({super.key,required this.value , required this.items,required this.onChanged,
  this.color = const Color(0xffD9D9D9)
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: AppColors.blackColor,
      ),
      alignment: Alignment.bottomCenter,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(
            left: AppConstants.padding_10,
            right: AppConstants.padding_10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              AppConstants.radius_3),
          borderSide: BorderSide(
            color:color,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              AppConstants.radius_3),
          borderSide: BorderSide(
            color: color,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              AppConstants.radius_3),
          borderSide: BorderSide(
            color: color,
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
      dropdownColor: AppColors.pageColor,
    );
  }
}
