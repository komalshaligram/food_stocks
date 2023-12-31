import 'dart:math';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_styles.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';

double getScreenHeight(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  return screenHeight;
}

double getScreenWidth(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return screenWidth;
}

enum SnackBarType {
  SUCCESS,
  FAILURE,
}

class CustomSnackBar {
  static bool isSnackBarOpen = false;

  static void showSnackBar(
      {required BuildContext context,
      required String title,
      required SnackBarType type}) {
    if (!isSnackBarOpen) {
      isSnackBarOpen = true;
      Flushbar(
        dismissDirection: FlushbarDismissDirection.VERTICAL,
        margin: const EdgeInsets.only(
            left: AppConstants.padding_10,
            right: AppConstants.padding_10,
            top: AppConstants.padding_10),
        duration: const Duration(milliseconds: 2000),
        borderRadius: BorderRadius.circular(8.0),
        backgroundColor: type == SnackBarType.SUCCESS
            ? AppColors.mainColor.withOpacity(0.85)
            : AppColors.redColor.withOpacity(0.85),
        // backgroundGradient: AppColors.appMainGradientColor.scale(0.8),
        borderWidth: 0,
        flushbarStyle: FlushbarStyle.FLOATING,
        flushbarPosition: FlushbarPosition.TOP,
        messageText: Text(
          title,
          style: AppStyles.rkRegularTextStyle(
              size: AppConstants.smallFont,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w400),
        ),
      ).show(context).whenComplete(() {
        isSnackBarOpen = false;
        debugPrint('isSnackBarOpen after = $isSnackBarOpen');
      }).catchError((err) {
        debugPrint('snackbar err = $err');
        isSnackBarOpen = false;
      });
    }
    // final snackBar = SnackBar(
    //   content: Text(
    //     title,
    //     style: AppStyles.rkRegularTextStyle(
    //         size: AppConstants.smallFont,
    //         color: AppColors.whiteColor,
    //         fontWeight: FontWeight.w400),
    //   ),
    //   backgroundColor: bgColor,
    //   behavior: SnackBarBehavior.floating,
    // );
    // ScaffoldMessenger.of(context).CustomSnackBar.showSnackBar(snackBar);
  }
}

Future<CroppedFile?> cropImage(
    {required String path,
    CropStyle shape = CropStyle.rectangle,
    int quality = 100,
    bool? isLogoCrop = false}) async {
  return await ImageCropper().cropImage(
    sourcePath: path,
    cropStyle: shape,
    compressQuality: quality,
    uiSettings: [
      AndroidUiSettings(
          activeControlsWidgetColor: AppColors.mainColor,
          cropFrameColor: AppColors.greyColor,
          initAspectRatio: isLogoCrop ?? false
              ? CropAspectRatioPreset.ratio16x9
              : CropAspectRatioPreset.square,
          hideBottomControls: true,
          showCropGrid: false,
          lockAspectRatio: true,
          toolbarColor: AppColors.blackColor,
          toolbarTitle: AppStrings.cropImageString,
          toolbarWidgetColor: AppColors.whiteColor),
      IOSUiSettings(
        title: AppStrings.cropImageString,
        aspectRatioLockEnabled: true,
        // showCancelConfirmationDialog: true,
        hidesNavigationBar: true,
        resetButtonHidden: true,
        rotateButtonsHidden: true,
        rotateClockwiseButtonHidden: true,
        aspectRatioPickerButtonHidden: true,
        cancelButtonTitle: AppStrings.cancelString,
        doneButtonTitle: AppStrings.doneString,
      ),
    ],
  );
}

String getFileSizeString({required int bytes, int decimals = 0}) {
  if (bytes <= 0) {
    return '0 bytes';
  }
  const suffixList = [" Bytes", " KB", " MB", " GB", " TB"];
  int i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixList[i];
}

Future<String> scanBarcodeOrQRCode(
    {required BuildContext context,
    required String cancelText,
    required ScanMode scanMode}) async {
  String barcodeSOrQRScanRes;
  try {
    barcodeSOrQRScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff20BF6B', cancelText, true, scanMode);
    print(barcodeSOrQRScanRes);
  } on PlatformException {
    barcodeSOrQRScanRes = 'Failed to get platform version.';
  }
  debugPrint('barcode = $barcodeSOrQRScanRes');
  return barcodeSOrQRScanRes;
}

bool isRTLContent({required BuildContext context}) {
  Locale locale = Localizations.localeOf(context);
  List<Locale> rtlLocales = [Locale('he')];
  // debugPrint('rtl = ${rtlLocales.contains(locale) ? "true" : "false"}');
  return rtlLocales.contains(locale) ? true : false;
}

extension RTLExtension on BuildContext {
  bool get rtl =>
      [Locale('he')].contains(Localizations.localeOf(this)) ? true : false;
}

String formatter(String currentBalance) {
  double value = double.parse(currentBalance);
  if (value < 1000) {
    return (splitNumber(value.toStringAsFixed(2)));
  } else if (value < 10000 && value >= 1000) {
    double result = (value / 1000);
    String result1 = splitNumber(result.toStringAsFixed(2));
    return ((result1.toString() + "K" + " "));
  } else if (value < 100000 && value >= 10000) {
    double result = value / 1000;
    String result1 = splitNumber(result.toStringAsFixed(2));
    return ((result1.toString() + "K" + " "));
  } else if (value < 1000000 && value >= 100000) {
    double result = value / 100000;
    String result1 = splitNumber(result.toStringAsFixed(2));
    return (result1.toString() + "L" + "");
  } else if (value < 10000000 && value >= 1000000) {
    // less than 100 million
    double result = value / 1000000;
    String result1 = splitNumber(result.toStringAsFixed(2));
    return (result1.toString() + "M" + " ");
  } else if (value < 100000000 && value >= 10000000) {
    // less than 100 million
    double result = value / 1000000;
    String result1 = splitNumber(result.toStringAsFixed(2));
    return (result1.toString() + "M" + " ");
  } else if (value < 1000000000 && value >= 100000000) {
    // less than 100 million
    double result = value / 1000000;
    String result1 = splitNumber(result.toStringAsFixed(2));
    return (result1.toString() + "M" + " ");
  } else if (value >= 1000000000) {
    // less than 100 million
    double result = value / 1000000;
    String result1 = splitNumber(result.toStringAsFixed(2));
    return (result1.toString() + "M" + " ");
  }
  return '';
}

String splitNumber(String price) {
  var splitPrice = price.split(".");
  if (splitPrice[1] == "00") {
    return splitPrice[0];
  } else {
    return price.toString();
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  String toLocalization() => this.split('.')[1].toLowerCase();
}


String formatNumber({required String value, required String local}){
  String result = (NumberFormat.simpleCurrency(locale: local,).format(double.parse(value)));
 String result1 =  splitNumber(result);
  return result1;
}
