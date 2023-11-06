import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/data/error/exceptions.dart';
import 'package:food_stock/data/model/req_model/supplier_products_req_model/supplier_products_req_model.dart';
import 'package:food_stock/data/model/res_model/supplier_products_res_model/supplier_products_res_model.dart';
import 'package:food_stock/repository/dio_client.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';

part 'supplier_products_event.dart';

part 'supplier_products_state.dart';

part 'supplier_products_bloc.freezed.dart';

class SupplierProductsBloc
    extends Bloc<SupplierProductsEvent, SupplierProductsState> {
  SupplierProductsBloc() : super(SupplierProductsState.initial()) {
    on<SupplierProductsEvent>((event, emit) async {
      if (event is _GetSupplierProductsIdEvent) {
        emit(state.copyWith(supplierId: event.supplierId));
      } else if (event is _GetSupplierProductsListEvent) {
        if (state.isBottomOfProducts) {
          return;
        }
        try {
          emit(state.copyWith(
              isShimmering: state.pageNum == 0 ? true : false,
              isLoadMore: state.pageNum == 0 ? false : true));
          SupplierProductsReqModel request = SupplierProductsReqModel(
              supplierId: state.supplierId,
              pageLimit: AppConstants.supplierProductPageLimit,
              pageNum: state.pageNum + 1);
          debugPrint('supplier products req = ${request.toJson()}');
          final res = await DioClient(event.context)
              .post(AppUrls.getSupplierProductsUrl, data: request.toJson());
          SupplierProductsResModel response =
              SupplierProductsResModel.fromJson(res);
          debugPrint('supplier Products res = ${response.data}');
          if (response.status == 200) {
            List<Datum> productList = state.productList.toList(growable: true);
            productList.addAll(response.data ?? []);
            debugPrint('new product list len = ${productList.length}');
            emit(state.copyWith(
                productList: productList,
                pageNum: state.pageNum + 1,
                isShimmering: false,
                isLoadMore: false));
            emit(state.copyWith(
                isBottomOfProducts:
                    state.pageNum == (response.metaData?.totalFilteredPage ?? 0)
                        ? true
                        : false));
          } else {
            emit(state.copyWith(isLoadMore: false));
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
