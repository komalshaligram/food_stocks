import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../bloc/way_of_payment/way_of_payment_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/custom_button_widget.dart';

class WayOfPaymentRoute {
  static Widget get route => const WayOfPaymentScreen();
}

class WayOfPaymentScreen extends StatelessWidget {
  const WayOfPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map?;

    return BlocProvider(
      create: (context) => WayOfPaymentBloc()
        ..add(WayOfPaymentEvent.getArgumentEvent(
          termsReqModel: args?[AppStrings.termsConditionParamString] ?? const TermsConditionReqModel(),
          isUpdate: args?[AppStrings.isUpdateParamString] ?? false,
        )),
      child: const WayOfPaymentScreenWidget(),
    );
  }
}

class WayOfPaymentScreenWidget extends StatelessWidget {
  const WayOfPaymentScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WayOfPaymentBloc, WayOfPaymentState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: AppColors.pageColor,
        appBar: AppBar(
          surfaceTintColor: AppColors.pageColor,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child:  Icon(Icons.arrow_back_ios, color: AppColors.blackColor)),
          title: Align(
            alignment: context.rtl ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(AppLocalizations.of(context)!.way_of_payment, style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont, color: AppColors.blackColor)),
          ),
          backgroundColor: AppColors.pageColor,
          titleSpacing: 0,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.padding_20),
            child: Column(children: [
              20.height,
              state.isEnablePayment
                  ? Column(
                      children: [
                        radioButtonWidget(context: context, paymentMethod: AppLocalizations.of(context)!.collection_from_bank_account, radioValue: 0),
                        10.height,
                        radioButtonWidget(context: context, paymentMethod: AppLocalizations.of(context)!.credit_card, radioValue: 1),
                      ],
                    )
                  : radioButtonWidget(context: context, paymentMethod: AppLocalizations.of(context)!.credit_card, radioValue: 0),
              10.height,
            ]),
          ),
        ),
        bottomSheet: Container(
          color: AppColors.pageColor,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.padding_30),
            child: CustomButtonWidget(
              isLoading: false,
              buttonText: state.isUpdate ? AppLocalizations.of(context)!.save.toUpperCase() : AppLocalizations.of(context)!.next.toUpperCase(),
              bGColor: AppColors.mainColor,
              onPressed: () {
                if (state.isUpdate) {
                  Navigator.pop(context);
                } else {
                  if (state.selectRadioTile == 0 && state.isEnablePayment) {
                    Navigator.pushNamed(context, RouteDefine.bankInfoScreen.name, arguments: {
                      AppStrings.termsConditionParamString: state.termsReqModel,
                    });
                  } else {
                    Navigator.pushNamed(context, RouteDefine.creditCardDetailsScreen.name, arguments: {
                      AppStrings.termsConditionParamString: state.termsReqModel,
                      AppStrings.isFromRegFlow: true,
                    });
                  }
                }
              },
              fontColors: AppColors.whiteColor,
            ),
          ),
        ),
      );
    });
  }

  Widget radioButtonWidget({required String paymentMethod, required int radioValue, required BuildContext context}) {
    WayOfPaymentBloc bloc = context.read<WayOfPaymentBloc>();
    return BlocProvider.value(
      value: context.read<WayOfPaymentBloc>(),
      child: BlocBuilder<WayOfPaymentBloc, WayOfPaymentState>(builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(AppConstants.radius_5),
            boxShadow: [BoxShadow(color: AppColors.shadowColor.withValues(alpha: 0.10), blurRadius: AppConstants.radius_5)],
          ),
          child: RadioListTile(
              value: radioValue,
              contentPadding: EdgeInsets.zero,
              dense: true,
              activeColor: AppColors.mainColor,
              selected: true,
              title: Text(paymentMethod, style: AppStyles.rkRegularTextStyle(size: AppConstants.font_17, color: AppColors.blackColor)),
              groupValue: state.selectRadioTile,
              onChanged: (int? val) {
                bloc.add(WayOfPaymentEvent.radioButtonEvent(selectRadioTile: val!));
              }),
        );
      }),
    );
  }
}
