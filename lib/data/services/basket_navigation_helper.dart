import 'package:flutter/material.dart';
import '../../bloc/basket/basket_bloc.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/constants/app_strings.dart';
import 'first_supplier_order_helper.dart';

Future<void> navigateFromBasketContinue({required BuildContext context, required BasketState state, required String formattedTotal}) async {
  if (state.supplierCount == 1) {
    final dialogResult = await checkAndShowFirstOrderDialogForSingleSupplier(context: context, language: state.language);
    if (!context.mounted || dialogResult == FirstOrderDialogResult.cancelled) {
      return;
    }

    if (dialogResult == FirstOrderDialogResult.confirmed) {
      await navigateToVerifyClientDataScreen(
          context: context,
          nextRouteName: RouteDefine.basketSummaryScreen.name,
          nextRouteArgs: {AppStrings.getCartListString: state.cartItemList, AppStrings.isSupplierSingle: 'Yes'});
      return;
    }

    Navigator.pushNamed(context, RouteDefine.basketSummaryScreen.name,
        arguments: {AppStrings.getCartListString: state.cartItemList, AppStrings.isSupplierSingle: 'Yes'});
  } else {
    Navigator.pushNamed(context, RouteDefine.orderSummaryScreen.name, arguments: {
      AppStrings.getCartListString: state.cartItemList,
      AppStrings.isbackString: 'Basket',
      AppStrings.totalAmountString: formattedTotal
    });
  }
}
