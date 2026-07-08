import 'package:flutter/material.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';

class CommonDropDownButton extends StatelessWidget {
  final String value;
  final List<DropdownMenuItem<String>>? items;
  final void Function(String?)? onChanged;
  final Color color;
  final double borderRadius;
  final Color? focusedBorderColor;
  final bool useFilledBackground;

  const CommonDropDownButton({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.color = const Color(0xffD9D9D9),
    this.borderRadius = AppConstants.radius_3,
    this.focusedBorderColor,
    this.useFilledBackground = false,
  });

  String? get _selectedValue {
    if (value.isEmpty || items == null || items!.isEmpty) {
      return null;
    }
    final hasMatch = items!.any((item) => item.value == value);
    return hasMatch ? value : null;
  }

  @override
  Widget build(BuildContext context) {
    final focusColor = focusedBorderColor ?? (useFilledBackground ? AppColors.mainColor : color);
    return DropdownButtonFormField<String>(
      icon: Icon(
        useFilledBackground ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_down,
        color: useFilledBackground ? AppColors.blackColor.withValues(alpha: 0.5) : AppColors.blackColor,
      ),
      alignment: Alignment.bottomCenter,
      decoration: InputDecoration(
        filled: useFilledBackground,
        fillColor: useFilledBackground ? AppColors.pageColor : null,
        contentPadding: useFilledBackground
            ? const EdgeInsets.symmetric(horizontal: AppConstants.padding_10, vertical: AppConstants.padding_8)
            : const EdgeInsets.only(left: AppConstants.padding_10, right: AppConstants.padding_10),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: color)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: focusColor)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: color)),
      ),
      isExpanded: true,
      elevation: 0,
      value: _selectedValue,
      style: TextStyle(fontSize: AppConstants.smallFont, color: AppColors.blackColor),
      items: items,
      onChanged: onChanged,
      dropdownColor: AppColors.pageColor,
    );
  }
}
