import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/constants/app_colors.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_styles.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import 'package:another_flushbar/flushbar.dart';
import 'constants/app_img_path.dart';
import 'constants/app_urls.dart';

double getScreenHeight(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  return screenHeight;
}

double getScreenWidth(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return screenWidth;
}

enum SnackBarType { success, failure }

bool isTablet(BuildContext context) {
  bool isTablet = false;
  if (MediaQuery.of(context).size.height > 800 &&
      MediaQuery.of(context).size.height > 500) {
    isTablet = true;
  } else {
    return false;
  }
  return isTablet;
}

String maskCreditCardNumber(String cardNumber) {
  var firstDigits = cardNumber.substring(0, 4);
  var lastDigits =
      cardNumber.substring(cardNumber.length - 4, cardNumber.length);
  var requiredMask = 'X' * (16 - firstDigits.length);
  var maskedString = requiredMask + lastDigits;
  var maskedCardNumberWithSpaces = maskedString.replaceAllMapped(
      RegExp(r'.{4}'), (match) => '${match.group(0)}-');
  return maskedCardNumberWithSpaces
      .toString()
      .substring(0, maskedCardNumberWithSpaces.length - 1);
}

String formatExpiryDate(String text) {
  String separator = '/';
  if (text.length == 1 && int.parse(text) > 1) {
    text = '0$text$separator';
  } else if (text.length == 2 && int.parse(text) > 12) {
    text = '12$separator';
  } else if (text.length > 2) {
    text = '${text.substring(0, 2)}$separator${text.substring(2)}';
  }
  return text;
}

Future<String> getBottleTax() async {
  SharedPreferencesHelper preferences =
      SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
  var value = preferences.getBottleTax().toString();
  return Future.value(value.toString());
}

Color getStatusColor(List<StatusData> statusList, String status) {
  if (status.isEmpty) {
    return AppColors.mainColor;
  }
  String color =
      statusList.where((e) => e.statusNameKey == status).first.statusColor ??
          '';
  final hexCode = color.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

String getStatus(
    List<StatusData> statusList, String currentStatus, String language) {
  String status = '';
  if (currentStatus.isEmpty) {
    return status;
  }
  if (language == AppStrings.hebrewString) {
    status = statusList
            .where((e) => e.statusNameKey == currentStatus)
            .first
            .statusNameHebrew ??
        '';
  } else {
    status = statusList
            .where((e) => e.statusNameKey == currentStatus)
            .first
            .statusNameEnglish ??
        '';
  }
  return status;
}

String getLocalizedReason(
    {required String apiReason, required BuildContext context}) {
  final l10n = AppLocalizations.of(context);
  if (l10n == null) {
    return apiReason;
  }

  final map = {
    'Product did not arrive at all': l10n.product_did_not_arrive_at_all,
    'המוצר לא הגיע בכלל': l10n.product_did_not_arrive_at_all,
    'Product arrived damaged': l10n.product_arrived_damaged,
    'המוצר הגיע פגום': l10n.product_arrived_damaged,
    'Product arrived incomplete': l10n.product_arrived_incomplete,
    'המוצר הגיע לא שלם': l10n.product_arrived_incomplete,
    'Expiration date issue': l10n.expiration_date_issue,
    'בעיית תאריך תפוגה': l10n.expiration_date_issue,
    'Wrong product received': l10n.wrong_product_received,
    'התקבל מוצר שגוי': l10n.wrong_product_received,
  };
  return map[apiReason.trim()] ?? apiReason;
}

double getChildAspectRatio(BuildContext context, bool isSaleOn) {
  return !isSaleOn
      ? AppConstants.productGridAspectRatio8
      : Platform.isAndroid
          ? getScreenHeight(context) > 900
              ? AppConstants.productGridAspectRatio9
              : getScreenHeight(context) > 820 && getScreenHeight(context) < 900
                  ? AppConstants.productGridAspectRatio51
                  : AppConstants.productGridAspectRatio51
          : getScreenHeight(context) > 820
              ? AppConstants.productGridAspectRatio51
              : AppConstants.productGridAspectRatio51;
}

double getItemHeight(BuildContext context, bool isSaleOn) {
  return getScreenHeight(context) > 1000 && getScreenWidth(context) > 700
      ? 350
      : getScreenHeight(context) < 1000 &&
              getScreenHeight(context) > 800 &&
              getScreenWidth(context) > 550
          ? 260
          : isSaleOn
              ? AppConstants.salesProductItemHeight
              : AppConstants.withoutSaleItemHeight;
}

double getItemWidth(BuildContext context) {
  return getScreenHeight(context) > 1000 && getScreenWidth(context) > 700
      ? 190
      : getScreenWidth(context) > 500
          ? 160
          : 140;
}

Widget isPesachLabelShow(bool isPesach, BuildContext context) {
  if (isPesach) {
    return Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
          color: AppColors.pesachBGColor,
          border: Border.all(color: AppColors.pesachBGColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Text(AppLocalizations.of(context)!.pesach,
            style: AppStyles.rkRegularTextStyle(size: AppConstants.font_13)));
  } else {
    return 0.height;
  }
}

class CustomSnackBar {
  static bool isSnackBarOpen = false;
  static void showSnackBar(
      {required BuildContext context,
      required String title,
      required SnackBarType type}) {
    Flushbar(
      backgroundColor: type == SnackBarType.success
          ? AppColors.mainColor.withValues(alpha: 0.85)
          : AppColors.redColor.withValues(alpha: 0.85),
      messageText: Text(title,
          style: AppStyles.rkRegularTextStyle(
              size: AppConstants.smallFont,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w400)),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(15),
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }
}

printData(String? message) {
  debugPrint(message ?? '');
}

customShowUpdateDialog(
    BuildContext context, String directionality, String storeUrl) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context1) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.new_version_app_update,
                style: AppStyles.rkRegularTextStyle(
                    color: AppColors.blackColor, size: AppConstants.mediumFont),
              ),
              actions: [
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      _launchUrl(storeUrl);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5.0),
                      alignment: Alignment.center,
                      width: AppConstants.containerHeight_80,
                      decoration: BoxDecoration(
                          gradient: AppColors.appMainGradientColor,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Text(
                        AppLocalizations.of(context)!.update,
                        style: AppStyles.rkRegularTextStyle(
                            color: AppColors.whiteColor,
                            size: AppConstants.font_14),
                      ),
                    ),
                  ),
                )
              ]),
        );
      });
}

