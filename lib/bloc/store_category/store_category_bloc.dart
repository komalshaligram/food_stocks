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
          add(_GetPlanogramProductsEvent(context: event.context));
        }
      } else if (event is _GetPlanogramProductsEvent) {
        debugPrint('planogram1 = ${state.isLoadMore}');
        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfPlanograms) {
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
            List<Datum> planogramsList =
                state.planogramsList.toList(growable: true);
            planogramsList.addAll(response.data ?? []);
            List<List<ProductStockModel>> productStockList =
                state.productStockList.toList(growable: true);
            for (int i = 0; i < (response.data?.length ?? 0); i++) {
              List<ProductStockModel> stockList = [];
              stockList.addAll(response.data![i].planogramproducts?.map(
                      (product) => ProductStockModel(
                          productId: product.id ?? '',
                          stock: product.productStock ?? 0)) ??
                  []);
              debugPrint('stockList[$i] = $stockList');
              productStockList.addAll([stockList]);
            }
            debugPrint('planogram12 = ${state.isLoadMore}');
            debugPrint('planogram list = ${planogramsList.length}');
            debugPrint('planogram stock list = ${productStockList.length}');
            emit(state.copyWith(
                planogramsList: planogramsList,
                productStockList: productStockList,
                pageNum: state.pageNum + 1,
                isShimmering: false,
                isLoadMore: false));
            emit(state.copyWith(
                isBottomOfPlanograms: planogramsList.length ==
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
      }
    });
  }
}
