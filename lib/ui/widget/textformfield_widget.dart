
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/validation/auth_form_validation.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_styles.dart';


class CustomFormField extends StatelessWidget {
  CustomFormField({
    Key? key,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required TextInputAction inputAction,
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
    this.textFieldLabel,
    this.textFieldLabelSize,
    this.inputformet,
  })  : _keyboardType = keyboardType,
        _fillColor = fillColor,
        _inputAction = inputAction,
        _hint = hint,
        _validator = validator,
        _controller = controller,
        super(key: key);
  final Widget? postIconBtn;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final bool? isEnabled;
  final List<TextInputFormatter>? inputformet;
  final TextInputType _keyboardType;
  final TextInputAction _inputAction;
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
  final TextEditingController _controller;
  final ValueChanged<String>? getxController;
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (textFieldLabel!.isNotEmpty)?Padding(
          padding:  const EdgeInsets.only(left: 10.0),
          child: Text(
            textFieldLabel!,
            style: AppStyles.rkRegularTextStyle(color: AppColors.blueColor, size:  15),
          ),
        ):const SizedBox(),
        Container(
          margin:  (textFieldLabel!.isNotEmpty)? const EdgeInsets.only(top: 6) : EdgeInsets.zero,
          height: 52,
          child: TextFormField(
            controller: _controller,
            inputFormatters: inputformet,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: AppStyles.rkRegularTextStyle(color: AppColors.blueColor, size: 15),
            //  style:  TextStyle(color: AppColors.textHeaderColor , fontSize: 14),
            maxLines: maxLines,
            enabled: isEnabled,
            keyboardType: _keyboardType,
            obscureText: isObscure,
            textCapitalization:
            isCapitalized ? TextCapitalization.words : TextCapitalization.none,
            textInputAction: _inputAction,
            onChanged: getxController,
            onTap: onTap,
            onFieldSubmitted: onFieldSubmitted,
            onSaved: onSaved,
            validator: (value) =>
                AuthFormValidation().formValidation(value!, _validator),
            decoration: InputDecoration(

                labelStyle: TextStyle(color: AppColors.blueColor),
                suffixIcon: postIconBtn,
                prefixIcon: prefixIcon,
                suffix: suffixIcon,
                hintText: _hint,
                filled: true,
                //<-- SEE HERE
                fillColor: _fillColor,
                hintStyle:  TextStyle(
                  color: AppColors.blueColor,
                ),
                errorStyle: TextStyle(color: AppColors.blueColor, height: height),

                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: AppColors.blueColor,
                      width: 1,
                    )),
                //  contentPadding:  const EdgeInsets.fromLTRB(18.0, 22.0, 0.0, 0.0),
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide:  BorderSide(
                      color: AppColors.blueColor
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                      color: AppColors.blueColor
                  ),
                ),
                /*     errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide:  BorderSide(
                    color: AppColors.offWhiteColor,
                    width: 1,
                  ),
                ),*/
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                    color: AppColors.blueColor,
                    width: 1,
                  ),
                )),
          ),
        ),
      ],
    );
  }
}