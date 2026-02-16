import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';
import 'custom_button_widget.dart';

class CountdownTimerDialog extends StatefulWidget {
  final int countdown;
  final VoidCallback onTimerComplete;
  final String title;
  final TextDirection directionality;

  const CountdownTimerDialog({Key? key, required this.countdown, required this.onTimerComplete, required this.title, required this.directionality}) : super(key: key);

  @override
  _CountdownTimerDialogState createState() => _CountdownTimerDialogState();
}

class _CountdownTimerDialogState extends State<CountdownTimerDialog> {
  late int _remainingTimeInSeconds;
  late Timer _timer;
  bool _isClosed = false;

  @override
  void initState() {
    super.initState();
    _remainingTimeInSeconds = widget.countdown;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_remainingTimeInSeconds > 0) {
          _remainingTimeInSeconds--;
        } else {
          _timer.cancel();
          widget.onTimerComplete();
          _closeDialog();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get formattedTime {
    int hours = _remainingTimeInSeconds ~/ 3600;
    int minutes = (_remainingTimeInSeconds % 3600) ~/ 60;
    int seconds = _remainingTimeInSeconds % 60;
    return '${_pad(hours)}:${_pad(minutes)}:${_pad(seconds)}';
  }

  String _pad(int number) {
    return number.toString().padLeft(2, '0');
  }

  void _closeDialog() {
    if (!_isClosed && mounted) {
      _isClosed = true;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radius_5),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$formattedTime ',
            textDirection: widget.directionality,
            style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.title,
            style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor, fontWeight: FontWeight.normal),
          ),
          20.height,
          CustomButtonWidget(
            buttonText: AppLocalizations.of(context)!.closeText,
            bGColor: AppColors.mainColor,
            onPressed: () {
              _closeDialog();
            },
          ),
        ],
      ),
    );
  }
}
