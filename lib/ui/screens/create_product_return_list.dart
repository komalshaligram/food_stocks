import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/data/model/req_model/create_return_req_model/create_return_req_model.dart' as req;
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/widget/custom_button_widget.dart';
import 'package:food_stock/ui/widget/order_summary_screen_shimmer_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/create_return_bloc/create_return_bloc.dart';
import '../../data/model/res_model/get_return_by_id_res_model/get_return_by_id_res_model.dart';
import '../../routes/app_routes.dart';
import '../utils/app_utils.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_img_path.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_alert_dialog.dart';
import '../widget/common_app_bar.dart';

class CreateProductReturnListRoute {
  static Widget get route => const CreateProductReturnListScreen();
}

class CreateProductReturnListScreen extends StatelessWidget {
  const CreateProductReturnListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => CreateReturnBloc()..add(CreateReturnEvent.getReturnListEvent(product: args?? {}, context: context)),
      child: const CreateProductReturnListWidget(),
    );
  }
}

class CreateProductReturnListWidget extends StatelessWidget {
  const CreateProductReturnListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateReturnBloc, CreateReturnState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pageColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(AppConstants.appBarHeight),
            child: CommonAppBar(
              bgColor: AppColors.pageColor,
              title: AppLocalizations.of(context)!.product_return_list,
              iconData: Icons.arrow_back_ios_sharp,
              onTap: () {
                Navigator.pop(context);
              },
              trailingWidget: state.returnProductList.isNotEmpty?InkWell(
                onTap: () {
                 deleteProductDialog(context: context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(color: AppColors.redColor, borderRadius: BorderRadius.circular(5.0)),
                  child: Text(
                    AppLocalizations.of(context)!.delete,
                    style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor),
                  ),
                ),
              ):0.height,
            ),
          ),
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                state.isShimmer?
                    const Expanded(child: OrderSummaryScreenShimmerWidget(containerHeight: 100,)):
                state.returnProductList.isNotEmpty
                    ?
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: state.returnProductList.length,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
                        duration: const Duration(seconds: 1),
                        position: index,
                        child: SlideAnimation(
                          verticalOffset: 44.0,
                          child: FadeInAnimation(
                            child: returnListItem(index: index, context: context, list: state.returnProductList,returnId: state.returnId??''),
                          ),
                        ),
                      ),
                    ),
                  ),
                ): SizedBox(
                  height: getScreenHeight(context) * 0.5,
                  child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.no_data,
                        style: AppStyles.pVRegularTextStyle(
                            size: AppConstants.normalFont,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w400),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(AppConstants.padding_15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      state.returnId.isEmpty?CustomButtonWidget(
                        iconWidget: Icon(Icons.add,color: AppColors.whiteColor,),
                        buttonText: AppLocalizations.of(context)!.add_another_product,
                        isLoading: false,
                        onPressed: () {
                         context.read<CreateReturnBloc>().add(CreateReturnEvent.navigateToAddProductEvent(context: context));
                        },
                      ):0.width,
                      12.height,
                      state.returnProductList.isNotEmpty
                          ? CustomButtonWidget(
                        buttonText: state.returnId.isEmpty?
                        AppLocalizations.of(context)!.send_the_request
                            :AppLocalizations.of(context)!.save,
                      isLoading: state.isLoading,
                        onPressed: () {
                          if(state.returnId.isEmpty){
                            context.read<CreateReturnBloc>().add(CreateReturnEvent.createReturnEvent(context: context));
                          }else {
                            context.read<CreateReturnBloc>().add(CreateReturnEvent.updateReturnEvent(context: context));
                          }
                    //      bloc.add(ManageCreditCardEvent.deleteCreditCardEvent(context: context));
                        },
                      ):0.height,
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void deleteProductDialog({
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      builder: (context1) => BlocProvider.value(
        value: context.read<CreateReturnBloc>(),
        child: BlocBuilder<CreateReturnBloc, CreateReturnState>(
          builder: (context, state) {
            CreateReturnBloc bloc = context.read<CreateReturnBloc>();
            return CommonAlertDialog(
              directionality: state.language,
              title: AppLocalizations.of(context)!.delete,
              subTitle: AppLocalizations.of(context)!.are_you_sure,
              positiveTitle: AppLocalizations.of(context)!.yes,
              negativeTitle: AppLocalizations.of(context)!.no,
              negativeOnTap: () {
                Navigator.pop(context1);
              },
              positiveOnTap: () async {
                bloc.add(CreateReturnEvent.deleteEvent(
                  context: context,
                ));
                Navigator.pop(context1);
              },
            );
          },
        ),
      ),
    );
  }


  Widget returnListItem({required int index, required BuildContext context, required List<ReturnProduct> list,String? returnId}) {
    return GestureDetector(
      onTap: () {
        context.read<CreateReturnBloc>().add(CreateReturnEvent.detailReturnEvent(context: context,index: index));
      },
      child: Container(
        margin: const EdgeInsets.all(AppConstants.padding_10),
        padding: const EdgeInsets.symmetric(vertical: AppConstants.padding_15, horizontal: AppConstants.padding_10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(color: AppColors.shadowColor.withOpacity(0.15), blurRadius: AppConstants.blur_10),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(AppConstants.radius_5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            list[index].productImg!.isNotEmpty
                ? Image.network(
              list[index].productImg??'',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: SizedBox(
                      width: AppConstants.containerHeight_80,
                      height: AppConstants.containerHeight_80,
                      child: CupertinoActivityIndicator(
                        color: AppColors.blackColor,
                      ),
                    ),
                  );
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(width: 100, height: 100, color: AppColors.whiteColor, alignment: Alignment.center, child: Image.asset(AppImagePath.imageNotAvailable5));
              },
            )
                : Image.asset(
              AppImagePath.imageNotAvailable5,
              fit: BoxFit.cover,
              width: AppConstants.containerHeight_80,
              height: AppConstants.containerHeight_80,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(list[index].productName??'',style: AppStyles.rkBoldTextStyle(size: AppConstants.smallFont),maxLines: 2,overflow: TextOverflow.ellipsis,),
                  3.height,
                  Text('${list[index].totalUnits.toString()??''} Units',style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14),),
                  3.height,
                  Text(list[index].reasonToReturn.toString(),style: AppStyles.rkRegularTextStyle(size: AppConstants.font_14),maxLines: 2,overflow: TextOverflow.ellipsis,),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
