import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/constants/app_colors.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_styles.dart';
import '../custom_button_widget.dart';

class SupplierTimer {
  final String supplierName;
  final int remainingSeconds;

  SupplierTimer({required this.supplierName, required this.remainingSeconds});
}

class MultiSupplierCountdownDialog extends StatefulWidget {
  final List<SupplierTimer> suppliers;
  final String title;

  const MultiSupplierCountdownDialog({Key? key, required this.suppliers, required this.title}) : super(key: key);

  @override
  State<MultiSupplierCountdownDialog> createState() => _MultiSupplierCountdownDialogState();
}

class _MultiSupplierCountdownDialogState extends State<MultiSupplierCountdownDialog> {
  late List<int> remainingTimes;
  late Timer timer;
  bool _isClosed = false;

  @override
  void initState() {
    super.initState();
    remainingTimes = widget.suppliers.map((e) => e.remainingSeconds).toList();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        for (int i = 0; i < remainingTimes.length; i++) {
          if (remainingTimes[i] > 0) {
            remainingTimes[i]--;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String format(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radius_5)),
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(widget.title,
              textAlign: TextAlign.center, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor)),
          15.height,
          ...List.generate(widget.suppliers.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  child: Text(widget.suppliers[index].supplierName,
                      style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor)),
                ),
                Text(format(remainingTimes[index]),
                    style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.mainColor, fontWeight: FontWeight.bold)),
              ]),
            );
          }),
          20.height,
          CustomButtonWidget(
              buttonText: AppLocalizations.of(context)!.closeText,
              bGColor: AppColors.mainColor,
              onPressed: () {
                if (!_isClosed && mounted) {
                  _isClosed = true;
                  timer.cancel();
                  Navigator.of(context, rootNavigator: true).pop();
                }
              }),
        ]),
      ),
    );
  }
}
