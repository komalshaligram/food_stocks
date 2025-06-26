import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/constants/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';

import '../utils/constants/app_constants.dart';
import '../utils/constants/app_styles.dart';
import 'custom_button_widget.dart';

class CountdownTimerDialog extends StatefulWidget {
  final int countdown; // Countdown in seconds
  final VoidCallback onTimerComplete;
  final String title;
  final TextDirection directionality;

  const CountdownTimerDialog({
    Key? key,
    required this.countdown,
    required this.onTimerComplete, required this.title, required this.directionality
  }) : super(key: key);

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

    // Start countdown timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return; // Prevent further actions if the widget is disposed
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

  // Convert remaining time in seconds to HH:MM:SS format
  String get formattedTime {
    int hours = _remainingTimeInSeconds ~/ 3600;
    int minutes = (_remainingTimeInSeconds % 3600) ~/ 60;
    int seconds = _remainingTimeInSeconds % 60;
    return '${_pad(hours)}:${_pad(minutes)}:${_pad(seconds)}';
  }

  // Helper function to pad numbers with leading zeros
  String _pad(int number) {
    return number.toString().padLeft(2, '0');
  }

  // Close the dialog safely only once
  void _closeDialog() {
    if (!_isClosed && mounted) {
      _isClosed = true;
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
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
            buttonText: AppLocalizations.of(context)!.close,
            bGColor: AppColors.mainColor,
            onPressed: () {
              _closeDialog(); // Close the dialog safely once
            },
          ),
        ],
      ),
    );
  }
}
