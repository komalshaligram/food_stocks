import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';
import '../utils/constants/app_urls.dart';
import 'sized_box_widget.dart';

class SummaryStyle {
  SummaryStyle._();

  static const double cardRadius = 18;
  static const double gutter = 14;

  static Color get titleColor => const Color(0xff1B2733);
  static Color get labelColor => AppColors.greyColor;
  static Color get amberColor => AppColors.statusNoMinimumColor;
  static Color get hairline => AppColors.lightBorderColor;

  static BoxDecoration get cardDecoration => BoxDecoration(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(cardRadius),
      border: Border.all(color: AppColors.lightBorderColor),
      boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.05), blurRadius: 18, offset: const Offset(0, 6))]);
}

final NumberFormat _amountFormat = NumberFormat('#,##0.00', 'en_US');

String summaryMoney(num? value) {
  final double amount = (value ?? 0).toDouble();
  return '${amount < 0 ? '-' : ''}₪${_amountFormat.format(amount.abs())}';
}

final NumberFormat _roundAmountFormat = NumberFormat('#,##0', 'en_US');

String summaryMoneyCompact(num? value) {
  final double amount = (value ?? 0).toDouble();
  if (amount == amount.roundToDouble()) {
    return '${amount < 0 ? '-' : ''}₪${_roundAmountFormat.format(amount.abs())}';
  }
  return summaryMoney(amount);
}

class SummaryAmountText extends StatelessWidget {
  const SummaryAmountText(this.text, {super.key, required this.style, this.textAlign});

  final String text;
  final TextStyle style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr, child: Text(text, style: style, textAlign: textAlign, maxLines: 1, overflow: TextOverflow.ellipsis));
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.children, this.margin});

  final List<Widget> children;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.fromLTRB(12, 6, 12, 6),
      decoration: SummaryStyle.cardDecoration,
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

class SummaryHairline extends StatelessWidget {
  const SummaryHairline({super.key});

  @override
  Widget build(BuildContext context) => Divider(height: 1, thickness: 1, color: SummaryStyle.hairline);
}

class SummarySupplierHeader extends StatelessWidget {
  const SummarySupplierHeader(
      {super.key,
      required this.supplierName,
      required this.totalLabel,
      required this.totalAmount,
      required this.productsLabel,
      required this.productsCount,
      required this.savings,
      this.supplierLogo});

  final String supplierName;

  final String? supplierLogo;
  final String totalLabel;
  final double totalAmount;
  final String productsLabel;
  final String productsCount;
  final double savings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(SummaryStyle.gutter, SummaryStyle.gutter, SummaryStyle.gutter, 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        _SupplierAvatar(name: supplierName, logo: supplierLogo),
        10.width,
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(supplierName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.rkBoldTextStyle(size: AppConstants.font_17, color: SummaryStyle.titleColor)),
            6.height,
            Wrap(spacing: 6, runSpacing: 4, children: [
              _MetaChip(icon: Icons.inventory_2_outlined, text: '$productsCount $productsLabel', color: AppColors.blueColor),
              if (savings.abs() > 0)
                _MetaChip(icon: Icons.sell_outlined, text: summaryMoney(savings.abs()), color: AppColors.orangeColor, isAmount: true),
            ]),
          ]),
        ),
        8.width,
        Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
          Text(totalLabel, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_10, color: SummaryStyle.labelColor)),
          2.height,
          SummaryAmountText(summaryMoney(totalAmount), style: AppStyles.rkBoldTextStyle(size: AppConstants.font_20, color: AppColors.blueColor))
        ]),
      ]),
    );
  }
}

class _SupplierAvatar extends StatelessWidget {
  const _SupplierAvatar({required this.name, this.logo});

  final String name;
  final String? logo;

  static const double _size = 46;
  static const double _radius = 14;

  static String _logoUrl(String path) => '${AppUrlEndPoints.baseFileUrl}${path.split('/').map(Uri.encodeComponent).join('/')}';

  @override
  Widget build(BuildContext context) {
    final bool hasLogo = logo?.trim().isNotEmpty == true;

    if (hasLogo) {
      return Container(
        width: _size,
        height: _size,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: AppColors.whiteColor, borderRadius: BorderRadius.circular(_radius), border: Border.all(color: AppColors.lightBorderColor)),
        child: CachedNetworkImage(
            imageUrl: _logoUrl(logo!.trim()),
            fit: BoxFit.contain,
            alignment: Alignment.center,
            placeholder: (context, url) => Container(color: AppColors.iconBGColor),
            errorWidget: (context, url, error) => _initialBadge()),
      );
    }

