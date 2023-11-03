import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/req_model/product_sales_req_model/product_sales_req_model.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/error/exceptions.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/req_model/product_stock_verify_req_model/product_stock_verify_req_model.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';
import '../../data/model/res_model/product_sales_res_model/product_sales_res_model.dart';
import '../../data/model/res_model/product_stock_verify_res_model/product_stock_verify_res_model.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'product_sale_event.dart';

part 'product_sale_state.dart';

part 'product_sale_bloc.freezed.dart';

class ProductSaleBloc extends Bloc<ProductSaleEvent, ProductSaleState> {
  ProductSaleBloc() : super(ProductSaleState.initial()) {
    on<ProductSaleEvent>((event, emit) async {
      if (event is _GetProductSalesListEvent) {
        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfProducts) {
          return;
        }
        try {
          emit(state.copyWith(
              isShimmering: state.pageNum == 0 ? true : false,
              isLoadMore: state.pageNum == 0 ? false : true));
          final res = await DioClient(event.context).post(
              AppUrls.getSaleProductsUrl,
              data: ProductSalesReqModel(
                      pageNum: state.pageNum + 1,
                      pageLimit: AppConstants.saleProductPageLimit)
                  .toJson());
          ProductSalesResModel response = ProductSalesResModel.fromJson(res);
          if (response.status == 200) {
            List<Datum> productSaleList =
                state.productSalesList.toList(growable: true);
            productSaleList.addAll(response.data ?? []);
            List<ProductStockModel> productStockList =
                state.productStockList.toList(growable: true);
            if ((response.metaData?.totalFilteredCount ?? 0) > 0) {
              for (int i = 0; i < (response.data?.length ?? 0); i++) {
                productStockList.add(
                    ProductStockModel(productId: response.data?[i].id ?? ''));
              }
            }
            debugPrint('new product sale list len = ${productSaleList.length}');
            debugPrint(
                'new product sale stock list len = ${productStockList.length}');
            emit(state.copyWith(
                productSalesList: productSaleList,
                productStockList: productStockList,
                pageNum: state.pageNum + 1,
                isLoadMore: false,
                isShimmering: false));
            emit(state.copyWith(
                isBottomOfProducts:
                    productSaleList.length ==
                        (response.metaData?.totalFilteredCount ?? 0)
                    ? true
                        : false));
          } else {
            emit(state.copyWith(isLoadMore: false));
            showSnackBar(
                context: event.context,
                title: AppStrings.somethingWrongString,
                bgColor: AppColors.mainColor);
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
            debugPrint(
                'id = ${state.productStockList.firstWhere((productStock) => productStock.productId == event.productId).productId}\n id = ${event.productId}');
            int productStockUpdateIndex = state.productStockList.indexWhere(
                (productStock) => productStock.productId == event.productId);
            debugPrint('product stock update index = $productStockUpdateIndex');
            // debugPrint('product details res = ${response.product}');
            emit(state.copyWith(
                productDetails: response,
                productStockUpdateIndex: productStockUpdateIndex,
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
        List<ProductStockModel> productStockList =
            state.productStockList.toList(growable: false);
        if (state.productStockUpdateIndex != -1) {
          // if (productStockList[state.productStockUpdateIndex].quantity < 30) {
          productStockList[state.productStockUpdateIndex] =
              productStockList[state.productStockUpdateIndex].copyWith(
                  quantity:
                      productStockList[state.productStockUpdateIndex].quantity +
                          1);
          debugPrint(
              'product quantity = ${productStockList[state.productStockUpdateIndex].quantity}');
          emit(state.copyWith(productStockList: productStockList));
          // } else {
          //   showSnackBar(
          //       context: event.context,
          //       title: AppStrings.maxQuantityAllowString,
          //       bgColor: AppColors.mainColor);
          // }
        }
      } else if (event is _DecreaseQuantityOfProduct) {
        List<ProductStockModel> productStockList =
            state.productStockList.toList(growable: false);
        if (state.productStockUpdateIndex != -1) {
          if (productStockList[state.productStockUpdateIndex].quantity > 0) {
            productStockList[state.productStockUpdateIndex] =
                productStockList[state.productStockUpdateIndex].copyWith(
                    quantity: productStockList[state.productStockUpdateIndex]
                            .quantity -
                        1);
            debugPrint(
                'product quantity = ${productStockList[state.productStockUpdateIndex].quantity}');
            emit(state.copyWith(productStockList: productStockList));
          } else {}
        }
      } else if (event is _ChangeNoteOfProduct) {
        if (state.productStockUpdateIndex != -1) {
          List<ProductStockModel> productStockList =
              state.productStockList.toList(growable: false);
          productStockList[state.productStockUpdateIndex] =
              productStockList[state.productStockUpdateIndex]
                  .copyWith(note: event.newNote);
          emit(state.copyWith(productStockList: productStockList));
        }
      } else if (event is _VerifyProductStockEvent) {
        if (state.productStockList[state.productStockUpdateIndex].quantity ==
            0) {
          showSnackBar(
              context: event.context,
              title: AppStrings.minQuantityMsgString,
              bgColor: AppColors.mainColor);
          return;
        }
        try {
          emit(state.copyWith(isLoading: true));
          ProductStockVerifyReqModel req = ProductStockVerifyReqModel(
              quantity: state
                  .productStockList[state.productStockUpdateIndex].quantity,
              supplierId: [
                state.productDetails.product?.first.supplierSales?.supplier
                        ?.id ??
                    ''
              ],
              productId: state
                  .productStockList[state.productStockUpdateIndex].productId);
          debugPrint('verify stock req = $req');
          final res = await DioClient(event.context)
              .post(AppUrls.verifyProductStockUrl, data: req.toJson());
          ProductStockVerifyResModel response =
              ProductStockVerifyResModel.fromJson(res);
          if (response.status == 200) {
            emit(state.copyWith(isLoading: false));
            if (state.productStockList[state.productStockUpdateIndex].quantity <
                (response.data?.stock?.first.data?.productStock ?? 0)) {
              showSnackBar(
                  context: event.context,
                  title: AppStrings.doneString,
                  bgColor: AppColors.mainColor);
              Navigator.pop(event.context);
            } else {
              showSnackBar(
                  context: event.context,
                  title: response.data?.stock?.first.message ??
                      AppStrings.somethingWrongString,
                  bgColor: AppColors.redColor);
            }
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
          }
        } on ServerException {
          emit(state.copyWith(isLoading: false));
          Navigator.pop(event.context);
        }
      }
    });
  }
}
