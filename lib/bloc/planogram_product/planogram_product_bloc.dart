import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/error/exceptions.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../../data/model/req_model/insert_cart_req_model/insert_cart_req_model.dart'
    as InsertCartModel;
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/res_model/insert_cart_res_model/insert_cart_res_model.dart';
import '../../data/model/res_model/planogram_res_model/planogram_res_model.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';
import '../../data/model/supplier_sale_model/supplier_sale_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'planogram_product_event.dart';

part 'planogram_product_state.dart';

part 'planogram_product_bloc.freezed.dart';

class PlanogramProductBloc
    extends Bloc<PlanogramProductEvent, PlanogramProductState> {
  PlanogramProductBloc() : super(PlanogramProductState.initial()) {
    on<PlanogramProductEvent>((event, emit) async {
      if (event is _GetPlanogramProductsEvent) {
        debugPrint('Planogram details = ${event.planogram.planogramproducts}');
        List<ProductStockModel> productStockList = [];
        productStockList = event.planogram.planogramproducts
            ?.map((product) => ProductStockModel(
            productId: product.id ?? '',
            stock: product.productStock ?? 0))
            .toList() ??
            [];
        emit(state.copyWith(
            planogramName: event.planogram.planogramName ?? '',
            planogramProductList: event.planogram.planogramproducts ?? [],
            productStockList: productStockList));
      } else if (event is _GetProductDetailsEvent) {
        debugPrint('product details id = ${event.productId}');
        try {
          emit(state.copyWith(isProductLoading: true, isSelectSupplier: false));
          final res = await DioClient(event.context).post(
              AppUrls.getProductDetailsUrl,
              data: ProductDetailsReqModel(params: event.productId).toJson());
          ProductDetailsResModel response =
              ProductDetailsResModel.fromJson(res);
          if (response.status == 200) {
            List<ProductStockModel> productStockList =
                state.productStockList.toList(growable: true);
            debugPrint(
                'id = ${state.productStockList.firstWhere((productStock) => productStock.productId == event.productId).productId}\n id = ${event.productId}');
            int productStockUpdateIndex = state.productStockList.indexWhere(
                (productStock) => productStock.productId == event.productId);
            productStockList[productStockUpdateIndex] =
                productStockList[productStockUpdateIndex]
                    .copyWith(stock: response.product?.first.numberOfUnit ?? 0);
            debugPrint('product stock update index = $productStockUpdateIndex');
            debugPrint(
                'product stock = ${productStockList[productStockUpdateIndex].stock}');
            List<ProductSupplierModel> supplierList = [];
            debugPrint(
                'supplier id = ${state.productStockList[productStockUpdateIndex].productSupplierIds}');
            supplierList.addAll(response.product?.first.supplierSales
                    ?.map((supplier) => ProductSupplierModel(
                          supplierId: supplier.supplierId ?? '',
                          companyName: supplier.supplierCompanyName ?? '',
                          selectedIndex: (supplier.supplierId ?? '') ==
                                  (state
                                          .productStockList[
                                              productStockUpdateIndex]
                                          .productSupplierIds
                                          .isNotEmpty
                                      ? state
                                          .productStockList[
                                              productStockUpdateIndex]
                                          .productSupplierIds
                                      : '')
                              ? supplier.saleProduct?.indexOf(
                                      supplier.saleProduct?.firstWhere((sale) =>
                                              sale.saleId ==
                                              state
                                                  .productStockList[
                                                      productStockUpdateIndex]
                                                  .productSaleId) ??
                                          SaleProduct()) ??
                                  -1
                              : -1,
                          supplierSales: supplier.saleProduct
                                  ?.map((sale) => SupplierSaleModel(
                                      saleId: sale.saleId ?? '',
                                      saleName: sale.saleName ?? '',
                                      saleDescription:
                                          parse(sale.salesDescription ?? '')
                                                  .body
                                                  ?.text ??
                                              '',
                                      salePrice:
                                          double.parse(sale.price ?? '0.0'),
                                      saleDiscount: double.parse(
                                          sale.discountPercentage ?? '0.0')))
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
                bgColor: AppColors.redColor);
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
          // if (event.supplierSaleIndex >= 0) {
          //sale avail then supplier sale selection
          List<ProductStockModel> productStockList =
              state.productStockList.toList(growable: true);
          productStockList[state.productStockUpdateIndex] =
              productStockList[state.productStockUpdateIndex].copyWith(
                  productSupplierIds:
                      supplierList[event.supplierIndex].selectedIndex ==
                              event.supplierSaleIndex
                          ? ''
                          : supplierList[event.supplierIndex].supplierId,
                  totalPrice: event.supplierSaleIndex == -2
                      ? supplierList[event.supplierIndex].basePrice
                      : supplierList[event.supplierIndex].selectedIndex ==
                              event.supplierSaleIndex
                          ? supplierList[event.supplierIndex]
                              .supplierSales[event.supplierSaleIndex]
                              .salePrice
                          : /*supplierList[event.supplierIndex]
                                    .supplierSales
                                    .isEmpty
                                ? supplierList[event.supplierIndex].basePrice
                                : */
                          supplierList[event.supplierIndex]
                              .supplierSales[event.supplierSaleIndex]
                              .salePrice,
                  productSaleId: event.supplierSaleIndex == -2
                      ? ''
                      : supplierList[event.supplierIndex].selectedIndex ==
                              event.supplierSaleIndex
                          ? ''
                          : supplierList[event.supplierIndex]
                              .supplierSales[event.supplierSaleIndex]
                              .saleId);
          debugPrint(
              'stock supplier id = ${productStockList[state.productStockUpdateIndex].productSupplierIds}');
          debugPrint(
              'stock supplier sale id = ${productStockList[state.productStockUpdateIndex].productSaleId}');
          supplierList[event.supplierIndex] = supplierList[event.supplierIndex]
              .copyWith(
                  selectedIndex: event.supplierSaleIndex == -2
                      ? -2
                      : supplierList[event.supplierIndex].selectedIndex ==
                              event.supplierSaleIndex
                          ? -1
                          : event.supplierSaleIndex);
          debugPrint(
              'supplier[${event.supplierIndex}] = ${supplierList[event.supplierIndex].selectedIndex}');
          debugPrint('supplier list = ${supplierList[event.supplierIndex]}');
          debugPrint(
              'supplier stock list = ${productStockList[state.productStockUpdateIndex]}');
          emit(state.copyWith(
              productSupplierList: supplierList,
              productStockList: productStockList));
          // } else {
          //   //no sale avail then supplier base price selection
          // }
        }
      } else if (event is _AddToCartProductEvent) {
        if (state.productStockList[state.productStockUpdateIndex]
            .productSupplierIds.isEmpty) {
          showSnackBar(
              context: event.context,
              title: AppStrings.selectSupplierMsgString,
              bgColor: AppColors.redColor);
          return;
        }
        if (state.productStockList[state.productStockUpdateIndex].quantity ==
            0) {
          showSnackBar(
              context: event.context,
              title: AppStrings.minQuantityMsgString,
              bgColor: AppColors.redColor);
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
                    .productSupplierIds,
                note: state.productStockList[state.productStockUpdateIndex].note
                        .isEmpty
                    ? null
                    : state
                        .productStockList[state.productStockUpdateIndex].note,
                saleId: state.productStockList[state.productStockUpdateIndex]
                        .productSaleId.isEmpty
                    ? null
                    : state.productStockList[state.productStockUpdateIndex]
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
            add(PlanogramProductEvent.setCartCountEvent());
            emit(state.copyWith(isLoading: false));
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.addCartSuccessString,
                bgColor: AppColors.mainColor);
            Navigator.pop(event.context);
          } else if (response.status == 403) {
            emit(state.copyWith(isLoading: false));
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.mainColor);
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
      } else if (event is _SetCartCountEvent) {
        SharedPreferencesHelper preferences = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());
        await preferences.setCartCount(count: preferences.getCartCount() + 1);
        debugPrint('cart count = ${preferences.getCartCount()}');
      }
    });
  }
}
