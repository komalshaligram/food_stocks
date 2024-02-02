import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';

class BalanceIndicator extends StatelessWidget {
  final String pendingBalance;
  final double expense;
  final double totalBalance;

  BalanceIndicator({super.key, required this.pendingBalance ,required this.expense , required this.totalBalance});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: SfRadialGauge(
        backgroundColor: Colors.transparent,
        axes: [
          RadialAxis(
            minimum: 0,
            maximum: totalBalance,
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            // radiusFactor: 1.1,
            axisLineStyle: AxisLineStyle(
                thicknessUnit: GaugeSizeUnit.factor,
                thickness: 0.2,
                color: AppColors.borderColor),
            annotations: [
              GaugeAnnotation(
                angle: 180,
                widget: Text(
                  context.rtl?'% ${expense.toString()}':'${expense.toString()} %',
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_14,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            pointers: [
              RangePointer(
                color: AppColors.mainColor,
                enableAnimation: true,
                animationDuration: 300,
                animationType: AnimationType.ease,
                cornerStyle: CornerStyle.bothCurve,
                value: expense,
                width: 6,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
