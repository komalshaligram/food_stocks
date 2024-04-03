import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/error/exceptions.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../../data/model/res_model/agent_model/agent_model.dart';
import '../../data/model/res_model/business_name_model/business_name_model.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'form_data_event.dart';
part 'form_data_state.dart';
part 'form_data_bloc.freezed.dart';


class FormDataBloc extends Bloc<FormDataEvent, FormDataState> {
  FormDataBloc() : super(FormDataState.initial()) {
    on<FormDataEvent>((event, emit) async {
      TermsConditionReqModel termsConditionReqModel = TermsConditionReqModel();
      if(event is _selectAgentEvent){
        emit(state.copyWith(agent: event.agent));
      }
    else if(event is _selectBusinessTypeEvent){
        state.businessTypeList.forEach((element) {
          if(element.businessTypeName == event.business){
            emit(state.copyWith(business: event.business ,haveMultiple: element.haveMultiple ?? false));
          }
        });
      }
   else if(event is _getAgentEvent){
        try {
          emit(state.copyWith(isAgentListShimmering: true));
          final res = await DioClient(event.context).get(path: AppUrls.getAgentUrl);
          AgentModel response = AgentModel.fromJson(res);
          debugPrint('Business type response = ${response.data.toString()}');
          debugPrint('Business url = ${AppUrls.baseUrl}${AppUrls.getAgentUrl}');

          if (response.status == 200) {
            emit(state.copyWith(isAgentListShimmering:false,agentList: response.data?.agent ?? [],agent: response.data?.agent?.first.agentName ?? '',
            ));
          } else {
            emit(state.copyWith(isAgentListShimmering: false));
          }
        } on ServerException {
          emit(state.copyWith(isAgentListShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isAgentListShimmering: false));
        }
      }
      else if(event is _getBusinessTypeEvent){
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).get(path: AppUrls.getBusinessTypeUrl);
          BusinessNameModel response = BusinessNameModel.fromJson(res);
          debugPrint('agent response = ${response.data.toString()}');
          debugPrint('Business url = ${AppUrls.baseUrl}${AppUrls.getBusinessTypeUrl}');
          if (response.status == 200) {
            emit(state.copyWith(isShimmering:false,businessTypeList: response.data?.businessType ?? [],business: response.data?.businessType?.first.businessTypeName ?? '',
              haveMultiple: response.data?.businessType?.first.haveMultiple ?? false
            ));
          } else {
            emit(state.copyWith(isShimmering: false));
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      }

      else if(event is _navigateToNextScreenEvent){

        termsConditionReqModel = TermsConditionReqModel(
            agentId: state.agentList.firstWhere((element)=>element.agentName == state.agent).id,
            businessTypeId: state.businessTypeList.firstWhere((element)=>element.businessTypeName == state.business).id,
            owner1FullName: state.owner1NameController.text.trim(),
            owner1IsraelId: state.owner1israelIdController.text.trim(),
            owner2FullName: state.owner2NameController.text.trim(),
          owner2IsraelId:state.owner2israelIdController.text.trim(),
          guarantee1FullName: state.guarantee1NameController.text.trim(),
          guarantee1IsraelId: state.guarantee1idController.text.trim(),
          guarantee1Address: state.guarantee1addressController.text.trim(),
          guarantee1PhoneNumber: state.guarantee1PhoneController.text.trim(),
          guarantee2FullName: state.guarantee2NameController.text.trim(),
          guarantee2IsraelId: state.guarantee2idController.text.trim() ,
          guarantee2Address:state.guarantee2addressController.text.trim() ,
          guarantee2PhoneNumber: state.guarantee2PhoneController.text.trim(),
        );
        Navigator.pushNamed(event.context, RouteDefine.bankInfoScreen.name,
        arguments: {
          AppStrings.termsConditionParamString :termsConditionReqModel
        }
        );
      }
    });
  }
}