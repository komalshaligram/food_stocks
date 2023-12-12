import 'package:flutter/cupertino.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';

class RefreshWidget extends StatelessWidget {
  const RefreshWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WaterDropHeader(
      waterDropColor: AppColors.mainColor,
      refresh: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: AppColors.shadowColor.withOpacity(0.1),
              blurRadius: AppConstants.blur_10)
        ], color: AppColors.whiteColor, shape: BoxShape.circle),
        child: CupertinoActivityIndicator(
          color: AppColors.mainColor,
          radius: 10,
        ),
      ),
      complete: 0.width,
    );
  }
}
