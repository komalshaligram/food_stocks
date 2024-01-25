
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
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/circular_button_widget.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_order_content_widget.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_form_field_widget.dart';
import '../widget/product_details_screen-shimmer_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


class ProductDetailsRoute {
  static Widget get route => ProductDetailsScreen();
}

class ProductDetailsScreen extends StatelessWidget {
  String orderId;

  String orderNumber;

  bool isNavigateToProductDetailString;


  var productData;
  var orderData;

   ProductDetailsScreen({super.key, this.orderId = '', this.orderNumber = '', this.isNavigateToProductDetailString = false,
   this.productData =const  OrdersBySupplier(),
     this.orderData = const OrderDatum()
   });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailsBloc()
        ..add( isNavigateToProductDetailString ?  ProductDetailsEvent.getOrderByIdEvent(
            context: context,
          orderId: orderId
        ):
        ProductDetailsEvent.getProductDataEvent(
          context: context,
          orderId: orderId,
          orderData: orderData,
          orderBySupplierProduct: productData,
        ) ) ,
      child: ProductDetailsScreenWidget(
        orderId: orderId,
        orderNumber: orderNumber,
      ),
    );
  }
}

class ProductDetailsScreenWidget extends StatefulWidget {
  String orderId;
  String orderNumber;

  ProductDetailsScreenWidget({
    super.key,
    required this.orderId,
    required this.orderNumber,
  });

  @override
  State<ProductDetailsScreenWidget> createState() => _ProductDetailsScreenWidgetState();
}

class _ProductDetailsScreenWidgetState extends State<ProductDetailsScreenWidget> {
  TextEditingController addProblemController = TextEditingController();
  int onTheWayStatus = 6;

