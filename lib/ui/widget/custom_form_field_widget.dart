import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../ui/utils/validation/auth_form_validation.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';

class CustomFormField extends StatelessWidget {
  CustomFormField({
    Key? key,
    required BuildContext context,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String hint,
    required String validator,
    required Color fillColor,
    this.maxLimits,
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
    this.inputFormat,
    this.autofocus = false,
    this.textInputAction,
    TextCapitalization textCapitalization = TextCapitalization.words,
    this.cursorColor = Colors.green,
    this.contentPaddingBottom = 0.0,
    this.contentPaddingTop = 0.0,
    this.border = 3.0,
    this.textDirection,
  })  : _keyboardType = keyboardType,
        _fillColor = fillColor,
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
  final List<TextInputFormatter>? inputFormat;
  final TextInputType _keyboardType;
  final bool autofocus;
  final Color cursorColor;
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
  final GestureTapCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChangeValue;
  final double contentPaddingTop;
  final double contentPaddingBottom;
  final double border;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.mainColor,
          selectionColor: AppColors.mainColor,
          selectionHandleColor: AppColors.mainColor,
        ),
      ),
      child: TextFormField(
        controller: _controller,
        inputFormatters: inputFormat,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: AppStyles.rkRegularTextStyle(color: AppColors.blackColor, size: AppConstants.smallFont, fontWeight: FontWeight.w400),
        maxLines: maxLines,
        enabled: isEnabled,
        textInputAction: textInputAction,
        keyboardType: _keyboardType,
        obscureText: isObscure,
        onChanged: onChangeValue,
        textCapitalization: TextCapitalization.sentences,
        onTap: onTap,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        onFieldSubmitted: onFieldSubmitted,
        onSaved: onSaved,
        autofocus: autofocus,
        cursorColor: cursorColor,
        textDirection: textDirection,
        textAlign: textDirection == TextDirection.ltr ? TextAlign.end : TextAlign.start,
        validator: (value) => AuthFormValidation().formValidation(value!, _validator, context),
        decoration: InputDecoration(
            labelStyle: TextStyle(color: AppColors.textColor, overflow: TextOverflow.visible),
            suffixIcon: postIconBtn,
            prefixIcon: prefixIcon,
            suffix: suffixIcon,
            hintText: _hint,
            hintTextDirection: textDirection == TextDirection.ltr ? TextDirection.ltr : null,
            filled: true,
            fillColor: _fillColor,
            hintStyle: TextStyle(
              color: AppColors.textColor,
            ),
            errorMaxLines: 2,
            errorStyle: TextStyle(color: AppColors.redColor, height: height, overflow: TextOverflow.visible, fontWeight: FontWeight.w400),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(border),
                borderSide: isBorderVisible
                    ? BorderSide(
                        color: AppColors.mainColor,
                        width: 1,
                      )
                    : BorderSide.none),
            contentPadding: EdgeInsets.fromLTRB(AppConstants.padding_10, contentPaddingTop, AppConstants.padding_10, contentPaddingBottom),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(border),
              borderSide: isBorderVisible ? BorderSide(color: AppColors.borderColor) : BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(border),
              borderSide: isBorderVisible ? BorderSide(color: AppColors.borderColor) : BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(border),
              borderSide: isBorderVisible
                  ? BorderSide(
                      color: AppColors.borderColor,
                      width: 1,
                    )
                  : BorderSide.none,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(border),
              borderSide: isBorderVisible
                  ? BorderSide(
                      color: AppColors.redColor,
                      width: 1,
                    )
                  : BorderSide.none,
            )),
      ),
    );
  }
}
