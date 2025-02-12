import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/req_model/create_return_req_model/create_return_req_model.dart';
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/res_model/create_return_res_model/create_return_res_model.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'create_return_state.dart';
part 'create_return_event.dart';
part 'create_return_bloc.freezed.dart';


class CreateReturnBloc extends Bloc<CreateReturnEvent, CreateReturnState> {
  CreateReturnBloc() : super(CreateReturnState.initial()) {
    on<CreateReturnEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if(event is _getReturnListEvent) {

       List<ReturnProducts> tempList = [];
       if(preferencesHelper.getReturnList().isNotEmpty){
         List<dynamic> jsonList = jsonDecode(preferencesHelper.getReturnList());
         tempList = jsonList.map((json) => ReturnProducts.fromJson(json)).toList();
       }
       tempList.addAll(event.product);
       String jsonString = jsonEncode(tempList.map((e) => e.toJson()).toList());
       preferencesHelper.setReturnProductList(returnList: jsonString);
        emit(state.copyWith(language: preferencesHelper.getAppLanguage(),returnProductList: tempList));
      }else if(event is _navigateToAddProductEvent){
        emit(state.copyWith(returnProductList: state.returnProductList));
        Navigator.pushNamed(event.context, RouteDefine.scanReturnProduct.name);
      }else if(event is _createReturnEvent){
        emit(state.copyWith(isLoading: true));
        try{
          CreateReturnReqModel reqModel = CreateReturnReqModel(applicationName: AppStrings.appName,clientId: preferencesHelper.getUserId(),

              returnProducts: state.returnProductList,subUserId: preferencesHelper.getSubUserId().isNotEmpty?preferencesHelper.getSubUserId():null);
          final res = await DioClient(event.context).post(
            AppUrlEndPoints.createReturnUrl,
            data: reqModel.toJson(),
          );
          CreateReturnResModel resModel = CreateReturnResModel.fromJson(res);
          if(resModel.status == AppConstants.code_201){
            preferencesHelper.setReturnProductList(returnList: '');
            emit(state.copyWith(isLoading: false));
              Navigator.pushNamedAndRemoveUntil(event.context, RouteDefine.returnListScreen.name, (Route route) => route.isFirst);
          }
        }catch(e){

        }
      }else if(event is _deleteEvent){
        Navigator.pushNamedAndRemoveUntil(event.context, RouteDefine.returnListScreen.name, (Route route) => route.isFirst);
      }
    });
  }
}