String normalizeWhatsAppPhone(String phoneNumber) {
  final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) {
    return '';
  }
  if (digits.startsWith('972')) {
    return digits;
  }
  if (digits.startsWith('0')) {
    return '972${digits.substring(1)}';
  }
  return '972$digits';
}

Future<bool> openPhoneCall(String phoneNumber) async {
  final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) {
    return false;
  }
  final uri = Uri(scheme: 'tel', path: digits);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
    return true;
  }
  return false;
}

Future<bool> openWhatsAppChat(String phoneNumber) async {
  final intlPhone = normalizeWhatsAppPhone(phoneNumber);
  if (intlPhone.isEmpty) {
    return false;
  }
  final appUri = Uri.parse('whatsapp://send?phone=$intlPhone');
  if (await canLaunchUrl(appUri)) {
    await launchUrl(appUri, mode: LaunchMode.externalApplication);
    return true;
  }
  final webUri = Uri.parse('https://wa.me/$intlPhone');
  if (await canLaunchUrl(webUri)) {
    await launchUrl(webUri, mode: LaunchMode.externalApplication);
    return true;
  }
  return false;
}

Future<void> _launchUrl(String storeUrl) async {
  Uri url = Uri.parse(storeUrl);
  try {
    launchUrl(url);
  } on PlatformException catch (e) {
    printData(e.toString());
  } finally {
    launchUrl(url);
  }
}

bool isValidIsraeliID(String id) {
  id = id.trim();
  if (id.length > 9 || id.length < 5 || int.tryParse(id) == null) return false;
  id = id.length < 9 ? id.padLeft(9, '0') : id;

  int sum = 0;
  for (int i = 0; i < id.length; i++) {
    int digit = int.parse(id[i]);
    int step = digit * ((i % 2) + 1);
    sum += (step > 9) ? step - 9 : step;
  }
  return sum % 10 == 0;
}

