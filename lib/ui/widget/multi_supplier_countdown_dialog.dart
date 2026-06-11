import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/constants/app_colors.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';
import 'custom_button_widget.dart';

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
          Text(widget.title, textAlign: TextAlign.center, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor)),
          15.height,
          ...List.generate(widget.suppliers.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Text(widget.suppliers[index].supplierName, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor))),
                Text(format(remainingTimes[index]), style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.mainColor, fontWeight: FontWeight.bold)),
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

// class CountdownTimerDialog extends StatefulWidget {
//   final int countdown;
//   final VoidCallback onTimerComplete;
//   final String title;
//   final TextDirection directionality;
//
//   const CountdownTimerDialog({Key? key, required this.countdown, required this.onTimerComplete, required this.title, required this.directionality}) : super(key: key);
//
//   @override
//   _CountdownTimerDialogState createState() => _CountdownTimerDialogState();
// }
//
// class _CountdownTimerDialogState extends State<CountdownTimerDialog> {
//   late int _remainingTimeInSeconds;
//   late Timer _timer;
//   bool _isClosed = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _remainingTimeInSeconds = widget.countdown;
//
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (!mounted) return;
//       setState(() {
//         if (_remainingTimeInSeconds > 0) {
//           _remainingTimeInSeconds--;
//         } else {
//           _timer.cancel();
//           widget.onTimerComplete();
//           _closeDialog();
//         }
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   String get formattedTime {
//     int hours = _remainingTimeInSeconds ~/ 3600;
//     int minutes = (_remainingTimeInSeconds % 3600) ~/ 60;
//     int seconds = _remainingTimeInSeconds % 60;
//     return '${_pad(hours)}:${_pad(minutes)}:${_pad(seconds)}';
//   }
//
//   String _pad(int number) {
//     return number.toString().padLeft(2, '0');
//   }
//
//   void _closeDialog() {
//     if (!_isClosed && mounted) {
//       _isClosed = true;
//       Navigator.of(context).pop();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radius_5)),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             '$formattedTime ',
//             textDirection: widget.directionality,
//             style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.bold),
//           ),
//           Text(widget.title, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.normal)),
//           20.height,
//           CustomButtonWidget(
//             buttonText: AppLocalizations.of(context)!.closeText,
//             bGColor: AppColors.mainColor,
//             onPressed: () {
//               _closeDialog();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
