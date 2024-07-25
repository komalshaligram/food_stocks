import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_stock/bloc/manage_credit_card/manage_credit_card_bloc.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/widget/custom_button_widget.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/container_widget.dart';
import '../widget/custom_form_field_widget.dart';

class ManageCreditCardRoute {
  static Widget get route => ManageCreditCard();
}

class ManageCreditCard extends StatelessWidget {
  const ManageCreditCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageCreditCardBloc()..add(ManageCreditCardEvent.getCreditCardInfoEvent(context: context)),
      child: ManageCreditCardWidget(),
    );
  }
}

class ManageCreditCardWidget extends StatelessWidget {
  const ManageCreditCardWidget({super.key});

  @override
    Widget build(BuildContext context) {
      return BlocBuilder<ManageCreditCardBloc, ManageCreditCardState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
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
                  AppLocalizations.of(context)!.manage_credit_card,
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
              child: state.isCreditCardExist?Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal:  getScreenWidth(context) * 0.1),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              // height: 200,
                              padding:const EdgeInsets.all(20.0) ,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: AppColors.mainColor,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  20.height,
                                  Text(state.creditCardNumberController.text.toString(),style: AppStyles.rkBoldTextStyle(size: AppConstants.font_22,color: AppColors.whiteColor),),
                                  15.height,
                                  Text(state.validityController.text.toString(),style: AppStyles.rkBoldTextStyle(size: AppConstants.font_17,color: AppColors.whiteColor)),
                                  10.height,
                                ],
                              ),
                            ),
                            30.height,
                            ContainerWidget(
                              name:  AppLocalizations.of(context)!.credit_card_number,
                            ),
                            CustomFormField(
                              context: context,
                              controller: state.creditCardNumberController,
                              keyboardType: TextInputType.number,
                              hint: "",
                              isEnabled: false,
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
                              isEnabled: false,
                              fillColor: Colors.transparent,
                              textInputAction: TextInputAction.done,
                              validator: AppStrings.creditCardValidityString,
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: AppColors.whiteColor,
                      padding: const EdgeInsets.only( left: 20,right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CustomButtonWidget(
                            buttonText: 'Change Credit Card',
                            bGColor: AppColors.mainColor,
                            isLoading: state.isLoading,
                            onPressed:  () {
                              Navigator.pushNamed(context, RouteDefine.creditCardDetailsScreen.name,
                                  arguments: {
                                    AppStrings.isPaymentFail: false
                                  }
                              );
                            },
                            fontColors: AppColors.whiteColor,
                          ),
                          15.height,
                          CustomButtonWidget(
                            buttonText:'Delete Credit Card',
                            fontColors: AppColors.redColor,
                            borderColor: AppColors.redColor,
                            isFromConnectScreen: true,
                            onPressed: () {
                                Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ):Padding(
                padding:  EdgeInsets.symmetric(horizontal:  getScreenWidth(context) * 0.05,vertical: 20),
                child: CustomButtonWidget(
                  buttonText:'Add Credit Card',
                  fontColors: AppColors.mainColor,
                  borderColor: AppColors.mainColor,
                  isFromConnectScreen: true,
                  onPressed: () {
                    Navigator.pushNamed(context, RouteDefine.creditCardDetailsScreen.name,
                        arguments: {
                          AppStrings.isPaymentFail: false
                        }
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
    }

  }