Future<CroppedFile?> cropImage(
    {required String path,
    CropStyle shape = CropStyle.rectangle,
    int quality = 100,
    bool? isLogoCrop = false}) async {
  return await ImageCropper().cropImage(
    sourcePath: path,
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
        lockAspectRatio: false,
        toolbarColor: AppColors.blackColor,
        toolbarTitle: AppStrings.cropImageString,
        toolbarWidgetColor: AppColors.whiteColor,
      ),
      IOSUiSettings(
        title: AppStrings.cropImageString,
        aspectRatioLockEnabled: true,
        hidesNavigationBar: true,
        resetButtonHidden: true,
        rotateButtonsHidden: true,
        rotateClockwiseButtonHidden: true,
        aspectRatioPickerButtonHidden: false,
        aspectRatioLockDimensionSwapEnabled: true,
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

Future<XFile?> openImagePicker(ImageSource source) async {
  try {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt < 30) {
        if (source == ImageSource.camera) {
          if (await Permission.camera.isPermanentlyDenied) {
            return null;
          }
          if (!(await Permission.camera.request().isGranted)) {
            return null;
          }
        } else {
          if (await Permission.photos.isPermanentlyDenied) {
            return null;
          }
          if (!(await Permission.photos.request().isGranted)) {
            return null;
          }
        }
      }
    }
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);
    return pickedImage;
  } on PlatformException {
    return null;
  } catch (_) {}
  return null;
}

Future<bool> ensureBarcodeScannerCameraPermission(BuildContext context) async {
  // iOS: let the barcode scanner plugin request camera via AVCaptureDevice.requestAccess,
  // which shows the native permission dialog (permission_handler may not prompt on iOS).
  if (Platform.isIOS) {
    return true;
  }

  if (await Permission.camera.isGranted) {
    return true;
  }

  if (await Permission.camera.isPermanentlyDenied) {
    if (context.mounted) {
      CustomSnackBar.showSnackBar(
        context: context,
        title: AppLocalizations.of(context)!.camera_permission,
        type: SnackBarType.failure,
      );
    }
    return false;
  }

  final status = await Permission.camera.request();
  if (status.isGranted) {
    return true;
  }

  if (context.mounted) {
    CustomSnackBar.showSnackBar(
      context: context,
      title: AppLocalizations.of(context)!.camera_permission,
      type: SnackBarType.failure,
    );
  }
  return false;
}

Future<String> scanBarcodeOrQRCode(
    {required BuildContext context,
    required String cancelText,
    required ScanMode scanMode}) async {
  if (!await ensureBarcodeScannerCameraPermission(context)) {
    return '-1';
  }

  String barcodeSOrQRScanRes;
  try {
    barcodeSOrQRScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff20BF6B', cancelText, true, scanMode);
    printData(barcodeSOrQRScanRes);
  } on PlatformException {
    barcodeSOrQRScanRes = 'Failed to get platform version.';
  }
  printData('barcode = $barcodeSOrQRScanRes');
  return barcodeSOrQRScanRes;
}

bool isRTLContent({required BuildContext context}) {
  Locale locale = Localizations.localeOf(context);
  List<Locale> rtlLocales = [const Locale(AppStrings.hebrewString)];
  return rtlLocales.contains(locale) ? true : false;
}

extension RTLExtension on BuildContext {
  bool get rtl => [const Locale(AppStrings.hebrewString)]
          .contains(Localizations.localeOf(this))
      ? true
      : false;
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
  String toLocalization() => contains('.') ? split('.')[1].toLowerCase() : this;
}

String formatNumber({required String value, required String local}) {
  final double number = double.parse(value);
  final bool isNegative = number < 0;
  final formatted =
      NumberFormat.simpleCurrency(locale: local).format(number.abs());
  final String result = isNegative ? '-$formatted' : formatted;
  return splitNumber(result);
}

String formatSignedNumber(dynamic value) {
  final double amount = value is num
      ? value.toDouble()
      : double.tryParse(value?.toString() ?? '0') ?? 0;
  final formatted = NumberFormat.decimalPattern('en_IN').format(amount.abs());
  return amount.isNegative ? '-$formatted ₪' : '$formatted ₪';
}

String formatNumberPositiveToNegative(
    {required String value, required String local}) {
  final double number = double.parse(value);
  final bool isNegative = number < 0;
  String formatted =
      NumberFormat.simpleCurrency(locale: local).format(number.abs());
  formatted = formatted.replaceAll(RegExp(r'\s+'), '');
  return isNegative ? ' -$formatted' : formatted;
}

String formatNumberForWallet(
    {required String value,
    required String local,
    required BuildContext context}) {
  final currency = AppLocalizations.of(context)?.currency ?? '₪';
  final parsed = double.tryParse(value) ?? 0;
  final integerPart =
      value.contains('.') ? value.split('.').first : parsed.toStringAsFixed(0);
  return '$integerPart$currency';
}

