import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/product_details/product_details_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/circular_button_widget.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_order_content_widget.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_form_field_widget.dart';
import '../widget/product_details_screen-shimmer_widget.dart';

class ProductDetailsRoute {
  static Widget get route => ProductDetailsScreen();
}

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => ProductDetailsBloc()
        ..add(ProductDetailsEvent.getProductDataEvent(
            context: context,
            productIndex: args?[AppStrings.productIndexString] ?? 0,
            orderId: args?[AppStrings.orderIdString] ?? '')),
      child: ProductDetailsScreenWidget(
        productIndex: args?[AppStrings.productIndexString] ?? 0,
        orderId: args?[AppStrings.orderIdString] ?? '',
        orderNumber: args?[AppStrings.orderNumberString] ?? '',
      ),
    );
  }
}

class ProductDetailsScreenWidget extends StatelessWidget {
  int productIndex;
  String orderId;
  String orderNumber;

  ProductDetailsScreenWidget(
      {super.key,
      required this.productIndex,
      required this.orderId,
      required this.orderNumber});

  TextEditingController addProblemController = TextEditingController();
  TextEditingController driverController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    /*  ProductDetailsBloc bloc = context.read<ProductDetailsBloc>();*/
    return BlocListener<ProductDetailsBloc, ProductDetailsState>(
      listener: (context, state) {
      },
      child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(AppConstants.appBarHeight),
                child: CommonAppBar(
                  title: orderNumber.toString(),
                  iconData: Icons.arrow_back_ios_sharp,
                  trailingWidget: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppConstants.padding_10,
                    ),
                    child:
                        (state.orderList.data?.ordersBySupplier?.length ?? 0) ==
                                0
                            ? CupertinoActivityIndicator()
                            : CircularButtonWidget(
                                buttonName: AppLocalizations.of(context)!.total,
                                buttonValue:
                                    '${state.orderList.data!.ordersBySupplier![productIndex].totalPayment.toString()}${AppLocalizations.of(context)!.currency}',
                              ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: (state.orderList.data?.ordersBySupplier?.length ?? 0) == 0
                  ? ProductDetailsScreenShimmerWidget()
                  : Form(
                      key: _formKey,
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
                                    color:
                                        AppColors.shadowColor.withOpacity(0.15),
                                    blurRadius: 10),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      state
                                          .orderList
                                          .data!
                                          .ordersBySupplier![productIndex]
                                          .supplierName!
                                          .toString(),
                                      style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.font_14,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                    Text(
                                      state
                                          .orderList
                                          .data!
                                          .ordersBySupplier![productIndex]
                                          .deliverStatus!
                                          .statusName
                                          .toString(),
                                      style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.smallFont,
                                          color: state
                                                      .orderList
                                                      .data!
                                                      .ordersBySupplier![
                                                          productIndex]
                                                      .deliverStatus!
                                                      .statusName
                                                      .toString() ==
                                                  AppLocalizations.of(context)!
                                                      .pending_delivery?
                                          /*state.orderList.data!.ordersBySupplier![productIndex].orderDeliveryDate == ''?*/
                                               AppColors.orangeColor
                                              : AppColors.mainColor,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                                7.height,
                                Row(
                                  children: [
                                    CommonOrderContentWidget(
                                      flexValue: 1,
                                      title: AppLocalizations.of(context)!
                                          .products,
                                      value: state
                                          .orderList
                                          .data!
                                          .ordersBySupplier![productIndex]
                                          .products!
                                          .length
                                          .toString(),
                                      titleColor: AppColors.mainColor,
                                      valueColor: AppColors.blackColor,
                                      valueTextWeight: FontWeight.w700,
                                      valueTextSize: AppConstants.mediumFont,
                                    ),
                                    5.width,
                                    CommonOrderContentWidget(
                                      flexValue: 2,
                                      title: AppLocalizations.of(context)!
                                          .delivery_date,
                                      value: /*state.orderList.data!.ordersBySupplier![productIndex].orderDeliveryDate != ''*/
                                      state
                                          .orderList
                                          .data!
                                          .ordersBySupplier![productIndex]
                                          .deliverStatus!
                                          .statusName
                                          .toString() !=
                                          AppLocalizations.of(context)!
                                              .pending_delivery
                                        ?'${state.orderList.data!.ordersBySupplier![productIndex].orderDeliveryDate.toString().replaceRange(10, 24, '')}' : '-',
                                      titleColor: AppColors.mainColor,
                                      valueColor: AppColors.blackColor,
                                      valueTextSize: AppConstants.font_10,
                                      valueTextWeight: FontWeight.w500,
                                      columnPadding: AppConstants.padding_10,
                                    ),
                                    5.width,
                                    CommonOrderContentWidget(
                                      flexValue: 2,
                                      title: AppLocalizations.of(context)!
                                          .total_order,
                                      value: '${state.orderList.data?.ordersBySupplier![productIndex].totalPayment.toString()}${AppLocalizations.of(context)!.currency}',
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
                                    style: AppStyles.rkRegularTextStyle(
                                      color: AppColors.blackColor,
                                      size: AppConstants.font_14,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              '${' : '}${state.orderList.data?.ordersBySupplier?[productIndex].supplierOrderNumber ?? '0'}',
                                          style: AppStyles.rkRegularTextStyle(
                                              color: AppColors.blackColor,
                                              size: AppConstants.font_14,
                                              fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                                7.height,
                                Text(
                                  AppLocalizations.of(context)!.driver_name,
                                  style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.font_14,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                                5.height,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                   state
                                                .orderList
                                                .data!
                                                .ordersBySupplier![productIndex]
                                                .deliverStatus!
                                                .statusName
                                                .toString() !=
                                            AppLocalizations.of(context)!
                                                .pending_delivery
                                    /*state.orderList.data!.ordersBySupplier![productIndex].orderDeliveryDate != ''*/
                                        ? Text(
                                            state
                                                    .orderList
                                                    .data
                                                    ?.ordersBySupplier![
                                                        productIndex]
                                                    .driverName
                                                    .toString() ??
                                                '',
                                            style: AppStyles.rkRegularTextStyle(
                                                size: AppConstants.mediumFont,
                                                color: AppColors.blackColor,
                                                fontWeight: FontWeight.w600),
                                          )
                                        : Container(
                                            width: 150,
                                            // height: 40,
                                            child: CustomFormField(
                                              controller: driverController,
                                              inputformet: [
                                                LengthLimitingTextInputFormatter(
                                                    15)],
                                              keyboardType: TextInputType.text,
                                              hint: '',
                                              validator:
                                                  AppStrings.driverNameString,
                                              fillColor: Colors.white,
                                            )),
                                   (state
                                                    .orderList
                                                    .data
                                                    ?.ordersBySupplier![
                                                        productIndex]
                                                    .deliverStatus!
                                                    .statusName
                                                    .toString() ??
                                                '') !=
                                            AppLocalizations.of(context)!
                                                .pending_delivery?
         /*         state.orderList.data!.ordersBySupplier![productIndex].orderDeliveryDate != ''*/
                                         Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      AppConstants.radius_100)),
                                              border: Border.all(
                                                color: AppColors.borderColor,
                                                width: 1,
                                              ),
                                            ),
                                            child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        AppConstants.padding_5,
                                                    vertical:
                                                        AppConstants.padding_5),
                                                decoration: BoxDecoration(
                                                  color: AppColors.mainColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              AppConstants
                                                                  .radius_100)),
                                                  border: Border.all(
                                                    color: AppColors.whiteColor,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Text(
                                                  state
                                                          .orderList
                                                          .data
                                                          ?.ordersBySupplier![
                                                              productIndex]
                                                          .driverNumber
                                                          .toString() ??
                                                      '',
                                                  style: AppStyles
                                                      .rkRegularTextStyle(
                                                          size: AppConstants
                                                              .mediumFont,
                                                          color: AppColors
                                                              .whiteColor,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                )),
                                          )
                                        : Container(
                                            width: 150,
                                            // height: 35,
                                            child: CustomFormField(
                                              controller: phoneNumberController,
                                              keyboardType:
                                                  TextInputType.number,
                                              hint: AppStrings.hintNumberString,
                                              validator:
                                                  AppStrings.mobileValString,
                                              fillColor: Colors.white,
                                              border: 30,
                                            ),
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
                              AppLocalizations.of(context)!.order_products_list,
                              style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.smallFont,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: (state.orderList.data?.ordersBySupplier
                                            ?.length ??
                                        0) ==
                                    0
                                ? CircularProgressIndicator()
                                : ListView.builder(
                                    itemCount: state
                                            .orderList
                                            .data
                                            ?.ordersBySupplier![productIndex]
                                            .products!
                                            .length ??
                                        0,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                        vertical: AppConstants.padding_5),
                                    itemBuilder: (context, index) =>
                                        productListItem(
                                            index: index,
                                            context: context,
                                            status: state
                                                    .orderList
                                                    .data
                                                    ?.ordersBySupplier?[
                                                        productIndex]
                                                    .deliverStatus
                                                    ?.statusName
                                                    .toString() ??
                                                ''),
                                  ),
                          ),
                        ],
                      ),
                    ),
              bottomSheet: Container(
                padding: EdgeInsets.symmetric(
                    vertical: AppConstants.padding_20,
                    horizontal: AppConstants.padding_30),
                color: AppColors.pageColor,
                child: CustomButtonWidget(
                  onPressed: () {
                    state.orderList.data?.orderData?.first.orderstatus
                                ?.statusName
                                .toString() !=
                            AppLocalizations.of(context)!.pending_delivery?
                    /*state.orderList.data!.ordersBySupplier![productIndex].orderDeliveryDate != ''?*/
                         Navigator.pushNamed(
                            context, RouteDefine.bottomNavScreen.name)
                        : _formKey.currentState?.validate() ?? false
                            ? Navigator.pushNamed(context,
                                RouteDefine.shipmentVerificationScreen.name,
                                arguments: {
                                    AppStrings.supplierNameString: state
                                            .orderList
                                            .data
                                            ?.ordersBySupplier![productIndex]
                                            .supplierName!
                                            .toString() ??
                                        '',
                                    AppStrings.deliveryStatusString: state
                                            .orderList
                                            .data
                                            ?.ordersBySupplier![productIndex]
                                            .deliverStatus!
                                            .statusName
                                            .toString() ??
                                        '',
                                    AppStrings.totalOrderString: state
                                            .orderList
                                            .data
                                            ?.ordersBySupplier![productIndex]
                                            .totalPayment
                                            .toString() ??
                                        '',
                                    AppStrings.deliveryDateString: /*state
                                        .orderList
                                        .data!
                                        .ordersBySupplier![productIndex]
                                        .orderDate
                                        .toString()*/
                                        '-',
                                    AppStrings.quantityString: state
                                        .orderList
                                        .data!
                                        .ordersBySupplier![productIndex]
                                        .products!
                                        .length
                                        .toString(),
                                    AppStrings.totalAmountString: state.orderList.data?.orderData?.first.totalAmount?.toString() ?? 0,
                                    AppStrings.orderIdString: orderId,
                                    AppStrings.supplierIdString: state
                                        .orderList
                                        .data!
                                        .ordersBySupplier![productIndex]
                                        .id,
                                    AppStrings.driverNameString:
                                        driverController.text,
                                    AppStrings.driverNumberString:
                                        phoneNumberController.text,
                                    AppStrings.supplierOrderNumberString: state
                                            .orderList
                                            .data
                                            ?.ordersBySupplier?[productIndex]
                                            .supplierOrderNumber ??
                                        0
                                  })
                            : SizedBox();
                  },
                  buttonText: AppLocalizations.of(context)!.next,
                  bGColor: AppColors.mainColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget productListItem(
      {required int index,
      required BuildContext context,
      required String status}) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) {
        ProductDetailsBloc bloc = context.read<ProductDetailsBloc>();
        return Container(
          margin: EdgeInsets.all(AppConstants.padding_10),
          padding: EdgeInsets.symmetric(
              vertical: AppConstants.padding_5,
              horizontal: AppConstants.padding_5),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                  color: AppColors.shadowColor.withOpacity(0.15),
                  blurRadius: AppConstants.blur_10),
            ],
            borderRadius:
                BorderRadius.all(Radius.circular(AppConstants.radius_5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
         /* state.orderList.data!.ordersBySupplier![index].orderDeliveryDate != '' ?*/
              state
                  .orderList
                  .data!
                  .ordersBySupplier![productIndex]
                  .deliverStatus!
                  .statusName
                  .toString() !=
                  AppLocalizations.of(context)!
                      .pending_delivery ?
                  Checkbox(
                      value:
                          state.productListIndex.contains(index) ? true : false,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.radius_3),
                      ),
                      side: MaterialStateBorderSide.resolveWith(
                        (states) =>
                            BorderSide(width: 1.0, color: AppColors.greyColor),
                      ),
                      activeColor: AppColors.mainColor,
                      onChanged: (value) {
                        bloc.add(ProductDetailsEvent.productProblemEvent(
                            isProductProblem: value!, index: index));
                      })
                  : SizedBox(),
              state.orderList.data?.ordersBySupplier![productIndex]
                          .products![index].mainImage !=
                      null
                  ? Image.network(
                      '${AppUrls.baseFileUrl}${state.orderList.data?.ordersBySupplier?[productIndex].products?[index].mainImage ?? ''}',
                      width: AppConstants.containerSize_50,
                      height: AppConstants.containerSize_50,
                    )
                  : SizedBox(),
              Container(
                width: 55,
                child: Text(
                  state.orderList.data?.ordersBySupplier![productIndex]
                          .products![index].productName
                          .toString() ??
                      '',
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.font_14, color: AppColors.blackColor),
                ),
              ),
              10.width,
              Text(
                '${state.orderList.data?.ordersBySupplier?[productIndex].products?[index].itemWeight.toString() ?? ''}${' '}${state.orderList.data?.ordersBySupplier?[productIndex].products![index].scale.toString() ?? ''}',
                style: AppStyles.rkRegularTextStyle(
                  color: AppColors.blackColor,
                  size: AppConstants.font_12,
                ),
              ),
              5.width,
              Text(
                '${state.orderList.data?.ordersBySupplier?[productIndex].products?[index].totalPayment.toString() ?? ''}${AppLocalizations.of(context)!.currency}',
                style: AppStyles.rkRegularTextStyle(
                    color: AppColors.blackColor,
                    size: AppConstants.font_14,
                    fontWeight: FontWeight.w700),
              ),
/*        state.orderList.data!.ordersBySupplier![productIndex].orderDeliveryDate!= ''?*/
              state
                  .orderList
                  .data!
                  .ordersBySupplier![productIndex]
                  .deliverStatus!
                  .statusName
                  .toString() !=
                  AppLocalizations.of(context)!
                      .pending_delivery ?
                   GestureDetector(
                      onTap: () {
                        state.productListIndex.contains(index)
                            ? ProductProblemBottomSheet(
                                context: context,
                                productName: state
                                    .orderList
                                    .data!
                                    .ordersBySupplier![productIndex]
                                    .products![index]
                                    .productName
                                    .toString(),
                                weight: state
                                    .orderList
                                    .data!
                                    .ordersBySupplier![productIndex]
                                    .products![index]
                                    .itemWeight!,
                                price: state
                                    .orderList
                                    .data!
                                    .ordersBySupplier![productIndex]
                                    .products![index]
                                    .totalPayment!,
                                image:
                                    '${state.orderList.data!.ordersBySupplier![productIndex].products![index].mainImage ?? ''}',
                                listIndex: index,
                                productId: state
                                    .orderList
                                    .data!
                                    .ordersBySupplier![productIndex]
                                    .products![index]
                                    .productId!,
                                supplierId: state.orderList.data!
                                    .ordersBySupplier![productIndex].id!,
                              )
                            : SizedBox();
                      },
                      child: Container(
                        margin: EdgeInsets.all(AppConstants.padding_10),
                        padding: EdgeInsets.symmetric(
                            vertical: AppConstants.padding_5,
                            horizontal: AppConstants.padding_5),
                        decoration: BoxDecoration(
                          color: state.productListIndex.contains(index)
                              ? AppColors.mainColor
                              : AppColors.lightBorderColor,
                          border: Border.all(color: AppColors.lightGreyColor),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radius_3),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.product_issue,
                          style: AppStyles.rkRegularTextStyle(
                              color: state.productListIndex.contains(index)
                                  ? AppColors.whiteColor
                                  : AppColors.blackColor,
                              size: AppConstants.font_12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        );
      },
    );
  }

  ProductProblemBottomSheet(
      {required BuildContext context,
      required String productName,
      required int weight,
      required int price,
      required String image,
      required int listIndex,
      required String productId,
      required String supplierId}) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: true,
      clipBehavior: Clip.hardEdge,
      useSafeArea: true,
      enableDrag: true,
      builder: (context1) {
        return DraggableScrollableSheet(
          expand: true,
          maxChildSize: 1 -
              (MediaQuery.of(context).viewPadding.top /
                  getScreenHeight(context)),
          minChildSize: 0.4,
          initialChildSize: 0.7,
          //shouldCloseOnMinExtent: true,
          builder: (context, scrollController) {
            return BlocProvider(
              create: (context) => ProductDetailsBloc(),
              child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                builder: (context, state) {
                  return Container(
                    color: AppColors.whiteColor,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: AppConstants.padding_15,
                          horizontal: AppConstants.padding_15),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppConstants.padding_5,
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context1);
                                      },
                                      child: Icon(Icons.close)),
                                  10.width,
                                  Text(
                                    AppLocalizations.of(context)!.product_issue,
                                    style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.smallFont,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            15.height,
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: AppConstants.padding_5,
                                  horizontal: AppConstants.padding_10),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                      color: AppColors.shadowColor
                                          .withOpacity(0.15),
                                      blurRadius: AppConstants.blur_10),
                                ],
                                borderRadius: BorderRadius.all(
                                    Radius.circular(AppConstants.radius_5)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  image != ''
                                      ? Image.network(
                                          '${AppUrls.baseFileUrl}${image}',
                                          width: AppConstants.containerSize_50,
                                          height: AppConstants.containerSize_50,
                                        )
                                      : SizedBox(),
                                  //  5.width,
                                  Text(
                                    productName,
                                    style: AppStyles.rkRegularTextStyle(
                                      color: AppColors.blackColor,
                                      size: AppConstants.font_14,
                                    ),
                                  ),
                                  //10.width,
                                  Text(
                                    '${weight.toString()}${AppLocalizations.of(context)!.kg}',
                                    style: AppStyles.rkRegularTextStyle(
                                      color: AppColors.blackColor,
                                      size: AppConstants.font_12,
                                    ),
                                  ),
                                  //  10.width,
                                  Text(
                                    '${price.toString() + AppLocalizations.of(context)!.currency}',
                                    style: AppStyles.rkRegularTextStyle(
                                        color: AppColors.blackColor,
                                        size: AppConstants.font_14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            20.height,
                            Text(
                              AppLocalizations.of(context)!.problem_detected,
                              style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.smallFont,
                                color: AppColors.blackColor,
                              ),
                            ),
                            20.height,
                            RadioButtonWidget(
                                context: context,
                                problem: AppLocalizations.of(context)!
                                    .the_product_did_not_arrive_at_all,
                                value: 1,
                                listIndex: listIndex),
                            10.height,
                            RadioButtonWidget(
                                context: context,
                                problem: AppLocalizations.of(context)!
                                    .product_arrived_damaged,
                                value: 2,
                                listIndex: listIndex),
                            10.height,
                            RadioButtonWidget(
                                context: context,
                                problem: AppLocalizations.of(context)!
                                    .the_product_arrived_missing,
                                value: 3,
                                weight: weight,
                                listIndex: listIndex),
                            10.height,
                            RadioButtonWidget(
                                context: context,
                                problem: AppLocalizations.of(context)!
                                    .another_product_problem,
                                value: 4,
                                listIndex: listIndex),
                            10.height,
                            GestureDetector(
                              onTap: () async {
                                context.read<ProductDetailsBloc>().add(
                                    ProductDetailsEvent.createIssueEvent(
                                        context: context1,
                                        supplierId: supplierId,
                                        productId: productId,
                                        issue: state.selectedRadioTile == 1
                                            ? AppLocalizations.of(context)!
                                                .the_product_did_not_arrive_at_all
                                            : state.selectedRadioTile == 2
                                                ? AppLocalizations.of(context)!
                                                    .product_arrived_damaged
                                                : state.selectedRadioTile == 3
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .the_product_arrived_missing
                                                    : state.selectedRadioTile ==
                                                            4
                                                        ? '/*${AppLocalizations.of(context)!.another_product_problem} ${' : '}*/${addProblemController.text.toString()}'
                                                        : '',
                                        missingQuantity:
                                            state.selectedRadioTile == 3
                                                ? state.productWeight
                                                : 0,
                                        orderId: orderId));
                              },
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: AppConstants.padding_20,
                                      horizontal: AppConstants.padding_30),
                                  color: AppColors.pageColor,
                                  child: CustomButtonWidget(
                                    buttonText:
                                        AppLocalizations.of(context)!.save,
                                    bGColor: AppColors.mainColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget RadioButtonWidget(
      {required BuildContext context,
      required String problem,
      required int value,
      int weight = 0,
      required int listIndex}) {
    ProductDetailsBloc bloc = context.read<ProductDetailsBloc>();
    return BlocProvider.value(
      value: context.read<ProductDetailsBloc>(),
      child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
          if (state.productWeight == 0) {
            weight = weight;
          } else {
            weight = state.productWeight;
          }
          return Container(
            height: value == 4 ? 160 : 50,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                    color: AppColors.shadowColor.withOpacity(0.10),
                    blurRadius: AppConstants.blur_10),
              ],
              borderRadius:
                  BorderRadius.all(Radius.circular(AppConstants.radius_5)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: value,
                          fillColor: MaterialStateColor.resolveWith(
                            (states) => AppColors.greyColor,
                          ),
                          groupValue: state.selectedRadioTile,
                          onChanged: (val) {
                            bloc.add(ProductDetailsEvent.radioButtonEvent(
                                selectRadioTile: val!));
                          },
                        ),
                        Text(
                          problem,
                          style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.font_14,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              value == 3
                                  ? GestureDetector(
                                      onTap: () {
                                        if (state.selectedRadioTile == 3) {
                                          bloc.add(ProductDetailsEvent
                                              .productIncrementEvent(
                                                  productWeight: weight,
                                                  listIndex: listIndex,
                                                  context: context));
                                        }
                                      },
                                      child: Container(
                                        width: AppConstants.containerSize_25,
                                        height: AppConstants.containerSize_25,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            border: Border.all(
                                                color: AppColors.greyColor),
                                            color: AppColors.pageColor),
                                        child: Icon(
                                          Icons.add,
                                          size: 15,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              getScreenHeight(context) <= 750
                                  ? 5.width
                                  : 8.width,
                              value == 3
                                  ? Text(
                                      '${weight.toString() + AppLocalizations.of(context)!.kg}',
                                      style: AppStyles.rkRegularTextStyle(
                                        color: AppColors.blackColor,
                                        size: AppConstants.font_12,
                                      ),
                                    )
                                  : SizedBox(),
                              getScreenHeight(context) <= 750
                                  ? 5.width
                                  : 8.width,
                              value == 3
                                  ? GestureDetector(
                                      onTap: () {
                                        if (state.selectedRadioTile == 3) {
                                          bloc.add(ProductDetailsEvent
                                              .productDecrementEvent(
                                                  productWeight: weight,
                                                  listIndex: listIndex));
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            border: Border.all(
                                                color: AppColors.greyColor),
                                            color: AppColors.pageColor),
                                        child: Text('-',
                                            style: AppStyles.rkRegularTextStyle(
                                                size: AppConstants.mediumFont)),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                value == 4
                    ? CustomFormField(
                        fillColor: AppColors.pageColor,
                        validator: '',
                        controller: addProblemController,
                        keyboardType: state.selectedRadioTile == 4
                            ? TextInputType.text
                            : TextInputType.none,
                        hint: AppLocalizations.of(context)!.add_text,
                        maxLines: 5,
                        isBorderVisible: false,
                        textInputAction: TextInputAction.done,
                        contentPaddingTop: AppConstants.padding_8,
                      )
                    : SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }
}
