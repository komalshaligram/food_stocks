import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ui/utils/themes/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../../data/model/res_model/agent_model/agent_model.dart';
import '../../data/model/res_model/business_name_model/business_name_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'form_data_event.dart';
part 'form_data_state.dart';
part 'form_data_bloc.freezed.dart';


class FormDataBloc extends Bloc<FormDataEvent, FormDataState> {
  FormDataBloc() : super(FormDataState.initial()) {
    on<FormDataEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
      SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      TermsConditionReqModel termsConditionReqModel = const TermsConditionReqModel();
      List<String > ownerList = [];
      List<BusinessType> businessTypeList = [];
      ownerList.add('Please select number of Owner');
      ownerList.add('1');
      ownerList.add('2');
      if(event is _selectAgentEvent){
        emit(state.copyWith(agent: event.agent,ownerList: state.ownerList));
      }
      else if(event is _getArgumentEvent){
        debugPrint("owner:${event.owner}");
        emit(state.copyWith(owner: event.owner,));
      }
    else if(event is _selectBusinessTypeEvent){
        for (var element in state.businessTypeList) {
          if (element.businessTypeName == event.business) {
            debugPrint('element.haveMultiple${element.haveMultiple}');
            emit(state.copyWith(business: event.business, haveMultiple: element.haveMultiple ?? false,ownerList: state.ownerList));
          }
        }
      }  else if(event is _selectOwnerNoEvent){
        emit(state.copyWith(owner: state.haveMultiple? event.owner:'1'));
      }

    else if (event is _getBusinessTypeEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).get(path: AppUrlEndPoints.getBusinessTypeUrl);
          BusinessNameModel response = BusinessNameModel.fromJson(res);

          businessTypeList.add(BusinessType(businessTypeName: AppLocalizations.of(event.context)!.type_of_business));
          businessTypeList.addAll(response.data?.businessType?.reversed ?? []);
          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(isShimmering: false, businessTypeList: businessTypeList, business: businessTypeList.first.businessTypeName.toString(), haveMultiple: response.data?.businessType?.reversed.first.haveMultiple ?? false));
          } else {
            emit(state.copyWith(isShimmering: false));
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      }
    else if (event is _navigateToNextScreenEvent) {
       termsConditionReqModel = TermsConditionReqModel(
          id: preferencesHelper.getUserId(),
          businessTypeId: state.businessTypeList.firstWhere((element) => element.businessTypeName == state.business).id,
          owner1FullName: state.owner1NameController.text.trim(),
          owner1IsraelId: state.owner1israelIdController.text.trim(),
          owner2FullName: state.owner2NameController.text.trim(),
          owner2IsraelId: state.owner2israelIdController.text.trim(),
          guarantee1FullName: state.guarantee1NameController.text.trim(),
          guarantee1IsraelId: state.guarantee1idController.text.trim(),
          guarantee1Address: state.guarantee1addressController.text.trim(),
          guarantee1PhoneNumber: state.guarantee1PhoneController.text.trim(),
          guarantee2FullName: state.guarantee2NameController.text.trim(),
          guarantee2IsraelId: state.guarantee2idController.text.trim(),
          guarantee2Address: state.guarantee2addressController.text.trim(),
          guarantee2PhoneNumber: state.guarantee2PhoneController.text.trim(),
        );
        Navigator.pushNamed(event.context, RouteDefine.wayOfPaymentScreen.name, arguments: {AppStrings.termsConditionParamString: termsConditionReqModel});
      }
    else if(event is _getAgentEvent){

      }
    else if(event is _verifyAgentEvent){
        try {
          emit(state.copyWith(isShimmering: true));
          Map reqMap ={"agentCode":state.agentCodeController.text.trim()};
          final res = await DioClient(event.context).post(AppUrlEndPoints.verifyAgentUrl,data: reqMap);

          if(res[AppStrings.statusString]==AppConstants.code_200){

            emit(state.copyWith(isShimmering: false));
            Navigator.pushNamed(event.context, RouteDefine.owner1FormScreen.name,arguments: {AppStrings.owner:state.owner,AppStrings.isFreelancer:state.haveMultiple,
            AppStrings.businessTypeIdString:state.businessTypeList.firstWhere((element) => element.businessTypeName == state.business).id});

          }else{
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    res['message'].toString().toLocalization(),
                    event.context),
                type: SnackBarType.failure);

            emit(state.copyWith(isShimmering: false));
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }

      }
    });
  }
}