import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/product_details/product_details_bloc.dart';
import '../../data/model/res_model/get_order_by_id/get_order_by_id_model.dart';
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
          orderId: args?[AppStrings.orderIdString] ?? '',
          orderBySupplierProduct:
              args?[AppStrings.productDataString] ?? OrdersBySupplier(),
        )),
      child: ProductDetailsScreenWidget(
        productData: args?[AppStrings.productDataString] ?? OrdersBySupplier(),
        orderId: args?[AppStrings.orderIdString] ?? '',
        orderNumber: args?[AppStrings.orderNumberString] ?? '',
      ),
    );
  }
}

class ProductDetailsScreenWidget extends StatelessWidget {
  OrdersBySupplier productData;
  String orderId;
  String orderNumber;

  ProductDetailsScreenWidget({
    super.key,
    required this.productData,
    required this.orderId,
    required this.orderNumber,
  });

  TextEditingController addProblemController = TextEditingController();
  TextEditingController driverController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductDetailsBloc, ProductDetailsState>(
      listener: (context, state) {},
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
                    child: (state.orderBySupplierProduct) == 0
                        ? CupertinoActivityIndicator()
                        : CircularButtonWidget(
                            buttonName: AppLocalizations.of(context)!.total,
                            buttonValue:
                                '${formatter(state.orderBySupplierProduct.totalPayment?.toString() ?? "0")}${AppLocalizations.of(context)!.currency}',
                          ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: state.isShimmering
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
                                      state.orderBySupplierProduct.supplierName
                                              ?.toString() ??
                                          '',
                                      style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants.font_14,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                    Text(
                                      state.orderBySupplierProduct.deliverStatus
                                              ?.statusName!
                                              .toTitleCase()??
                                          '',
                                      style: AppStyles.rkRegularTextStyle(
                                          size: AppConstants.smallFont,
                                          color: /*( state
                                                      .orderBySupplierProduct
                                                      .deliverStatus?.statusName.toString() ?? '') ==
                                                  AppLocalizations.of(context)!
                                                      .pending_delivery?*/
                                              state.orderBySupplierProduct
                                                          .orderDeliveryDate ==
                                                      ''
                                                  ? AppColors.orangeColor
                                                  : AppColors.mainColor,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                                7.height,
                                Row(
                                  children: [
                                    CommonOrderContentWidget(
                                      flexValue: 2,
                                      title: AppLocalizations.of(context)!
                                          .products,
                                      value: state.orderBySupplierProduct
                                              .products?.length
                                              .toString() ??
                                          '',
                                      titleColor: AppColors.mainColor,
                                      valueColor: AppColors.blackColor,
                                      valueTextWeight: FontWeight.w700,
                                      valueTextSize: AppConstants.smallFont,
                                    ),
                                    5.width,
                                    CommonOrderContentWidget(
                                      flexValue: 3,
                                      title: AppLocalizations.of(context)!
                                          .delivery_date,
                                      value: (state.orderBySupplierProduct
                                                  .orderDeliveryDate) !=
                                              ''
                                          /* (state.orderBySupplierProduct.deliverStatus?.statusName
                                          .toString() ?? '') !=
                                          AppLocalizations.of(context)!
                                              .pending_delivery*/
                                          ? '${state.orderBySupplierProduct.orderDeliveryDate?.toString().replaceRange(10, 24, '')}'
                                          : '-',
                                      titleColor: AppColors.mainColor,
                                      valueColor: AppColors.blackColor,
                                      valueTextSize: AppConstants.smallFont,
                                      valueTextWeight: FontWeight.w500,
                                      // columnPadding: AppConstants.padding_5,
                                    ),
                                    5.width,
                                    CommonOrderContentWidget(
                                      flexValue: 3,
                                      title: AppLocalizations.of(context)!
                                          .total_order,
                                      value:
                                          '${formatter(state.orderBySupplierProduct.totalPayment?.toString() ?? '0')}${AppLocalizations.of(context)!.currency}',
                                      titleColor: AppColors.mainColor,
                                      valueColor: AppColors.blackColor,
                                      valueTextWeight: FontWeight.w500,
                                      valueTextSize: AppConstants.smallFont,
                                      // columnPadding: AppConstants.padding_5,
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
                                              '${' : '}${state.orderBySupplierProduct.supplierOrderNumber ?? '0'}',
                                          style: AppStyles.rkRegularTextStyle(
                                              color: AppColors.blackColor,
                                              size: AppConstants.font_14,
                                              fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                                7.height,
                                Text(
                                  '${AppLocalizations.of(context)!.driver_name}${' : '}',
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
                                    state.orderBySupplierProduct.deliverStatus
                                                ?.statusName
                                                .toString() !=
                                            AppLocalizations.of(context)!
                                                .pending_delivery
                                        /*state.orderList.data!.ordersBySupplier![productIndex].orderDeliveryDate != ''*/
                                        ? Text(
                                            state.orderBySupplierProduct
                                                    .driverName
                                                    ?.toString() ??
                                                '',
                                            style: AppStyles.rkRegularTextStyle(
                                                size: AppConstants.mediumFont,
                                                color: AppColors.blackColor,
                                                fontWeight: FontWeight.w600),
                                          )
                                        : Container(
                                            // width: 150,
                                            // height: 40,
                                            child: Expanded(
                                            flex: 4,
                                            child: CustomFormField(
                                              context: context,
                                              controller: driverController,
                                              inputformet: [
                                                LengthLimitingTextInputFormatter(
                                                    20)
                                              ],
                                              keyboardType: TextInputType.text,
                                              hint: '',
                                              validator:
                                                  AppStrings.driverNameString,
                                              fillColor: Colors.white,
                                            ),
                                          )),
                                    15.width,
                                    (state.orderBySupplierProduct.deliverStatus
                                                    ?.statusName
                                                    .toString() ??
                                                '') !=
                                            AppLocalizations.of(context)!
                                                .pending_delivery
                                        ?
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
                                                  state.orderBySupplierProduct
                                                          .driverNumber
                                                          ?.toString() ??
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
                                            // width: 150,
                                            // height: 35,
                                            child: Expanded(
                                              flex: 5,
                                              child: CustomFormField(
                                                context: context,
                                                inputformet: [
                                                  FilteringTextInputFormatter
                                                      .deny(RegExp(r'\s')),
                                                ],
                                                controller:
                                                    phoneNumberController,
                                                keyboardType:
                                                    TextInputType.number,
                                                hint:
                                                    AppStrings.hintNumberString,
                                                validator:
                                                    AppStrings.mobileValString,
                                                fillColor: Colors.white,
                                                border: 30,
                                              ),
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
                            child: ListView.builder(
                              itemCount: state.orderBySupplierProduct.products
                                      ?.length ??
                                  0,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  vertical: AppConstants.padding_5),
                              itemBuilder: (context, index) => productListItem(
                                index: index,
                                context: context,
                                status: state.orderBySupplierProduct
                                        .deliverStatus?.statusName
                                        .toString() ??
                                    '',
                                issue: state.orderBySupplierProduct
                                        .products?[index].issue ??
                                    '',
                                isIssue: state.orderBySupplierProduct
                                        .products?[index].isIssue ??
                                    false,
                                missingQuantity: state.orderBySupplierProduct
                                        .products?[index].missingQuantity ??
                                    0,
                                issueStatus: state
                                        .orderBySupplierProduct
                                        .products?[index]
                                        .issueStatus!
                                        .statusName ??
                                    '',
                              ),
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
                    state.orderBySupplierProduct.deliverStatus?.statusName
                                .toString() !=
                            AppLocalizations.of(context)!.pending_delivery
                        ?
                        /*state.orderList.data!.ordersBySupplier![productIndex].orderDeliveryDate != ''?*/
                        /*   Navigator.pushNamed(
                            context, RouteDefine.bottomNavScreen.name)*/
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            RouteDefine.orderScreen.name,
                            (Route route) =>
                                route.settings.name ==
                                RouteDefine.menuScreen.name)
                        : _formKey.currentState?.validate() ?? false
                            ? state.phoneNumber != phoneNumberController.text
                                ? Navigator.pushNamed(context,
                                    RouteDefine.shipmentVerificationScreen.name,
                                    arguments: {
                                        AppStrings.supplierNameString: state
                                                .orderBySupplierProduct
                                                .supplierName
                                                ?.toString() ??
                                            '',
                                        AppStrings.deliveryStatusString: state
                                                .orderBySupplierProduct
                                                .deliverStatus
                                                ?.statusName
                                                .toString() ??
                                            '',
                                        AppStrings.totalOrderString: state
                                                .orderBySupplierProduct
                                                .totalPayment
                                                ?.toStringAsFixed(2) ??
                                            '0',
                                        AppStrings
                                                .deliveryDateString: /*state
                                        .orderList
                                        .data!
                                        .ordersBySupplier![productIndex]
                                        .orderDate
                                        .toString()*/
                                            '-',
                                        AppStrings.quantityString: state
                                                .orderBySupplierProduct
                                                .products
                                                ?.length
                                                .toString() ??
                                            '',
                                        AppStrings.totalAmountString: state
                                                .orderBySupplierProduct
                                                .totalPayment
                                                ?.toStringAsFixed(2) ??
                                            0,
                                        AppStrings.orderIdString: orderId,
                                        AppStrings.supplierIdString:
                                            state.orderBySupplierProduct.id,
                                        AppStrings.driverNameString:
                                            driverController.text.toTitleCase(),
                                        AppStrings.driverNumberString:
                                            phoneNumberController.text,
                                        AppStrings.supplierOrderNumberString:
                                            state.orderBySupplierProduct
                                                    .supplierOrderNumber ??
                                                0
                                      })
                                : showSnackBar(
                                    context: context,
                                    title:
                                        'User Number & driver Number are same',
                                    bgColor: AppColors.redColor)
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
      required String status,
      String? issue,
      bool? isIssue,
      int? missingQuantity,
      String issueStatus = ''}) {
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
      builder: (context, state) {
        ProductDetailsBloc bloc = context.read<ProductDetailsBloc>();
        return Container(
          margin: EdgeInsets.all(AppConstants.padding_10),
          padding: EdgeInsets.symmetric(
              vertical: AppConstants.padding_5,
              horizontal:
                  getScreenHeight(context) >= 730 ? AppConstants.padding_3 : 0),
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
              /*state
                  .orderList
                  .data!
                  .ordersBySupplier![productIndex]
                  .deliverStatus!
                  .statusName
                  .toString() !=
                  AppLocalizations.of(context)!
                      .pending_delivery ?*/
              (state.orderBySupplierProduct.deliverStatus?.statusName
                              .toString() ??
                          '') !=
                      AppLocalizations.of(context)!.pending_delivery
                  ? Checkbox(
                      value: ((isIssue ?? false) ||
                              state.productListIndex.contains(index))
                          ? true
                          : false,
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
                  : 0.width,
              /* state.orderList.data?.ordersBySupplier![productIndex]
                          .products![index].mainImage !=*/
              state.orderBySupplierProduct.products?.first.mainImage != null
                  ? CachedNetworkImage(
                      imageUrl:
                          '${AppUrls.baseFileUrl}${state.orderBySupplierProduct.products?[index].mainImage ?? ''}',
                      width: AppConstants.containerSize_50,
                      height: AppConstants.containerSize_50,
                    )
                  : SizedBox(),
              getScreenHeight(context) >= 730 ? 7.width : 2.width,
              state.orderBySupplierProduct.orderDeliveryDate != '' ?  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    child: Text(
                      state.orderBySupplierProduct.products![index].productName
                          .toString(),
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.font_14, color: AppColors.blackColor,fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    '${(state.orderBySupplierProduct.products?[index].quantity.toString() ?? '')}',
                    style: AppStyles.rkRegularTextStyle(
                      color: AppColors.blackColor,
                      size: AppConstants.font_12,
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      '${formatter(state.orderBySupplierProduct.products?[index].totalPayment?.toString() ?? '0')}${AppLocalizations.of(context)!.currency}',
                      style: AppStyles.rkRegularTextStyle(
                          color: AppColors.blackColor,
                          size: AppConstants.font_14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ) : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    child: Text(
                      state.orderBySupplierProduct.products![index].productName
                          .toString(),
                      style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.font_14, color: AppColors.blackColor),
                    ),
                  ),
                  10.width,
                  Text(
                    '${(state.orderBySupplierProduct.products?[index].itemWeight.toString() ?? '')}${' '}${state.orderBySupplierProduct.products?[index].scale.toString() ?? ''}',
                    style: AppStyles.rkRegularTextStyle(
                      color: AppColors.blackColor,
                      size: AppConstants.font_12,
                    ),
                  ),
                  10.width,
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      '${formatter(state.orderBySupplierProduct.products?[index].totalPayment?.toStringAsFixed(2) ?? '0')}${AppLocalizations.of(context)!.currency}',
                      style: AppStyles.rkRegularTextStyle(
                          color: AppColors.blackColor,
                          size: AppConstants.font_14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),





/*        state.orderList.data!.ordersBySupplier![productIndex].orderDeliveryDate!= ''?*/
              /*        state
                  .orderList
                  .data!
                  .ordersBySupplier![productIndex]
                  .deliverStatus!
                  .statusName
                  .toString() !=
                  AppLocalizations.of(context)!
                      .pending_delivery ?*/
              state.orderBySupplierProduct.deliverStatus?.statusName
                          .toString() !=
                      AppLocalizations.of(context)!.pending_delivery
                  ? Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            (isIssue! || state.productListIndex.contains(index))
                                ? ProductProblemBottomSheet(
                                    radioValue: isIssue == true
                                        ? ((issue ?? '') ==
                                                AppLocalizations.of(context)!
                                                    .the_product_did_not_arrive_at_all)
                                            ? 1
                                            : ((issue ?? '') ==
                                                    AppLocalizations.of(
                                                            context)!
                                                        .product_arrived_damaged)
                                                ? 2
                                                : ((issue ?? '') ==
                                                        AppLocalizations.of(
                                                                context)!
                                                            .the_product_arrived_missing)
                                                    ? 3
                                                    : 4
                                        : 0,
                                    context: context,
                                    productName: state.orderBySupplierProduct
                                            .products?[index].productName
                                            .toString() ??
                                        '',
                                    weight: state.orderBySupplierProduct
                                        .products![index].itemWeight!
                                        .toDouble(),
                                    price: double.parse(state
                                        .orderBySupplierProduct
                                        .products![index]
                                        .totalPayment!
                                        .toStringAsFixed(2)),
                                    image:
                                        '${state.orderBySupplierProduct.products![index].mainImage ?? ''}',
                                    listIndex: index,
                                    productId: state.orderBySupplierProduct
                                            .products?.first.productId ??
                                        '',
                                    supplierId: state.orderBySupplierProduct.id
                                        .toString(),
                                    scale: (state.orderBySupplierProduct
                                            .products?[index].scale
                                            .toString() ??
                                        ''),
                                    isIssue: isIssue,
                                    issue: issue,
                                    missingQuantity: missingQuantity,
                              quantity : state.orderBySupplierProduct
                                  .products?[index].quantity ?? 0,
                                  )
                                : SizedBox();
                          },
                          child: Container(
                            margin: EdgeInsets.all(AppConstants.padding_10),
                            padding: EdgeInsets.symmetric(
                                vertical: AppConstants.padding_5,
                                horizontal: AppConstants.padding_5),
                            decoration: BoxDecoration(
                              color: (isIssue ?? false)
                                  ? AppColors.mainColor
                                  : state.productListIndex.contains(index)
                                      ? AppColors.mainColor
                                      : AppColors.lightBorderColor,
                              border:
                                  Border.all(color: AppColors.lightGreyColor),
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radius_3),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.product_issue,
                              style: AppStyles.rkRegularTextStyle(
                                  color: (isIssue ?? false) ||
                                          state.productListIndex.contains(index)
                                      ? AppColors.whiteColor
                                      : AppColors.blackColor,
                                  size: AppConstants.font_12,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        (isIssue ?? false)
                            ? Text('${issueStatus.toString()}')
                            : SizedBox(),
                      ],
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
      required double weight,
      required double price,
      required String image,
      required int listIndex,
      required String productId,
      required String supplierId,
      required String scale,
      bool? isIssue,
      String? issue,
      required int radioValue,
      int? missingQuantity, required int quantity}) {
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
                                      ? CachedNetworkImage(
                                          imageUrl:
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
                                    '${quantity.toString()}',
                                    style: AppStyles.rkRegularTextStyle(
                                      color: AppColors.blackColor,
                                      size: AppConstants.font_12,
                                    ),
                                  ),
                                  //  10.width,
                                  Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: Text(
                                      '${formatter(price.toString()) + AppLocalizations.of(context)!.currency}',
                                      style: AppStyles.rkRegularTextStyle(
                                          color: AppColors.blackColor,
                                          size: AppConstants.font_14,
                                          fontWeight: FontWeight.w700),
                                    ),
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
                              listIndex: listIndex,
                              scale: scale,
                              groupValue: radioValue,
                            ),
                            10.height,
                            RadioButtonWidget(
                              context: context,
                              problem: AppLocalizations.of(context)!
                                  .product_arrived_damaged,
                              value: 2,
                              listIndex: listIndex,
                              scale: scale,
                              groupValue: radioValue,
                            ),
                            10.height,
                            RadioButtonWidget(
                              context: context,
                              problem: AppLocalizations.of(context)!
                                  .the_product_arrived_missing,
                              value: 3,
                              listIndex: listIndex,
                              scale: scale,
                              groupValue: radioValue,
                              missingQuantity: missingQuantity,
                              totalQuantity :quantity,
                            ),
                            10.height,
                            RadioButtonWidget(
                              context: context,
                              problem: AppLocalizations.of(context)!
                                  .another_product_problem,
                              value: 4,
                              listIndex: listIndex,
                              scale: scale,
                              groupValue: radioValue,
                              note: issue,
                            ),
                            10.height,
                            GestureDetector(
                              onTap: () async {
                                if (radioValue != 0) {
                                  Navigator.pop(context1);
                                } else {
                                  context.read<ProductDetailsBloc>().add(
                                      ProductDetailsEvent.createIssueEvent(
                                          context: context1,
                                          supplierId: supplierId,
                                          productId: productId,
                                          issue: state.selectedRadioTile == 1
                                              ? AppLocalizations.of(context)!
                                                  .the_product_did_not_arrive_at_all
                                              : state.selectedRadioTile == 2
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .product_arrived_damaged
                                                  : state.selectedRadioTile == 3
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .the_product_arrived_missing
                                                      : state.selectedRadioTile ==
                                                              4
                                                          ? '${addProblemController.text.toString()}'
                                                          : '',
                                          missingQuantity:
                                              state.selectedRadioTile == 3
                                                  ? state.quantity
                                                  : 0,
                                          orderId: orderId));
                                }
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
                                    isLoading: state.isLoading,
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

  Widget RadioButtonWidget({
    required BuildContext context,
    required String problem,
    required int value,
    required int listIndex,
    required String scale,
    required int groupValue,
    int? missingQuantity,
    String? note,
    int? totalQuantity,
    int quantity = 0,

  }) {
    ProductDetailsBloc bloc = context.read<ProductDetailsBloc>();
    if (groupValue == 4) {
      addProblemController.text = note ?? '';
    }

    return BlocProvider.value(
      value: context.read<ProductDetailsBloc>(),
      child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
     quantity = state.quantity;
          return Container(
            height: value == 4 ? 160 : 60,
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
                          groupValue: (groupValue != 0)
                              ? groupValue
                              : state.selectedRadioTile,
                          onChanged: (val) {
                            bloc.add(ProductDetailsEvent.radioButtonEvent(
                                selectRadioTile: val!));
                          },
                        ),
                       value == 3 ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              problem,
                              style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.font_14,
                                color: AppColors.blackColor,
                              ),
                            ),
                            12.height,
                            Row(
                              children: [
                                value == 3
                                    ? GestureDetector(
                                  onTap: () {
                                    if (state.selectedRadioTile == 3) {
                                      bloc.add(ProductDetailsEvent
                                          .productIncrementEvent(
                                          productQuantity: totalQuantity!,
                                          listIndex: listIndex,
                                          context: context,
                                        messingQuantity: quantity
                                      ));
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
                                10.width,
                                value == 3
                                    ? Text(
                                  groupValue == 3
                                      ? '${missingQuantity.toString()}'
                                      : '${quantity.toString()}',
                                  style: AppStyles.rkRegularTextStyle(
                                    color: AppColors.blackColor,
                                    size: AppConstants.font_12,
                                  ),
                                )
                                    : SizedBox(),
                                10.width,
                                value == 3
                                    ? GestureDetector(
                                  onTap: () {
                                    if (state.selectedRadioTile == 3) {
                                      bloc.add(ProductDetailsEvent
                                          .productDecrementEvent(
                                          productQuantity: totalQuantity!,
                                          listIndex: listIndex,
                                      messingQuantity:quantity,
                                        context: context
                                      ));
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
                                    : 0.width,
                              ],
                            ),
                          ],
                        ) :    Text(
                         problem,
                         style: AppStyles.rkRegularTextStyle(
                           size: AppConstants.font_14,
                           color: AppColors.blackColor,
                         ),
                       ),
                      ],
                    ),

                    5.width,

                  ],
                ),
                (value == 4)
                    ? CustomFormField(
                  context: context,
                        fillColor: AppColors.pageColor,
                        validator: '',
                        controller: addProblemController,
                        keyboardType: state.selectedRadioTile == 4
                            ? TextInputType.text
                            : TextInputType.none,
                        hint: AppLocalizations.of(context)!.add_text,
                        maxLines: 5,
                        isEnabled: state.selectedRadioTile == 4 ? true : false,
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
