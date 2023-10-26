import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/data/error/exceptions.dart';
import 'package:food_stock/data/model/res_model/product_categories_res_model/product_categories_res_model.dart';
import 'package:food_stock/data/model/res_model/product_sales_res_model/product_sales_res_model.dart';
import 'package:food_stock/repository/dio_client.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/model/res_model/suppliers_res_model/suppliers_res_model.dart';
import '../../ui/utils/themes/app_strings.dart';

part 'store_event.dart';

part 'store_state.dart';

part 'store_bloc.freezed.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreState.initial()) {
    on<StoreEvent>((event, emit) async {
      if (event is _ChangeCategoryExpansion) {
        if (event.isOpened != null) {
          emit(state.copyWith(isCategoryExpand: false));
        } else {
          emit(state.copyWith(isCategoryExpand: !state.isCategoryExpand));
        }
      } else if (event is _GetProductCategoriesListEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context)
              .get(path: AppUrls.getProductCategoriesUrl);
          ProductCategoriesResModel response =
              ProductCategoriesResModel.fromJson(res);
          debugPrint('product categories = ${response.data?.categories}');
          if (response.status == 200) {
            emit(state.copyWith(
                productCategoryList: response.data?.categories ?? [],
                isShimmering: false));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
      } else if (event is _GetProductSalesListEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res =
              await DioClient(event.context).post(AppUrls.getSaleProductsUrl);
          ProductSalesResModel response = ProductSalesResModel.fromJson(res);
          if (response.status == 200) {
            emit(state.copyWith(
                productSalesList: response, isShimmering: false));
          } else {
            showSnackBar(
                context: event.context,
                title: AppStrings.somethingWrongString,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
      } else if (event is _GetSuppliersListEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res =
              await DioClient(event.context).post(AppUrls.getSuppliersUrl);
          SuppliersResModel response = SuppliersResModel.fromJson(res);
          debugPrint('suppliers = ${response.data}');
          if (response.status == 200) {
            emit(state.copyWith(suppliersList: response, isShimmering: false));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
      }
    });
  }
}
