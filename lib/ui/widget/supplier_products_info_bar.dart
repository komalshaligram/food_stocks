import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../data/model/res_model/supplier_city_delivery_schedule_res_model/supplier_city_delivery_schedule_res_model.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';
import 'sized_box_widget.dart';
import 'supplier_delivery_schedule_widget.dart';

class SupplierProductsInfoBar extends StatelessWidget {
  const SupplierProductsInfoBar({
    super.key,
    required this.minimumOrder,
    required this.deliveryCityName,
    required this.deliveryDays,
    required this.isDeliveryScheduleLoading,
  });

  final int? minimumOrder;
  final String? deliveryCityName;
  final List<SupplierCityDeliveryDay> deliveryDays;
  final bool isDeliveryScheduleLoading;

  bool get _showDeliverySection =>
      isDeliveryScheduleLoading ||
      (deliveryCityName?.isNotEmpty == true && deliveryDays.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        AppConstants.padding_10,
        AppConstants.padding_2,
        AppConstants.padding_10,
        0,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(AppConstants.radius_10),
        border: Border.all(color: AppColors.lightBorderColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radius_10),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: _showDeliverySection ? 1 : 2,
                child: _MinimumOrderSection(
                  label: l10n.minimum_order,
                  amount: minimumOrder,
                ),
              ),
              if (_showDeliverySection) ...[
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: AppColors.lightBorderColor,
                ),
                Expanded(
                  child: _DeliveryScheduleSection(
                    isLoading: isDeliveryScheduleLoading,
                    cityName: deliveryCityName,
                    deliveryDays: deliveryDays,
                    label: l10n.supplier_delivery_schedule_button,
                    onTap: deliveryCityName == null || deliveryDays.isEmpty
                        ? null
                        : () => SupplierDeliveryScheduleWidget.showSheet(
                              context,
                              cityName: deliveryCityName!,
                              deliveryDays: deliveryDays,
                            ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MinimumOrderSection extends StatelessWidget {
  const _MinimumOrderSection({
    required this.label,
    required this.amount,
  });

  final String label;
  final int? amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.padding_10,
        vertical: AppConstants.padding_10,
      ),
      color: AppColors.mainColor.withValues(alpha: 0.06),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.appMainGradientColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.whiteColor,
              size: 20,
            ),
          ),
          10.width,
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_10,
                    color: AppColors.greyColor,
                  ),
                ),
                2.height,
                Text(
                  '${amount ?? 0} ₪',
                  style: AppStyles.rkBoldTextStyle(
                    size: AppConstants.mediumFont,
                    color: AppColors.blueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryScheduleSection extends StatelessWidget {
  const _DeliveryScheduleSection({
    required this.isLoading,
    required this.cityName,
    required this.deliveryDays,
    required this.label,
    required this.onTap,
  });

  final bool isLoading;
  final String? cityName;
  final List<SupplierCityDeliveryDay> deliveryDays;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_10),
        alignment: Alignment.center,
        color: AppColors.blueColor.withValues(alpha: 0.04),
        child: SizedBox(
          width: 22,
          height: 22,
          child: CupertinoActivityIndicator(color: AppColors.blueColor),
        ),
      );
    }

    return Material(
      color: AppColors.blueColor.withValues(alpha: 0.04),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.padding_10,
            vertical: AppConstants.padding_10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppColors.appMainGradientColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Transform.flip(
                  flipX: true,
                  child: Icon(Icons.local_shipping_outlined, color: AppColors.whiteColor, size: 18),
                ),
              ),
              10.width,
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.rkBoldTextStyle(
                        size: AppConstants.font_13,
                        color: AppColors.blueColor,
                      ),
                    ),
                    if (cityName?.isNotEmpty == true) ...[
                      2.height,
                      Text(
                        cityName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.font_10,
                          color: AppColors.greyColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              4.width,
              Icon(Icons.chevron_right, color: AppColors.blueColor, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
