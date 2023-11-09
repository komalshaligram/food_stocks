import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/data/model/req_model/product_sales_req_model/product_sales_req_model.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/error/exceptions.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../../data/model/req_model/insert_cart_req_model/insert_cart_req_model.dart'
    as InsertCartModel;
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/res_model/insert_cart_res_model/insert_cart_res_model.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';
import '../../data/model/res_model/product_sales_res_model/product_sales_res_model.dart';
import '../../data/model/supplier_sale_model/supplier_sale_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'home_event.dart';

part 'home_state.dart';

part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    on<HomeEvent>((event, emit) async {
      if (event is _getPreferencesDataEvent) {
        SharedPreferencesHelper preferences = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());

        debugPrint(
            'getUserImageUrl ${AppUrls.baseFileUrl}${preferences.getUserImageUrl()}');
        debugPrint(
            'getUserCompanyLogoUrl ${preferences.getUserCompanyLogoUrl()}');

        emit(state.copyWith(UserImageUrl: preferences.getUserImageUrl()));
        emit(state.copyWith(
            UserCompanyLogoUrl: preferences.getUserCompanyLogoUrl()));
      } else if (event is _GetProductSalesListEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).post(
              AppUrls.getSaleProductsUrl,
              data: ProductSalesReqModel(
                  pageNum: 1, pageLimit: AppConstants.defaultPageLimit)
                  .toJson());
          ProductSalesResModel response = ProductSalesResModel.fromJson(res);
          if (response.status == 200) {
            List<ProductStockModel> productStockList = [];
            productStockList.addAll(response.data?.map((saleProduct) =>
                ProductStockModel(
                    productId: saleProduct.id ?? '',
                    stock: saleProduct.numberOfUnit ?? 0)) ??
                []);
            // if ((response.metaData?.totalFilteredCount ?? 0) > 0) {
            //   for (int i = 0; i < (response.data?.length ?? 0); i++) {
            //     productStockList.add(ProductStockModel(
            //         productId: response.data?[i].id ?? '',
            //         stock: response.data?[i].numberOfUnit ?? 0));
            //   }
            // }
            debugPrint('stock list len = ${productStockList.length}');
            emit(state.copyWith(
                productSalesList: response,
                productStockList: productStockList,
                isShimmering: false));
          } else {
            showSnackBar(
                context: event.context,
                title: AppStrings.somethingWrongString,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
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
            debugPrint(
                'product stock = ${state.productStockList[productStockUpdateIndex].stock}');
            List<ProductSupplierModel> supplierList = [];
            debugPrint(
                'response supplier id = ${response.product?.first.supplierSales?.supplier?.id ?? ''}');
            debugPrint(
                'supplier id = ${state.productStockList[productStockUpdateIndex].productSupplierIds}');
            supplierList.addAll(response.product
                    ?.map((supplier) => ProductSupplierModel(
                          supplierId:
                              supplier.supplierSales?.supplier?.id ?? '',
                          companyName:
                              supplier.supplierSales?.supplier?.companyName ??
                                  '',
                          selectedIndex: (supplier
                                          .supplierSales?.supplier?.id ??
                                      '') ==
                                  (state
                                          .productStockList[
                                              productStockUpdateIndex]
                                          .productSupplierIds
                                          .isNotEmpty
                                      ? state
                                          .productStockList[
                                              productStockUpdateIndex]
                                          .productSupplierIds
                                          .first
                                      : '')
                              ? supplier.supplierSales?.supplier?.sale?.indexOf(
                                      supplier.supplierSales?.supplier?.sale
                                              ?.firstWhere((sale) =>
                                                  sale.saleId ==
                                                  state
                                                      .productStockList[
                                                          productStockUpdateIndex]
                                                      .productSaleId) ??
                                          Sale()) ??
                                  -1
                              : -1,
                          supplierSales: supplier.supplierSales?.supplier?.sale
                                  ?.map((sale) => SupplierSaleModel(
                                      saleId: sale.saleId ?? '',
                                      saleName: sale.salesName ?? '',
                                      saleDescription:
                                          sale.salesDescription ?? '',
                                      saleDiscount:
                                          sale.discountPercentage?.toDouble() ??
                                              0.0))
                                  .toList() ??
                              [],
                        ))
                    .toList() ??
                []);
            debugPrint('response list = ${response.product?.length}');
            debugPrint('supplier list = ${supplierList.length}');
            debugPrint(
                'supplier select index = ${supplierList.map((e) => e.selectedIndex)}');
            emit(state.copyWith(
                productDetails: response.product ?? [],
                productStockUpdateIndex: productStockUpdateIndex,
                productSupplierList: supplierList,
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
          if (productStockList[state.productStockUpdateIndex].quantity <
              productStockList[state.productStockUpdateIndex].stock) {
            productStockList[state.productStockUpdateIndex] =
                productStockList[state.productStockUpdateIndex].copyWith(
                    quantity: productStockList[state.productStockUpdateIndex]
                        .quantity +
                        1);
            debugPrint(
                'product quantity = ${productStockList[state.productStockUpdateIndex].quantity}');
            emit(state.copyWith(productStockList: productStockList));
          } else {
            showSnackBar(
                context: event.context,
                title: AppStrings.maxQuantityMsgString,
                bgColor: AppColors.mainColor);
          }
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
      } else if (event is _ChangeSupplierSelectionExpansionEvent) {
        emit(state.copyWith(
            isSelectSupplier:
                event.isSelectSupplier ?? !state.isSelectSupplier));
        debugPrint('supplier selection : ${state.isSelectSupplier}');
      } else if (event is _SupplierSelectionEvent) {
        debugPrint(
            'supplier[${event.supplierIndex}][${event.supplierSaleIndex}]');
        if (event.supplierIndex >= 0) {
          List<ProductSupplierModel> supplierList =
              state.productSupplierList.toList(growable: true);
          if (event.supplierSaleIndex >= 0) {
            //sale avail then supplier sale selection
            List<ProductStockModel> productStockList =
                state.productStockList.toList(growable: true);
            productStockList[state.productStockUpdateIndex] =
                productStockList[state.productStockUpdateIndex].copyWith(
                    productSupplierIds:
                        supplierList[event.supplierIndex].selectedIndex ==
                                event.supplierSaleIndex
                            ? []
                            : [supplierList[event.supplierIndex].supplierId],
                    productSaleId:
                        supplierList[event.supplierIndex].selectedIndex ==
                                event.supplierSaleIndex
                            ? ''
                            : supplierList[event.supplierIndex]
                                .supplierSales[event.supplierSaleIndex]
                                .saleId);
            debugPrint(
                'stock supplier id = ${productStockList[state.productStockUpdateIndex].productSupplierIds}');
            debugPrint(
                'stock supplier sale id = ${productStockList[state.productStockUpdateIndex].productSaleId}');
            if (supplierList[event.supplierIndex].selectedIndex ==
                event.supplierSaleIndex) {}
            supplierList[event.supplierIndex] =
                supplierList[event.supplierIndex].copyWith(
                    selectedIndex:
                        supplierList[event.supplierIndex].selectedIndex ==
                                event.supplierSaleIndex
                            ? -1
                            : event.supplierSaleIndex);
            debugPrint(
                'supplier[${event.supplierIndex}] = ${supplierList[event.supplierIndex].selectedIndex}');
            emit(state.copyWith(
                productSupplierList: supplierList,
                productStockList: productStockList));
          } else {
            //no sale avail then supplier base price selection
          }
        }
      } else if (event is _AddToCartProductEvent) {
        if (state.productStockList[state.productStockUpdateIndex]
            .productSupplierIds.isEmpty) {
          showSnackBar(
              context: event.context,
              title: AppStrings.selectSupplierMsgString,
              bgColor: AppColors.mainColor);
          return;
        }
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
          InsertCartModel.InsertCartReqModel req =
              InsertCartModel.InsertCartReqModel(products: [
            InsertCartModel.Product(
                productId: state
                    .productStockList[state.productStockUpdateIndex].productId,
                quantity: state
                    .productStockList[state.productStockUpdateIndex].quantity,
                supplierId: state
                    .productStockList[state.productStockUpdateIndex]
                    .productSupplierIds
                    .first,
                saleId: state.productStockList[state.productStockUpdateIndex]
                    .productSaleId)
          ]);
          debugPrint('insert cart req = $req');
          SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
              prefs: await SharedPreferences.getInstance());

          debugPrint(
              'insert cart url1 = ${AppUrls.insertProductInCartUrl}${preferencesHelper.getCartId()}');
          debugPrint(
              'insert cart url1 auth = ${preferencesHelper.getAuthToken()}');
          final res = await DioClient(event.context).post(
              '${AppUrls.insertProductInCartUrl}${preferencesHelper.getCartId()}',
              data: req.toJson(),
              options: Options(
                headers: {
                  HttpHeaders.authorizationHeader:
                      'Bearer ${preferencesHelper.getAuthToken()}',
                },
              ));
          InsertCartResModel response = InsertCartResModel.fromJson(res);
          if (response.status == 201) {
            emit(state.copyWith(isLoading: false));
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.addCartSuccessString,
                bgColor: AppColors.mainColor);
            Navigator.pop(event.context);
          } else {
            emit(state.copyWith(isLoading: false));
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
          }
        } on ServerException {
          debugPrint('url1 = ');
          emit(state.copyWith(isLoading: false));
        }
      }
    });
  }
}
