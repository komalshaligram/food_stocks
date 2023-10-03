import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_stock/ui/utils/validation/auth_form_validation.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_styles.dart';

class CustomFormField extends StatelessWidget {
  CustomFormField({
    Key? key,
    required TextEditingController controller,
    required TextInputType keyboardType,
    //   required TextInputAction inputAction,
    required String hint,
    required String validator,
    required Color fillColor,
    this.maxLimits,
    this.getxController,
    this.onTap,
    this.onFieldSubmitted,
    this.onSaved,
    this.focusNode,
    this.postIconBtn,
    this.prefixIcon,
    this.suffixIcon,
    this.onChangeValue,
    this.suffixIconConstraints,
    this.filteringRegex = ".*",
    this.isEnabled,
    this.isObscure = false,
    this.height,
    this.width,
    this.isOtp = false,
    this.isPassword = false,
    this.isCapitalized = false,
    this.maxLines = 1,
    this.isLabelEnabled = true,
    this.isBorderVisible = true,
    this.textFieldLabel,
    this.textFieldLabelSize,
    this.inputformet,
    this.autofocus = false,
    this.textInputAction,  TextCapitalization textCapitalization = TextCapitalization.words,
    this.cursorColor = Colors.white
  })  : _keyboardType = keyboardType,
        _fillColor = fillColor,
        //   _inputAction = inputAction,
        _hint = hint,
        _validator = validator,
        _controller = controller,
        super(key: key);
  final Widget? postIconBtn;
  final bool isBorderVisible;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final bool? isEnabled;
  final List<TextInputFormatter>? inputformet;
  final TextInputType _keyboardType;
  final bool autofocus;
  final Color cursorColor;

  // final TextInputAction _inputAction;
  final String _hint;
  final Color _fillColor;
  final String? textFieldLabel;
  final double? textFieldLabelSize;
  final FocusNode? focusNode;
  bool isObscure;
  final double? height;
  final double? width;
  final bool isCapitalized;
  final int maxLines;
  final int? maxLimits;
  final bool isLabelEnabled;
  final String _validator;
  final String? filteringRegex;
  final bool isOtp;
  final bool isPassword;
  final TextInputAction? textInputAction;
  final TextEditingController _controller;
  final ValueChanged<String>? getxController;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChangeValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      inputFormatters: inputformet,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: AppStyles.rkRegularTextStyle(
          color: AppColors.blackColor, size: 16, fontWeight: FontWeight.w400),
      //  style:  TextStyle(color: AppColors.textHeaderColor , fontSize: 14),
      maxLines: maxLines,
      enabled: isEnabled,
      textInputAction: textInputAction,
      keyboardType: _keyboardType,
      obscureText: isObscure,
      onChanged: onChangeValue,
      textCapitalization: TextCapitalization.sentences,
      //   textInputAction: _inputAction,
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      autofocus: autofocus,
      cursorColor: cursorColor,
      validator: (value) =>
          AuthFormValidation().formValidation(value!, _validator),
      decoration: InputDecoration(
          labelStyle: TextStyle(color: AppColors.textColor),
          suffixIcon: postIconBtn,
          prefixIcon: prefixIcon,
          suffix: suffixIcon,
          hintText: _hint,
          filled: true,
          fillColor: _fillColor,
          hintStyle: TextStyle(
            color: AppColors.textColor,
          ),
          errorStyle: TextStyle(
              color: AppColors.redColor,
              height: height,
              fontWeight: FontWeight.w400),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: isBorderVisible
                  ? BorderSide(
                      color: AppColors.mainColor,
                      width: 1,
                    )
                  : BorderSide.none),
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: isBorderVisible
                ? BorderSide(color: AppColors.borderColor)
                : BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: isBorderVisible
                ? BorderSide(color: AppColors.borderColor)
                : BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: isBorderVisible
                ? BorderSide(
                    color: AppColors.borderColor,
                    width: 1,
                  )
                : BorderSide.none,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3.0),
            borderSide: isBorderVisible
                ? BorderSide(
                    color: AppColors.redColor,
                    width: 1,
                  )
                : BorderSide.none,
          )),
    );
  }
}
