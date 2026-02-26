import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import '../../bloc/manage_credit_card/manage_credit_card_bloc.dart';
import '../../ui/utils/app_utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/utils/constants/app_img_path.dart';
import '../../ui/widget/custom_button_widget.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/container_widget.dart';
import '../widget/custom_form_field_widget.dart';
import '../widget/manage_credit_card_shimmer.dart';

class ManageCreditCardRoute {
  static Widget get route => const ManageCreditCard();
}

class ManageCreditCard extends StatelessWidget {
  const ManageCreditCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageCreditCardBloc()..add(ManageCreditCardEvent.getCreditCardInfoEvent(context: context)),
      child: const ManageCreditCardWidget(),
    );
  }
}

class ManageCreditCardWidget extends StatelessWidget {
  const ManageCreditCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ManageCreditCardBloc bloc = context.read<ManageCreditCardBloc>();
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
              alignment: context.rtl ? Alignment.centerRight : Alignment.centerLeft,
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
          body: FocusDetector(
            onFocusGained: () {
              bloc.add(ManageCreditCardEvent.getCreditCardInfoEvent(context: context));
            },
            child: state.isLoading
                ? const ManageCreditCardShimmer()
                : SafeArea(
                    child: state.isCreditCardExist
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.1),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(20.0),
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            color: AppColors.blueColor.withValues(alpha: 0.8),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Image.asset(
                                                    AppImagePath.chipIcon,
                                                    height: 50,
                                                    width: 50,
                                                    color: AppColors.mainColor,
                                                  )),
                                              8.height,
                                              Text(
                                                state.creditCardNumberController.text,
                                                style: AppStyles.rkBoldTextStyle(size: AppConstants.font_22, color: AppColors.whiteColor),
                                              ),
                                              15.height,
                                              Text(state.validityController.text.toString(),
                                                  style: AppStyles.rkBoldTextStyle(
                                                    size: AppConstants.font_17,
                                                    color: AppColors.whiteColor,
                                                  )),
                                              10.height,
                                            ],
                                          ),
                                        ),
                                        30.height,
                                        ContainerWidget(
                                          name: AppLocalizations.of(context)!.credit_card_number,
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
                                          name: AppLocalizations.of(context)!.validity,
                                        ),
                                        CustomFormField(
                                          context: context,
                                          controller: state.validityController,
                                          keyboardType: TextInputType.datetime,
                                          hint: "",
                                          isEnabled: false,
                                          fillColor: Colors.transparent,
                                          textInputAction: TextInputAction.done,
                                          validator: formatExpiryDate(state.validityController.text.toString()),
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
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomButtonWidget(
                                        buttonText: AppLocalizations.of(context)!.change_credit_card,
                                        bGColor: AppColors.mainColor,
                                        isLoading: state.isLoading,
                                        onPressed: () {
                                          bloc.add(ManageCreditCardEvent.addCreditCardEvent(context: context));
                                        },
                                        fontColors: AppColors.whiteColor,
                                      ),
                                      15.height,
                                      CustomButtonWidget(
                                        buttonText: AppLocalizations.of(context)!.delete_credit_card,
                                        fontColors: AppColors.redColor,
                                        borderColor: AppColors.redColor,
                                        isFromConnectScreen: true,
                                        isLoading: state.isDeleteLoading,
                                        loadingColor: AppColors.redColor,
                                        onPressed: () {
                                          bloc.add(ManageCreditCardEvent.deleteCreditCardEvent(context: context));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: getScreenWidth(context) * 0.05, vertical: 20),
                            child: CustomButtonWidget(
                              buttonText: AppLocalizations.of(context)!.add_credit_card,
                              fontColors: AppColors.mainColor,
                              borderColor: AppColors.mainColor,
                              isFromConnectScreen: true,
                              onPressed: () {
                                bloc.add(ManageCreditCardEvent.addCreditCardEvent(context: context));
                              },
                            ),
                          ),
                  ),
          ),
        );
      },
    );
  }
}