double vatCalculation(
    {required double price,
    required double vat,
    double qty = 0,
    double deposit = 0}) {
  double result = price +
      ((price * vat) / 100) +
      (qty * deposit) +
      ((qty * deposit * vat) / 100);
  return result;
}

double vatCalculationRefund(
    {required double price,
    required double vat,
    double qty = 0,
    double deposit = 0,
    double? refund}) {
  double priceWithVat = price + ((price * vat) / 100);
  double depositWithVat = (qty * deposit) + ((qty * deposit * vat) / 100);
  double total = priceWithVat + depositWithVat;

  if (refund != null) {
    if (total <= -refund) {
      return 0;
    } else {
      if (total <= -refund) {
        return total + refund;
      } else {
        return total + refund;
      }
    }
  }
  return total;
}

double totalVatAmountCalculation(
    {required double price,
    required double vat,
    double qty = 0,
    double deposit = 0}) {
  double result = ((price * vat) / 100) + ((qty * deposit * vat) / 100);
  return result;
}

double bottleDepositCalculation(
    {double units = 1, required double deposit, required double qty}) {
  double result = qty * deposit * units;
  return result;
}

double bottleDepositCalculationWithVat(
    {required double deposit, required double qty, double vatPercentage = 1}) {
  double result = (qty * deposit) + ((qty * deposit * vatPercentage) / 100);
  return result;
}

/// Sum of product [totalVatAmount] from cart API.
double sumProductTotalVatAmounts(Iterable<double?> productTotalVatAmounts) {
  return productTotalVatAmounts.fold<double>(
      0, (sum, amount) => sum + (amount ?? 0));
}

/// Grand total: sum(totalVatAmount) + bottle deposit + 18% on deposit when [bottleQuantities] > 0.
double calculateBasketGrandTotal(
    {required double productsTotalWithVat,
    required double bottleTax,
    required double vatPercentage,
    required int bottleQuantities}) {
  if (bottleQuantities <= 0) {
    return productsTotalWithVat;
  }

  return productsTotalWithVat +
      bottleDepositCalculationWithVat(
          deposit: bottleTax,
          qty: bottleQuantities.toDouble(),
          vatPercentage: vatPercentage);
}

// double bottleDepositCalculationWithVatRefund({required double deposit, required double qty, double vatPercentage = 1, double? refund}) {
//   double depositWithVat = (qty * deposit) + ((qty * deposit * vatPercentage) / 100);
//
//   if (refund != null) {
//     if (depositWithVat <= -refund) {
//       return 0;
//     } else {
//       if (depositWithVat <= -refund) {
//         return depositWithVat + refund;
//       } else {
//         return depositWithVat + refund;
//       }
//     }
//   }
//   return depositWithVat;
// }

String formatInvoiceDate(String date) {
  if (date.isEmpty) return '';
  if (date.length > 10) {
    return date.substring(0, 10);
  }
  return date;
}

Widget getPaymentStatusWidget(String status, BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(
          vertical: AppConstants.padding_3, horizontal: AppConstants.padding_8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radius_50),
        color: status == AppStrings.openText
            ? AppColors.statusOpenColor
            : status == AppStrings.closedText
                ? AppColors.statusCloseColor
                : status == AppStrings.inProgressText
                    ? AppColors.statusInProgressColor
                    : AppColors.statusPartiallyClosedColor,
      ),
      child: Text(
        status == AppStrings.openText
            ? AppLocalizations.of(context)!.invoice_open
            : status == AppStrings.closedText
                ? AppLocalizations.of(context)!.invoice_close
                : status == AppStrings.inProgressText
                    ? AppLocalizations.of(context)!.in_progress_text
                    : AppLocalizations.of(context)!.partially_closed_text,
        style: AppStyles.rkRegularTextStyle(
            size: AppConstants.font_12,
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w400),
      ),
    );

