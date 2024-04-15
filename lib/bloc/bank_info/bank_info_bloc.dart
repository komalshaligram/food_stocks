import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import'dart:io';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../../data/model/res_model/bank_detail_model/bank_detail_model.dart';
import '../../data/model/res_model/terms_condition_res/terms_condition_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';
import 'package:http_parser/http_parser.dart';
part 'bank_info_event.dart';
part 'bank_info_state.dart';
part 'bank_info_bloc.freezed.dart';


class BankInfoBloc extends Bloc<BankInfoEvent, BankInfoState> {
  TermsConditionReqModel termsConditionReqModel = TermsConditionReqModel();
  BankInfoBloc() : super(BankInfoState.initial()) {
    on<BankInfoEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
      SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (event is _selectBankEvent) {
        emit(state.copyWith(bankName: event.bankName));
      }
      else if (event is _getBankNameEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).get(
              path: AppUrls.getBankDetailUrl);
          BankDetailModel response = BankDetailModel.fromJson(res);
          debugPrint('bank details  response = ${response.data.toString()}');
          debugPrint('bank details url = ${AppUrls.baseUrl}${AppUrls
              .getBankDetailUrl}');
          if (response.status == 200) {
            emit(state.copyWith(
              isShimmering: false, bankList: response.data?.bankDetail ?? [],
              bankName: response.data?.bankDetail?.first.bankName ?? '',
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
      else if (event is _getTermsConditionModelEvent) {
        termsConditionReqModel = event.termsConditionReqModel;
      }
      else if (event is _termsConditionApiEvent) {
        termsConditionReqModel = TermsConditionReqModel(
            id: preferencesHelper.getUserId(),
            agentId: termsConditionReqModel.agentId,
            businessTypeId: termsConditionReqModel.businessTypeId,
            owner1FullName: termsConditionReqModel.owner1FullName,
            owner1IsraelId: termsConditionReqModel.owner1IsraelId,
            owner2FullName: termsConditionReqModel.owner2FullName,
            owner2IsraelId: termsConditionReqModel.owner2IsraelId,
            guarantee1FullName: termsConditionReqModel.guarantee1FullName,
            guarantee1IsraelId: termsConditionReqModel.guarantee1IsraelId,
            guarantee1Address: termsConditionReqModel.guarantee1Address,
            guarantee1PhoneNumber: termsConditionReqModel.guarantee1PhoneNumber,
            guarantee2FullName: termsConditionReqModel.guarantee2FullName,
            guarantee2IsraelId: termsConditionReqModel.guarantee2IsraelId,
            guarantee2Address: termsConditionReqModel.guarantee2Address,
            guarantee2PhoneNumber: termsConditionReqModel.guarantee2PhoneNumber,
            bankId: state.bankList
                .firstWhere((element) => element.bankName == state.bankName)
                .id,
            accountNumber: state.accountNumberController.text.trim(),
            branchNumber: state.branchController.text.trim()
        );
        Map<String, dynamic> req = termsConditionReqModel.toJson();
        req.removeWhere((key, value) {
          if (value != null) {
            debugPrint("[$key] = $value");
          }
          return value == null;
        });
        try {
          emit(state.copyWith(isApiShimmering: true,));
          final res =
          await DioClient(event.context).uploadFileProgressWithFormData(
            path: AppUrls.termsConditionUrl,
            formData: FormData.fromMap(
              {
                AppStrings.userIdString : preferencesHelper.getUserId(),
                AppStrings.agentIdString : termsConditionReqModel.agentId,
                AppStrings.businessTypeIdString : termsConditionReqModel.businessTypeId,
                AppStrings.owner1FullNameString : termsConditionReqModel.owner1FullName,
                AppStrings.owner1IsraelIdString : termsConditionReqModel.owner1IsraelId,
                AppStrings.owner2FullNameString : termsConditionReqModel.owner2FullName,
                AppStrings.owner2IsraelIdString : termsConditionReqModel.owner2IsraelId,
                AppStrings.guarantee1FullNameString : termsConditionReqModel.guarantee1FullName,
                AppStrings.guarantee1IsraelIdString : termsConditionReqModel.guarantee1IsraelId,
                AppStrings.guarantee1AddressString : termsConditionReqModel.guarantee1Address,
                AppStrings.guarantee1PhoneNumberString : termsConditionReqModel.guarantee1PhoneNumber,
                AppStrings.guarantee2FullNameString : termsConditionReqModel.guarantee2FullName,
                AppStrings.guarantee2IsraelIdString : termsConditionReqModel.guarantee2IsraelId,
                AppStrings.guarantee2AddressString : termsConditionReqModel.guarantee2Address,
                AppStrings.guarantee2PhoneNumberString : termsConditionReqModel.guarantee2PhoneNumber,
                AppStrings.bankIdString : termsConditionReqModel.bankId,
                AppStrings.branchNumberString : termsConditionReqModel.branchNumber,
                AppStrings.accountNumberString : termsConditionReqModel.accountNumber,
              },
            ),
          );
          debugPrint('fileUpload url = ${AppUrls.baseUrl}${AppUrls.termsConditionUrl}');
          debugPrint('termCondition response ____${res}');

          TermsConditionResModel response =
          TermsConditionResModel.fromJson(res);
          if(response.status == 200){

            emit(state.copyWith(isApiShimmering: false,));
            Navigator.pushNamed(event.context, RouteDefine.privacyPolicyScreen.name,
                arguments: {
                  AppStrings.privacyPolicyPdfString : response.data ?? '',
                  AppStrings.termsConditionParamString :termsConditionReqModel
                }
            );

          }

        } on ServerException {}
  /*      termsConditionReqModel = TermsConditionReqModel(
            id: preferencesHelper.getUserId(),
            agentId: termsConditionReqModel.agentId,
            businessTypeId: termsConditionReqModel.businessTypeId,
            owner1FullName: termsConditionReqModel.owner1FullName,
            owner1IsraelId: termsConditionReqModel.owner1IsraelId,
            owner2FullName: termsConditionReqModel.owner2FullName,
            owner2IsraelId: termsConditionReqModel.owner2IsraelId,
            guarantee1FullName: termsConditionReqModel.guarantee1FullName,
            guarantee1IsraelId: termsConditionReqModel.guarantee1IsraelId,
            guarantee1Address: termsConditionReqModel.guarantee1Address,
            guarantee1PhoneNumber: termsConditionReqModel.guarantee1PhoneNumber,
            guarantee2FullName: termsConditionReqModel.guarantee2FullName,
            guarantee2IsraelId: termsConditionReqModel.guarantee2IsraelId,
            guarantee2Address: termsConditionReqModel.guarantee2Address,
            guarantee2PhoneNumber: termsConditionReqModel.guarantee2PhoneNumber,
            bankId: state.bankList
                .firstWhere((element) => element.bankName == state.bankName)
                .id,
            accountNumber: state.accountNumberController.text.trim(),
            branchNumber: state.branchController.text.trim()
        );
        Map<String, dynamic> req = termsConditionReqModel.toJson();
        req.removeWhere((key, value) {
          if (value != null) {
            debugPrint("[$key] = $value");
          }
          return value == null;
        });
        print('termsConditionReqModel____${req}');
        try {
          emit(state.copyWith(isApiShimmering: true));
          final res = await DioClient(event.context).post(
            AppUrls.termsConditionUrl,
            data: req,
          );


          print('termCondition response ____${res}');

          TermsConditionResModel response =
          TermsConditionResModel.fromJson(res);


          if (response.status == 200) {
            if(res != null){
              emit(state.copyWith(isApiShimmering: false,));
              Navigator.pushNamed(event.context, RouteDefine.privacyPolicyScreen.name,
                  arguments: {
                    AppStrings.privacyPolicyPdfString : response.data ?? '',
                    AppStrings.termsConditionParamString :termsConditionReqModel
                  }
              );
            }
          } else {
            emit(state.copyWith(isApiShimmering: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(
                  response.message?.toLocalization() ??
                      response.message!,
                  event.context),
              type: SnackBarType.FAILURE,
            );
          }
        } on ServerException {
          emit(state.copyWith(isApiShimmering: false));
        }
        catch (e) {
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: e.toString(),
            type: SnackBarType.FAILURE,
          );
        }*/
      }
    }
    );
  }
}