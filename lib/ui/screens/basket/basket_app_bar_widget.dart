import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_styles.dart';
import '../../widget/custom_dialog.dart';
import '../../widget/sized_box_widget.dart';
import '../../../bloc/basket/basket_bloc.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_constants.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/constants/app_img_path.dart';

Widget appBarWidget(BuildContext context, BasketState state) => state
        .basketProductList.isNotEmpty
    ? Container(
        margin: const EdgeInsets.all(AppConstants.padding_10),
        padding: const EdgeInsets.all(AppConstants.padding_10),
        decoration: BoxDecoration(
          color: AppColors.whiteColor.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(
                color: AppColors.shadowColor.withValues(alpha: 0.20),
                blurRadius: AppConstants.blur_10)
          ],
          borderRadius:
              const BorderRadius.all(Radius.circular(AppConstants.radius_40)),
        ),
        child: Row(children: [
          Expanded(
            child: InkWell(
              onTap: () {
                deleteDialog(
                    context: context,
                    updateClearString: AppStrings.clearString,
                    listIndex: 0,
                    cartProductId: '',
                    totalAmount: 0.0);
              },
              child: Row(children: [
                SvgPicture.asset(AppImagePath.delete,
                    colorFilter:
                        ColorFilter.mode(AppColors.redColor, BlendMode.srcIn)),
                5.width,
                Text(AppLocalizations.of(context)!.empty,
                    style: AppStyles.rkRegularTextStyle(
                        size: AppConstants.font_14, color: AppColors.redColor)),
              ]),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.my_basket,
                textAlign: TextAlign.center,
                style: AppStyles.rkRegularTextStyle(
                    size: AppConstants.mediumFont,
                    color: AppColors.greyColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
        ]))
    : const SizedBox();

void deleteDialog(
    {required BuildContext context,
    required String updateClearString,
    required String cartProductId,
    required int listIndex,
    double? totalAmount}) {
  BasketBloc bloc = context.read<BasketBloc>();
  showDialog(
      context: context,
      builder: (context1) => BlocProvider.value(
            value: context.read<BasketBloc>(),
            child:
                BlocBuilder<BasketBloc, BasketState>(builder: (context, state) {
              return AbsorbPointer(
                  absorbing: state.isRemoveProcess ? true : false,
                  child: CustomDialog(
                      title: updateClearString == AppStrings.clearString
                          ? AppLocalizations.of(context)!.you_want_clear_cart
                          : AppLocalizations.of(context)!
                              .you_want_delete_product,
                      content: const [],
                      isMixedSale: false,
                      directionality: state.language,
                      positiveTitle: AppLocalizations.of(context)!.yes,
                      isProcessing: state.isRemoveProcess,
                      negativeTitle: AppLocalizations.of(context)!.no,
                      positiveOnTap: () {
                        updateClearString == AppStrings.clearString
                            ? bloc.add(
                                BasketEvent.clearCartEvent(context: context1))
                            : bloc.add(BasketEvent.removeCartProductEvent(
                                isFromDelete: false,
                                context: context,
                                cartProductId: cartProductId,
                                listIndex: listIndex,
                                dialogContext: context1,
                                totalAmount: totalAmount!,
                              ));
                      },
                      negativeOnTap: () {
                        Navigator.pop(context1);
                      }));
            }),
          ));
}
