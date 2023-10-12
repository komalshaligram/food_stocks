import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/product_details/product_details_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_order_content_widget.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_form_field_widget.dart';

class ProductDetailsRoute {
  static Widget get route => ProductDetailsScreen();
}

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailsBloc(),
      child: ProductDetailsScreenWidget(),
    );
  }
}

class ProductDetailsScreenWidget extends StatelessWidget {
  ProductDetailsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
  /*  ProductDetailsBloc bloc = context.read<ProductDetailsBloc>();*/
    return BlocListener<ProductDetailsBloc, ProductDetailsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(AppConstants.appBarHeight),
                child: CommonAppBar(
                  title: '123456',
                  iconData: Icons.arrow_back_ios_sharp,
                  trailingWidget: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppConstants.padding_10,
                    ),
                    child: Container(
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
                            text: AppLocalizations.of(context)!.total,
                            style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: AppConstants.font_14,
                                fontWeight: FontWeight.w400),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' : 12,450₪',
                                  style: TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: AppConstants.font_14,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: SingleChildScrollView(
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
                              blurRadius: 1),
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
                                AppLocalizations.of(context)!.name_provider,
                                style: AppStyles.rkRegularTextStyle(
                                    size: AppConstants.font_14,
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                AppLocalizations.of(context)!.awaiting_shipment,
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
                                valueTextSize: AppConstants.mediumFont,
                              ),
                              5.width,
                              CommonOrderContentWidget(
                                flexValue: 2,
                                title:
                                    AppLocalizations.of(context)!.delivery_date,
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
                                title:
                                    AppLocalizations.of(context)!.total_order,
                                value: '18,360₪',
                                titleColor: AppColors.mainColor,
                                valueColor: AppColors.blackColor,
                                valueTextWeight: FontWeight.w500,
                                valueTextSize: AppConstants.smallFont,
                              ),
                            ],
                          ),
                          7.height,
                          Text(
                            AppLocalizations.of(context)!.supplier_order_number,
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.font_14,
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.w400),
                          ),
                          7.height,
                          RichText(
                            text: TextSpan(
                              text:
                                  AppLocalizations.of(context)!.driver_details,
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
                                          Radius.circular(
                                              AppConstants.radius_100)),
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
                                          fontWeight: FontWeight.w400),
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
                        AppLocalizations.of(context)!.list_of_products_on_order,
                        style: AppStyles.rkRegularTextStyle(
                            size: AppConstants.smallFont,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    state.productList.isNotEmpty
                        ? ListView.builder(
                            itemCount: state.productList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                vertical: AppConstants.padding_5),
                            itemBuilder: (context, index) =>
                                productListItem(index: index, context: context),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              bottomSheet: GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, RouteDefine.shipmentVerificationScreen.name),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: AppConstants.padding_20,
                      horizontal: AppConstants.padding_30),
                  color: AppColors.pageColor,
                  child: CustomButtonWidget(
                    buttonText: AppLocalizations.of(context)!.next,
                    bGColor: AppColors.mainColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget productListItem({required int index, required BuildContext context}) {
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
              Checkbox(
                  value: state.productList[index].isProductIssue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  side: MaterialStateBorderSide.resolveWith(
                    (states) =>
                        BorderSide(width: 1.0, color: AppColors.greyColor),
                  ),
                  activeColor: AppColors.mainColor,
                  onChanged: (value) {
                    bloc.add(ProductDetailsEvent.productProblemEvent(
                        isProductProblem: value!, index: index));
                  }),
              Image.asset(
                state.productList[index].productImage!,
                width: 50,
                height: 50,
              ),
              Text(
                state.productList[index].productName!,
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: AppConstants.font_14,
                    fontWeight: FontWeight.w400),
              ),
              10.width,
              Text(
                '${'ק”ג' + state.productList[index].productWeight!.toString()}',
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: AppConstants.font_14,
                    fontWeight: FontWeight.w400),
              ),
              Text(
                '${state.productList[index].productWeight!.toString() + '₪'}',
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: AppConstants.font_14,
                    fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () {
                  state.productList[index].isProductIssue
                      ? ProductProblemBottomSheet(
                      context,
                      state.productList[index].productName!,
                      state.productList[index].productWeight!,
                      state.productList[index].productPrice!,
                      state.productList[index].productImage!) : SizedBox();
                },
                child: Container(
                  margin: EdgeInsets.all(AppConstants.padding_10),
                  padding: EdgeInsets.symmetric(
                      vertical: AppConstants.padding_5,
                      horizontal: AppConstants.padding_5),
                  decoration: BoxDecoration(
                    color: state.productList[index].isProductIssue
                        ? AppColors.mainColor
                        : AppColors.lightBorderColor,
                    border: Border.all(color: AppColors.lightGreyColor),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.product_problem,
                    style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: AppConstants.font_12,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  ProductProblemBottomSheet(BuildContext context, String productName,
      int weight, int price, String image) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: AppColors.pageColor,
      context: context,
      builder: (context1) {
        return Padding(
          padding: EdgeInsets.symmetric(
              vertical: AppConstants.padding_15,
              horizontal: AppConstants.padding_15),
          child: Container(
            height: getScreenHeight(context) * 0.67,
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
                        AppLocalizations.of(context)!.product_problem,
                        style: AppStyles.rkRegularTextStyle(
                          size: AppConstants.mediumFont,
                          fontWeight: FontWeight.w400,
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
                          color: AppColors.shadowColor.withOpacity(0.15),
                          blurRadius: AppConstants.blur_10),
                    ],
                    borderRadius: BorderRadius.all(
                        Radius.circular(AppConstants.radius_5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        image,
                        width: 50,
                        height: 50,
                      ),
                      5.width,
                      Text(
                        productName,
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: AppConstants.font_14,
                            fontWeight: FontWeight.w400),
                      ),
                      10.width,
                      Text(
                        '${'ק”ג' + weight.toString()}',
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: AppConstants.font_14,
                            fontWeight: FontWeight.w400),
                      ),
                      10.width,
                      Text(
                        '${price.toString() + '₪'}',
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: AppConstants.font_14,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                15.height,
                Text(
                  AppLocalizations.of(context)!.problem_detected,
                  style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.mediumFont,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackColor,
                  ),
                ),
                10.height,
                RadioButtonWidget(context,context1,AppLocalizations.of(context)!.the_product_did_not_arrive_at_all,1,0),
                10.height,
                RadioButtonWidget(context,context1,AppLocalizations.of(context)!.product_arrived_damaged,2,0),
                10.height,
                RadioButtonWidget(context,context1,AppLocalizations.of(context)!.the_product_arrived_missing,3,weight),
                10.height,
                RadioButtonWidget(context,context1,AppLocalizations.of(context)!.another_product_problem,4,0),
                10.height,
                GestureDetector(
                  onTap: () async{
                    Navigator.pop(context1);
                  },
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: AppConstants.padding_20,
                          horizontal: AppConstants.padding_30),
                      color: AppColors.pageColor,
                      child: CustomButtonWidget(
                        buttonText: AppLocalizations.of(context)!.save,
                        bGColor: AppColors.mainColor,
                      ),
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


  Widget RadioButtonWidget(BuildContext context ,BuildContext context1, String problem, int value , int weight) {
    ProductDetailsBloc bloc = context.read<ProductDetailsBloc>();
    TextEditingController addProblemController = TextEditingController();
    return BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
    builder: (context, state) {
      return Container(
        height: value == 4 ? 150 : 50,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: AppConstants.padding_10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor.withOpacity(0.10),
                blurRadius: AppConstants.blur_10),
          ],
          borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_5)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio(
                  value: value,
                  fillColor: MaterialStateColor.resolveWith((states) => AppColors.greyColor),
                  groupValue: state.selectedRadioTile,
                  activeColor: AppColors.blueColor,
                  onChanged: (val) {
                    bloc.add(ProductDetailsEvent.radioButtonEvent(selectRadioTile: val!));
                    print(val);
                  },
                ),
                Text(
                  problem,
                  style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.mediumFont,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackColor,
                  ),
                ),
                15.width,
                Container(
                  child: Row(
                    children: [
                      weight != 0 ? GestureDetector(
                        onTap: (){

                        },
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              border: Border.all(color: AppColors.greyColor),
                              color: AppColors.pageColor
                          ),
                          child: Icon(Icons.add),
                        ),
                      ) : SizedBox(),
                      5.width,
                      weight != 0 ?  Text(
                        '${'ק”ג' + weight.toString()}',
                        style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: AppConstants.font_14,
                            fontWeight: FontWeight.w700),
                      ) : SizedBox(),
                      5.width,
                      weight != 0 ? GestureDetector(
                        onTap: (){

                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(color: AppColors.greyColor),
                              color: AppColors.pageColor
                          ),
                          child: Text('-',style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont)),
                        ),
                      ) : SizedBox(),
                    ],
                  ),
                ),

              ],
            ),
            value == 4 ? CustomFormField(
                 fillColor: AppColors.pageColor,
              validator: '',
              controller: addProblemController,
              keyboardType: TextInputType.none,
              hint: AppLocalizations.of(context)!.add_text,
              maxLines: 5,
              isBorderVisible: false,
            ) : SizedBox(),


          ],
        ),
      );
    },
);
  }
}
