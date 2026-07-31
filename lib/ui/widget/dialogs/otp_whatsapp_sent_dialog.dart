import 'package:flutter/material.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';

import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_styles.dart';

const Color kWhatsappGreen = Color(0xFF25D366);
const Color kWhatsappDarkGreen = Color(0xFF128C7E);

Future<void> showOtpSentViaWhatsappDialog({required BuildContext context, required String contact}) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) => _OtpSentViaWhatsappDialog(contact: contact));
}

class _OtpSentViaWhatsappDialog extends StatelessWidget {
  final String contact;

  const _OtpSentViaWhatsappDialog({required this.contact});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 30, 24, 22),
        decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 30, offset: const Offset(0, 10))]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(alignment: Alignment.center, children: [
              Container(width: 96, height: 96, decoration: BoxDecoration(color: kWhatsappGreen.withValues(alpha: 0.10), shape: BoxShape.circle)),
              Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [kWhatsappGreen, kWhatsappDarkGreen]),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 40)),
            ]),
          ),
          const SizedBox(height: 18),
          Text(l10n.otp_sent_via_whatsapp_title,
              textAlign: TextAlign.center, style: AppStyles.rkBoldTextStyle(size: 19, color: AppColors.blackColor, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Text(l10n.otp_sent_via_whatsapp_message,
              textAlign: TextAlign.center, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.greyColor)),
          const SizedBox(height: 6),
          Directionality(
            textDirection: TextDirection.ltr,
            child:
                Text(contact, style: AppStyles.rkBoldTextStyle(size: AppConstants.font_17, color: AppColors.blackColor, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.maxFinite,
            height: AppConstants.buttonHeight,
            child: MaterialButton(
              onPressed: () => Navigator.pop(context),
              elevation: 0,
              color: kWhatsappGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radius_10)),
              child: Text(l10n.otp_sent_via_whatsapp_action,
                  style: AppStyles.rkBoldTextStyle(size: 16, color: AppColors.whiteColor, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      ),
    );
  }
}
