import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/way_of_payment/way_of_payment_bloc.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_styles.dart';
import '../widget/custom_button_widget.dart';

class WayOfPaymentRoute {
  static Widget get route => WayOfPaymentScreen();
}


class WayOfPaymentScreen extends StatelessWidget {
  const WayOfPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WayOfPaymentBloc(),
      child: WayOfPaymentScreenWidget(),
    );
  }
}

class WayOfPaymentScreenWidget extends StatelessWidget {
  const WayOfPaymentScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WayOfPaymentBloc, WayOfPaymentState>(
      builder: (context, state) {
        WayOfPaymentBloc bloc = context.read<WayOfPaymentBloc>();
        return Scaffold(
          appBar: AppBar(
            surfaceTintColor: AppColors.whiteColor,
            leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
            title: Align(
              alignment:
              context.rtl ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.way_of_payment,
                style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont,
                  color: Colors.black,
                ),
              ),
            ),
            backgroundColor: AppColors.whiteColor,
            titleSpacing: 0,
            elevation: 0,
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getScreenWidth(context) * 0.1),
              child: Column(
                children: [
                  RadioButtonWidget(context: context,
                      paymentMethod: AppLocalizations.of(context)!
                          .collection_from_bank_account,
                      radioValue: 0),
                  10.height,
                  RadioButtonWidget(context: context,
                      paymentMethod: AppLocalizations.of(context)!
                          .credit_card,
                      radioValue: 1),
                ],
              ),
            ),
          ),
          bottomSheet: Container(
            color: AppColors.whiteColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: CustomButtonWidget(
                isLoading: false,
                buttonText: AppLocalizations.of(context)!
                    .next
                    .toUpperCase(),
                bGColor: AppColors.mainColor,
                onPressed: () {},
                fontColors: AppColors.whiteColor,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget RadioButtonWidget(
      {required String paymentMethod, required int radioValue, required BuildContext context}) {
    WayOfPaymentBloc bloc = context.read<WayOfPaymentBloc>();
    return BlocProvider.value(
      value: context.read<WayOfPaymentBloc>(),
      child: BlocBuilder<WayOfPaymentBloc, WayOfPaymentState>(
        builder: (context, state) {
          return Row(
            children: [
              Radio(
                value: radioValue,
                fillColor: MaterialStateColor.resolveWith(
                      (states) => AppColors.greyColor,
                ),
                groupValue: state.selectRadioTile,
                onChanged: (val) {
                  debugPrint('value___$val');
                  bloc.add(WayOfPaymentEvent.radioButtonEvent(
                      selectRadioTile: val!));
                },
              ),
              Text(
                paymentMethod,
                style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.font_14,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

