import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/error/exceptions.dart';
import 'package:food_stock/data/model/product_supplier_model/product_supplier_model.dart';
import 'package:food_stock/data/model/req_model/company_req_model/company_req_model.dart';
import 'package:food_stock/data/model/req_model/global_search_req_model/global_search_req_model.dart';
import 'package:food_stock/data/model/req_model/insert_cart_req_model/insert_cart_req_model.dart'
    as InsertCartModel;
import 'package:food_stock/data/model/req_model/previous_order_products_req_model/previous_order_products_req_model.dart';
import 'package:food_stock/data/model/req_model/product_categories_req_model/product_categories_req_model.dart';
import 'package:food_stock/data/model/req_model/product_sales_req_model/product_sales_req_model.dart';
import 'package:food_stock/data/model/req_model/recommendation_products_req_model/recommendation_products_req_model.dart';
import 'package:food_stock/data/model/req_model/suppliers_req_model/suppliers_req_model.dart';
import 'package:food_stock/data/model/res_model/company_res_model/company_res_model.dart';
import 'package:food_stock/data/model/res_model/insert_cart_res_model/insert_cart_res_model.dart';
import 'package:food_stock/data/model/res_model/product_categories_res_model/product_categories_res_model.dart';
import 'package:food_stock/data/model/res_model/product_sales_res_model/product_sales_res_model.dart';
import 'package:food_stock/data/model/search_model/search_model.dart';
import 'package:food_stock/data/model/supplier_sale_model/supplier_sale_model.dart';
import 'package:food_stock/data/storage/shared_preferences_helper.dart';
import 'package:food_stock/repository/dio_client.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/req_model/update_cart/update_cart_req_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/global_search_res_model/global_search_res_model.dart';
import '../../data/model/res_model/previous_order_products_res_model/previous_order_products_res_model.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';
import '../../data/model/res_model/recommendation_products_res_model/recommendation_products_res_model.dart';
import '../../data/model/res_model/suppliers_res_model/suppliers_res_model.dart';
import '../../data/model/res_model/update_cart_res/update_cart_res_model.dart';
import '../../ui/utils/themes/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../ui/utils/themes/app_strings.dart';

part 'store_event.dart';

part 'store_state.dart';

