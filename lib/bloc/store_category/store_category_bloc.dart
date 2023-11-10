import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/error/exceptions.dart';
import 'package:food_stock/data/model/req_model/planogram_req_model/planogram_req_model.dart';
import 'package:food_stock/data/model/req_model/product_subcategories_req_model/product_subcategories_req_model.dart';
import 'package:food_stock/data/model/res_model/planogram_res_model/planogram_res_model.dart';
import 'package:food_stock/data/model/res_model/product_subcategories_res_model/product_subcategories_res_model.dart';
import 'package:food_stock/repository/dio_client.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../../data/model/req_model/insert_cart_req_model/insert_cart_req_model.dart'
    as InsertCartModel;
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/res_model/insert_cart_res_model/insert_cart_res_model.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';
import '../../data/model/supplier_sale_model/supplier_sale_model.dart';
import '../../data/storage/shared_preferences_helper.dart';

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
      } else if (event is _ChangeSubCategoryOrPlanogramEvent) {
        emit(state.copyWith(isSubCategory: event.isSubCategory));
      } else if (event is _ChangeCategoryDetailsEvent) {
        emit(state.copyWith(
            categoryId: event.categoryId,
            categoryName: event.categoryName,
            productStockList: [
              [ProductStockModel(productId: '')]
            ]));
        add(StoreCategoryEvent.getSubCategoryListEvent(context: event.context));
      } else if (event is _ChangeSubCategoryDetailsEvent) {
        debugPrint(
            'sub category ${event.subCategoryId}(${event.subCategoryName})');
        if (event.subCategoryId != state.subCategoryId) {
          emit(state.copyWith(
            subCategoryId: event.subCategoryId,
            subCategoryName: event.subCategoryName,
            planoGramsList: [],
            productStockList: [
              state.productStockList.isEmpty
                  ? [ProductStockModel(productId: '')]
                  : state.productStockList.first
            ],
            productStockUpdateIndex: -1,
            planoGramUpdateIndex: -1,
            planogramPageNum: 0,
            isBottomOfPlanoGrams: false,
          ));
          add(StoreCategoryEvent.getPlanoGramProductsEvent(
              context: event.context));
        }
        emit(state.copyWith(isSubCategory: false));
      } else if (event is _GetSubCategoryListEvent) {
        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfPlanoGrams) {
          return;
        }
        try {
          emit(state.copyWith(
              isSubCategoryShimmering:
              state.subCategoryPageNum == 0 ? true : false,
              isLoadMore: state.subCategoryPageNum == 0 ? false : true));
          final res = await DioClient(event.context).post(
              AppUrls.getSubCategoriesUrl,
              data: ProductSubcategoriesReqModel(
                  parentCategoryId: state.categoryId,
                  pageNum: state.subCategoryPageNum + 1,
                  pageLimit: AppConstants.productSubCategoryPageLimit)
                  .toJson());
          ProductSubcategoriesResModel response =
          ProductSubcategoriesResModel.fromJson(res);
          if (response.status == 200) {
            List<SubCategory> subCategoryList =
            state.subCategoryList.toList(growable: true);
            subCategoryList.addAll(response.data?.subCategories ?? []);
            debugPrint('new sub category List = ${subCategoryList.length}');
            emit(state.copyWith(
              subCategoryList: subCategoryList,
              subCategoryPageNum: state.subCategoryPageNum + 1,
              isSubCategoryShimmering: false,
              isLoadMore: false,
            ));
            emit(state.copyWith(
                isBottomOfSubCategory:
                subCategoryList.length == (response.data?.totalRecords ?? 0)
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
      } else if (event is _GetPlanoGramProductsEvent) {
        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfPlanoGrams) {
          return;
        }
        try {
          emit(state.copyWith(
              isPlanogramShimmering: state.planogramPageNum == 0 ? true : false,
              isLoadMore: state.planogramPageNum == 0 ? false : true));

          PlanogramReqModel planogramReqModel = PlanogramReqModel(
              pageNum: state.planogramPageNum + 1,
              pageLimit: AppConstants.planogramProductPageLimit,
              sortOrder: AppStrings.ascendingString,
              sortField: AppStrings.planogramSortFieldString,
              categoryId: state.categoryId,
              subCategoryId: state.subCategoryId);
          Map<String, dynamic> req = planogramReqModel.toJson();
          req.removeWhere((key, value) {
            if (value != null) {
              debugPrint("[$key] = $value");
            }
            return value == null;
          });
          debugPrint('sub category req = $req');
          final res = await DioClient(event.context)
              .post(AppUrls.getPlanogramProductsUrl, data: req);
          PlanogramResModel response = PlanogramResModel.fromJson(res);
          if (response.status == 200) {
            List<Datum> planoGramsList =
                state.planoGramsList.toList(growable: true);
            planoGramsList.addAll(response.data ?? []);
            List<List<ProductStockModel>> productStockList =
                state.productStockList.toList(growable: true);
            // List<ProductStockModel> barcodeStock = [];
            // if(productStockList.isNotEmpty) {
            //   barcodeStock = productStockList.removeLast();
            //   debugPrint('last barcode = $barcodeStock');
            // }
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
            // productStockList.add(barcodeStock.isNotEmpty ? barcodeStock : [ProductStockModel(productId: '')]);
            debugPrint('planogram list = ${planoGramsList.length}');
            debugPrint('planogram stock list = ${productStockList.length}');
            emit(state.copyWith(
                planoGramsList: planoGramsList,
                productStockList: productStockList,
                planogramPageNum: state.planogramPageNum + 1,
                isPlanogramShimmering: false,
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
            if (productStockUpdateIndex == -1 && (event.isBarcode ?? false)) {
              List<List<ProductStockModel>> productStockList =
                  state.productStockList.toList(growable: false);
              productStockList.first = [
                productStockList.first.first.copyWith(
                    productId: event.productId,
                    stock: response.product?.first.numberOfUnit ?? 0)
              ];
              emit(state.copyWith(productStockList: productStockList));
              productStockUpdateIndex = 0;
              /*productStockList[planoGramIndex].indexOf(productStockList[planoGramIndex].last);*/
              debugPrint(
                  'new index = ${event.planoGramIndex},$productStockUpdateIndex');
            }
            productStockList[event.planoGramIndex][productStockUpdateIndex] =
                productStockList[event.planoGramIndex][productStockUpdateIndex]
                    .copyWith(stock: response.product?.first.numberOfUnit ?? 0);
            debugPrint(
                'product stock update index = ${state.planoGramsList[event.planoGramIndex - 1].planogramName}[${state.planoGramsList[event.planoGramIndex - 1].planogramproducts?[productStockUpdateIndex].id}]');
            debugPrint(
                'stock ${productStockList[event.planoGramIndex][productStockUpdateIndex].stock}');
            List<ProductSupplierModel> supplierList = [];
            debugPrint(
                'response supplier id = ${response.product?.first.supplierSales?.supplier?.id ?? ''}');
            debugPrint(
                'supplier id = ${state.productStockList[event.planoGramIndex][productStockUpdateIndex].productSupplierIds}');
            supplierList.addAll(response.product
                    ?.map((supplier) => ProductSupplierModel(
                          supplierId:
                              supplier.supplierSales?.supplier?.id ?? '',
                          companyName:
                              supplier.supplierSales?.supplier?.companyName ??
                                  '',
                          selectedIndex: (supplier.supplierSales?.supplier?.id ?? '') ==
                                  (state
                                          .productStockList[event.planoGramIndex]
                                              [productStockUpdateIndex]
                                          .productSupplierIds
                                          .isNotEmpty
                                      ? state
                                          .productStockList[event.planoGramIndex]
                                              [productStockUpdateIndex]
                                          .productSupplierIds
                                          .first
                                      : '')
                              ? supplier.supplierSales?.supplier?.sale?.indexOf(
                                      supplier.supplierSales?.supplier?.sale
                                              ?.firstWhere((sale) =>
                                                  sale.saleId ==
                                                  state
                                                      .productStockList[event.planoGramIndex]
                                                          [productStockUpdateIndex]
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
            debugPrint('supplier list = ${supplierList}');
            debugPrint(
                'supplier select index = ${supplierList.map((e) => e.selectedIndex)}');
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(
                productDetails: response,
                productStockList: productStockList,
                productStockUpdateIndex: productStockUpdateIndex,
                productSupplierList: supplierList,
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
            List<List<ProductStockModel>> productStockList =
                state.productStockList.toList(growable: true);
            productStockList[state.planoGramUpdateIndex]
                    [state.productStockUpdateIndex] =
                productStockList[state.planoGramUpdateIndex]
                        [state.productStockUpdateIndex]
                    .copyWith(
                        productSupplierIds: supplierList[event.supplierIndex]
                                    .selectedIndex ==
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
                'stock supplier id = ${productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].productSupplierIds}');
            debugPrint(
                'stock supplier sale id = ${productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].productSaleId}');
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
        if (state
            .productStockList[state.planoGramUpdateIndex]
                [state.productStockUpdateIndex]
            .productSupplierIds
            .isEmpty) {
          showSnackBar(
              context: event.context,
              title: AppStrings.selectSupplierMsgString,
              bgColor: AppColors.mainColor);
          return;
        }
        if (state
                .productStockList[state.planoGramUpdateIndex]
                    [state.productStockUpdateIndex]
                .quantity ==
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
                    .productStockList[state.planoGramUpdateIndex]
                        [state.productStockUpdateIndex]
                    .productId,
                quantity: state
                    .productStockList[state.planoGramUpdateIndex]
                        [state.productStockUpdateIndex]
                    .quantity,
                supplierId: state
                    .productStockList[state.planoGramUpdateIndex]
                        [state.productStockUpdateIndex]
                    .productSupplierIds
                    .first,
                saleId: state
                    .productStockList[state.planoGramUpdateIndex]
                        [state.productStockUpdateIndex]
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
      } else if (event is _GetScanProductDetailsEvent) {}
    });
  }
}