Widget titleText(BuildContext context, String title) => Text(
      title,
      style: AppStyles.rkBoldTextStyle(
          size: AppConstants.smallFont,
          color: AppColors.blackColor,
          fontWeight: FontWeight.bold),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

Widget subTitleValueText(BuildContext context, String subTitle) => Text(
      subTitle,
      style: AppStyles.rkRegularTextStyle(
          size: AppConstants.smallFont,
          color: AppColors.blackColor,
          fontWeight: FontWeight.normal),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

Widget titleGreenText(BuildContext context, String title, ltr) =>
    Directionality(
      textDirection: ltr,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: AppStyles.rkBoldTextStyle(
            size: AppConstants.smallFont,
            color: AppColors.notificationColor,
            fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

Future<Map<String, int>> fetchCartQuantities(BuildContext context) async {
  SharedPreferencesHelper preferences =
      SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
  try {
    if (!preferences.getGuestUser()) {
      final cartRes = await DioClient(context)
          .post('${AppUrlEndPoints.getAllCartUrl}${preferences.getCartId()}');
      final cartResponse = GetAllCartResModel.fromJson(cartRes);

      if (cartResponse.status == AppConstants.code_200) {
        final items = cartResponse.data?.data ?? [];
        return {
          for (var item in items) item.id ?? '': item.totalQuantity ?? 0,
        };
      }
    }
  } catch (_) {}
  return {};
}

Widget noDataWidget(String title) => Center(
      child: Text(title,
          textAlign: TextAlign.center,
          style: AppStyles.rkRegularTextStyle(
              size: AppConstants.smallFont, color: AppColors.textColor)),
    );

Widget noDataWithEmpty(String title, BuildContext context) => Container(
      height: getScreenHeight(context) - 80,
      width: getScreenWidth(context),
      alignment: Alignment.center,
      child: noDataWidget(title),
    );

Widget cartImageWidget() => Container(
      height: 50,
      width: 50,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent, width: 1),
        gradient: AppColors.appMainGradientColor,
        borderRadius:
            const BorderRadius.all(Radius.circular(AppConstants.radius_100)),
      ),
      child: Center(
        child: SvgPicture.asset(
          AppImagePath.cart,
          height: 26,
          width: 26,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn),
        ),
      ),
    );

void inProgressSnackBarWidget(BuildContext context) =>
    CustomSnackBar.showSnackBar(
      context: context,
      title: AppStrings.getLocalizedStrings('Oops! in progress', context),
      type: SnackBarType.success,
    );

Widget smartRefreshCustomHeaderWidget() => CustomHeader(
    refreshStyle: RefreshStyle.Behind,
    builder: (c, m) {
      return Container(
        height: 30,
        width: 30,
        margin: const EdgeInsets.only(top: 90, bottom: AppConstants.padding_30),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor.withValues(alpha: 0.1),
                blurRadius: AppConstants.blur_10)
          ],
          color: AppColors.whiteColor,
          shape: BoxShape.circle,
        ),
        child: CupertinoActivityIndicator(
            color: AppColors.mainColor, radius: AppConstants.radius_10),
      );
    });

Widget imageNotAvailableWidget(double size) => Container(
      width: size,
      height: size,
      color: AppColors.whiteColor,
      alignment: Alignment.center,
      child: Image.asset(AppImagePath.imageNotAvailable5),
    );

Widget loaderWidget(double size) => Center(
      child: SizedBox(
          width: size,
          height: size,
          child: CupertinoActivityIndicator(color: AppColors.blackColor)),
    );

Widget invoiceOrderNumberWidget(String title) =>
    Stack(alignment: Alignment.bottomLeft, children: [
      Text(
        title,
        style: AppStyles.rkRegularTextStyle(
            size: AppConstants.smallFont,
            color: AppColors.notificationColor,
            fontWeight: FontWeight.w400),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
            height: 1,
            color: AppColors.notificationColor,
            margin: const EdgeInsets.only(top: AppConstants.padding_3)),
      ),
    ]);

/// Maps API weekday codes to app labels.
/// Supports 0=Sunday..6=Saturday and ISO 1=Monday..7=Sunday.
int normalizeWeekdayIndex(int day) {
  if (day < 0) {
    return -1;
  }
  if (day == 0) {
    return 0;
  }
  if (day <= 7) {
    return day % 7;
  }
  return -1;
}

String weekdayLabel(
  BuildContext context,
  int day, {
  AppLocalizations? l10n,
}) {
  final localizations = l10n ?? AppLocalizations.of(context);
  if (localizations == null) {
    return '';
  }
  switch (normalizeWeekdayIndex(day)) {
    case 0:
      return localizations.sunday;
    case 1:
      return localizations.monday;
    case 2:
      return localizations.tuesday;
    case 3:
      return localizations.wednesday;
    case 4:
      return localizations.thursday;
    case 5:
      return localizations.friday_and_holiday_eves;
    case 6:
      return localizations.saturday_and_holidays;
    default:
      return '';
  }
}
