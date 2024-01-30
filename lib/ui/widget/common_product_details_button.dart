import 'package:flutter/cupertino.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import 'common_product_button_widget.dart';

class CommonProductDetailsButton extends StatelessWidget {
  final bool isLoading;
  final bool isSupplierAvailable;
  final int productStock;
  final void Function()? onAddToOrderPressed;

  const CommonProductDetailsButton(
      {super.key,
      required this.isLoading,
      required this.isSupplierAvailable,
      required this.productStock,
      this.onAddToOrderPressed});

  @override
  Widget build(BuildContext context) {
    debugPrint('product stock$productStock');
    return !isSupplierAvailable || productStock == 0
        ? 0.width
        : Container(
            height: 90,
            width: getScreenWidth(context),
            padding: EdgeInsets.symmetric(
                horizontal: AppConstants.padding_20,
                vertical: AppConstants.padding_20),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border(
                    top: BorderSide(
                        color: AppColors.lightBorderColor, width: 1))),
            child: CommonProductButtonWidget(
              title: AppLocalizations.of(context)!.add_to_order,
              isLoading: isLoading,
              onPressed: onAddToOrderPressed,
              width: double.maxFinite,
              height: AppConstants.buttonHeight,
              borderRadius: AppConstants.radius_5,
              textSize: AppConstants.normalFont,
              textColor: AppColors.whiteColor,
              bgColor: AppColors.mainColor,
            ),
          );
  }
}
