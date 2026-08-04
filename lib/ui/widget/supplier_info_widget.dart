import 'package:flutter/material.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';
import 'sized_box_widget.dart';

class SupplierInfoWidget {
  SupplierInfoWidget._();

  static Future<void> showSheet(BuildContext context, {required String infoText, String? supplierName}) {
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context);
    return showMaterialModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        isDismissible: true,
        builder: (sheetContext) {
          return Localizations(
            locale: locale,
            delegates: AppLocalizations.localizationsDelegates,
            child: Builder(builder: (localizedContext) {
              final maxHeight = MediaQuery.sizeOf(localizedContext).height * 0.85;
              return SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppConstants.padding_10, 0, AppConstants.padding_10, AppConstants.padding_10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxHeight),
                    child: SupplierInfoPanel(
                        infoText: infoText, supplierName: supplierName, showDragHandle: true, l10n: l10n ?? AppLocalizations.of(localizedContext)),
                  ),
                ),
              );
            }),
          );
        });
  }
}

class SupplierInfoPanel extends StatelessWidget {
  const SupplierInfoPanel({super.key, required this.infoText, this.supplierName, this.showDragHandle = false, this.l10n});

  final String infoText;
  final String? supplierName;
  final bool showDragHandle;
  final AppLocalizations? l10n;

  @override
  Widget build(BuildContext context) {
    final localizations = l10n ?? AppLocalizations.of(context);
    if (localizations == null) {
      return const SizedBox.shrink();
    }

    final title = supplierName?.trim().isNotEmpty == true ? supplierName!.trim() : localizations.supplier_info_title;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(AppConstants.radius_15),
          border: Border.all(color: AppColors.lightBorderColor),
          boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.1), blurRadius: 16, offset: const Offset(0, -2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
        if (showDragHandle)
          Center(
            child: Container(
                margin: const EdgeInsets.only(top: AppConstants.padding_10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.lightBorderColor, borderRadius: BorderRadius.circular(AppConstants.radius_4))),
          ),
        Container(
          margin: const EdgeInsets.all(AppConstants.padding_10),
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10, vertical: AppConstants.padding_10),
          decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(AppConstants.radius_10)),
          child: Row(children: [
            Icon(Icons.info_outline, color: AppColors.whiteColor, size: 22),
            8.width,
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.rkBoldTextStyle(size: AppConstants.font_14, color: AppColors.whiteColor)),
                if (supplierName?.trim().isNotEmpty == true) ...[
                  2.height,
                  Text(localizations.supplier_info_title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.rkRegularTextStyle(size: AppConstants.font_10, color: AppColors.whiteColor.withValues(alpha: 0.85)))
                ]
              ]),
            ),
          ]),
        ),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppConstants.padding_10, 0, AppConstants.padding_10, AppConstants.padding_10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_15, vertical: AppConstants.padding_15),
              decoration: BoxDecoration(
                  color: AppColors.pageColor,
                  borderRadius: BorderRadius.circular(AppConstants.radius_10),
                  border: Border.all(color: AppColors.lightBorderColor)),
              child: Text(infoText,
                  style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_14,
                    color: AppColors.blackColor,
                  ).copyWith(height: 1.5)),
            ),
          ),
        ),
      ]),
    );
  }
}
