import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_styles.dart';

class CustomFormField extends StatelessWidget {
  CustomFormField({
    Key? key,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String hint,
    this.maxLimits,
    this.height,
    this.width,
    this.isOtp = false,
    this.isPassword = false,
    this.isCapitalized = false,
    this.maxLines = 1,
    this.isLabelEnabled = true,
    this.textFieldLabel,
    this.textFieldLabelSize,
  })  : _keyboardType = keyboardType,
        _hint = hint,
        _controller = controller,
        super(key: key);
  final TextInputType _keyboardType;
  final String _hint;
  final String? textFieldLabel;
  final double? textFieldLabelSize;
  final double? height;
  final double? width;
  final bool isCapitalized;
  final int maxLines;
  final int? maxLimits;
  final bool isLabelEnabled;
  final bool isOtp;
  final bool isPassword;
  final TextEditingController _controller;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      style: AppStyles.rkRegularTextStyle(
          color: AppColors.blackColor, size: AppConstants.smallFont, fontWeight: FontWeight.w400),
      keyboardType: _keyboardType,
      decoration: InputDecoration(
          labelStyle: TextStyle(color: AppColors.textColor),
          hintText: _hint,
          hintStyle: AppStyles.rkRegularTextStyle(
            size: AppConstants.smallFont,color: AppColors.textColor,
          ),
          errorStyle: TextStyle(
              color: AppColors.borderColor,
              height: height,
              fontWeight: FontWeight.w400),

           focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide(
                 color: AppColors.borderColor,
                width: 1,
               )),
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: BorderSide(color: AppColors.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: BorderSide(color: AppColors.borderColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: BorderSide(
              color: AppColors.mainColor,
              width: 1,
            ),
          )
      ),
    );
  }
}
