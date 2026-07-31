import 'package:flutter/material.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_img_path.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_styles.dart';
import '../sized_box_widget.dart';

const String supplierNamePlaceholder = '{supplier name}';

List<InlineSpan> buildFirstSupplierOrderMessageSpans({required String template, required String supplierDisplayName}) {
  const placeholder = supplierNamePlaceholder;
  final baseStyle =
      AppStyles.rkRegularTextStyle(size: AppConstants.font_15, color: AppColors.blackColor, fontWeight: FontWeight.w500).copyWith(height: 1.5);

  if (!template.contains(placeholder)) {
    return [TextSpan(text: template, style: baseStyle)];
  }

  final parts = template.split(placeholder);
  final spans = <InlineSpan>[];

  for (var i = 0; i < parts.length; i++) {
    if (parts[i].isNotEmpty) {
      spans.add(TextSpan(text: parts[i], style: baseStyle));
    }
    if (i < parts.length - 1) {
      spans.add(WidgetSpan(alignment: PlaceholderAlignment.middle, child: _SupplierNameHighlight(name: supplierDisplayName)));
    }
  }

  return spans;
}

Widget buildFirstSupplierOrderMessageContent({
  required String template,
  required String supplierDisplayName,
}) {
  final paragraphs = template.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();

  if (paragraphs.isEmpty) {
    return const SizedBox.shrink();
  }

  return Column(mainAxisSize: MainAxisSize.min, children: [
    for (var i = 0; i < paragraphs.length; i++) ...[
      if (i > 0) 14.height,
      RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: buildFirstSupplierOrderMessageSpans(template: paragraphs[i], supplierDisplayName: supplierDisplayName)))
    ]
  ]);
}

class _SupplierNameHighlight extends StatelessWidget {
  final String name;

  const _SupplierNameHighlight({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.padding_2),
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10, vertical: AppConstants.padding_3),
      decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(AppConstants.radius_20), boxShadow: [
        BoxShadow(color: AppColors.mainColor.withValues(alpha: 0.3), blurRadius: AppConstants.blur_10, offset: const Offset(0, 2)),
      ]),
      child: Text(name, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_15, color: AppColors.whiteColor, fontWeight: FontWeight.w700)),
    );
  }
}

class FirstSupplierOrderDialog extends StatelessWidget {
  final String messageTemplate;
  final String supplierDisplayName;
  final String language;

  const FirstSupplierOrderDialog({super.key, required this.messageTemplate, required this.supplierDisplayName, required this.language});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: language == AppStrings.englishString ? TextDirection.ltr : TextDirection.rtl,
      child: Dialog(
        surfaceTintColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radius_20)),
        child: Stack(clipBehavior: Clip.none, children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.padding_20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(height: 100, width: 100, child: Image.asset(AppImagePath.successIcon)),
              20.height,
              buildFirstSupplierOrderMessageContent(template: messageTemplate, supplierDisplayName: supplierDisplayName),
              24.height,
              InkWell(
                onTap: () => Navigator.pop(context, true),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(AppConstants.radius_40)),
                  child: Text(AppLocalizations.of(context)!.continues,
                      style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont, color: AppColors.whiteColor)),
                ),
              ),
            ]),
          ),
          Positioned(
              top: AppConstants.padding_8,
              left: language == AppStrings.englishString ? null : AppConstants.padding_8,
              right: language == AppStrings.englishString ? AppConstants.padding_8 : null,
              child: GestureDetector(onTap: () => Navigator.pop(context, false), child: Icon(Icons.close, size: 28, color: AppColors.blackColor))),
        ]),
      ),
    );
  }
}
