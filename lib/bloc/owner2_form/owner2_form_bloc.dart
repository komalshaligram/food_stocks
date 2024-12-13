import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/res_model/terms_condition_res/terms_condition_res_model.dart';
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

part 'owner2_form_event.dart';
part 'owner2_form_state.dart';
part 'owner2_form_bloc.freezed.dart';


class Owner2FormBloc extends Bloc<Owner2FormEvent, Owner2FormState> {
  Owner2FormBloc() : super(Owner2FormState.initial()) {
    on<Owner2FormEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
      SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      TermsConditionReqModel termsConditionReqModel = const TermsConditionReqModel();
       if(event is _getArgumentEvent){
        emit(state.copyWith(termsConditionReqModel: event.reqModel));
      }
    else if (event is _navigateToNextScreenEvent) {
       termsConditionReqModel = TermsConditionReqModel(
          id: preferencesHelper.getUserId(),
          businessTypeId: state.termsConditionReqModel.businessTypeId,
         guarantee1FullName: state.termsConditionReqModel.guarantee1FullName,
         guarantee1IsraelId: state.termsConditionReqModel.guarantee1IsraelId,
         guarantee1Address: state.termsConditionReqModel.guarantee1Address,
         guarantee1PhoneNumber: termsConditionReqModel.guarantee1PhoneNumber,
         owner1FullName: state.termsConditionReqModel.owner1FullName,
         owner1IsraelId: state.termsConditionReqModel.owner1IsraelId,
          owner2FullName: state.owner2NameController.text.trim(),
          guarantee2FullName: state.guarantee2NameController.text.trim(),
          guarantee2IsraelId: state.guarantee2idController.text.trim(),
          guarantee2Address: state.guarantee2addressController.text.trim(),
          guarantee2PhoneNumber: state.guarantee2PhoneController.text.trim(),
         owner2IsraelId: state.owner2israelIdController.text.trim(),

        );
        Navigator.pushNamed(event.context, RouteDefine.wayOfPaymentScreen.name, arguments: {AppStrings.termsConditionParamString: termsConditionReqModel});
      }

    });
  }
}