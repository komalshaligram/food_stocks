import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/res_model/credit_card_res_model/credit_card_res_model.dart';
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
  CreditCardDetailsBloc() : super(CreditCardDetailsState.initial()) {
    on<CreditCardDetailsEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
      SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
  if(event is _getArgumentEvent){
    emit(state.copyWith(isPaymentFail: event.isPaymentFail,termsModel: event.termsReqModel));
  }
  else if(event is _addCreditCardEvent){

    emit(state.copyWith(isLoading:true));

    try {
      CreditCardReqModel reqMap = CreditCardReqModel(
     cardNum: state.creditCardNumberController.text.trim(),
        expDate_YYMM: state.validityController.text.trim()
      );
      debugPrint(
          'Credit card req = ${reqMap.toJson()}');
      debugPrint('url = ${AppUrls.updateCreditCardUrl+preferencesHelper.getUserId()}');
      final res = await DioClient(event.context).post(
        AppUrls.updateCreditCardUrl+preferencesHelper.getUserId(),
        data: reqMap,
      );

      CreditCardResModel response = CreditCardResModel.fromJson(res);
      //    debugPrint('login response --- ${response}');
      if (response.status == 200) {
        add(CreditCardDetailsEvent.termsConditionApiEvent(context: event.context));
      }
      else {
        emit(state.copyWith(isLoading: false));
        CustomSnackBar.showSnackBar(
            context: event.context,
            title: AppStrings.getLocalizedStrings(
                response.message.toLocalization(),
                event.context),
            type: SnackBarType.FAILURE);
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
  }     else if (event is _termsConditionApiEvent) {
 
    Map<String, dynamic> req = state.termsModel.toJson();
    req.removeWhere((key, value) {
      if (value != null) {
        debugPrint("[$key] = $value");
      }
      return value == null;
    });
    try {
    
      final res =
      await DioClient(event.context).uploadFileProgressWithFormData(
        path: AppUrls.termsConditionUrl,
        formData: FormData.fromMap(
          {
            AppStrings.userIdString : preferencesHelper.getUserId(),
            AppStrings.agentIdString : state.termsModel.agentId,
            AppStrings.businessTypeIdString : state.termsModel.businessTypeId,
            AppStrings.owner1FullNameString : state.termsModel.owner1FullName,
            AppStrings.owner1IsraelIdString : state.termsModel.owner1IsraelId,
            AppStrings.owner2FullNameString : state.termsModel.owner2FullName,
            AppStrings.owner2IsraelIdString : state.termsModel.owner2IsraelId,
            AppStrings.guarantee1FullNameString : state.termsModel.guarantee1FullName,
            AppStrings.guarantee1IsraelIdString : state.termsModel.guarantee1IsraelId,
            AppStrings.guarantee1AddressString : state.termsModel.guarantee1Address,
            AppStrings.guarantee1PhoneNumberString : state.termsModel.guarantee1PhoneNumber,
            AppStrings.guarantee2FullNameString : state.termsModel.guarantee2FullName,
            AppStrings.guarantee2IsraelIdString : state.termsModel.guarantee2IsraelId,
            AppStrings.guarantee2AddressString : state.termsModel.guarantee2Address,
            AppStrings.guarantee2PhoneNumberString : state.termsModel.guarantee2PhoneNumber,
            AppStrings.bankIdString : state.termsModel.bankId,
            AppStrings.branchNumberString : state.termsModel.branchNumber,
            AppStrings.accountNumberString : state.termsModel.accountNumber,
          },
        ),
      );
      debugPrint('termCondition url = ${AppUrls.baseUrl}${AppUrls.termsConditionUrl}');
      debugPrint('termCondition response ____${res}');

      TermsConditionResModel response =
      TermsConditionResModel.fromJson(res);
      if(response.status == 200){

        emit(state.copyWith(isLoading: false,));
        Navigator.pushNamed(event.context, RouteDefine.privacyPolicyScreen.name,
            arguments: {
              AppStrings.privacyPolicyPdfString : response.data ?? '',
              AppStrings.termsConditionParamString :state.termsModel
            }
        );
      }else{
        emit(state.copyWith(isLoading: false,));
      }
    } on ServerException {
      emit(state.copyWith(isLoading: false,));
    }
    catch(e){
      CustomSnackBar.showSnackBar(
          context: event.context,
          title: e.toString(),
          type: SnackBarType.FAILURE);
      emit(state.copyWith(isLoading: false,));
    }
  }
    });
  }
}