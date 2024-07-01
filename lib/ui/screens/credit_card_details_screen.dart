import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/container_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/credit_card_details/credit_card_details_bloc.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_form_field_widget.dart';

class CreditCardDetailsRoute {
  static Widget get route => CreditCardDetailsScreen();
}


class CreditCardDetailsScreen extends StatelessWidget {
  const CreditCardDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreditCardDetailsBloc(),
      child: CreditCardDetailsScreenWidget(),
    );
  }
}

class CreditCardDetailsScreenWidget extends StatelessWidget {
  const CreditCardDetailsScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreditCardDetailsBloc, CreditCardDetailsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.whiteColor,
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
                AppLocalizations.of(context)!.credit_card_details,
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
                  ContainerWidget(
                    name:  AppLocalizations.of(context)!.credit_card_number,
                  ),
                  CustomFormField(
                    context: context,
                    controller: state.creditCardNumberController,
                    keyboardType: TextInputType.number,
                    hint: "",
                    fillColor: Colors.transparent,
                    textInputAction: TextInputAction.next,
                    validator: AppStrings.idValString,
                  ),
                  7.height,
                  ContainerWidget(
                    name:  AppLocalizations.of(context)!.validity,
                  ),
                  CustomFormField(
                    context: context,
                    controller: state.validityController,
                    keyboardType: TextInputType.number,
                    hint: "",
                    fillColor: Colors.transparent,
                    textInputAction: TextInputAction.done,
                    validator: AppStrings.idValString,
                  ),

                ],
              ),
            ),
          ),
          bottomSheet:  CustomButtonWidget(
            buttonText: AppLocalizations.of(context)!
                .next
                .toUpperCase(),
            bGColor: AppColors.mainColor,
            onPressed:  () {

            },
            fontColors: AppColors.whiteColor,
          ),
        );
      },
    );
  }
}
