import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/error/exceptions.dart';
import '../../data/model/res_model/get_order_by_id/get_order_by_id_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'product_details_event.dart';

part 'product_details_state.dart';

part 'product_details_bloc.freezed.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc() : super(ProductDetailsState.initial()) {
    on<ProductDetailsEvent>((event, emit) async {
      if (event is _getProductDataEvent) {
        SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());
        debugPrint('token___${preferencesHelper.getAuthToken()}');
        debugPrint('id___${event.orderId}');


        try {
          final res = await DioClient(event.context).get(
              path: '${AppUrls.getOrderById}${event.orderId}',
              options: Options(headers: {
                HttpHeaders.authorizationHeader:
                    'Bearer ${preferencesHelper.getAuthToken()}'
              }));
          debugPrint('GetOrderByIdModel  = $res');

          GetOrderByIdModel response = GetOrderByIdModel.fromJson(res);
          debugPrint('GetOrderByIdModel  = $response');

          if (response.status == 200) {
            emit(state.copyWith(orderList: response));
            showSnackBar(
                context: event.context,
                title: response.message!,
                bgColor: AppColors.mainColor);
          } else {
            showSnackBar(
                context: event.context,
                title: response.message!,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
      }

      if (event is _productProblemEvent) {
      //  List<ProductDetailsModel> temp = state.productList;
       // temp[event.index].isProductIssue = event.isProductProblem;
        List<int>index = [];
        if(state.productListIndex.contains(event.index)){
          index.remove(event.index);
        }
        else{
          index.add(event.index);
        }
        emit(state.copyWith(isRefresh: !state.isRefresh, productListIndex: index
        ));
      }

      if (event is _radioButtonEvent) {
        emit(state.copyWith(
            selectedRadioTile: event.selectRadioTile,
            isRefresh: !state.isRefresh));
      }

      if (event is _productIncrementEvent) {
        emit(state.copyWith(productWeight: event.productWeight + 1, isRefresh: !state.isRefresh));
      }

      if (event is _productDecrementEvent) {
        if (event.productWeight >= 0) {
          emit(state.copyWith(productWeight: event.productWeight - 1, isRefresh: !state.isRefresh));
        } else {
        }
      }
    });
  }
}
