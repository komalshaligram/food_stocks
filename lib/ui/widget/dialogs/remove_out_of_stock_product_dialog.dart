import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/basket/basket_bloc.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../screens/basket/basket_total_widget.dart';
import '../../utils/basket_navigation_helper.dart';
import 'custom_dialog.dart';
import 'call_agent_dialog.dart';

void removeOutOfStockProductDialog({required BuildContext context}) {
  BasketBloc bloc = context.read<BasketBloc>();
  showDialog(
      context: context,
      builder: (context1) => BlocProvider.value(
            value: context.read<BasketBloc>(),
            child: BlocBuilder<BasketBloc, BasketState>(builder: (context, state) {
              return AbsorbPointer(
                absorbing: state.isRemoveProcess ? true : false,
                child: CustomDialog(
                    title: AppLocalizations.of(context)!.some_products_out_of_stock_Do_you_want_submit_order,
                    content: const [],
                    isMixedSale: false,
                    directionality: state.language,
                    positiveTitle: AppLocalizations.of(context)!.yes,
                    isProcessing: state.isRemoveProcess,
                    negativeTitle: AppLocalizations.of(context)!.no,
                    positiveOnTap: () async {
                      if (!state.isRemoveProcess && !state.isLoading && !state.isShimmering) {
                        Navigator.pop(context1);
                        if (state.draftReturnExists) {
                          await showDialog(
                              context: context,
                              builder: (_) => CallAgentDialog(language: state.language, state: state, context1: context, bloc: bloc));
                        } else {
                          await navigateFromBasketContinue(context: context, state: state, formattedTotal: formattedBasketGrandTotal(state));
                        }
                      }
                    },
                    negativeOnTap: () {
                      Navigator.pop(context1);
                    }),
              );
            }),
          ));
}
