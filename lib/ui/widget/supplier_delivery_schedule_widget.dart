import 'package:flutter/material.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../data/model/res_model/supplier_city_delivery_schedule_res_model/supplier_city_delivery_schedule_res_model.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';
import 'sized_box_widget.dart';

class SupplierDeliveryScheduleWidget {
  SupplierDeliveryScheduleWidget._();

  static Future<void> showSheet(BuildContext context, {required String cityName, required List<SupplierCityDeliveryDay> deliveryDays}) {
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
                    child: SupplierDeliverySchedulePanel(
                        cityName: cityName, deliveryDays: deliveryDays, showDragHandle: true, l10n: l10n ?? AppLocalizations.of(localizedContext)),
                  ),
                ),
              );
            }),
          );
        });
  }
}

class SupplierDeliverySchedulePanel extends StatelessWidget {
  const SupplierDeliverySchedulePanel({super.key, required this.cityName, required this.deliveryDays, this.showDragHandle = false, this.l10n});

  final String cityName;
  final List<SupplierCityDeliveryDay> deliveryDays;
  final bool showDragHandle;
  final AppLocalizations? l10n;

  @override
  Widget build(BuildContext context) {
    final localizations = l10n ?? AppLocalizations.of(context);
    if (localizations == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(AppConstants.radius_15),
          border: Border.all(color: AppColors.lightBorderColor),
          boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.1), blurRadius: 16, offset: const Offset(0, -2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (showDragHandle)
          Center(
            child: Container(
                margin: const EdgeInsets.only(top: AppConstants.padding_10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.lightBorderColor, borderRadius: BorderRadius.circular(AppConstants.radius_4))),
          ),
        Container(
          margin: EdgeInsets.fromLTRB(AppConstants.padding_10, showDragHandle ? AppConstants.padding_10 : AppConstants.padding_10,
              AppConstants.padding_10, AppConstants.padding_10),
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10, vertical: AppConstants.padding_10),
          decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(AppConstants.radius_10)),
          child: Row(children: [
            Transform.flip(flipX: true, child: Icon(Icons.local_shipping_outlined, color: AppColors.whiteColor, size: 22)),
            8.width,
            Expanded(
              child: Text(localizations.supplier_delivery_schedule_title(cityName),
                  style: AppStyles.rkBoldTextStyle(size: AppConstants.font_14, color: AppColors.whiteColor)),
            ),
          ]),
        ),
        Flexible(
          child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(AppConstants.padding_10, 0, AppConstants.padding_10, AppConstants.padding_10),
              child: Column(children: deliveryDays.map((day) => _DeliveryDayRow(day: day, l10n: localizations)).toList())),
        ),
      ]),
    );
  }
}

class _DeliveryDayRow extends StatelessWidget {
  const _DeliveryDayRow({required this.day, required this.l10n});

  final SupplierCityDeliveryDay day;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final deliveryLabel = weekdayLabel(context, day.deliveryDay ?? -1, l10n: l10n);
    final orderUntilLabel = weekdayLabel(context, day.orderUntilDay ?? -1, l10n: l10n);

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.padding_8),
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10, vertical: AppConstants.padding_10),
      decoration: BoxDecoration(
          color: AppColors.pageColor,
          borderRadius: BorderRadius.circular(AppConstants.radius_10),
          border: Border.all(color: AppColors.lightBorderColor)),
      child: Column(children: [
        Row(children: [
          Expanded(
            child: Text(l10n.supplier_delivery_schedule_order_until,
                style: AppStyles.rkRegularTextStyle(size: AppConstants.font_10, color: AppColors.greyColor)),
          ),
          const SizedBox(width: 34),
          Expanded(
            child: Text(l10n.supplier_delivery_schedule_delivery_on,
                style: AppStyles.rkRegularTextStyle(size: AppConstants.font_10, color: AppColors.greyColor)),
          ),
        ]),
        4.height,
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(child: _DayPill(dayName: orderUntilLabel, accentColor: AppColors.blueColor)),
          8.width,
          Icon(Icons.arrow_forward, size: 18, color: AppColors.greyColor),
          8.width,
          Expanded(child: _DayPill(dayName: deliveryLabel, accentColor: AppColors.mainColor))
        ]),
        if (_hasAnyTime(day)) ...[
          6.height,
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _UntilTimeLabel(untilTime: day.orderUntilTime, accentColor: AppColors.blueColor, l10n: l10n)),
            const SizedBox(width: 34),
            Expanded(child: _UntilTimeLabel(untilTime: day.deliveryUntilTime, accentColor: AppColors.mainColor, l10n: l10n))
          ]),
        ]
      ]),
    );
  }

  bool _hasAnyTime(SupplierCityDeliveryDay day) {
    return _formatUntilTime(day.orderUntilTime).isNotEmpty || _formatUntilTime(day.deliveryUntilTime).isNotEmpty;
  }

  String _formatUntilTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }
    final parts = value.trim().split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }
    return value.trim();
  }
}

class _UntilTimeLabel extends StatelessWidget {
  const _UntilTimeLabel({required this.untilTime, required this.accentColor, required this.l10n});

  final String? untilTime;
  final Color accentColor;
  final AppLocalizations l10n;

  String _formatUntilTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }
    final parts = value.trim().split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }
    return value.trim();
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = _formatUntilTime(untilTime);
    if (formattedTime.isEmpty) {
      return 0.height;
    }

    final untilLabel = l10n.supplier_delivery_schedule_until_time(formattedTime);

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.schedule, size: 14, color: accentColor),
      4.width,
      Flexible(
        child: Text(untilLabel,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: accentColor)),
      ),
    ]);
  }
}

class _DayPill extends StatelessWidget {
  const _DayPill({required this.dayName, required this.accentColor});

  final String dayName;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_8, vertical: AppConstants.padding_6),
      decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppConstants.radius_50),
          border: Border.all(color: accentColor.withValues(alpha: 0.35))),
      child: Text(dayName,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: accentColor)),
    );
  }
}
