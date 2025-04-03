
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/widget/sized_box_widget.dart';
import '../../bloc/bank_info/bank_info_bloc.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';
import '../utils/constants/app_styles.dart';
import '../widget/bank_info_shimmer_widget.dart';
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
    Map<dynamic, dynamic>? args =
    ModalRoute.of(context)?.settings.arguments as Map?;
    return BlocProvider(
      create: (context) => BankInfoBloc()..add(BankInfoEvent.getBankNameEvent(context: context))
      ..add(BankInfoEvent.getTermsConditionModelEvent(context: context,
          termsConditionReqModel: args?[AppStrings.termsConditionParamString] ?? const TermsConditionReqModel()))
        ..add(BankInfoEvent.getArgumentEvent(isPaymentFail: args?[AppStrings.isPaymentFail] ?? false,isUpdate: args?[AppStrings.updateString]??false)),
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
                  Navigator.pop(context);
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
              child: state.isShimmering ? const BankInfoScreenShimmerWidget():
              Padding(
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
                        items: state.bankList.map((element) {
                          return DropdownMenuItem<String>(
                            value: element.bankName,
                            child: Text(
                                element.bankName ?? ''),
                          );
                        }).toList(),
                        onChanged: (newBankName) {
                          bloc.add(BankInfoEvent.selectBankEvent(bankName: newBankName ?? ''));
                        },
                        value: state.bankName,
                      ),
                      CustomContainerWidget(
                        name: AppLocalizations.of(context)!.branch_number,
                      ),
                      CustomFormField(
                        inputFormat: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16)
                        ],
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
                        inputFormat: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16)
                        ],
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
          bottomSheet:  !state.isShimmering? Container(
            color: AppColors.whiteColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 30),
              child: CustomButtonWidget(
                isLoading: state.isApiShimmering ? true: false,
                buttonText: AppLocalizations.of(context)!
                    .next
                    .toUpperCase(),
                bGColor: AppColors.mainColor,
                onPressed:  () {
                  if (_formKey.currentState
                      ?.validate() ??
                      false) {
                    if(!state.isUpdate){
                      bloc.add(BankInfoEvent.termsConditionApiEvent(context: context));
                    }
                    else{
                      bloc.add(BankInfoEvent.addBankInfoEvent(context: context));
                    }
                  }
                },
                fontColors: AppColors.whiteColor,
              ),
            ),
          ):const SizedBox(),
        );
      },
    );
  }
}
