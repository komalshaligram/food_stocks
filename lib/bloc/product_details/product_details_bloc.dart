

import 'package:bloc/bloc.dart';
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
        debugPrint('[token]   ${preferencesHelper.getAuthToken()}');
        debugPrint('[id]   ${event.orderId}');
       emit(state.copyWith(phoneNumber: preferencesHelper.getPhoneNumber(),isShimmering: true));

        try {
          final res = await DioClient(event.context).get(
              path: '${AppUrls.getOrderById}${event.orderId}',
           /*   options: Options(headers: {
                HttpHeaders.authorizationHeader:
                    'Bearer ${preferencesHelper.getAuthToken()}'
              })*/);
          debugPrint(
              'GetOrderById  url  = ${AppUrls.getOrderById}${event.orderId}');
          debugPrint('GetOrderById res  = $res');

          GetOrderByIdModel response = GetOrderByIdModel.fromJson(res);
          debugPrint('GetOrderByIdModel res = $response');

          if (response.status == 200) {
            emit(state.copyWith(orderBySupplierProduct: event.orderBySupplierProduct,isShimmering: false));
          /*  showSnackBar(
                context: event.context,
                title: response.message!,
                bgColor: AppColors.mainColor);*/
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
            /*isRefresh: !state.isRefresh,*/
            productListIndex: index));
      } else if (event is _radioButtonEvent) {

        emit(state.copyWith(
            selectedRadioTile: event.selectRadioTile,
            isRefresh: !state.isRefresh));

      } else if (event is _productIncrementEvent) {
        emit(state.copyWith(
            productWeight: event.productWeight.round() + 1,
            isRefresh: !state.isRefresh));
      } else if (event is _productDecrementEvent) {
        if (event.productWeight >= 1) {
          emit(state.copyWith(
              productWeight: event.productWeight.round() - 1,
              isRefresh: !state.isRefresh));
        } else {}
      } else if (event is _createIssueEvent) {
        emit(state.copyWith(isLoading: true));
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
            /*    options: Options(headers: {
                  HttpHeaders.authorizationHeader:
                      'Bearer ${preferencesHelper.getAuthToken()}'
                })*/);

            debugPrint(
                'createIssue url  = ${AppUrls.baseUrl}${AppUrls.createIssueUrl}${event.orderId}');
            debugPrint('createIssue Req  = $reqMap');
            debugPrint('[order Id ] = ${event.orderId}');
            debugPrint('createIssue response = $response');

            if (response['status'] == 201) {
              emit(state.copyWith(isLoading: false));
              showSnackBar(
                  context: event.context,
                  title: response['message'],
                  bgColor: AppColors.mainColor);
              Navigator.pop(event.context);
            } else {
              emit(state.copyWith(isLoading: false));
              showSnackBar(
                  context: event.context,
                  title: response['message'],
                  bgColor: AppColors.mainColor);
            }
          } on ServerException {}
        } else {
          emit(state.copyWith(isLoading: false));
          Navigator.pop(event.context);
          showSnackBar(
              context: event.context,
              title: 'Please select issue',
              bgColor: AppColors.redColor);
        }
      }
    });
  }
  String splitNumber(String price){
    var splitPrice = price.split(".");
    if(splitPrice[1] == "00"){
      return splitPrice[0];
    }else {
      return price.toString();
    }
  }
}
