import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/widget/sized_box_widget.dart';
import '../../bloc/bank_info/bank_info_bloc.dart';
import '../../routes/app_routes.dart';
import '../utils/themes/app_colors.dart';
import '../utils/themes/app_constants.dart';
import '../utils/themes/app_strings.dart';
import '../utils/themes/app_styles.dart';
import '../widget/common_drop_down_button.dart';
import '../widget/custom_button_widget.dart';
import '../widget/custom_container_widget.dart';
import '../widget/custom_form_field_widget.dart';


class BankInfoRoute {
  static Widget get route => const BankInfoScreen();
}


class BankInfoScreen extends StatelessWidget {
  const BankInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BankInfoBloc(),
      child: BankInfoWidget(),
    );
  }
}

class BankInfoWidget extends StatelessWidget {
   BankInfoWidget({super.key});
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    BankInfoBloc bloc = context.read<BankInfoBloc>();
    return BlocBuilder<BankInfoBloc, BankInfoState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
            surfaceTintColor: AppColors.whiteColor,
            leading: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                      context, RouteDefine.activityTimeScreen.name);
                },
                child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
            title: Align(
              alignment:
              context.rtl ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.bank_info,
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
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getScreenWidth(context) * 0.1),
                child: Form(
                  key:_formKey,
                  child: Column(
                    children: [
                      CustomContainerWidget(
                        name: AppLocalizations.of(context)!.name_of_bank,
                      ),
                      CommonDropDownButton(
                        items: state.bankList.map((bankName) {
                          return DropdownMenuItem<String>(
                            value: bankName,
                            child: Text(
                                bankName),
                          );
                        }).toList(),
                        onChanged: (newBankName) {
                          bloc.add(BankInfoEvent.selectBankEvent(agent: newBankName ?? ''));
                        },
                        value: state.bankName,
                      ),
                      CustomContainerWidget(
                        name: AppLocalizations.of(context)!.branch_number,
                      ),

                      CustomFormField(
                        context: context,
                        controller: state.branchController,
                        keyboardType: TextInputType.number,
                        hint: "",
                        fillColor: Colors.transparent,
                        textInputAction: TextInputAction.next,
                        validator: AppStrings.branchValString,
                      ),
                      7.height,
                      CustomContainerWidget(
                        name: AppLocalizations.of(context)!.account_number,
                      ),
                      CustomFormField(
                        context: context,
                        controller: state.accountNumberController,
                        keyboardType: TextInputType.number,
                        hint: "",
                        fillColor: Colors.transparent,
                        textInputAction: TextInputAction.done,
                        validator: AppStrings.accountValString,
                      ),
                      40.height,
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomSheet:   Container(
            color: AppColors.whiteColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 30),
              child: CustomButtonWidget(
                buttonText: AppLocalizations.of(context)!
                    .next
                    .toUpperCase(),
                bGColor: AppColors.mainColor,
                onPressed:  () {
                  if (_formKey.currentState
                      ?.validate() ??
                      false) {
                    Navigator.pushNamed(context, RouteDefine.privacyPolicyScreen.name);
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
