import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_stock/bloc/basket/basket_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';

class BasketRoute {
  static Widget get route => const BasketScreen();
}

class BasketScreen extends StatelessWidget {
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BasketBloc(),
      child: const BasketScreenWidget(),
    );
  }
}


class BasketScreenWidget extends StatelessWidget {
  const BasketScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<BasketBloc, BasketState>(
      listener: (context, state) {
      },
      child: BlocBuilder<BasketBloc, BasketState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.pageColor,
            body: SafeArea(
              child: Padding(
                padding:  EdgeInsets.symmetric(vertical: AppConstants.padding_5,),
                child: Column(
                  children: [
                   Container(
                     margin: EdgeInsets.all(AppConstants.padding_10),
                     decoration: BoxDecoration(
                       color: AppColors.whiteColor.withOpacity(0.95),
                       boxShadow: [
                         BoxShadow(
                             color: AppColors.shadowColor.withOpacity(0.20),
                             blurRadius: AppConstants.blur_10),
                       ],
                       borderRadius: BorderRadius.all(
                           Radius.circular(AppConstants.radius_40)),
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Container(
                           padding: EdgeInsets.symmetric(
                               vertical: AppConstants.padding_5,
                               horizontal: AppConstants.padding_5
                           ),
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(30),
                             color: AppColors.whiteColor,
                             border: Border.all(color: AppColors.borderColor)
                           ),
                           child: Row(
                             children: [
                               Container(
                                 width: getScreenWidth(context) * 0.35,
                                 height: 50,
                                 alignment: Alignment.center,
                                 padding: EdgeInsets.symmetric(
                                     vertical: AppConstants.padding_5,
                                     horizontal: AppConstants.padding_5),
                                 decoration: BoxDecoration(
                                     color: AppColors.mainColor,
                                     borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5),
                                         bottomRight: Radius.circular(25),topRight: Radius.circular(25)
                                     )
                                 ),
                                 child: Text('${'11.90₪ : ' + AppLocalizations.of(context)!.total  }',
                                   style: AppStyles.rkRegularTextStyle(
                                       size: AppConstants.normalFont,
                                       color: AppColors.whiteColor,
                                       fontWeight: FontWeight.w700),
                                 ),
                               ),
                               8.width,
                               GestureDetector(
                                 onTap: (){
                                   Navigator.pushNamed(
                                       context, RouteDefine.orderSummaryScreen.name);
                                 },
                                 child: Container(
                                   width: getScreenWidth(context) * 0.22,
                                   height: 50,
                                   alignment: Alignment.center,
                                   padding: EdgeInsets.symmetric(
                                       vertical: AppConstants.padding_5,
                                       horizontal: AppConstants.padding_5),
                                   decoration: BoxDecoration(
                                       color: AppColors.navSelectedColor,
                                       borderRadius: BorderRadius.only(topLeft: Radius.circular(25),bottomLeft: Radius.circular(25),
                                           bottomRight: Radius.circular(4),topRight: Radius.circular(4)
                                       )
                                   ),
                                   child: Text(AppLocalizations.of(context)!.submit,
                                     style: AppStyles.rkRegularTextStyle(
                                         size: AppConstants.normalFont,
                                         color: AppColors.whiteColor,
                                     ),
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         ),

                         SvgPicture.asset(
                           AppImagePath.delete,
                         ),
                         Text(
                           AppLocalizations.of(context)!.empty,
                           style: AppStyles.rkRegularTextStyle(
                               size: AppConstants.smallFont,
                               color: AppColors.greyColor,
                           ),
                         ),
                         5.width,

                       ],
                     ),
                   ),

              state.basketProductList.isNotEmpty
                  ? Expanded(
                    child: ListView.builder(
                itemCount: state.basketProductList.length,
                shrinkWrap: true,
               scrollDirection: Axis.vertical,
                padding: EdgeInsets.symmetric(
                      vertical: AppConstants.padding_5),
                itemBuilder: (context, index) =>
                      basketListItem(index: index, context: context),
              ),
                  )
                  : SizedBox(),
                  ],
                ),
              ),

            ),
          );
        },
      ),
    );
  }

  Widget basketListItem({required int index, required BuildContext context}) {
    return BlocBuilder<BasketBloc, BasketState>(
      builder: (context, state) {
       BasketBloc bloc = context.read<BasketBloc>();
        return Container(
          margin: EdgeInsets.symmetric(vertical: AppConstants.padding_5,horizontal: AppConstants.padding_10),
          padding: EdgeInsets.symmetric(
              vertical: AppConstants.padding_3,
              horizontal: AppConstants.padding_10),
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
              Image.asset(
                state.basketProductList[index].productImage!,
                width: 50,
                height: 50,
              ),
              Text(
                state.basketProductList[index].productName!,
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: AppConstants.font_14,
                ),
              ),
              10.width,
              GestureDetector(
                onTap: (){
                  bloc.add(BasketEvent.productIncrementEvent(listIndex: index,productWeight: state.basketProductList[index].productWeight!));
                },
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.navSelectedColor),
                      color: AppColors.pageColor
                  ),
                  child: Icon(Icons.add,size: 15,color: AppColors.blackColor,),
                ),
              ),

              Text(
                '${AppLocalizations.of(context)!.kg + state.basketProductList[index].productWeight!.toString()}',
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: AppConstants.font_14,
                    ),
              ),
              GestureDetector(
                onTap: (){
                  bloc.add(BasketEvent.productDecrementEvent(listIndex: index,productWeight: state.basketProductList[index].productWeight!));
                },
                child: Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: AppColors.navSelectedColor),
                      color: AppColors.pageColor
                  ),
                  child: Text('-',style: AppStyles.rkRegularTextStyle(size: AppConstants.mediumFont,
                  color: AppColors.blackColor
                  )),
                ),
              ),

              Text(
                '${state.basketProductList[index].productPrice!.toString() + '₪'}',
                style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: AppConstants.font_14,
                    fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: (){
                  bloc.add(BasketEvent.deleteListItemEvent(listIndex: index ,context: context));
                },
                child: SvgPicture.asset(
                  AppImagePath.delete,
                ),
              ),


            ],
          ),
        );
      },
    );
  }

}
