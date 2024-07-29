import 'package:flutter/material.dart';

import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';

class CommonCheckBox extends StatelessWidget {
  final void Function(bool?)? onChanged;
  final bool value;
   CommonCheckBox({super.key,required this.value, this.onChanged,});

  @override
  Widget build(BuildContext context) {
    return  Checkbox(
        value: value,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius
              .circular(
              AppConstants
                  .radius_3),
        ),
        side: WidgetStateBorderSide
            .resolveWith(
              (states) =>
              BorderSide(
                  width: 1.0,
                  color: AppColors
                      .greyColor),
        ),
        activeColor: AppColors
            .mainColor,
        fillColor: WidgetStateColor.resolveWith(
        (states) {
    if (states.contains(WidgetState.selected)) {
    return AppColors.mainColor;
    }
    return AppColors.whiteColor;
    }
        ),
      onChanged: onChanged,
        );
  }
}
