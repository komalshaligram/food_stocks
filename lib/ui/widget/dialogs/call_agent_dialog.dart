import 'package:flutter/material.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../../bloc/basket/basket_bloc.dart';
import '../../../data/services/basket_navigation_helper.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/constants/app_styles.dart';
import '../../../routes/app_routes.dart';
import '../../screens/basket/basket_total_widget.dart';

class CallAgentDialog extends StatelessWidget {
  final String language;
  final BasketState state;
  final BuildContext context1;
  final BasketBloc bloc;

  const CallAgentDialog({Key? key, required this.language, required this.state, required this.context1, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: language == 'en' ? TextDirection.ltr : TextDirection.rtl,
      child: AlertDialog(
          contentPadding: const EdgeInsets.all(AppConstants.padding_20),
          surfaceTintColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.radius_20)),
          content: Text(AppLocalizations.of(context)!.return_draft_not_sent,
              style: AppStyles.rkRegularTextStyle(color: AppColors.blackColor, size: AppConstants.smallFont)),
          actions: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
              InkWell(
                onTap: () async {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, RouteDefine.returnListScreen.name, arguments: {AppStrings.isbackString: 'Basket'});
                },
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.padding_8),
                  decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(AppConstants.radius_5)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(AppLocalizations.of(context)!.view_return,
                        style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor)),
                  ]),
                ),
              ),
              InkWell(
                onTap: () async {
                  Navigator.of(context).pop();
                  if (!context1.mounted) return;
                  await navigateFromBasketContinue(context: context1, state: state, formattedTotal: formattedBasketGrandTotal(state));
                },
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.padding_8),
                  decoration: BoxDecoration(gradient: AppColors.appMainGradientColor, borderRadius: BorderRadius.circular(AppConstants.radius_5)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(AppLocalizations.of(context)!.send_any_way,
                        style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.whiteColor)),
                  ]),
                ),
              ),
            ]),
          ]),
    );
  }
}
