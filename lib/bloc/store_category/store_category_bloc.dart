import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/error/exceptions.dart';
import 'package:food_stock/data/model/req_model/planogram_req_model/planogram_req_model.dart';
import 'package:food_stock/data/model/res_model/planogram_res_model/planogram_res_model.dart';
import 'package:food_stock/repository/dio_client.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';

part 'store_category_event.dart';

part 'store_category_state.dart';

part 'store_category_bloc.freezed.dart';

class StoreCategoryBloc extends Bloc<StoreCategoryEvent, StoreCategoryState> {
  StoreCategoryBloc() : super(StoreCategoryState.initial()) {
    on<StoreCategoryEvent>((event, emit) async {
      if (event is _ChangeCategoryExpansionEvent) {
        if (event.isOpened != null) {
          emit(state.copyWith(isCategoryExpand: false));
        } else {
          emit(state.copyWith(isCategoryExpand: !state.isCategoryExpand));
        }
      } else if (event is _ChangeCategoryOrSubCategoryEvent) {
        emit(state.copyWith(isCategory: event.isCategory));
        if (!state.isCategory) {
          add(_GetPlanoGramProductsEvent(context: event.context));
        }
      } else if (event is _GetPlanoGramProductsEvent) {
        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfPlanoGrams) {
          return;
        }
        try {
          emit(state.copyWith(
              isShimmering: state.pageNum == 0 ? true : false,
              isLoadMore: state.pageNum == 0 ? false : true));
          final res = await DioClient(event.context).post(
              AppUrls.getPlanogramProductsUrl,
              data: PlanogramReqModel(
                      pageNum: state.pageNum + 1,
                      pageLimit: AppConstants.planogramProductPageLimit,
                      sortOrder: AppStrings.ascendingString,
                      sortField: AppStrings.planogramSortFieldString)
                  .toJson());
          PlanogramResModel response = PlanogramResModel.fromJson(res);
          if (response.status == 200) {
            List<Datum> planoGramsList =
                state.planoGramsList.toList(growable: true);
            planoGramsList.addAll(response.data ?? []);
            List<List<ProductStockModel>> productStockList =
                state.productStockList.toList(growable: true);
            for (int i = 0; i < (response.data?.length ?? 0); i++) {
              List<ProductStockModel> stockList = [];
              stockList.addAll(response.data![i].planogramproducts?.map(
                      (product) => ProductStockModel(
                          productId: product.id ?? '',
                          stock: product.productStock ?? 0)) ??
                  []);
              // debugPrint('stockList[$i] = $stockList');
              productStockList.addAll([stockList]);
            }
            debugPrint('planogram list = ${planoGramsList.length}');
            debugPrint('planogram stock list = ${productStockList.length}');
            emit(state.copyWith(
                planoGramsList: planoGramsList,
                productStockList: productStockList,
                pageNum: state.pageNum + 1,
                isShimmering: false,
                isLoadMore: false));
            emit(state.copyWith(
                isBottomOfPlanoGrams: planoGramsList.length ==
                        (response.metaData?.totalFilteredCount ?? 0)
                    ? true
                    : false));
          } else {
            emit(state.copyWith(isLoadMore: false));
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
      } else if (event is _GetProductDetailsEvent) {
        debugPrint('product details id = ${event.productId}');
        try {
          emit(state.copyWith(isProductLoading: true));
          final res = await DioClient(event.context).post(
              AppUrls.getProductDetailsUrl,
              data: ProductDetailsReqModel(params: event.productId).toJson());
          ProductDetailsResModel response =
              ProductDetailsResModel.fromJson(res);
          if (response.status == 200) {
            List<List<ProductStockModel>> productStockList =
                state.productStockList.toList(growable: true);
            int productStockUpdateIndex = state
                .productStockList[event.planoGramIndex]
                .indexWhere((productStock) =>
                    productStock.productId == event.productId);
            productStockList[event.planoGramIndex][productStockUpdateIndex] =
                productStockList[event.planoGramIndex][productStockUpdateIndex]
                    .copyWith(stock: response.product?.first.numberOfUnit ?? 0);
            debugPrint(
                'product stock update index = ${state.planoGramsList[event.planoGramIndex].planogramName}[${state.planoGramsList[event.planoGramIndex].planogramproducts?[productStockUpdateIndex].id}]');
            debugPrint(
                'stock ${productStockList[event.planoGramIndex][productStockUpdateIndex].stock}');
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(
                productDetails: response,
                productStockList: productStockList,
                productStockUpdateIndex: productStockUpdateIndex,
                planoGramUpdateIndex: event.planoGramIndex,
                isProductLoading: false));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
          }
        } on ServerException {
          // emit(state.copyWith(isProductLoading: false));
        }
      } else if (event is _IncreaseQuantityOfProduct) {
        List<List<ProductStockModel>> productStockList =
            state.productStockList.toList(growable: false);
        if (state.productStockUpdateIndex != -1) {
          if (productStockList[state.planoGramUpdateIndex]
                      [state.productStockUpdateIndex]
                  .quantity <
              productStockList[state.planoGramUpdateIndex]
                      [state.productStockUpdateIndex]
                  .stock) {
            productStockList[state.planoGramUpdateIndex]
                    [state.productStockUpdateIndex] =
                productStockList[state.planoGramUpdateIndex]
                        [state.productStockUpdateIndex]
                    .copyWith(
                        quantity: productStockList[state.planoGramUpdateIndex]
                                    [state.productStockUpdateIndex]
                                .quantity +
                            1);
            debugPrint(
                'product quantity = ${productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].quantity}');
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          } else {
            showSnackBar(
                context: event.context,
                title: AppStrings.maxQuantityMsgString,
                bgColor: AppColors.mainColor);
          }
        }
      } else if (event is _DecreaseQuantityOfProduct) {
        List<List<ProductStockModel>> productStockList =
            state.productStockList.toList(growable: false);
        if (state.productStockUpdateIndex != -1) {
          if (productStockList[state.planoGramUpdateIndex]
                      [state.productStockUpdateIndex]
                  .quantity >
              0) {
            productStockList[state.planoGramUpdateIndex]
                    [state.productStockUpdateIndex] =
                productStockList[state.planoGramUpdateIndex]
                        [state.productStockUpdateIndex]
                    .copyWith(
                        quantity: productStockList[state.planoGramUpdateIndex]
                                    [state.productStockUpdateIndex]
                                .quantity -
                            1);
            debugPrint(
                'product quantity = ${productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].quantity}');
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          } else {}
        }
      } else if (event is _ChangeNoteOfProduct) {
        if (state.productStockUpdateIndex != -1) {
          List<List<ProductStockModel>> productStockList =
              state.productStockList.toList(growable: false);
          productStockList[state.planoGramUpdateIndex]
                  [state.productStockUpdateIndex] =
              productStockList[state.planoGramUpdateIndex]
                      [state.productStockUpdateIndex]
                  .copyWith(note: event.newNote);
          emit(state.copyWith(productStockList: productStockList));
        }
      }
    });
  }
}