  @override
  Widget build(BuildContext context) {
    ProductDetailsBloc bloc =context.read<ProductDetailsBloc>();

    return BlocListener<ProductDetailsBloc, ProductDetailsState>(
      listener: (context, state) {

      },
      child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(AppConstants.appBarHeight),
              child: CommonAppBar(
                bgColor: AppColors.pageColor,
                title: widget.orderNumber.toString(),
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
                         '${formatNumber(value: state.orderBySupplierProduct.totalPayment?.toStringAsFixed(2) ?? '0',local: AppStrings.hebrewLocal)}',
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: state.isShimmering
                ? ProductDetailsScreenShimmerWidget()
                : SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
                  child: SafeArea(
                    child: AnimationLimiter(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(seconds: 1),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: MediaQuery.of(context).size.width / 2,
                        child: FadeInAnimation(child: widget)
                      ), children: [
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
                                        state.orderData
                                            .orderstatus?.statusName?.toTitleCase() ??
                                            '',
                                        style: AppStyles.rkRegularTextStyle(
                                            size: AppConstants.smallFont,
                                            color:
                                            state.orderData
                                                .orderstatus?.orderStatusNumber == onTheWayStatus ||   state.orderData
                                                .orderstatus?.orderStatusNumber == 5
                                            ? AppColors.graphColor
                                                : AppColors.orangeColor,
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
                                        backGroundColor: AppColors.iconBGColor,
                                        borderCoder: AppColors.lightBorderColor,
                                        flexValue: 3,
                                        title: AppLocalizations.of(context)!
                                            .delivery_date,
                                        value: (state.orderBySupplierProduct
                                            .orderDeliveryDate) !=
                                            ''
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
                                        backGroundColor: AppColors.iconBGColor,
                                        borderCoder: AppColors.lightBorderColor,
                                        flexValue: 3,
                                        title: AppLocalizations.of(context)!
                                            .total_order,
                                        value:
                                        '${formatNumber(value: state.orderBySupplierProduct.totalPayment?.toStringAsFixed(2) ?? '0',local: AppStrings.hebrewLocal)}',
                                        titleColor: AppColors.mainColor,
                                        valueColor: AppColors.blackColor,
                                        valueTextWeight: FontWeight.w500,
                                        valueTextSize: AppConstants.smallFont,
                                        // columnPadding: AppConstants.padding_5,
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
                                            '${' : '}${state.orderBySupplierProduct.supplierOrderNumber ?? '0'}',
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.order_products_list,
                                    style: AppStyles.rkRegularTextStyle(
                                      size: AppConstants.smallFont,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                  state.orderData
                                      .orderstatus?.orderStatusNumber == onTheWayStatus? GestureDetector(
                                    onTap: (){
                                      bloc.add(ProductDetailsEvent.checkAllEvent());
                                    },
                                    child: Container(
                                        padding: EdgeInsets.all(AppConstants.padding_5),
                                        decoration: BoxDecoration(
                                            borderRadius:  BorderRadius.all(Radius.circular(AppConstants.padding_3)),
                                            color: state.isAllCheck ? AppColors.mainColor : AppColors.lightBorderColor,
                                            border: Border.all(color: AppColors.lightGreyColor)
                                        ),
                                        child: Text(AppLocalizations.of(context)!.check_all,
                                          style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14,
                                              color: state.isAllCheck ? AppColors.whiteColor : AppColors.blackColor
                                          ),
                                        )),
                                  ) : SizedBox()
                                  //: 0.width
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 85),
                              child: ListView.builder(
                                itemCount: state.orderBySupplierProduct.products
                                    ?.length ??
                                    0,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                    vertical: AppConstants.padding_5),
                                itemBuilder: (context, index) => productListItem(
                                  index: index,
                                  context: context,
                                  statusNumber: state.orderData.orderstatus?.orderStatusNumber??0,
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
                                      .statusName.toString().toTitleCase() ??
                                      '',

                                ),
                              ),
                            ),
                      
                          ],
                          )
                      ),
                    ),
                  ),
                ),

            bottomSheet: state.orderData
          .orderstatus?.orderStatusNumber == onTheWayStatus ?Container(
              padding: EdgeInsets.symmetric(
                  vertical: AppConstants.padding_20,  
                  horizontal: AppConstants.padding_30),
              color: AppColors.pageColor,
              child: CustomButtonWidget(
                onPressed: () {
                  state.orderBySupplierProduct.deliverStatus?.statusName?.toTitleCase()
                      !=
                      AppLocalizations.of(context)!.pending_delivery ?
                  Navigator.pushNamedAndRemoveUntil(
                      context,
                      RouteDefine.orderScreen.name,
                          (Route route) =>
                      route.settings.name ==
                          RouteDefine.menuScreen.name)
                      :
                  Navigator.pushNamed(context,
                      RouteDefine.shipmentVerificationScreen.name,
                      arguments: {
                        AppStrings.supplierNameString: state
                            .orderBySupplierProduct
                            .supplierName
                            ?.toString() ??
                            '',
                        AppStrings.deliveryStatusString: state
                            .orderData.orderstatus?.statusName
                            .toString().toTitleCase() ??
                            '',
                        AppStrings.totalOrderString: state
                            .orderBySupplierProduct
                            .totalPayment
                            ?.toStringAsFixed(2) ??
                            '0',
                        AppStrings
                            .deliveryDateString:
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
                        AppStrings.orderIdString: widget.orderId,
                        AppStrings.supplierIdString:
                        state.orderBySupplierProduct.id,

                        AppStrings.supplierOrderNumberString:
                        state.orderBySupplierProduct
                            .supplierOrderNumber ??
                            0,
                        AppStrings.orderStatusNo:
                        state.orderData
                            .orderstatus?.orderStatusNumber ??
                            2,
                      });

                },
                buttonText: AppLocalizations.of(context)!.next,
                bGColor: AppColors.mainColor,
              ),
            ) : 0.width,
          );
        },
      ),
    );
  }

  Widget productListItem(
      {required int index,
      required BuildContext context,
      required int statusNumber,
      String? issue,
      bool? isIssue,
      int? missingQuantity,
      String issueStatus = '',

      }) {
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
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(

              mainAxisAlignment: statusNumber ==  onTheWayStatus ?  MainAxisAlignment.spaceBetween: MainAxisAlignment.start ,
              children: [
                statusNumber ==  onTheWayStatus ? Checkbox(
                        value:((isIssue ?? false) ||
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
                        }) : SizedBox(),
                   // : 0.width,

                state.orderBySupplierProduct.products?[index].mainImage != ''
                    ? Expanded(
                    flex: 2,
                      child:
                      Image.network(
                        '${AppUrls.baseFileUrl}${state.orderBySupplierProduct.products?[index].mainImage ?? ''}',
                        width: statusNumber ==  onTheWayStatus? AppConstants.containerSize_50 : 60,
                        height: statusNumber ==  onTheWayStatus ? AppConstants.containerSize_50 : 60,
                        fit: BoxFit.fill,
                        loadingBuilder:
                            (context,
                            child,
                            loadingProgress) {
                          if (loadingProgress ==
                              null) {
                            return child;
                          } else {
                            return Center(
                              child: Container(
                                width: statusNumber ==  onTheWayStatus ? AppConstants.containerSize_50 : 60,
                                height:statusNumber ==  onTheWayStatus ? AppConstants.containerSize_50 : 60,
                                child: CupertinoActivityIndicator(
                                  color: AppColors
                                      .blackColor,
                                ),
                              ),
                            );
                          }
                        },
                        errorBuilder:
                            (context,
                            error,
                            stackTrace) {
                          return Container(
                            width: AppConstants.containerSize_50,
                            height: AppConstants.containerSize_50,
                            color: AppColors
                                .whiteColor,
                            alignment:
                            Alignment
                                .center,
                            child: Image.asset(AppImagePath.imageNotAvailable5)
                            /*Text(
                              AppStrings
                                  .failedToLoadString,
                              style: AppStyles.rkRegularTextStyle(
                                  size: AppConstants
                                      .font_14,
                                  color:
                                  AppColors.textColor),
                            ),*/
                          );
                        },
                      ),
                    )
                    : Image.asset(
                  AppImagePath.imageNotAvailable5,
                  fit: BoxFit.cover,
                  width: statusNumber ==  onTheWayStatus ? AppConstants.containerSize_50 : 60,
                  height:statusNumber ==  onTheWayStatus ? AppConstants.containerSize_50 : 60,

                ),
                15.width,
                 Column(
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
                      '${(state.orderBySupplierProduct.products?[index].quantity.toString() ?? '')}${' '}${state.orderBySupplierProduct.products?[index].scale.toString()}',
                      style: AppStyles.rkRegularTextStyle(
                        color: AppColors.blackColor,
                        size: AppConstants.font_12,
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        '${formatNumber(value: state.orderBySupplierProduct.products?[index].totalPayment?.toStringAsFixed(2) ?? '0',local: AppStrings.hebrewLocal)}',
                        style: AppStyles.rkRegularTextStyle(
                            color: AppColors.blackColor,
                            size: AppConstants.font_14,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),

                Expanded(child: SizedBox()),
                statusNumber ==  onTheWayStatus ||  statusNumber ==  5 ?   Column(
                        children: [
                          statusNumber !=  5 ? GestureDetector(
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
                                              .products?[index].productId ??
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
                                isDeliver: (state.orderBySupplierProduct
                                    .orderDeliveryDate  != '') ? true : false)
                                  : SizedBox();
                              bloc.add(ProductDetailsEvent.radioButtonEvent(selectRadioTile: isIssue == true
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
                                  : 0));
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
                          ) : SizedBox(),
                          (isIssue ?? false)
                              ? Text('${issueStatus.toString()}',
                          style: AppStyles.rkRegularTextStyle(
                              color: AppColors.blackColor,
                              size: AppConstants.font_14,
                              fontWeight: FontWeight.w400),
                          )
                              : SizedBox(),
                        ],
                      ) : SizedBox(),
                10.width,
                   // : SizedBox(),
              ],
            ),
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
      int? missingQuantity, required int quantity,
        required bool isDeliver,
      }) {
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
          initialChildSize: AppConstants.bottomSheetInitHeight,
          shouldCloseOnMinExtent: true,
          builder: (context, scrollController) {
            return BlocProvider(
              create: (context) => ProductDetailsBloc()
                ..add(ProductDetailsEvent.radioButtonEvent(
                    selectRadioTile: radioValue))
                ..add(ProductDetailsEvent.getBottomSheetDataEvent(
                    note: radioValue == 4 ? issue ?? '' : '')),
              child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
                builder: (context, state) {
                  return Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(AppConstants.radius_30),topRight: Radius.circular(AppConstants.radius_30))
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: AppConstants.padding_15,
                                horizontal: AppConstants.padding_15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                0.width,
                                Text(
                                  AppLocalizations.of(context)!.product_issue,
                                  style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.smallFont,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context1);
                                    },
                                    child: Icon(Icons.close)),
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
                                image != '' ?
                            Image.network(
                              '${AppUrls.baseFileUrl}${image}',
                              width: AppConstants.containerSize_50,
                              height: AppConstants.containerSize_50,
                              fit: BoxFit.fill,
                              loadingBuilder:
                                  (context,
                                  child,
                                  loadingProgress) {
                                if (loadingProgress ==
                                    null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: Container(
                                      width: AppConstants.containerSize_50,
                                      height: AppConstants.containerSize_50,
                                      child: CupertinoActivityIndicator(
                                        color: AppColors
                                            .blackColor,
                                      ),
                                    ),
                                  );
                                }
                              },
                              errorBuilder:
                                  (context,
                                  error,
                                  stackTrace) {
                                return Container(
                                  width: AppConstants.containerSize_50,
                                  height: AppConstants.containerSize_50,
                                  color: AppColors
                                      .whiteColor,
                                  alignment:
                                  Alignment
                                      .center,
                                  child: Image.asset(AppImagePath.imageNotAvailable5)
                                  /*Text(
                                    AppStrings.failedToLoadString,
                                    style: AppStyles.rkRegularTextStyle(
                                        size: AppConstants
                                            .font_14,
                                        color:
                                        AppColors.textColor),
                                  ),*/
                                );
                              },
                            )
                                    : Image.asset(
                            AppImagePath.imageNotAvailable5,
                            fit: BoxFit.cover,
                                  width: AppConstants.containerSize_50,
                                  height: AppConstants.containerSize_50,

                          ),
                                //  5.width,
                                Container(
                                  width: 100,
                                  child: Text(
                                    productName,
                                    style: AppStyles.rkRegularTextStyle(
                                      color: AppColors.blackColor,
                                      size: AppConstants.font_14,
                                    ),
                                  ),
                                ),
                                //10.width,
                                Text(
                                  '${quantity.toString()}${' '}${scale}',
                                  style: AppStyles.rkRegularTextStyle(
                                    color: AppColors.blackColor,
                                    size: AppConstants.font_12,
                                  ),
                                ),
                                //  10.width,
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Text(
                                    '${formatNumber(value: price.toStringAsFixed(2),local: AppStrings.hebrewLocal)}',
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
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              AppLocalizations.of(context)!.problem_detected,
                              style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.smallFont,
                                color: AppColors.blackColor,
                              ),
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
                            bottomSheetContext: context1
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
                              bottomSheetContext: context1
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
                              bottomSheetContext: context1
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
                              bottomSheetContext: context1
                          ),
                          10.height,
                          GestureDetector(
                            onTap: () async {
                                context.read<ProductDetailsBloc>().add(
                                    ProductDetailsEvent.createIssueEvent(
                                        context: context,
                                        BottomSheetContext: context1,
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
                                                        ? '${state.addNoteController.text.toString()}'
                                                        : '',
                                        missingQuantity: state.selectedRadioTile == 3
                                                ? state.quantity
                                                : 0,
                                        orderId: widget.orderId,
                                    isDeliver:isDeliver));
                            },
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: AppConstants.padding_20,
                                    horizontal: AppConstants.padding_30),
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
    required BuildContext bottomSheetContext,
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
    if (groupValue == 4 && note != '') {
      addProblemController.text = note ?? '';
    }

    return BlocProvider.value(
      value: context.read<ProductDetailsBloc>(),
      child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
     quantity = (state.quantity == 0 ? missingQuantity : state.quantity) ?? 0;
          return Container(
            height: value == 4 ? 165: 60,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: AppConstants.padding_10,vertical: value == 3 ? AppConstants.padding_3 : 0),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                          value: value,
                          fillColor: MaterialStateColor.resolveWith(
                            (states) => AppColors.greyColor,
                          ),
                          groupValue:/* (groupValue != 0)
                              ? groupValue*/
                               state.selectedRadioTile,
                          onChanged: (val) {
                                // addProblemController.text = '';
                                 addProblemController.clear();
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
                            8.height,
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
                                          context: bottomSheetContext,
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
                                  state.selectedRadioTile == 3 && state.quantity == 0
                                      ? '${quantity.toString()}${' '}${scale}'
                                      : '${state.quantity}${' '}${scale}',
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
                                    child: Icon(
                                      Icons.remove,
                                      size: 15,
                                    ),
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
                  inputformet: [
                    LengthLimitingTextInputFormatter(150)
                  ],
                        controller: state.addNoteController,
                        keyboardType: state.selectedRadioTile == 4
                            ? TextInputType.text
                            : TextInputType.none,
                        hint: AppLocalizations.of(context)!.add_text,
                        maxLines: 4,
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
