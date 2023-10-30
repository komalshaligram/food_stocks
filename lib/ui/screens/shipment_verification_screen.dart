/*import 'dart:io';
import 'dart:ui' as ui;*/
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_stock/ui/screens/order_details_screen.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../bloc/shipment_verification/shipment_verification_bloc.dart';
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
    return BlocProvider(
      create: (context) => ShipmentVerificationBloc(),
      child: ShipmentVerificationScreenWidget(),
    );
  }
}

class ShipmentVerificationScreenWidget extends StatelessWidget {
  ShipmentVerificationScreenWidget({super.key});

  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    ShipmentVerificationBloc bloc = context.read<ShipmentVerificationBloc>();
  /*  var bytes;*/
    return BlocListener<ShipmentVerificationBloc, ShipmentVerificationState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      child: BlocBuilder<ShipmentVerificationBloc, ShipmentVerificationState>(
        builder: (context, state) {
          return SafeArea(
              child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                title: AppLocalizations.of(context)!.shipment_verification,
                iconData: Icons.arrow_back_ios_sharp,
                trailingWidget: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppConstants.padding_10,
                  ),
                  child: CircularButtonWidget(
                    buttonName: AppLocalizations.of(context)!.total,
                    buttonValue: '12,450₪',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Column(
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
                            AppLocalizations.of(context)!.supplier_name,
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.font_14,
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            AppLocalizations.of(context)!.pending_delivery,
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.smallFont,
                                color: AppColors.orangeColor,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                      7.height,
                      Row(
                        children: [
                          CommonOrderContentWidget(
                            flexValue: 1,
                            title: AppLocalizations.of(context)!.products,
                            value: "23",
                            titleColor: AppColors.mainColor,
                            valueColor: AppColors.blackColor,
                            valueTextWeight: FontWeight.w700,
                            valueTextSize: AppConstants.smallFont,
                          ),
                          5.width,
                          CommonOrderContentWidget(
                            flexValue: 2,
                            title: AppLocalizations.of(context)!.delivery_date,
                            value: "12.02.23 10:00-12:00",
                            titleColor: AppColors.mainColor,
                            valueColor: AppColors.blackColor,
                            valueTextSize: AppConstants.font_10,
                            valueTextWeight: FontWeight.w500,
                            columnPadding: AppConstants.padding_8,
                          ),
                          5.width,
                          CommonOrderContentWidget(
                            flexValue: 2,
                            title: AppLocalizations.of(context)!.total_order,
                            value: '18,360₪',
                            titleColor: AppColors.mainColor,
                            valueColor: AppColors.blackColor,
                            valueTextWeight: FontWeight.w500,
                            valueTextSize: AppConstants.smallFont,
                          ),
                        ],
                      ),
                      7.height,
                      RichText(
                        text: TextSpan(
                          text: AppLocalizations.of(context)!
                              .supplier_order_number,
                          style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: AppConstants.font_14,
                              fontWeight: FontWeight.w400),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' : 1524812',
                                style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: AppConstants.font_14,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      7.height,
                      Text(
                        AppLocalizations.of(context)!.driver_name,
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.smallFont,
                            color: AppColors.orangeColor,
                            fontWeight: FontWeight.w700),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'חיים משה',
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.mediumFont,
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(AppConstants.radius_100)),
                              border: Border.all(
                                color: AppColors.borderColor,
                                width: 1,
                              ),
                            ),
                            child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppConstants.padding_10,
                                    vertical: AppConstants.padding_5),
                                decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(AppConstants.radius_100)),
                                  border: Border.all(
                                    color: AppColors.whiteColor,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  '054-5858996',
                                  style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: AppConstants.font_14,
                                      fontWeight: FontWeight.w700),
                                )),
                          ),
                        ],
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
                        fontWeight: FontWeight.w400),
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
                        state.isSignaturePadActive
                            ? Expanded(
                                child: SfSignaturePad(
                                    key: signatureGlobalKey,
                                    backgroundColor: Colors.white,
                                    strokeColor: Colors.black,
                                    minimumStrokeWidth: 1.0,
                                    maximumStrokeWidth: 4.0),
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
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  signatureGlobalKey.currentState!.clear();
                                },
                                child: SvgPicture.asset(
                                  AppImagePath.deleteRed,
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
                    /*  final Image =
                        await signatureGlobalKey.currentState!.toImage();
                     bytes =
                        await Image.toByteData(format: ui.ImageByteFormat.png);*/
                    /*Navigator.of(context)
                        .pushNamed(RouteDefine.orderDetailsScreen.name);*/

                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){
                      return OrderDetailsScreen();
                    } ));

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
                    ),
                  ),
                ),
                /*   bytes != null ? Container(
                      color: Colors.grey[300],
                      child: Image.memory(bytes!.buffer.asUint8List()),
                    ) : SizedBox(),*/
              ],
            ),
          ));
        },
      ),
    );
  }
}

/* Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(AppConstants.radius_100)),
                          border: Border.all(
                            color: AppColors.borderColor,
                            width: 1,
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: AppConstants.padding_10,
                              vertical: AppConstants.padding_5),
                          decoration: BoxDecoration(
                            color: AppColors.lightGreyColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(AppConstants.radius_100)),
                            border: Border.all(
                              color: AppColors.whiteColor,
                              width: 1,
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: AppLocalizations.of(context)!.total ,
                              style: TextStyle(
                                  color: AppColors.whiteColor, fontSize: AppConstants.font_14,fontWeight: FontWeight.w400),
                              children: <TextSpan>[
                                TextSpan(text: ' : 12,450₪',
                                    style: TextStyle(
                                        color: AppColors.whiteColor, fontSize: AppConstants.font_14,fontWeight: FontWeight.w700)
                                ),
                              ],
                            ),
                          ),
                        ),
                      )*/