    return _initialBadge();
  }

  Widget _initialBadge() {
    final String initial = name.trim().isEmpty ? '' : name.trim().characters.first;
    return Container(
        width: _size,
        height: _size,
        alignment: Alignment.center,
        decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(_radius)),
        child: initial.isEmpty
            ? Icon(Icons.storefront_outlined, color: AppColors.whiteColor, size: 22)
            : Text(initial, style: AppStyles.rkBoldTextStyle(size: AppConstants.mediumFont, color: AppColors.whiteColor)));
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.text, required this.color, this.isAmount = false});

  final IconData icon;
  final String text;
  final Color color;
  final bool isAmount;

  @override
  Widget build(BuildContext context) {
    final style = AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: color, fontWeight: FontWeight.w600);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(AppConstants.radius_8)),
      child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(icon, size: 13, color: color), 4.width, isAmount ? SummaryAmountText(text, style: style) : Text(text, style: style)]),
    );
  }
}

class MinimumOrderProgress extends StatelessWidget {
  const MinimumOrderProgress(
      {super.key,
      required this.minimumAmount,
      required this.currentAmount,
      required this.isReached,
      required this.minimumLabel,
      required this.reachedText,
      required this.missingText});

  final int minimumAmount;
  final double currentAmount;
  final bool isReached;
  final String minimumLabel;
  final String reachedText;
  final String missingText;

  @override
  Widget build(BuildContext context) {
    final Color accent = isReached ? AppColors.notificationColor : SummaryStyle.amberColor;
    final double progress = isReached ? 1 : (minimumAmount <= 0 ? 1 : (currentAmount / minimumAmount).clamp(0.0, 1.0).toDouble());

    return Container(
      width: double.infinity,
      color: AppColors.pageColor.withValues(alpha: 0.7),
      padding: const EdgeInsets.symmetric(horizontal: SummaryStyle.gutter, vertical: 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        if (minimumAmount > 0) ...[
          Row(children: [
            Text(minimumLabel, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: SummaryStyle.labelColor)),
            const Spacer(),
            SummaryAmountText(summaryMoneyCompact(minimumAmount),
                style: AppStyles.rkBoldTextStyle(size: AppConstants.font_13, color: AppColors.blueColor)),
          ]),
          8.height,
          _ProgressBar(progress: progress, accent: accent),
          8.height
        ],
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(isReached ? Icons.check_circle_rounded : Icons.info_rounded, size: 16, color: accent),
          6.width,
          Expanded(
            child: Text(isReached ? reachedText : missingText,
                style: AppStyles.rkBoldTextStyle(size: AppConstants.font_12, color: accent, fontWeight: FontWeight.w600)),
          ),
        ]),
      ]),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.accent});

  final double progress;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstants.radius_100),
      child: Container(
        height: 8,
        color: AppColors.borderColor.withValues(alpha: 0.5),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: progress),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          builder: (context, value, _) => FractionallySizedBox(
            alignment: AlignmentDirectional.centerStart,
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radius_100),
                  gradient: LinearGradient(colors: [accent.withValues(alpha: 0.75), accent])),
            ),
          ),
        ),
      ),
    );
  }
}

class SummaryActionTile extends StatelessWidget {
  const SummaryActionTile(
      {super.key,
      required this.icon,
      required this.label,
      required this.accent,
      this.subLabel,
      this.onTap,
      this.isLoading = false,
      this.flipIcon = false});

