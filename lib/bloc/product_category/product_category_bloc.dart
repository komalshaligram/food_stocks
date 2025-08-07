import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/error/exceptions.dart';
import '../../data/model/req_model/product_categories_req_model/product_categories_req_model.dart';
import '../../data/model/res_model/product_categories_res_model/product_categories_res_model.dart';
import '../../data/model/search_model/search_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';

part 'product_category_event.dart';

part 'product_category_state.dart';

part 'product_category_bloc.freezed.dart';

class ProductCategoryBloc
    extends Bloc<ProductCategoryEvent, ProductCategoryState> {
  ProductCategoryBloc() : super(ProductCategoryState.initial()) {
    on<ProductCategoryEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
      SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      printData("come her categories");

      if (event is _getProductCategoriesListEvent) {
        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfCategories) {
          return;
        }
        try {
          emit(state.copyWith(
              isShimmering: state.pageNum == 0 ? true : false,
              isLoadMore: state.pageNum == 0 ? false : true));
          final res = await DioClient(event.context).post(
              AppUrlEndPoints.getProductCategoriesUrl,
              data: ProductCategoriesReqModel(
                      pageNum: state.pageNum + 1,
                      pageLimit: AppConstants.productCategoryPageLimit,
                      search: state.reqSearch)
                  .toJson());
          ProductCategoriesResModel response =
              ProductCategoriesResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            List<Category> productCategoryList =
                state.productCategoryList.toList(growable: true);
            productCategoryList.addAll(response.data?.categories ?? []);
            emit(state.copyWith(
                productCategoryList: productCategoryList,
                pageNum: state.pageNum + 1,
                isLoadMore: false,
                isShimmering: false));
            emit(state.copyWith(
                isBottomOfCategories: productCategoryList.length ==
                        (response.data?.totalRecords ?? 0)
                    ? true
                    : false));
          } else {
            emit(state.copyWith(isLoadMore: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                type: SnackBarType.success);
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
        state.refreshController.refreshCompleted();
        state.refreshController.loadComplete();
      }
      else if (event is _refreshListEvent) {
        emit(state.copyWith(
            pageNum: 0, productCategoryList: [], isBottomOfCategories: false));
        add(ProductCategoryEvent.getProductCategoriesListEvent(
            context: event.context));
      }
      else if (event is _setSearchNavEvent) {
        emit(state.copyWith(
            reqSearch: event.reqSearch,
            isFromStoreCategory: event.isFromStoreCategory));
      }
      else if (event is _updateGlobalSearchEvent) {
        emit(
            state.copyWith(search: event.search, searchList: event.searchList));
      }
      else if (event is _getCartCountEvent) {
        emit(
            state.copyWith(cartCount: preferencesHelper.getCartCount()));
      }

    });
  }
}
