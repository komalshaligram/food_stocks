import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';

class BalanceIndicator extends StatelessWidget {
  final int balance;

  BalanceIndicator({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 70,
      child: SfRadialGauge(
        backgroundColor: Colors.transparent,
        axes: [
          RadialAxis(
            minimum: 0,
            maximum: 100,
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            // radiusFactor: 0.8,
            axisLineStyle: AxisLineStyle(
                thicknessUnit: GaugeSizeUnit.factor,
                thickness: 0.2,
                color: AppColors.borderColor),
            annotations: [
              GaugeAnnotation(
                angle: 270,
                widget: Text(
                  '$balance\n${AppLocalizations.of(context)!.currency}',
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
                value: balance.toDouble(),
                width: 6,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
