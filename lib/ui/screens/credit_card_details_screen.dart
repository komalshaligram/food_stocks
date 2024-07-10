import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/routes/app_routes.dart';
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
    Map<dynamic, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map?;
    debugPrint(
        "isPaymentFail : ${args?.containsKey(AppStrings.isPaymentFail)}}");
    return BlocProvider(
      create: (context) => CreditCardDetailsBloc()..add(CreditCardDetailsEvent.getArgumentEvent(isPaymentFail: args?[AppStrings.isPaymentFail] ?? false)),
      child: CreditCardDetailsScreenWidget(),
    );
  }
}

class CreditCardDetailsScreenWidget extends StatelessWidget {
   CreditCardDetailsScreenWidget({super.key});
  final _formKey = GlobalKey<FormState>();
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
              child: Form(
                key: _formKey,
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
                      validator: AppStrings.creditCardNumberString,
                    ),
                    7.height,
                    ContainerWidget(
                      name:  AppLocalizations.of(context)!.validity,
                    ),
                    CustomFormField(
                      context: context,
                      controller: state.validityController,
                      keyboardType: TextInputType.datetime,
                      hint: "",
                      fillColor: Colors.transparent,
                      textInputAction: TextInputAction.done,
                      validator: AppStrings.creditCardValidityString,
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomSheet:  Container(
            color: AppColors.whiteColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: CustomButtonWidget(
                buttonText: AppLocalizations.of(context)!
                    .next
                    .toUpperCase(),
                bGColor: AppColors.mainColor,
                isLoading: state.isLoading,
                onPressed:  () {
                  if(_formKey.currentState?.validate() ?? false){
                    if(state.isPaymentFail){
                     Navigator.pop(context);
                    }
                    else{
                      Navigator.pushNamed(context,RouteDefine.privacyPolicyScreen.name);
                    }
                  }
                },
                fontColors: AppColors.whiteColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
