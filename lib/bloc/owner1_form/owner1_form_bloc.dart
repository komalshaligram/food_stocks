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

part 'owner1_form_event.dart';
part 'owner1_form_state.dart';
part 'owner1_form_bloc.freezed.dart';


class Owner1FormBloc extends Bloc<Owner1FormEvent, Owner1FormState> {
  Owner1FormBloc() : super(Owner1FormState.initial()) {
    on<Owner1FormEvent>((event, emit) async {
      TermsConditionReqModel termsConditionReqModel = const TermsConditionReqModel();
      SharedPreferencesHelper preferencesHelper =
      SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

       if(event is _getArgumentEvent){
        debugPrint("owner:${event.owner}");
        emit(state.copyWith(owner: event.owner,businessID: event.businessTypeId,haveMultiple: event.isFreelancer));
      }
       else if (event is _navigateToNextScreenEvent) {
         termsConditionReqModel = TermsConditionReqModel(
           id: preferencesHelper.getUserId(),
           businessTypeId: state.businessID,
           owner1FullName: state.owner1NameController.text.toString(),
           owner1IsraelId: state.owner1israelIdController.text.toString(),
           owner2FullName: '',
           owner2IsraelId: '',
           guarantee1FullName: state.guarantee1NameController.text.toString(),
           guarantee1IsraelId:state.guarantee1idController.text.toString(),
           guarantee1Address: state.guarantee1addressController.text.toString(),
           guarantee1PhoneNumber: state.guarantee1PhoneController.text.toString(),
           guarantee2FullName: '',
           guarantee2IsraelId:'',
           guarantee2Address: '',
           guarantee2PhoneNumber: '',

         );
         if(state.owner=='2'){
           Navigator.pushNamed(event.context, RouteDefine.owner2FormScreen.name, arguments: {AppStrings.termsConditionParamString: termsConditionReqModel});
         }else {
           Navigator.pushNamed(event.context, RouteDefine.wayOfPaymentScreen.name, arguments: {AppStrings.termsConditionParamString: termsConditionReqModel});

         }
       }
    });
  }
}