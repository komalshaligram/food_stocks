import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_styles.dart';
import '../../utils/constants/app_img_path.dart';
import '../../utils/constants/app_strings.dart';

class WhatsappOptionDialog extends StatelessWidget {
  final String directionality;
  final String title;
  final String body;
  final String approveTitle;
  final String notNowTitle;
  final bool isProcessing;
  final void Function()? onApprove;
  final void Function()? onNotNow;

  const WhatsappOptionDialog(
      {super.key,
      required this.directionality,
      required this.title,
      required this.body,
      required this.approveTitle,
      required this.notNowTitle,
      this.isProcessing = false,
      this.onApprove,
      this.onNotNow});

  static const Color _whatsappGreen = Color(0xff25D366);
  static const Color _whatsappDarkGreen = Color(0xff128C7E);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: directionality == AppStrings.englishString ? TextDirection.ltr : TextDirection.rtl,
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        backgroundColor: AppColors.whiteColor,
        surfaceTintColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radius_20)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_20),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_whatsappGreen, _whatsappDarkGreen]),
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(AppConstants.radius_20), topRight: Radius.circular(AppConstants.radius_20))),
              child: Column(children: [
                Container(
                    height: 64,
                    width: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.circular(AppConstants.radius_50)),
                    child: Image.asset(AppImagePath.whatsapp, height: 40, width: 40, color: _whatsappGreen)),
                12.height,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_20),
                  child: Text(title,
                      textAlign: TextAlign.center,
                      style: AppStyles.rkBoldTextStyle(size: AppConstants.mediumFont, color: AppColors.whiteColor, fontWeight: FontWeight.w700)),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppConstants.padding_20, AppConstants.padding_20, AppConstants.padding_20, AppConstants.padding_10),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 240),
                child: SingleChildScrollView(
                  child: Text(body,
                      style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.blackColor, fontWeight: FontWeight.w400)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppConstants.padding_20, AppConstants.padding_5, AppConstants.padding_20, AppConstants.padding_20),
              child: Column(children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: isProcessing ? null : onApprove,
                  child: Container(
                    width: double.maxFinite,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient:
                          const LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [_whatsappGreen, _whatsappDarkGreen]),
                      borderRadius: BorderRadius.circular(AppConstants.radius_10),
                    ),
                    child: isProcessing
                        ? const CupertinoActivityIndicator(color: Colors.white)
                        : Text(approveTitle,
                            style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor, fontWeight: FontWeight.w600)),
                  ),
                ),
                8.height,
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: isProcessing ? null : onNotNow,
                  child: Container(
                    width: double.maxFinite,
                    height: 44,
                    alignment: Alignment.center,
                    child: Text(notNowTitle, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.greyColor)),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}
