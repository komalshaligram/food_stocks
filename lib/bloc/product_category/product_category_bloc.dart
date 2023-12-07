import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/error/exceptions.dart';
import '../../data/model/req_model/product_categories_req_model/product_categories_req_model.dart';
import '../../data/model/res_model/product_categories_res_model/product_categories_res_model.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'product_category_event.dart';

part 'product_category_state.dart';

part 'product_category_bloc.freezed.dart';

class ProductCategoryBloc
    extends Bloc<ProductCategoryEvent, ProductCategoryState> {
  ProductCategoryBloc() : super(ProductCategoryState.initial()) {
    on<ProductCategoryEvent>((event, emit) async {
      if (event is _GetProductCategoriesListEvent) {
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
              AppUrls.getProductCategoriesUrl,
              data: ProductCategoriesReqModel(
                      pageNum: state.pageNum + 1,
                      pageLimit: AppConstants.productCategoryPageLimit,
                      search: state.search)
                  .toJson());
          ProductCategoriesResModel response =
              ProductCategoriesResModel.fromJson(res);
          debugPrint('product categories = ${response.data?.categories}');
          if (response.status == 200) {
            List<Category> productCategoryList =
                state.productCategoryList.toList(growable: true);
            productCategoryList.addAll(response.data?.categories ?? []);
            debugPrint('new category list = ${productCategoryList.length}');
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
            showSnackBar(
                context: event.context,
                title: response.message ?? '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                bgColor: AppColors.mainColor);
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
      } else if (event is _SetSearchEvent) {
        emit(state.copyWith(
            search: event.search,
            isFromStoreCategory: event.isFromStoreCategory));
      }
    });
  }
}