part 'store_bloc.freezed.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  bool _isProductInCart = false;
  String _cartProductId = '';
  int _productQuantity = 0;

  StoreBloc() : super(StoreState.initial()) {
    on<StoreEvent>((event, emit) async {
      if (event is _ChangeCategoryExpansion) {
        if (event.isOpened != null) {
          emit(state.copyWith(isCategoryExpand: event.isOpened ?? false));
        } else {
          emit(state.copyWith(isCategoryExpand: !state.isCategoryExpand));
        }
      } else if (event is _ChangeSupplierSelectionExpansionEvent) {
        emit(state.copyWith(
            isSelectSupplier:
                event.isSelectSupplier ?? !state.isSelectSupplier));
        debugPrint('supplier selection : ${state.isSelectSupplier}');
      } else if (event is _GetProductCategoriesListEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).post(
              AppUrls.getProductCategoriesUrl,
              data: ProductCategoriesReqModel(
                      pageNum: 1, pageLimit: AppConstants.searchPageLimit)
                  .toJson());
          ProductCategoriesResModel response =
              ProductCategoriesResModel.fromJson(res);
          debugPrint('product categories = ${response.data?.categories}');
          if (response.status == 200) {
            List<SearchModel> searchList = [];
            searchList.addAll(response.data?.categories?.map((category) =>
                    SearchModel(
                        searchId: category.id ?? '',
                        name: category.categoryName ?? '',
                        searchType: SearchTypes.category,
                        image: category.categoryImage ?? '')) ??
                []);
            debugPrint('store search list = ${searchList.length}');
            emit(state.copyWith(
                productCategoryList: response.data?.categories ?? [],
                searchList: searchList,
                isShimmering: false));
          } else {
            emit(state.copyWith(isShimmering: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        'something_is_wrong_try_again',
                    event.context),
                type: SnackBarType.SUCCESS);
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      } else if (event is _ChangeSearchListEvent) {
        emit(state.copyWith(searchList: event.newSearchList));
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
            List<ProductSale> saleProductsList =
                response.data?.toList(growable: true) ?? [];
            // saleProductsList.removeWhere(
            //     (sale) => sale.endDate?.isBefore(DateTime.now()) ?? true);
            debugPrint('sale Products = ${saleProductsList.length}');
            debugPrint('sale Products = ${response.data?.length}');
            List<ProductStockModel> productStockList =
                state.productStockList.toList(growable: true);
            ProductStockModel barcodeStock = productStockList.removeLast();
            productStockList.addAll(response.data?.map((saleProduct) =>
                    ProductStockModel(
                        productId: saleProduct.id ?? '',
                        stock: int.parse(saleProduct.numberOfUnit ?? '0'))) ??
                []);
            productStockList.add(barcodeStock);
            emit(state.copyWith(
                productSalesList: response.data ?? [],
                productStockList: productStockList,
                isShimmering: false));
          } else {
            emit(state.copyWith(isShimmering: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                type: SnackBarType.SUCCESS);
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      } else if (event is _GetRecommendationProductsListEvent) {
        try {
          SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
              prefs: await SharedPreferences.getInstance());
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).post(
              AppUrls.getRecommendationProductsUrl,
              data: RecommendationProductsReqModel(
                      pageNum: 1, pageLimit: AppConstants.defaultPageLimit)
                  .toJson(),
              options: Options(
                headers: {
                  HttpHeaders.authorizationHeader:
                      'Bearer ${preferencesHelper.getAuthToken()}',
                },
              ));
          RecommendationProductsResModel response =
              RecommendationProductsResModel.fromJson(res);
          if (response.status == 200) {
            List<ProductStockModel> productStockList =
                state.productStockList.toList(growable: true);
            ProductStockModel barcodeStock = productStockList.removeLast();
            productStockList.addAll(response.data?.map(
                    (recommendationProduct) => ProductStockModel(
                        productId: recommendationProduct.id ?? '',
                        stock: recommendationProduct.productStock ?? 0)) ??
                []);
            productStockList.add(barcodeStock);
            emit(state.copyWith(
                recommendedProductsList: response.data ?? [],
                productStockList: productStockList,
                isShimmering: false));
          } else {
            emit(state.copyWith(isShimmering: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                type: SnackBarType.SUCCESS);
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      } else if (event is _GetSuppliersListEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).post(
              AppUrls.getSuppliersUrl,
              data: SuppliersReqModel(
                      pageNum: 1, pageLimit: AppConstants.defaultPageLimit)
                  .toJson());
          SuppliersResModel response = SuppliersResModel.fromJson(res);
          debugPrint('suppliers = ${response.data}');
          if (response.status == 200) {
            emit(state.copyWith(suppliersList: response, isShimmering: false));
          } else {
            emit(state.copyWith(isShimmering: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        'something_is_wrong_try_again',
                    event.context),
                type: SnackBarType.SUCCESS);
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      } else if (event is _GetCompaniesListEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).post(
              AppUrls.getCompaniesUrl,
              data: CompanyReqModel(
                      pageNum: 1, pageLimit: AppConstants.companyPageLimit)
                  .toJson());
          CompanyResModel response = CompanyResModel.fromJson(res);
          debugPrint('companies = ${response.data}');
          if (response.status == 200) {
            emit(state.copyWith(
                companiesList: response.data?.brandList ?? [],
                isShimmering: false));
          } else {
            emit(state.copyWith(isShimmering: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        'something_is_wrong_try_again',
                    event.context),
                type: SnackBarType.SUCCESS);
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      } else if (event is _GetProductDetailsEvent) {
        debugPrint('product details id = ${event.productId}');
        _isProductInCart = false;
        _cartProductId = '';
        _productQuantity = 0;
        try {
          emit(state.copyWith(isProductLoading: true, isSelectSupplier: false));
          final res = await DioClient(event.context).post(
              AppUrls.getProductDetailsUrl,
              data: ProductDetailsReqModel(params: event.productId).toJson());
          ProductDetailsResModel response =
              ProductDetailsResModel.fromJson(res);
          if (response.status == 200) {
            int productStockUpdateIndex = state.productStockList.indexWhere(
                (productStock) => productStock.productId == event.productId);
            if (productStockUpdateIndex == -1 && (event.isBarcode ?? false)) {
              List<ProductStockModel> productStockList =
                  state.productStockList.toList(growable: false);
              productStockList[productStockList
                  .indexOf(productStockList.last)] = productStockList[
                      productStockList.indexOf(productStockList.last)]
                  .copyWith(
                      productId: response.product?.first.id ?? '',
                      stock: response.product?.first.numberOfUnit ?? 0);
              emit(state.copyWith(productStockList: productStockList));
              debugPrint('new index = ${state.productStockList.last}');
              productStockUpdateIndex =
                  productStockList.indexOf(productStockList.last);
              debugPrint('barcode stock = ${state.productStockList.last}');
              debugPrint(
                  'barcode stock update index = ${state.productStockList.length}');
              debugPrint(
                  'barcode stock update index = $productStockUpdateIndex');
            }
            debugPrint('product stock update index = $productStockUpdateIndex');
            debugPrint(
                'product stock = ${state.productStockList[productStockUpdateIndex].stock}');
            debugPrint(
                'supplier list stock = ${response.product?.first.supplierSales?.map((e) => e.productStock)}');
            List<ProductSupplierModel> supplierList = [];
            debugPrint(
                'supplier id = ${state.productStockList[productStockUpdateIndex].productSupplierIds}');
            supplierList.addAll(response.product?.first.supplierSales
                    ?.map((supplier) => ProductSupplierModel(
                          supplierId: supplier.supplierId ?? '',
                          companyName: supplier.supplierCompanyName ?? '',
                          basePrice:
                              double.parse(supplier.productPrice ?? '0.0'),
                          stock: int.parse(supplier.productStock ?? '0'),
                          selectedIndex: (supplier.supplierId ?? '') ==
                                  state
                                      .productStockList[productStockUpdateIndex]
                                      .productSupplierIds
                              ? supplier.saleProduct?.indexOf(
                                          supplier.saleProduct?.firstWhere(
                                                (sale) =>
                                                    sale.saleId ==
                                                    state
                                                        .productStockList[
                                                            productStockUpdateIndex]
                                                        .productSaleId,
                                                orElse: () => SaleProduct(),
                                              ) ??
                                              SaleProduct()) ==
                                      -1
                                  ? -2
                                  : supplier.saleProduct?.indexOf(
                                          supplier.saleProduct?.firstWhere(
                                                (sale) =>
                                                    sale.saleId ==
                                                    state
                                                        .productStockList[
                                                            productStockUpdateIndex]
                                                        .productSaleId,
                                                orElse: () => SaleProduct(),
                                              ) ??
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
                                      salePrice: double.parse(
                                          sale.discountedPrice ?? '0.0'),
                                      saleDiscount: double.parse(
                                          sale.discountPercentage ?? '0.0')))
                                  .toList() ??
                              [],
                        ))
                    .toList() ??
                []);
            supplierList.removeWhere((supplier) => supplier.stock == 0);
            debugPrint(
                'response list = ${response.product?.first.supplierSales?.length}');
            debugPrint('supplier list = ${supplierList.length}');
            debugPrint(
                'supplier select index = ${supplierList.map((e) => e.selectedIndex)}');
            String note =
                state.productStockList.indexOf(state.productStockList.last) ==
                        productStockUpdateIndex
                    ? ''
                    : state.productStockList[productStockUpdateIndex].note;
            emit(state.copyWith(
                productDetails: response.product ?? [],
                productStockUpdateIndex: productStockUpdateIndex,
                noteController: TextEditingController(text: note),
                productSupplierList: supplierList,
                isProductLoading: false));
            if (supplierList.isNotEmpty) {
              bool isSupplierSelected = false;
              supplierList.forEach((supplier) {
                if (supplier.selectedIndex != -1) {
                  isSupplierSelected = true;
                  return;
                }
              });
              debugPrint('isSupplierSelected = $isSupplierSelected');
              if (!isSupplierSelected) {
                int supplierIndex = 0;
                int supplierSaleIndex = -1;
                double cheapestPrice = supplierList.first.basePrice;
                supplierList.forEach(
                    (supplier) => supplier.supplierSales.forEach((sale) {
                          if (sale.salePrice < cheapestPrice) {
                            cheapestPrice = sale.salePrice;
                            supplierIndex = supplierList.indexOf(supplier);
                            supplierSaleIndex =
                                supplier.supplierSales.indexOf(sale);
                          }
                        }));
                debugPrint('cheapest = $cheapestPrice');
                supplierList.forEach((supplier) {
                  if (supplier.basePrice < cheapestPrice) {
                    cheapestPrice = supplier.basePrice;
                    supplierIndex = supplierList.indexOf(supplier);
                  }
                });
                if (supplierSaleIndex == -1) {
                  supplierSaleIndex = -2;
                }
                debugPrint('cheapest = $cheapestPrice');
                debugPrint('supplier index = $supplierIndex');
                debugPrint('supplier sale index = $supplierSaleIndex');
                add(StoreEvent.supplierSelectionEvent(
                    supplierIndex: supplierIndex,
                    context: event.context,
                    supplierSaleIndex: supplierSaleIndex));
              }
            }
            try {
              SharedPreferencesHelper preferences = SharedPreferencesHelper(
                  prefs: await SharedPreferences.getInstance());
              final res = await DioClient(event.context).post(
                  '${AppUrls.getAllCartUrl}${preferences.getCartId()}',
                  options: Options(headers: {
                    HttpHeaders.authorizationHeader:
                        'Bearer ${preferences.getAuthToken()}'
                  }));
              GetAllCartResModel response = GetAllCartResModel.fromJson(res);
              if (response.status == 200) {
                debugPrint('cart before = ${response.data}');
                response.data?.data?.forEach((cartProduct) {
                  if (cartProduct.id ==
                      state.productStockList[state.productStockUpdateIndex]
                          .productId) {
                    _isProductInCart = true;
                    _cartProductId = cartProduct.cartProductId ?? '';
                    _productQuantity = cartProduct.totalQuantity ?? 0;
                    return;
                  }
                });
                debugPrint(
                    '1)exist = $_isProductInCart\n2)id = $_cartProductId\n3) quan = $_productQuantity');
              }
            } on ServerException {}
          } else {
            Navigator.pop(event.context);
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        'something_is_wrong_try_again',
                    event.context),
                type: SnackBarType.FAILURE);
          }
        } on ServerException {
          // emit(state.copyWith(isProductLoading: false));
          Navigator.pop(event.context);
        } catch (e) {
          Navigator.pop(event.context);
        }
      } else if (event is _IncreaseQuantityOfProduct) {
        List<ProductStockModel> productStockList =
            state.productStockList.toList(growable: false);
        if (state.productStockUpdateIndex != -1) {
          if (productStockList[state.productStockUpdateIndex].quantity <
              productStockList[state.productStockUpdateIndex].stock) {
            if (productStockList[state.productStockUpdateIndex]
                .productSupplierIds
                .isEmpty) {
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title:
                      '${AppLocalizations.of(event.context)!.please_select_supplier}',
                  type: SnackBarType.FAILURE);
              return;
            }
            productStockList[state.productStockUpdateIndex] =
                productStockList[state.productStockUpdateIndex].copyWith(
                    quantity: productStockList[state.productStockUpdateIndex]
                            .quantity +
                        1);
            debugPrint(
                'product quantity = ${productStockList[state.productStockUpdateIndex].quantity}');
            emit(state.copyWith(productStockList: productStockList));
          } else {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    "${AppStrings.maxQuantityMsg1String}${productStockList[state.productStockUpdateIndex].stock}${AppStrings.maxQuantityMsg2String}",
                // '${AppLocalizations.of(event.context)!.you_have_reached_maximum_quantity}',
                type: SnackBarType.FAILURE);
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
      } else if (event is _UpdateQuantityOfProduct) {
        List<ProductStockModel> productStockList =
            state.productStockList.toList(growable: false);
        if (state.productStockUpdateIndex != -1) {
          String quantityString = event.quantity;
          if (quantityString.length == 2 && quantityString.startsWith('0')) {
            quantityString = quantityString.substring(1);
          }
          int newQuantity = int.tryParse(quantityString) ?? 0;
          debugPrint('new quantity = $newQuantity');
          if (newQuantity <=
              productStockList[state.productStockUpdateIndex].stock) {
            productStockList[state.productStockUpdateIndex] =
                productStockList[state.productStockUpdateIndex]
                    .copyWith(quantity: newQuantity);
            debugPrint(
                'product quantity update = ${productStockList[state.productStockUpdateIndex].quantity}');
            emit(state.copyWith(productStockList: productStockList));
          } else {
            productStockList[state.productStockUpdateIndex] =
                productStockList[state.productStockUpdateIndex].copyWith(
                    quantity: int.tryParse(quantityString.substring(
                            0, quantityString.length - 1)) ??
                        0);
            debugPrint(
                'product max quantity update = ${int.tryParse(quantityString.substring(0, quantityString.length - 1)) ?? 0}');
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    "${AppStrings.maxQuantityMsg1String}${productStockList[state.productStockUpdateIndex].stock}${AppStrings.maxQuantityMsg2String}",
                type: SnackBarType.FAILURE);
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          }
        }
      } else if (event is _ChangeNoteOfProduct) {
        if (state.productStockUpdateIndex != -1) {
          debugPrint('note changed');
          List<ProductStockModel> productStockList =
              state.productStockList.toList(growable: false);
          productStockList[state.productStockUpdateIndex] =
              productStockList[state.productStockUpdateIndex]
                  .copyWith(note: /*event.newNote*/ state.noteController.text);
          emit(state.copyWith(productStockList: productStockList));
        }
      } else if (event is _AddToCartProductEvent) {
        if (state.productStockList[state.productStockUpdateIndex]
            .productSupplierIds.isEmpty) {
          CustomSnackBar.showSnackBar(
              context: event.context,
              title:
                  '${AppLocalizations.of(event.context)!.please_select_supplier}',
              type: SnackBarType.FAILURE);
          return;
        }
        if (state.productStockList[state.productStockUpdateIndex].quantity ==
            0) {
          CustomSnackBar.showSnackBar(
              context: event.context,
              title: '${AppLocalizations.of(event.context)!.add_1_quantity}',
              type: SnackBarType.FAILURE);
          return;
        }
        if (_isProductInCart) {
          debugPrint('update cart');
          try {
            emit(state.copyWith(isLoading: true));
            UpdateCartReqModel request = UpdateCartReqModel(
              productId: state
                  .productStockList[state.productStockUpdateIndex].productId,
              supplierId: state.productStockList[state.productStockUpdateIndex]
                  .productSupplierIds,
              saleId: state.productStockList[state.productStockUpdateIndex]
                          .productSaleId ==
                      ''
                  ? null
                  : state.productStockList[state.productStockUpdateIndex]
                      .productSaleId,
              quantity: state.productStockList[state.productStockUpdateIndex]
                      .quantity +
                  _productQuantity,
              cartProductId: _cartProductId,
            );
            SharedPreferencesHelper preferences = SharedPreferencesHelper(
                prefs: await SharedPreferences.getInstance());
            final res = await DioClient(event.context).post(
              '${AppUrls.updateCartProductUrl}${preferences.getCartId()}',
              data: request,
            );
            UpdateCartResModel response = UpdateCartResModel.fromJson(res);
            if (response.status == 201) {
              Vibration.vibrate();
              emit(state.copyWith(isLoading: false));
              Navigator.pop(event.context);
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message!.toLocalization(), event.context),
                  type: SnackBarType.SUCCESS);
            } else {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          'something_is_wrong_try_again',
                      event.context),
                  type: SnackBarType.FAILURE);
            }
          } on ServerException {
            emit(state.copyWith(isLoading: false));
          } catch (e) {
            debugPrint('err = $e');
            emit(state.copyWith(isLoading: false));
          }
        } else {
          try {
            emit(state.copyWith(isLoading: true));
            InsertCartModel.InsertCartReqModel insertCartReqModel =
                InsertCartModel.InsertCartReqModel(products: [
              InsertCartModel.Product(
                  productId: state
                      .productStockList[state.productStockUpdateIndex]
                      .productId,
                  quantity: state
                      .productStockList[state.productStockUpdateIndex].quantity,
                  supplierId: state
                      .productStockList[state.productStockUpdateIndex]
                      .productSupplierIds,
                  note: state.productStockList[state.productStockUpdateIndex]
                          .note.isEmpty
                      ? null
                      : state
                          .productStockList[state.productStockUpdateIndex].note,
                  saleId: state.productStockList[state.productStockUpdateIndex]
                          .productSaleId.isEmpty
                      ? null
                      : state.productStockList[state.productStockUpdateIndex]
                          .productSaleId)
            ]);
            Map<String, dynamic> req = insertCartReqModel.toJson();
            req.removeWhere((key, value) {
              if (value != null) {
                debugPrint("[$key] = $value");
              }
              return value == null;
            });
            debugPrint('insert cart req = $req');
            SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
                prefs: await SharedPreferences.getInstance());

            debugPrint(
                'insert cart url1 = ${AppUrls.insertProductInCartUrl}${preferencesHelper.getCartId()}');
            debugPrint(
                'insert cart url1 auth = ${preferencesHelper.getAuthToken()}');
            final res = await DioClient(event.context).post(
                '${AppUrls.insertProductInCartUrl}${preferencesHelper.getCartId()}',
                data: req,
                options: Options(
                  headers: {
                    HttpHeaders.authorizationHeader:
                        'Bearer ${preferencesHelper.getAuthToken()}',
                  },
                ));
            InsertCartResModel response = InsertCartResModel.fromJson(res);
            if (response.status == 201) {
              List<ProductStockModel> productStockList =
                  state.productStockList.toList(growable: true);
              productStockList[state.productStockUpdateIndex] =
                  productStockList[state.productStockUpdateIndex].copyWith(
                note: '',
                isNoteOpen: false,
                // quantity: 0,
                // productSupplierIds: '',
                // totalPrice: 0.0,
                // productSaleId: '',
              );
              add(StoreEvent.setCartCountEvent());
              Vibration.vibrate(amplitude: 128);
              emit(state.copyWith(
                  isLoading: false,
                  productStockList: productStockList,
                  isCartCountChange: true));
              emit(state.copyWith(isCartCountChange: false));
              Navigator.pop(event.context);
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  /* title: response.message ??
                    '${AppLocalizations.of(event.context)!.product_added_to_cart}',*/
                  title: AppStrings.getLocalizedStrings(
                      response.message!.toLocalization(), event.context),
                  type: SnackBarType.SUCCESS);
            } else if (response.status == 403) {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          'something_is_wrong_try_again',
                      event.context),
                  type: SnackBarType.FAILURE);
            } else {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          'something_is_wrong_try_again',
                      event.context),
                  type: SnackBarType.FAILURE);
            }
          } on ServerException {
            debugPrint('url1 = ');
            emit(state.copyWith(isLoading: false));
          } catch (e) {
            debugPrint('err = $e');
            emit(state.copyWith(isLoading: false));
          }
        }
      } else if (event is _SetCartCountEvent) {
        SharedPreferencesHelper preferences = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());
        await preferences.setCartCount(count: preferences.getCartCount() + 1);
        await preferences.setIsAnimation(isAnimation: true);
        debugPrint('cart count = ${preferences.getCartCount()}');
      } else if (event is _SupplierSelectionEvent) {
        debugPrint(
            'supplier[${event.supplierIndex}][${event.supplierSaleIndex}]');
        if (event.supplierIndex >= 0) {
          List<ProductSupplierModel> supplierList =
              state.productSupplierList.toList(growable: true);
          List<ProductStockModel> productStockList =
              state.productStockList.toList(growable: true);

          productStockList[state.productStockUpdateIndex] =
              productStockList[state.productStockUpdateIndex].copyWith(
                  productSupplierIds:
                      supplierList[event.supplierIndex].supplierId,
                  stock: supplierList[event.supplierIndex].stock,
                  quantity: 1,
                  totalPrice: event.supplierSaleIndex == -2
                      ? supplierList[event.supplierIndex].basePrice
                      : supplierList[event.supplierIndex]
                          .supplierSales[event.supplierSaleIndex]
                          .salePrice,
                  productSaleId: event.supplierSaleIndex == -2
                      ? ''
                      : supplierList[event.supplierIndex]
                          .supplierSales[event.supplierSaleIndex]
                          .saleId);
          debugPrint(
              'selected stock supplier = ${productStockList[state.productStockUpdateIndex]}');
          supplierList = supplierList
              .map((supplier) => supplier.copyWith(selectedIndex: -1))
              .toList();
          debugPrint('selected supplier = ${supplierList}');
          supplierList[event.supplierIndex] = supplierList[event.supplierIndex]
              .copyWith(selectedIndex: event.supplierSaleIndex);
          debugPrint(
              'selected supplier[${event.supplierIndex}] = ${supplierList[event.supplierIndex]}');
          emit(state.copyWith(
              productSupplierList: supplierList,
              productStockList: productStockList));
        }
      } else if (event is _GlobalSearchEvent) {
        emit(state.copyWith(search: state.searchController.text));
        debugPrint('data1 = ${state.searchController.text}');
        try {
          GlobalSearchReqModel globalSearchReqModel =
              GlobalSearchReqModel(search: state.searchController.text);
          emit(state.copyWith(isSearching: true));
          final res = await DioClient(event.context).post(
              AppUrls.getGlobalSearchResultUrl,
              data: globalSearchReqModel.toJson());
          debugPrint('data1 = $res');
          GlobalSearchResModel response = GlobalSearchResModel.fromJson(res);
          debugPrint('cat len = ${response.data?.categoryData?.length}');
          debugPrint('com len = ${response.data?.companyData?.length}');
          debugPrint('sale len = ${response.data?.saleData?.length}');
          debugPrint('sup len = ${response.data?.supplierData?.length}');
          debugPrint(
              'sup prod len = ${response.data?.supplierProductData?.length}');
          if (state.searchController.text == '') {
            List<SearchModel> searchList = [];
            searchList.addAll(state.productCategoryList.map((category) =>
                SearchModel(
                    searchId: category.id ?? '',
                    name: category.categoryName ?? '',
                    searchType: SearchTypes.category,
                    image: category.categoryImage ?? '')));
            emit(state.copyWith(searchList: searchList, isSearching: false));
            return;
          }
          if (response.status == 200) {
            List<SearchModel> searchList = [];
            //category search result
            searchList.addAll(response.data?.categoryData
                    ?.map((category) => SearchModel(
                        searchId: category.id ?? '',
                        name: category.categoryName ?? '',
                        searchType: SearchTypes.category,
                        image: category.categoryImage ?? ''))
                    .toList() ??
                []);
            //company search result
            searchList.addAll(response.data?.companyData
                    ?.map((company) => SearchModel(
                        searchId: company.id ?? '',
                        name: company.brandName ?? '',
                        searchType: SearchTypes.company,
                        image: company.brandLogo ?? ''))
                    .toList() ??
                []);
            // supplier search result
            searchList.addAll(response.data?.supplierData
                    ?.map((supplier) => SearchModel(
                        searchId: supplier.id ?? '',
                        name: supplier.supplierDetail?.companyName ?? '',
                        searchType: SearchTypes.supplier,
                        image: supplier.logo ?? ''))
                    .toList() ??
                []);
            //sale search result
            searchList.addAll(response.data?.saleData
                    ?.map((sale) => SearchModel(
                        searchId: sale.id ?? '',
                        name: sale.productName ?? '',
                        searchType: SearchTypes.sale,
                        image: sale.mainImage ?? ''))
                    .toList() ??
                []);
            //supplier products result
            searchList.addAll(response.data?.supplierProductData
                    ?.map((supplier) => SearchModel(
                        searchId: supplier.productId ?? '',
                        name: supplier.productName ?? '',
                        searchType: SearchTypes.product,
                        image: supplier.mainImage ?? ''))
                    .toList() ??
                []);
            debugPrint('store search list = ${searchList.length}');
            emit(state.copyWith(
                searchList: searchList,
                search: state.searchController.text,
                isSearching: false));
          } else {
            // emit(state.copyWith(searchList: []));
            emit(state.copyWith(isSearching: false));
            // CustomSnackBar.showSnackBar(
            //     context: event.context,
            //     title: response.message ?? AppStrings.somethingWrongString,
            //     type: SnackBarType.SUCCESS);
          }
        } on ServerException {
          emit(state.copyWith(isSearching: false));
        } catch (exc) {
          emit(state.copyWith(isSearching: false));
        }
      } else if (event is _UpdateImageIndexEvent) {
        emit(state.copyWith(imageIndex: event.index));
      } else if (event is _UpdateGlobalSearchEvent) {
        emit(state.copyWith(
            searchController: TextEditingController(text: event.search),
            searchList: event.searchList));
      } else if (event is _ToggleNoteEvent) {
        List<ProductStockModel> productStockList =
            state.productStockList.toList(growable: true);
        if (event.isBarcode) {
          productStockList[productStockList.indexOf(productStockList.last)] =
              productStockList[productStockList.indexOf(productStockList.last)]
                  .copyWith(
                      isNoteOpen: !productStockList[
                              productStockList.indexOf(productStockList.last)]
                          .isNoteOpen);
        } else {
          productStockList[state.productStockUpdateIndex] =
              productStockList[state.productStockUpdateIndex].copyWith(
                  isNoteOpen: !productStockList[state.productStockUpdateIndex]
                      .isNoteOpen);
        }
        emit(state.copyWith(productStockList: productStockList));
      } else if (event is _ResetGlobalSearchEvent) {
        List<SearchModel> searchList = [];
        searchList.addAll(state.productCategoryList.map((category) =>
            SearchModel(
                searchId: category.id ?? '',
                name: category.categoryName ?? '',
                searchType: SearchTypes.category,
                image: category.categoryImage ?? '')));
        emit(state.copyWith(
            searchList: searchList, searchController: TextEditingController()));
      } else if (event is _GetPreviousOrderProductsListEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).post(
            AppUrls.getPreviousOrderProductsUrl,
            data: PreviousOrderProductsReqModel(
                    pageNum: 1, pageLimit: AppConstants.defaultPageLimit)
                .toJson(),
          );
          PreviousOrderProductsResModel response =
              PreviousOrderProductsResModel.fromJson(res);
          if (response.status == 200) {
            debugPrint(
                'previous order products len = ${response.previousProductData?.length}');
            List<ProductStockModel> productStockList =
                state.productStockList.toList(growable: true);
            ProductStockModel barcodeStock = productStockList.removeLast();
            productStockList.addAll(response.previousProductData?.map(
                    (previousOrderProduct) => ProductStockModel(
                        productId: previousOrderProduct.id ?? '',
                        stock: previousOrderProduct.productStock ?? 0)) ??
                []);
            productStockList.add(barcodeStock);
            emit(state.copyWith(
                previousOrderProductsList: response.previousProductData ?? [],
                productStockList: productStockList,
                isShimmering: false));
            debugPrint(
                'previous order products len = ${state.previousOrderProductsList.length}');
          } else {
            emit(state.copyWith(isShimmering: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                type: SnackBarType.SUCCESS);
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      }
    });
  }
}
