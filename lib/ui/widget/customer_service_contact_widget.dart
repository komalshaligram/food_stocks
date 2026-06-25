import 'package:flutter/material.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_styles.dart';
import 'sized_box_widget.dart';

class CustomerServiceContactButton extends StatelessWidget {
  final String customerServicePhone;
  final String customerServiceWhatsApp;
  final bool isGuestUser;
  final VoidCallback? onGuestLoginRequired;

  const CustomerServiceContactButton({
    super.key,
    required this.customerServicePhone,
    required this.customerServiceWhatsApp,
    this.isGuestUser = false,
    this.onGuestLoginRequired,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConstants.radius_100),
        onTap: () {
          if (isGuestUser) {
            onGuestLoginRequired?.call();
            return;
          }
          showCustomerServiceBottomSheet(
            context: context,
            customerServicePhone: customerServicePhone,
            customerServiceWhatsApp: customerServiceWhatsApp,
          );
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.18), blurRadius: AppConstants.blur_10, offset: const Offset(0, 4))],
            borderRadius: BorderRadius.circular(AppConstants.radius_100),
            border: Border.all(color: AppColors.lightBorderColor.withValues(alpha: 0.8)),
          ),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: AppColors.appMainGradientColor,
              borderRadius: BorderRadius.circular(AppConstants.radius_100),
            ),
            child: Icon(Icons.headset_mic_rounded, color: AppColors.whiteColor, size: 28),
          ),
        ),
      ),
    );
  }
}

Future<void> showCustomerServiceBottomSheet({
  required BuildContext context,
  required String customerServicePhone,
  required String customerServiceWhatsApp,
}) {
  final l10n = AppLocalizations.of(context)!;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppConstants.padding_20, AppConstants.padding_10, AppConstants.padding_20, AppConstants.padding_20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.lightGreyColor.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(AppConstants.radius_100),
                    ),
                  ),
                  16.height,
                  Text(
                    l10n.customer_service_sheet_title,
                    textAlign: TextAlign.center,
                    style: AppStyles.rkBoldTextStyle(size: AppConstants.font_17, color: AppColors.blackColor),
                  ),
                  20.height,
                  _CustomerServiceActionTile(
                    title: l10n.customer_service_write_to_us,
                    subtitle: customerServiceWhatsApp.isNotEmpty ? customerServiceWhatsApp : l10n.customer_service_not_configured,
                    iconBackgroundColor: const Color(0xFF25D366),
                    iconWidget: Image.asset(AppImagePath.whatsapp, height: 26, width: 26),
                    onTap: () async {
                      if (customerServiceWhatsApp.trim().isEmpty) {
                        CustomSnackBar.showSnackBar(context: sheetContext, title: l10n.customer_service_whatsapp_unavailable, type: SnackBarType.failure);
                        return;
                      }
                      final opened = await openWhatsAppChat(customerServiceWhatsApp);
                      if (!opened && sheetContext.mounted) {
                        CustomSnackBar.showSnackBar(context: sheetContext, title: l10n.customer_service_whatsapp_unavailable, type: SnackBarType.failure);
                      }
                    },
                  ),
                  12.height,
                  _CustomerServiceActionTile(
                    title: l10n.customer_service_call_us,
                    subtitle: customerServicePhone.isNotEmpty ? customerServicePhone : l10n.customer_service_not_configured,
                    iconBackgroundColor: AppColors.blueColor,
                    iconWidget: Icon(Icons.phone_rounded, color: AppColors.whiteColor, size: 24),
                    onTap: () async {
                      if (customerServicePhone.trim().isEmpty) {
                        CustomSnackBar.showSnackBar(context: sheetContext, title: l10n.customer_service_phone_unavailable, type: SnackBarType.failure);
                        return;
                      }
                      final opened = await openPhoneCall(customerServicePhone);
                      if (!opened && sheetContext.mounted) {
                        CustomSnackBar.showSnackBar(context: sheetContext, title: l10n.customer_service_phone_unavailable, type: SnackBarType.failure);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _CustomerServiceActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget iconWidget;
  final Color iconBackgroundColor;
  final VoidCallback onTap;

  const _CustomerServiceActionTile({
    required this.title,
    required this.subtitle,
    required this.iconWidget,
    required this.iconBackgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.pageColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_15, vertical: AppConstants.padding_15),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: iconBackgroundColor.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                child: iconWidget,
              ),
              14.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppStyles.rkBoldTextStyle(size: AppConstants.font_15, color: AppColors.blackColor)),
                    4.height,
                    Text(
                      subtitle,
                      style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.greyColor),
                    ),
                  ],
                ),
              ),
              Icon(context.rtl ? Icons.chevron_right_rounded : Icons.chevron_left_rounded, color: AppColors.lightGreyColor, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}