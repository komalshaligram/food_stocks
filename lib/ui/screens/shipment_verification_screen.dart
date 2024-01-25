import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../bloc/shipment_verification/shipment_verification_bloc.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';
import '../widget/circular_button_widget.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_order_content_widget.dart';
import '../widget/custom_button_widget.dart';

class ShipmentVerificationRoute {
  static Widget get route => ShipmentVerificationScreen();
}

class ShipmentVerificationScreen extends StatelessWidget {
  const ShipmentVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;

    return BlocProvider(
      create: (context) => ShipmentVerificationBloc(),
      child: ShipmentVerificationScreenWidget(
        args: args,
        status: args?[AppStrings.deliveryStatusString],
      ),
    );
  }
}

class ShipmentVerificationScreenWidget extends StatelessWidget {
  final Map? args;
  String? status;

  ShipmentVerificationScreenWidget(
      {required this.args, super.key, required this.status});

  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  bool isSign = false;

  @override
  Widget build(BuildContext context) {
    ShipmentVerificationBloc bloc = context.read<ShipmentVerificationBloc>();
    return BlocBuilder<ShipmentVerificationBloc, ShipmentVerificationState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.shipment_verification,
              iconData: Icons.arrow_back_ios_sharp,
              trailingWidget: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppConstants.padding_10,
                ),
                child: CircularButtonWidget(
                  buttonName: AppLocalizations.of(context)!.total,
                  buttonValue:
                      '${formatNumber(value: args?[AppStrings.totalAmountString] ?? '0', local: AppStrings.hebrewLocal)}',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(AppConstants.padding_10),
                  padding: EdgeInsets.symmetric(
                      vertical: AppConstants.padding_15,
                      horizontal: AppConstants.padding_10),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.shadowColor.withOpacity(0.15),
                          blurRadius: AppConstants.blur_10),
                    ],
                    borderRadius: BorderRadius.all(
                        Radius.circular(AppConstants.radius_5)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            args?[AppStrings.supplierNameString] ?? '',
                            style: AppStyles.rkRegularTextStyle(
                              size: AppConstants.font_14,
                              color: AppColors.blackColor,
                            ),
                          ),
                          Text(
                            status?.toTitleCase() ?? '',
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.smallFont,
                                color:  args?[AppStrings.orderStatusNo] == 6  ? AppColors.blueColor: AppColors.mainColor,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      7.height,
                      Row(
                        children: [
                          CommonOrderContentWidget(
                            backGroundColor: AppColors.iconBGColor,
                            borderCoder: AppColors.lightBorderColor,
                            flexValue: 1,
                            title: AppLocalizations.of(context)!.products,
                            value: args?[AppStrings.quantityString] ?? '',
                            titleColor: AppColors.mainColor,
                            valueColor: AppColors.blackColor,
                            valueTextWeight: FontWeight.w700,
                            valueTextSize: AppConstants.smallFont,
                          ),
                          5.width,
                          CommonOrderContentWidget(
                            backGroundColor: AppColors.iconBGColor,
                            borderCoder: AppColors.lightBorderColor,
                            flexValue: 2,
                            title: AppLocalizations.of(context)!.delivery_date,
                            value: args?[AppStrings.deliveryDateString] ?? '',
                            titleColor: AppColors.mainColor,
                            valueColor: AppColors.blackColor,
                            valueTextSize: AppConstants.font_10,
                            valueTextWeight: FontWeight.w500,
                            columnPadding: AppConstants.padding_8,
                          ),
                          5.width,
                          CommonOrderContentWidget(
                            backGroundColor: AppColors.iconBGColor,
                            borderCoder: AppColors.lightBorderColor,
                            flexValue: 2,
                            title: AppLocalizations.of(context)!.total_order,
                            value:
                                '${formatNumber(value: args?[AppStrings.totalOrderString] ?? '0', local: AppStrings.hebrewLocal)}',
                            titleColor: AppColors.mainColor,
                            valueColor: AppColors.blackColor,
                            valueTextWeight: FontWeight.w500,
                            valueTextSize: AppConstants.smallFont,
                          ),
                        ],
                      ),
                      15.height,
                      RichText(
                        text: TextSpan(
                          text: AppLocalizations.of(context)!
                              .supplier_order_number,
                          style: AppStyles.rkRegularTextStyle(
                            color: AppColors.blackColor,
                            size: AppConstants.font_14,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    '${' : '}${args?[AppStrings.supplierOrderNumberString] ?? ''}',
                                style: AppStyles.rkRegularTextStyle(
                                    color: AppColors.blackColor,
                                    size: AppConstants.font_14,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: AppConstants.padding_5,
                      horizontal: AppConstants.padding_15),
                  child: Text(
                    AppLocalizations.of(context)!.signature,
                    style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(AppConstants.padding_10),
                    padding: EdgeInsets.symmetric(
                        vertical: AppConstants.padding_15,
                        horizontal: AppConstants.padding_10),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.shadowColor.withOpacity(0.15),
                            blurRadius: AppConstants.blur_10),
                      ],
                      borderRadius: BorderRadius.all(
                          Radius.circular(AppConstants.radius_5)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        state.isSignaturePadActive && !state.isDelete
                            ? Expanded(
                                child: SfSignaturePad(
                                  key: signatureGlobalKey,
                                  backgroundColor: Colors.white,
                                  strokeColor: Colors.black,
                                  minimumStrokeWidth: 1.0,
                                  maximumStrokeWidth: 4.0,
                                  onDrawStart: () {
                                    isSign = true;
                                    return false;
                                  },
                                ),
                              )
                            : 0.height,
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  bloc.add(ShipmentVerificationEvent
                                      .signatureEvent());
                                },
                                child: SvgPicture.asset(
                                  AppImagePath.signature,
                                  color: state.isSignaturePadActive && !state.isDelete ? AppColors.mainColor : AppColors.blackColor,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  signatureGlobalKey.currentState!.clear();
                                  bloc.add(ShipmentVerificationEvent
                                      .signDeleteEvent());
                                },
                                child: SvgPicture.asset(
                                  AppImagePath.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (state.isSignaturePadActive &&
                        !state.isDelete &&
                        isSign) {
                      ui.Image tempImage =
                          await signatureGlobalKey.currentState!.toImage();
                      var data = await tempImage.toByteData(
                          format: ui.ImageByteFormat.png);
                      final imageInUnit8List = (data!.buffer.asUint8List());
                      final directory =
                          (await getApplicationDocumentsDirectory())
                              .path; // to get path of the file
                      var path = '$directory/fileName.png';
                      File image =
                          await File(path).writeAsBytes(imageInUnit8List);
                      bloc.add(
                        ShipmentVerificationEvent.deliveryConfirmEvent(
                          context: context,
                          supplierId: args?[AppStrings.supplierIdString],
                          signPath: image.path,
                          orderId: args?[AppStrings.orderIdString],
                        ),
                      );
                    } else {
                      CustomSnackBar.showSnackBar(
                          context: context,
                          title:
                              '${AppLocalizations.of(context)!.signature_missing}',
                          type: SnackBarType.FAILURE);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: AppConstants.padding_20,
                        horizontal: AppConstants.padding_30),
                    color: AppColors.pageColor,
                    child: CustomButtonWidget(
                      buttonText:
                          AppLocalizations.of(context)!.save.toUpperCase(),
                      bGColor: AppColors.mainColor,
                      isLoading: state.isLoading,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
