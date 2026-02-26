import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/widget/sized_box_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../bloc/shipment_verification/shipment_verification_bloc.dart';
import '../utils/app_utils.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_img_path.dart';
import '../utils/constants/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_order_content_widget.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_container_widget.dart';
import '../widget/custom_form_field_widget.dart';

class ShipmentVerificationRoute {
  static Widget get route => const ShipmentVerificationScreen();
}

class ShipmentVerificationScreen extends StatelessWidget {
  const ShipmentVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;

    return BlocProvider(
      create: (context) => ShipmentVerificationBloc(),
      child: ShipmentVerificationScreenWidget(
        args: args,
        status: args?[AppStrings.deliveryStatusString],
      ),
    );
  }
}

class ShipmentVerificationScreenWidget extends StatefulWidget {
  final Map? args;
  final String? status;

  const ShipmentVerificationScreenWidget({required this.args, super.key, required this.status});

  @override
  State<ShipmentVerificationScreenWidget> createState() => _ShipmentVerificationScreenWidgetState();
}

class _ShipmentVerificationScreenWidgetState extends State<ShipmentVerificationScreenWidget> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  final GlobalKey<SfSignaturePadState> driverSignatureGlobalKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  bool isSign = false;
  bool isDriverSign = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<ShipmentVerificationBloc>();
      bloc.state.surfacesController.text = '0';
    });
  }

  @override
  Widget build(BuildContext context) {
    ShipmentVerificationBloc bloc = context.read<ShipmentVerificationBloc>();
    return BlocBuilder<ShipmentVerificationBloc, ShipmentVerificationState>(
      builder: (context, state) {
        final availableQty = widget.args?[AppStrings.availableSurfaceQuantityToReturn] ?? 0;

        return Stack(
          children: [
            WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                backgroundColor: AppColors.pageColor,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
                  child: CommonAppBar(
                    bgColor: AppColors.pageColor,
                    title: AppLocalizations.of(context)!.shipment_verification,
                    iconData: Icons.arrow_back_ios_sharp,
                    trailingWidget: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.padding_10,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100)),
                            border: Border.all(
                              color: AppColors.borderColor,
                              width: 1,
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_10, vertical: AppConstants.padding_5),
                            decoration: BoxDecoration(
                              color: AppColors.lightGreyColor,
                              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_100)),
                              border: Border.all(
                                color: AppColors.whiteColor,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${AppLocalizations.of(context)!.total}:',
                                  style: TextStyle(color: AppColors.whiteColor, fontSize: AppConstants.font_14, fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  formatNumber(value: widget.args?[AppStrings.totalAmountString] ?? '0', local: AppStrings.hebrewLocal),
                                  style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14, color: AppColors.whiteColor, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_15, horizontal: AppConstants.padding_15),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: AppConstants.padding_50),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_15, horizontal: AppConstants.padding_10),
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      boxShadow: [
                                        BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10),
                                      ],
                                      borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
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
                                              widget.args?[AppStrings.supplierNameString] ?? '',
                                              style: AppStyles.rkRegularTextStyle(
                                                size: AppConstants.font_14,
                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                            Text(
                                              widget.status?.toTitleCase() ?? '',
                                              style: AppStyles.rkRegularTextStyle(
                                                size: AppConstants.smallFont,
                                                color: widget.args?[AppStrings.orderStatusNo] == 6 ? AppColors.blueColor : AppColors.mainColor,
                                                fontWeight: FontWeight.w700,
                                              ),
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
                                              value: widget.args?[AppStrings.quantityString] ?? '',
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
                                              value: widget.args?[AppStrings.deliveryDateString] ?? '',
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
                                              value: formatNumber(value: widget.args?[AppStrings.totalOrderString] ?? '0', local: AppStrings.hebrewLocal),
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
                                            text: AppLocalizations.of(context)!.supplier_order_number,
                                            style: AppStyles.rkRegularTextStyle(
                                              color: AppColors.blackColor,
                                              size: AppConstants.font_14,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '${' : '}${widget.args?[AppStrings.supplierOrderNumberString] ?? ''}',
                                                style: AppStyles.rkRegularTextStyle(
                                                  color: AppColors.blackColor,
                                                  size: AppConstants.font_14,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  5.height,
                                  CustomContainerWidget(
                                    name: AppLocalizations.of(context)!.pallets_return,
                                    star: '*',
                                  ),
                                  CustomFormField(
                                    context: context,
                                    fillColor: AppColors.whiteColor,
                                    controller: state.surfacesController,
                                    keyboardType: TextInputType.number,
                                    hint: "",
                                    textInputAction: TextInputAction.next,
                                    validator: AppStrings.surfaceValString,
                                    availableQtyVal: availableQty,
                                  ),

                                  8.height,
                                  CustomContainerWidget(
                                    name: AppLocalizations.of(context)!.driver_name,
                                    star: '*',
                                  ),
                                  CustomFormField(
                                    context: context,
                                    fillColor: AppColors.whiteColor,
                                    controller: state.driverNameController,
                                    keyboardType: TextInputType.text,
                                    hint: "",
                                    textInputAction: TextInputAction.done,
                                    validator: AppStrings.driverNameString,
                                  ),
                                  8.height,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: 0),
                                    child: Text(
                                      AppLocalizations.of(context)!.signature,
                                      style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.smallFont,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getScreenHeight(context) / 4.5,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_15, horizontal: AppConstants.padding_10),
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        boxShadow: [
                                          BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10),
                                        ],
                                        borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          state.isSignaturePadActive /*&& !state.isDelete*/
                                              ? Expanded(
                                                  child: SfSignaturePad(
                                                    key: signatureGlobalKey,
                                                    backgroundColor: Colors.white,
                                                    strokeColor: Colors.black,
                                                    minimumStrokeWidth: 1.0,
                                                    maximumStrokeWidth: 4.0,
                                                    onDrawStart: () {
                                                      setState(() => isSign = true);
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
                                                    bloc.add(ShipmentVerificationEvent.signatureEvent());
                                                  },
                                                  child: SvgPicture.asset(
                                                    AppImagePath.signature,
                                                    colorFilter: ColorFilter.mode(state.isSignaturePadActive ? AppColors.mainColor : AppColors.blackColor, BlendMode.srcIn),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    signatureGlobalKey.currentState!.clear();
                                                    setState(() => isSign = false);
                                                    bloc.add(ShipmentVerificationEvent.signDeleteEvent());
                                                  },
                                                  child: SvgPicture.asset(
                                                    AppImagePath.delete,
                                                    colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  8.height,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_5, horizontal: 0),
                                    child: Text(
                                      AppLocalizations.of(context)!.driver_signature,
                                      style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.smallFont,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getScreenHeight(context) / 4.5,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_15, horizontal: AppConstants.padding_10),
                                      decoration: BoxDecoration(
                                        color: AppColors.whiteColor,
                                        boxShadow: [
                                          BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.15), blurRadius: AppConstants.blur_10),
                                        ],
                                        borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          state.isSignaturePadActive /*&& !state.isDelete*/
                                              ? Expanded(
                                                  child: SfSignaturePad(
                                                    key: driverSignatureGlobalKey,
                                                    backgroundColor: Colors.white,
                                                    strokeColor: Colors.black,
                                                    minimumStrokeWidth: 1.0,
                                                    maximumStrokeWidth: 4.0,
                                                    onDrawStart: () {
                                                      setState(() => isDriverSign = true);
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
                                                    bloc.add(ShipmentVerificationEvent.signatureEvent());
                                                  },
                                                  child: SvgPicture.asset(
                                                    AppImagePath.signature,
                                                    colorFilter: ColorFilter.mode(state.isSignaturePadActive ? AppColors.mainColor : AppColors.blackColor, BlendMode.srcIn),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    driverSignatureGlobalKey.currentState!.clear();
                                                    setState(() => isDriverSign = false);
                                                    bloc.add(ShipmentVerificationEvent.signDeleteEvent());
                                                  },
                                                  child: SvgPicture.asset(
                                                    AppImagePath.delete,
                                                    colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  8.height,
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                bottomSheet: SafeArea(
                  child: GestureDetector(
                    onTap: () async {
                      if (!_formKey.currentState!.validate()) return;

                      if (!isSign) {
                        CustomSnackBar.showSnackBar(
                          context: context,
                          title: AppLocalizations.of(context)!.signature_missing,
                          type: SnackBarType.failure,
                        );
                        return;
                      }

                      if (!isDriverSign) {
                        CustomSnackBar.showSnackBar(
                          context: context,
                          title: AppLocalizations.of(context)!.driver_signature_missing,
                          type: SnackBarType.failure,
                        );
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                        return;
                      }

                      final signImage = await signatureGlobalKey.currentState!.toImage();
                      final signData = await signImage.toByteData(format: ui.ImageByteFormat.png);
                      final signBytes = signData!.buffer.asUint8List();
                      final dir = (await getApplicationDocumentsDirectory()).path;
                      final signFile = await File('$dir/sign.png').writeAsBytes(signBytes);

                      final driverImage = await driverSignatureGlobalKey.currentState!.toImage();
                      final driverData = await driverImage.toByteData(format: ui.ImageByteFormat.png);
                      final driverBytes = driverData!.buffer.asUint8List();
                      final driverFile = await File('$dir/driver_sign.png').writeAsBytes(driverBytes);

                      bloc.add(
                        ShipmentVerificationEvent.deliveryConfirmEvent(
                          context: context,
                          supplierId: widget.args?[AppStrings.supplierIdString],
                          signPath: signFile.path,
                          driverSignPath: driverFile.path,
                          orderId: widget.args?[AppStrings.orderIdString],
                          driverDeliveryDocumentsImages: widget.args?[AppStrings.driverDeliveryDocumentsImages],
                          sentReturnData: (widget.args?[AppStrings.sentReturnData] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [],
                          orderIssueReturnId: widget.args?[AppStrings.orderIssueReturnId],
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_20, horizontal: AppConstants.padding_30),
                      color: AppColors.pageColor,
                      child: CustomButtonWidget(
                        buttonText: AppLocalizations.of(context)!.save.toUpperCase(),
                        bGColor: AppColors.mainColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (state.isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Center(
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(AppConstants.padding_5),
                        width: 220,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppConstants.radius_7),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: AppConstants.radius_10, offset: Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: Lottie.asset(
                                'assets/images/order_confirmation.json',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              AppLocalizations.of(context)?.order_confirmation_loader_text ?? 'Loading...',
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: AppConstants.font_14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              AppLocalizations.of(context)?.please_wait_text ?? 'Please wait...',
                              style: TextStyle(
                                fontSize: AppConstants.font_14,
                                color: AppColors.greyColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
