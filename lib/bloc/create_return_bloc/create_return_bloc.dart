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
       ReturnProducts map = event.product;
       List<ReturnProducts> tempList = [];
       if(state.returnProductList.isNotEmpty){
         tempList.addAll(state.returnProductList);
       }
       tempList.add(map);
        printData('arguments1:${map}');
        emit(state.copyWith(language: preferencesHelper.getAppLanguage(),returnProductList: tempList));
/*        await Future.delayed(const Duration(seconds: 1));
        emit(state.copyWith(isAnimate: true));
        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(isRedirected: true));*/

      }else if(event is _getArgumentsEvent){
        emit(state.copyWith(language: preferencesHelper.getAppLanguage(),));
      }

    });
  }
}