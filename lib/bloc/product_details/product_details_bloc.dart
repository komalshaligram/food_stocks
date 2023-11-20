import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/error/exceptions.dart';
import '../../data/model/req_model/create_issue/create_issue_req_model.dart'
    as create;
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
      SharedPreferencesHelper preferencesHelper =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getProductDataEvent) {
        debugPrint('token___${preferencesHelper.getAuthToken()}');
        debugPrint('id___${event.orderId}');

        try {
          final res = await DioClient(event.context).get(
              path: '${AppUrls.getOrderById}${event.orderId}',
              options: Options(headers: {
                HttpHeaders.authorizationHeader:
                    'Bearer ${preferencesHelper.getAuthToken()}'
              }));

          debugPrint(
              'GetOrderById  url  = ${AppUrls.getOrderById}${event.orderId}');
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
      } else if (event is _productProblemEvent) {

        List<int> index = [];
        if (state.productListIndex.contains(event.index)) {
          index.remove(event.index);
        } else {
          index.add(event.index);
        }
        emit(state.copyWith(
            /*isRefresh: !state.isRefresh,*/ productListIndex: index));
      } else if (event is _radioButtonEvent) {
        emit(state.copyWith(
            selectedRadioTile: event.selectRadioTile,
            isRefresh: !state.isRefresh));
      } else if (event is _productIncrementEvent) {
        emit(state.copyWith(
            productWeight: event.productWeight + 1,
            isRefresh: !state.isRefresh));
      } else if (event is _productDecrementEvent) {
        if (event.productWeight >= 1) {
          emit(state.copyWith(
              productWeight: event.productWeight - 1,
              isRefresh: !state.isRefresh));
        } else {}
      }

      else if (event is _createIssueEvent) {

        if (event.issue != '') {
          create.CreateIssueReqModel reqMap = create.CreateIssueReqModel(
            supplierId: event.supplierId,
            products: [
              create.Product(
                productId: event.productId,
                issue: event.issue,
                missingQuantity: event.missingQuantity,
              )
            ],
          );

          try {
            final response = await DioClient(event.context).post(
                '${AppUrls.createIssueUrl}${event.orderId}',
                data: reqMap,
                options: Options(headers: {
                  HttpHeaders.authorizationHeader:
                      'Bearer ${preferencesHelper.getAuthToken()}'
                }));

            debugPrint(
                'createIssue url  = ${AppUrls.baseUrl}${AppUrls.createIssueUrl}${event.orderId}');
            debugPrint('createIssue Req  = $reqMap');
            debugPrint('order Id  = ${event.orderId}');
            debugPrint('createIssue response = $response');

            if (response['status'] == 201) {
              showSnackBar(
                  context: event.context,
                  title: response['message'],
                  bgColor: AppColors.mainColor);
              Navigator.pop(event.context);
            } else {
              showSnackBar(
                  context: event.context,
                  title: response['message'],
                  bgColor: AppColors.mainColor);
            }
          } on ServerException {}
        } else {
          Navigator.pop(event.context);
          showSnackBar(
              context: event.context,
              title: 'Please select issue',
              bgColor: AppColors.redColor);
        }
      }
    });
  }
}
