import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/product_details/product_details_bloc.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_app_bar.dart';
import '../widget/common_order_content_widget.dart';
import '../widget/custom_button_widget.dart';


class ProductDetailsRoute {
  static Widget get route => ProductDetailsScreen();
}


class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => ProductDetailsBloc(),
  child: ProductDetailsScreenWidget(
    ),
);
  }
}

class ProductDetailsScreenWidget extends StatelessWidget {
  const ProductDetailsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
            trailingWidget:  Padding(
              padding:  EdgeInsets.symmetric(vertical: AppConstants.padding_10,
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
                  blurRadius: AppConstants.blur_10),
            ],
            borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_5)),
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
                        color:  AppColors.orangeColor ,
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
                    valueColor:AppColors.blackColor,
                    valueTextWeight: FontWeight.w500,
                    valueTextSize: AppConstants.smallFont,
                  ),
                ],
              ),
              7.height,
              Text( AppLocalizations.of(context)!.supplier_order_number,
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.font_14,
                    color:  AppColors.blackColor ,
                    fontWeight: FontWeight.w400),
              ),
              7.height,
              RichText(
                text: TextSpan(
                  text: AppLocalizations.of(context)!.driver_details ,
                  style: TextStyle(
                      color: AppColors.blackColor, fontSize: AppConstants.font_14,fontWeight: FontWeight.w400),
                  children: <TextSpan>[
                    TextSpan(text: ' : 1524812',
                        style: TextStyle(
                            color: AppColors.blackColor, fontSize: AppConstants.font_14,fontWeight: FontWeight.w700)
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('חיים משה',
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.mediumFont,
                        color:  AppColors.blackColor ,
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
                      child:
                      Text('054-5858996',
                        style: TextStyle(
                            color: AppColors.whiteColor, fontSize: AppConstants.font_14,fontWeight: FontWeight.w400),
                      )
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
                child: Text(AppLocalizations.of(context)!.list_of_products_on_order,
                  style: AppStyles.rkRegularTextStyle(
                      size: AppConstants.smallFont,
                      color:  AppColors.blackColor ,
                      fontWeight: FontWeight.w400),),
              ),
              state.productList.isNotEmpty ? ListView.builder(
                itemCount: state.productList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: AppConstants.padding_5),
                itemBuilder: (context, index) =>
                    productListItem(index: index, context: context),
              ) : SizedBox(),

            ],
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.symmetric(
              vertical: AppConstants.padding_20,
              horizontal: AppConstants.padding_30),
          color: AppColors.pageColor,
         child: CustomButtonWidget(
           buttonText: AppLocalizations.of(context)!.continued,
           bGColor: AppColors.mainColor,
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
        borderRadius: BorderRadius.all(Radius.circular(AppConstants.radius_5)),
      ),
      child: Row(
        children: [
          Checkbox(
              value: state.productList[index].isProductIssue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
              ),
              side: MaterialStateBorderSide.resolveWith(
                    (states) => BorderSide(width: 1.0, color: AppColors.greyColor),
              ),
              activeColor: AppColors.mainColor,
              onChanged: (value){
                bloc.add(ProductDetailsEvent.checkBoxEvent(isCheckBox: value! ,index: index));
              }
              ),
          Image.asset(
            state.productList[index].productImage!,
            width: 50,
            height: 50,
          ),
          10.width,
          Text(state.productList[index].productName!,
            style: TextStyle(
                color: AppColors.blackColor, fontSize: AppConstants.font_14,fontWeight: FontWeight.w400),
          ),
          30.width,
          Text('12 ק”ג',
            style: TextStyle(
                color: AppColors.blackColor, fontSize: AppConstants.font_14,fontWeight: FontWeight.w400),
          ),
          10.width,
          Text('20₪',
            style: TextStyle(
                color: AppColors.blackColor, fontSize: AppConstants.font_14,fontWeight: FontWeight.w700),
          ),
          10.width,
          GestureDetector(
            onTap: (){
              bloc.add(ProductDetailsEvent.productProblemEvent(isProductProblem: state.isProductProblem ,index: index));
            },
            child: Container(
              margin: EdgeInsets.all(AppConstants.padding_10),
              padding: EdgeInsets.symmetric(
                  vertical: AppConstants.padding_5,
                  horizontal: AppConstants.padding_5),
              decoration: BoxDecoration(
                color: state.isProductProblem ? AppColors.mainColor :AppColors.lightBorderColor,
                border: Border.all(color: AppColors.lightGreyColor),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(AppLocalizations.of(context)!.product_problem,
                style: TextStyle(
                    color: AppColors.blackColor, fontSize: AppConstants.font_12,fontWeight: FontWeight.w400),),
            ),
          ),


        ],
      ),
    );
  },
);
 }
}
