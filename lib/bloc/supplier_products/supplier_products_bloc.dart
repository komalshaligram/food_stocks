import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/data/error/exceptions.dart';
import 'package:food_stock/data/model/req_model/supplier_products_req_model/supplier_products_req_model.dart';
import 'package:food_stock/data/model/res_model/supplier_products_res_model/supplier_products_res_model.dart';
import 'package:food_stock/repository/dio_client.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/storage/shared_preferences_helper.dart';

part 'supplier_products_event.dart';

part 'supplier_products_state.dart';

part 'supplier_products_bloc.freezed.dart';

class SupplierProductsBloc
    extends Bloc<SupplierProductsEvent, SupplierProductsState> {
  SupplierProductsBloc() : super(SupplierProductsState.initial()) {
    on<SupplierProductsEvent>((event, emit) async {
      if (event is _GetSupplierProductsListEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          SupplierProductsReqModel request =
              SupplierProductsReqModel(userId: event.supplierId);
          debugPrint('supplier products req = ${request.toJson()}');
          final res = await DioClient(event.context)
              .post(AppUrls.getSupplierProductsUrl, data: request.toJson());
          SupplierProductsResModel response =
              SupplierProductsResModel.fromJson(res);
          debugPrint('supplier Products res = ${response.data}');
          response.data?.forEach((element) {
            debugPrint('supplier Products res = ${element.id}');
          });

          if (response.status == 200) {
            emit(state.copyWith(
                productList: response.data ?? [], isShimmering: false));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
          }
        } on ServerException {}
      }
    });
  }
}