  final IconData icon;
  final String label;
  final String? subLabel;
  final Color accent;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool flipIcon;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          child: SizedBox(width: 20, height: 20, child: CupertinoActivityIndicator(color: accent)));
    }

    final Widget iconWidget = Icon(icon, color: accent, size: 18);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SummaryStyle.gutter, vertical: 10),
          child: Row(children: [
            Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: accent.withValues(alpha: 0.10), shape: BoxShape.circle),
                child: flipIcon ? Transform.flip(flipX: true, child: iconWidget) : iconWidget),
            10.width,
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(label,
                    maxLines: 1, overflow: TextOverflow.ellipsis, style: AppStyles.rkBoldTextStyle(size: AppConstants.font_13, color: accent)),
                if (subLabel?.isNotEmpty == true) ...[
                  2.height,
                  Text(subLabel!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.rkRegularTextStyle(size: AppConstants.font_10, color: SummaryStyle.labelColor))
                ]
              ]),
            ),
            if (onTap != null) Icon(Icons.chevron_right, color: accent, size: 22)
          ]),
        ),
      ),
    );
  }
}

class SummaryBreakdownRow extends StatelessWidget {
  const SummaryBreakdownRow({super.key, required this.label, required this.amount, this.amountColor, this.isMuted = false});

  final String label;
  final String amount;
  final Color? amountColor;
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(children: [
        Expanded(
          child: Text(label,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: isMuted ? SummaryStyle.labelColor : SummaryStyle.titleColor)),
        ),
        8.width,
        SummaryAmountText(amount,
            style: AppStyles.rkBoldTextStyle(size: AppConstants.font_14, color: amountColor ?? SummaryStyle.titleColor, fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

class SummaryGrandTotalRow extends StatelessWidget {
  const SummaryGrandTotalRow({super.key, required this.label, required this.amount});

  final String label;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(color: AppColors.blueColor.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(AppConstants.radius_15)),
      child: Row(children: [
        Expanded(child: Text(label, style: AppStyles.rkBoldTextStyle(size: AppConstants.font_15, color: SummaryStyle.titleColor))),
        8.width,
        SummaryAmountText(summaryMoney(amount), style: AppStyles.rkBoldTextStyle(size: AppConstants.font_22, color: AppColors.blueColor))
      ]),
    );
  }
}

class SummaryNote extends StatelessWidget {
  const SummaryNote({super.key, required this.text, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color tint = color ?? SummaryStyle.labelColor;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(Icons.info_outline_rounded, size: 14, color: tint),
      6.width,
      Expanded(child: Text(text, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_12, color: tint))),
    ]);
  }
}

class SummaryCreditBanner extends StatelessWidget {
  const SummaryCreditBanner({super.key, required this.text, this.margin});

  final String text;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin ?? const EdgeInsets.fromLTRB(12, 4, 12, 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.notificationColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppConstants.radius_15),
          border: Border.all(color: AppColors.notificationColor.withValues(alpha: 0.25))),
      child: Row(children: [
        Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.notificationColor.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Icon(Icons.account_balance_wallet_outlined, size: 17, color: AppColors.notificationColor)),
        10.width,
        Expanded(
          child: Text(text,
              style: AppStyles.rkBoldTextStyle(size: AppConstants.font_13, color: AppColors.notificationColor, fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }
}

class SummaryTotalPill extends StatelessWidget {
  const SummaryTotalPill({super.key, required this.label, required this.amount});

  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(AppConstants.radius_100), boxShadow: [
          BoxShadow(color: AppColors.blueColor.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 4)),
        ]),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_10, color: AppColors.whiteColor.withValues(alpha: 0.85))),
          5.width,
          SummaryAmountText(amount, style: AppStyles.rkBoldTextStyle(size: AppConstants.font_14, color: AppColors.whiteColor))
        ]),
      ),
    );
  }
}

class SummaryPrimaryButton extends StatelessWidget {
  const SummaryPrimaryButton({super.key, required this.text, required this.onPressed, this.icon, this.isLoading = false});

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          gradient: onPressed == null ? AppColors.disableGradientColor : AppColors.appMainGradientColor,
          borderRadius: BorderRadius.circular(AppConstants.radius_15),
          boxShadow:
              onPressed == null ? null : [BoxShadow(color: AppColors.blueColor.withValues(alpha: 0.22), blurRadius: 12, offset: const Offset(0, 5))]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          child: Center(
            child: isLoading
                ? CupertinoActivityIndicator(color: AppColors.whiteColor)
                : Row(mainAxisSize: MainAxisSize.min, children: [
                    if (icon != null) ...[Icon(icon, color: AppColors.whiteColor, size: 20), 8.width],
                    Text(text,
                        style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor, fontWeight: FontWeight.w600)),
                  ]),
          ),
        ),
      ),
    );
  }
}
