import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';
import 'common_shimmer_widget.dart';
import 'custom_button_widget.dart';

class PermissionScreenWidgets {
  PermissionScreenWidgets._();

  static const double horizontalPadding = 16;
  static const double groupRadius = 16;

  static Widget appBarIcon(IconData icon) {
    return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(color: AppColors.mainColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, size: 21, color: AppColors.mainColor));
  }

  static Widget formCard({required Widget child}) {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(groupRadius),
            boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 2))]),
        clipBehavior: Clip.antiAlias,
        child: child);
  }

  static List<Widget> intersperseDividers(List<Widget> children, {double indent = 14}) {
    if (children.length <= 1) return children;
    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(Divider(height: 1, thickness: 1, indent: indent, endIndent: 14, color: AppColors.lightBorderColor.withValues(alpha: 0.6)));
      }
    }
    return result;
  }

  static Widget switchTile({required String title, required bool value, required ValueChanged<bool>? onChanged, bool isSubItem = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onChanged == null ? null : () => onChanged(!value),
        child: Padding(
          padding: EdgeInsets.fromLTRB(isSubItem ? 28 : 14, 12, 14, 12),
          child: Row(children: [
            Expanded(
              child: Text(title,
                  style: AppStyles.rkRegularTextStyle(
                      size: isSubItem ? AppConstants.font_14 : AppConstants.font_15,
                      color: AppColors.blackColor.withValues(alpha: isSubItem ? 0.65 : 0.88),
                      fontWeight: isSubItem ? FontWeight.w400 : FontWeight.w500)),
            ),
            Transform.scale(
              scale: 0.88,
              child: CupertinoSwitch(
                  value: value,
                  onChanged: onChanged,
                  activeTrackColor: AppColors.mainColor,
                  thumbColor: AppColors.whiteColor,
                  inactiveTrackColor: AppColors.lightBorderColor),
            ),
          ]),
        ),
      ),
    );
  }

  static Widget selectAllButton({required String text, required VoidCallback onPressed}) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.mainColor.withValues(alpha: 0.35))),
            child:
                Text(text, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.mainColor, fontWeight: FontWeight.w500)),
          ),
        ),
      ),
    );
  }

  static Widget saveButton({required String text, required VoidCallback? onPressed, bool isLoading = false}) {
    return CustomButtonWidget(
        buttonText: text, bGColor: AppColors.mainColor, isLoading: isLoading, radius: 14, onPressed: onPressed, fontColors: AppColors.whiteColor);
  }

  static Widget bottomSaveBar({required String text, required VoidCallback? onPressed, bool isLoading = false}) {
    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 16),
          child: saveButton(text: text, onPressed: onPressed, isLoading: isLoading)),
    );
  }
}

class PermissionScreenShimmerWidget extends StatelessWidget {
  final int itemCount;
  const PermissionScreenShimmerWidget({super.key, this.itemCount = 8});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(PermissionScreenWidgets.horizontalPadding, 8, PermissionScreenWidgets.horizontalPadding, 32),
        child: PermissionScreenWidgets.formCard(
          child: Column(children: PermissionScreenWidgets.intersperseDividers(List.generate(itemCount, (_) => _buildRowShimmer()))),
        ));
  }

  Widget _buildRowShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: CommonShimmerWidget(
        child: Row(children: [
          Expanded(child: Container(height: 14, decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(8)))),
          const SizedBox(width: 12),
          Container(height: 28, width: 48, decoration: BoxDecoration(color: AppColors.pageColor, borderRadius: BorderRadius.circular(14))),
        ]),
      ),
    );
  }
}
