import '../../../bloc/basket_summary/basket_summary_bloc.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../../routes/app_routes.dart';

class BasketSummaryCallAgentDialog extends StatelessWidget {
  final String language;
  final String id;
  final int index;
  final BasketSummaryBloc bloc;

  const BasketSummaryCallAgentDialog(
      {Key? key,
      required this.language,
      required this.id,
      required this.index,
      required this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: language == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: AlertDialog(
          contentPadding: const EdgeInsets.all(AppConstants.padding_20),
          surfaceTintColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radius_20)),
          content: Text(
            AppLocalizations.of(context)!.return_draft_not_sent,
            style: AppStyles.rkRegularTextStyle(
                color: AppColors.blackColor, size: AppConstants.smallFont),
          ),
          actions: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(
                          context, RouteDefine.returnListScreen.name,
                          arguments: {AppStrings.isbackString: 'orderSummary'});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppConstants.padding_8),
                      decoration: BoxDecoration(
                          gradient: AppColors.appMainGradientColor,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radius_5)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(AppLocalizations.of(context)!.view_return,
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.smallFont,
                                color: AppColors.whiteColor)),
                      ]),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.of(context).pop();
                      bloc.add(BasketSummaryEvent.getSupplierPaymentTypeEvent(
                          context: context, id: id, index: index));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppConstants.padding_8),
                      decoration: BoxDecoration(
                          gradient: AppColors.appMainGradientColor,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radius_5)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(AppLocalizations.of(context)!.send_any_way,
                            style: AppStyles.rkRegularTextStyle(
                                size: AppConstants.smallFont,
                                color: AppColors.whiteColor)),
                      ]),
                    ),
                  ),
                ]),
          ]),
    );
  }
}
