import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/credit_card_req_model/credit_card_req_model.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../../data/model/res_model/terms_condition_res/terms_condition_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'credit_card_details_state.dart';
part 'credit_card_details_event.dart';
part 'credit_card_details_bloc.freezed.dart';

class CreditCardDetailsBloc extends Bloc<CreditCardDetailsEvent, CreditCardDetailsState> {
  TermsConditionReqModel termsConditionReqModel = const TermsConditionReqModel();

  CreditCardDetailsBloc() : super(CreditCardDetailsState.initial()) {
    on<CreditCardDetailsEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());


      if (event is _getArgumentEvent) {
        termsConditionReqModel = event.termsReqModel;
        emit(state.copyWith(isPaymentFail: event.isPaymentFail, termsModel: event.termsReqModel, isFromRegFlow: event.isFromRegFlow));
      } else if (event is _addCreditCardEvent) {
        emit(state.copyWith(isLoading: true));

        try {
          CreditCardReqModel reqMap = CreditCardReqModel(cardNum: state.creditCardNumberController.text.trim(), expDate_YY: state.validityController.text.trim(), expDate_MM: state.selectedMonth);

          final res = await DioClient(event.context).post(
            AppUrls.updateCreditCardUrl + preferencesHelper.getUserId(),
            data: reqMap,
          );

          // CreditCardResModel response = CreditCardResModel.fromJson(res);
          if (res[AppStrings.statusString] == AppConstants.code_200) {
            debugPrint('isFromRegFlow:${state.isFromRegFlow}');
            if (state.isFromRegFlow) {
              add(CreditCardDetailsEvent.termsConditionApiEvent(context: event.context));
            } else {
              preferencesHelper.setPaymentMethod(method: AppStrings.creditCard);
              Navigator.pop(event.context);
            }
          } else {
            emit(state.copyWith(isLoading: false));
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(res[AppStrings.messageString].toLocalization(), event.context), type: SnackBarType.failure);
          }
        } on ServerException {
          emit(state.copyWith(
            isLoading: false,
          ));
        } catch (e) {
          emit(state.copyWith(
            isLoading: false,
          ));
          debugPrint("error:${e.toString()}");
        }
      } else if (event is _termsConditionApiEvent) {
        try {
          termsConditionReqModel = TermsConditionReqModel(
            paymentType: AppStrings.creditCard,
            id: preferencesHelper.getUserId(),
            accountNumber: preferencesHelper.getUserId(),
            agentId: state.termsModel.agentId,
            bankId: state.termsModel.bankId,
            branchNumber: state.termsModel.branchNumber,
            businessTypeId: state.termsModel.businessTypeId,
            guarantee1Address: state.termsModel.guarantee1Address,
            guarantee1FullName: state.termsModel.guarantee1FullName,
            guarantee1IsraelId: state.termsModel.guarantee1IsraelId,
            guarantee1PhoneNumber: state.termsModel.guarantee1PhoneNumber,
            guarantee2Address: state.termsModel.guarantee2Address,
            guarantee2FullName: state.termsModel.guarantee2FullName,
            guarantee2IsraelId: state.termsModel.guarantee2IsraelId,
            guarantee2PhoneNumber: state.termsModel.guarantee2PhoneNumber,
            owner1FullName: state.termsModel.owner1FullName,
            owner1IsraelId: state.termsModel.owner1IsraelId,
            owner2FullName: state.termsModel.owner2FullName,
            owner2IsraelId: state.termsModel.owner2IsraelId,
          );
          debugPrint("bank id________:${state.termsModel.bankId}");

          Map<String, dynamic> req = termsConditionReqModel.toJson();
          req.removeWhere((key, value) {
            if (value != null) {
              debugPrint("[$key] = $value");
            }
            return value == null;
          });
          final res = await DioClient(event.context).uploadFileProgressWithFormData(
            path: AppUrls.termsConditionUrl,
            formData: FormData.fromMap(
              {
                AppStrings.userIdString: termsConditionReqModel.id,
                AppStrings.agentIdString: termsConditionReqModel.agentId,
                AppStrings.businessTypeIdString: termsConditionReqModel.businessTypeId,
                AppStrings.owner1FullNameString: termsConditionReqModel.owner1FullName,
                AppStrings.owner1IsraelIdString: termsConditionReqModel.owner1IsraelId,
                AppStrings.owner2FullNameString: termsConditionReqModel.owner2FullName,
                AppStrings.owner2IsraelIdString: termsConditionReqModel.owner2IsraelId,
                AppStrings.guarantee1FullNameString: termsConditionReqModel.guarantee1FullName,
                AppStrings.guarantee1IsraelIdString: termsConditionReqModel.guarantee1IsraelId,
                AppStrings.guarantee1AddressString: termsConditionReqModel.guarantee1Address,
                AppStrings.guarantee1PhoneNumberString: termsConditionReqModel.guarantee1PhoneNumber,
                AppStrings.guarantee2FullNameString: termsConditionReqModel.guarantee2FullName,
                AppStrings.guarantee2IsraelIdString: termsConditionReqModel.guarantee2IsraelId,
                AppStrings.guarantee2AddressString: termsConditionReqModel.guarantee2Address,
                AppStrings.guarantee2PhoneNumberString: termsConditionReqModel.guarantee2PhoneNumber,
                AppStrings.branchNumberString: termsConditionReqModel.branchNumber,
                AppStrings.accountNumberString: termsConditionReqModel.accountNumber,
                AppStrings.paymentType: termsConditionReqModel.paymentType
              },
            ),
          );

          TermsConditionResModel response = TermsConditionResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(
              isLoading: false,
            ));
            Navigator.pushNamed(event.context, RouteDefine.privacyPolicyScreen.name, arguments: {AppStrings.privacyPolicyPdfString: response.data ?? '', AppStrings.termsConditionParamString: termsConditionReqModel});
          } else {
            emit(state.copyWith(
              isLoading: false,
            ));
          }
        } on ServerException {
          emit(state.copyWith(
            isLoading: false,
          ));
        } catch (e) {
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
          emit(state.copyWith(
            isLoading: false,
          ));
        }
      } else if (event is _selectMonthEvent) {
        emit(state.copyWith(selectedMonth: event.month));
      }

    });
  }
}
