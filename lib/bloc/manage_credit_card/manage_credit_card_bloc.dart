import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/req_model/profile_details_req_model/profile_details_req_model.dart';
import '../../data/model/res_model/profile_details_res_model/profile_details_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'manage_credit_card_event.dart';
part 'manage_credit_card_state.dart';
part 'manage_credit_card_bloc.freezed.dart';

class ManageCreditCardBloc extends Bloc<ManageCreditCardEvent, ManageCreditCardState> {
  ManageCreditCardBloc() : super(ManageCreditCardState.initial()) {
    on<ManageCreditCardEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (event is _getCreditCardInfoEvent) {
        emit(state.copyWith(isLoading: true));
        try {
          final res = await DioClient(event.context).post(AppUrls.getProfileDetailsUrl, data: ProfileDetailsReqModel(id: preferencesHelper.getUserId()).toJson());
          debugPrint('getUserId = ${preferencesHelper.getUserId()}');
          ProfileDetailsResModel resModel = ProfileDetailsResModel.fromJson(res);
          debugPrint('credit card res = ${resModel.data?.clients?.elementAt(0).clientDetail?.creditCard}');
          if (resModel.status == AppConstants.code_200) {
            if (resModel.data?.clients?.elementAt(0).clientDetail?.creditCard?.expireDate != null) {
              emit(state.copyWith(isLoading: false, creditCardNumberController: TextEditingController(text: maskCreditCardNumber(resModel.data?.clients?.elementAt(0).clientDetail?.creditCard?.cardNumber ?? '')), validityController: TextEditingController(text: formatExpiryDate(resModel.data?.clients?.elementAt(0).clientDetail?.creditCard?.expireDate ?? '')), isCreditCardExist: true));
            } else {
              emit(state.copyWith(isCreditCardExist: false, isLoading: false));
            }
          } else {
            emit(state.copyWith(isLoading: false));
          }
        } catch (e) {
          emit(state.copyWith(isLoading: false));
        }
      }
     else if(event is _addCreditCardEvent){
        Navigator.pushNamed(event.context, RouteDefine.creditCardDetailsScreen.name, arguments: {AppStrings.isPaymentFail: false, AppStrings.isFromRegFlow: false});
      }
     else if(event is _deleteCreditCardEvent){
       emit(state.copyWith(isCreditCardExist: false));
      }
    });
  }
}
