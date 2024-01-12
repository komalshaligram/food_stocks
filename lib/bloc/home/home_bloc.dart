import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:food_stock/data/model/req_model/product_sales_req_model/product_sales_req_model.dart';
import 'package:food_stock/data/model/req_model/update_cart/update_cart_req_model.dart';
import 'package:food_stock/data/model/res_model/message_count_res_model/message_count_res_model.dart';
import 'package:food_stock/data/model/res_model/product_details_res_model/product_details_res_model.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../../data/model/req_model/get_messages_req_model/get_messages_req_model.dart';
import '../../data/model/req_model/get_order_count/get_order_count_req_model.dart';
import '../../data/model/req_model/insert_cart_req_model/insert_cart_req_model.dart'
    as InsertCartModel;
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/req_model/wallet_record_req/wallet_record_req_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/get_messages_res_model/get_messages_res_model.dart';
import '../../data/model/res_model/insert_cart_res_model/insert_cart_res_model.dart';
import '../../data/model/res_model/order_count/get_order_count_res_model.dart';
import '../../data/model/res_model/product_sales_res_model/product_sales_res_model.dart';
import '../../data/model/res_model/update_cart_res/update_cart_res_model.dart';
import '../../data/model/res_model/wallet_record_res/wallet_record_res_model.dart';
import '../../data/model/supplier_sale_model/supplier_sale_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'home_event.dart';

part 'home_state.dart';

part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  bool _isProductInCart = false;
  String _cartProductId = '';
  int _productQuantity = 0;

  HomeBloc() : super(HomeState.initial()) {
    on<HomeEvent>((event, emit) async {
      SharedPreferencesHelper preferences =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getPreferencesDataEvent) {
        debugPrint(
            'getUserImageUrl ${AppUrls.baseFileUrl}${preferences.getUserImageUrl()}');
        debugPrint(
            'getUserCompanyLogoUrl ${preferences.getUserCompanyLogoUrl()}');
        debugPrint('cart count ${preferences.getCartCount()}');
        debugPrint('message count ${preferences.getMessageCount()}');
        emit(state.copyWith(
            UserImageUrl: preferences.getUserImageUrl(),
            UserCompanyLogoUrl: preferences.getUserCompanyLogoUrl(),
            messageCount: preferences.getMessageCount(),
            cartCount: preferences.getCartCount()));
      } else if (event is _GetCartCountEvent) {
        try {
          final res = await DioClient(event.context).post(
              '${AppUrls.getAllCartUrl}${preferences.getCartId()}',
              options: Options(headers: {
                HttpHeaders.authorizationHeader:
                    'Bearer ${preferences.getAuthToken()}'
              }));
          GetAllCartResModel response = GetAllCartResModel.fromJson(res);
          if (response.status == 200) {
            debugPrint('cart1 = ${response.data}');
            debugPrint('main cart count = ${response.data?.data?.length}');
            await preferences.setCartCount(
                count: response.data?.data?.length ?? preferences.getCartCount());
            // List<String> cartProductList = [];
            // cartProductList.addAll(response.data?.data?.map(
            //         (cartProduct) => cartProduct.productDetails?.id ?? '') ??
            //     []);
            // List<String> cartProductIdList = [];
            // cartProductIdList.addAll(response.data?.data
            //         ?.map((cartProduct) => cartProduct.cartProductId ?? '') ??
            //     []);
            // List<String> cartProductQuantityList = [];
            // cartProductQuantityList.addAll(response.data?.data?.map(
            //         (cartProduct) => "${cartProduct.totalQuantity ?? '0'}") ??
            //     []);
            // debugPrint('cart product id List = ${cartProductIdList}');
            // debugPrint('cart product List = ${cartProductList}');
            // debugPrint(
            //     'cart product quantity List = ${cartProductQuantityList}');
            // await preferences.setCartProductIdList(
            //     cartProductIds: cartProductIdList);
            // await preferences.setCartProductList(cartProducts: cartProductList);
            // await preferences.setCartProductQuantityList(
            //     cartProductQuantityList: cartProductQuantityList);
            emit(state.copyWith(cartCount: preferences.getCartCount()));
          }
        } on ServerException {}
        //message count
        try {
          final res = await DioClient(event.context).post(
              AppUrls.getUnreadMessageCountUrl,
              options: Options(headers: {
                HttpHeaders.authorizationHeader:
                    'Bearer ${preferences.getAuthToken()}'
              }));

          MessageCountResModel response = MessageCountResModel.fromJson(res);
          if (response.status == 200) {
            print('unread message count = ${response.data}');
            await preferences.setMessageCount(
                count: response.data ?? preferences.getMessageCount());
            emit(state.copyWith(messageCount: response.data ?? 0));
          }
        } on ServerException {
        } catch (e) {}
      } else if (event is _GetProductSalesListEvent) {
        try {
          emit(state.copyWith(isProductSaleShimmering: true));
          final res = await DioClient(event.context).post(
              AppUrls.getSaleProductsUrl,
              data: ProductSalesReqModel(
                      pageNum: 1, pageLimit: AppConstants.defaultPageLimit)
                  .toJson());
          ProductSalesResModel response = ProductSalesResModel.fromJson(res);
          if (response.status == 200) {
            List<ProductSale> saleProductsList =
                response.data?.toList(growable: true) ?? [];
            saleProductsList.map((sale) => debugPrint('${sale.endDate}'));
            // saleProductsList.removeWhere(
            //     (sale) => sale.endDate?.isBefore(DateTime.now()) ?? true);
            debugPrint('sale Products = ${saleProductsList.length}');
            debugPrint('sale Products = ${response.data?.length}');
            List<ProductStockModel> productStockList = [];
            productStockList.addAll(response.data?.map((saleProduct) =>
                    ProductStockModel(
                        productId: saleProduct.id ?? '',
                        stock: int.parse(saleProduct.numberOfUnit ?? '0'))) ??
                []);
            debugPrint('stock list len = ${productStockList.length}');
            emit(state.copyWith(
                productSalesList: response.data ?? [],
                productStockList: productStockList,
                isProductSaleShimmering: false));
          } else {
            /*CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                type: SnackBarType.FAILURE);*/
          }
        } on ServerException {
          emit(state.copyWith(isProductSaleShimmering: false));
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
            debugPrint(
                'id = ${state.productStockList.firstWhere((productStock) => productStock.productId == event.productId).productId}\n id = ${event.productId}');
            int productStockUpdateIndex = state.productStockList.indexWhere(
                (productStock) => productStock.productId == event.productId);
            debugPrint('product stock update index = $productStockUpdateIndex');
            debugPrint(
                'product stock = ${state.productStockList[productStockUpdateIndex].stock}');
            List<ProductSupplierModel> supplierList = [];
            // debugPrint(
            //     'response supplier id = ${response.product?.first.supplierSales?.supplier?.id ?? ''}');
            debugPrint(
                'supplier id = ${state.productStockList[productStockUpdateIndex].productSupplierIds}');
            debugPrint(
                'supplier list stock = ${response.product?.first.supplierSales?.map((e) => e.productStock)}');
            supplierList.addAll(response.product?.first.supplierSales
                    ?.map((supplier) => ProductSupplierModel(
                          supplierId: supplier.supplierId ?? '',
                          companyName: supplier.supplierCompanyName ?? '',
                          basePrice:
                              double.parse(supplier.productPrice ?? '0.0'),
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
                          // supplier.supplierSales?.supplier?.sale?.indexOf(
                          //             supplier.supplierSales?.supplier?.sale
                          //                     ?.firstWhere((sale) =>
                          //                         sale.saleId ==
                          //                         state
                          //                             .productStockList[
                          //                                 productStockUpdateIndex]
                          //                             .productSaleId) ??
                          //                 Sale()) ??
                          // -1
                          // : -1,
                          stock: int.parse(supplier.productStock ?? '0'),
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
            emit(state.copyWith(
                productDetails: response.product ?? [],
                productStockUpdateIndex: productStockUpdateIndex,
                noteController: TextEditingController(
                    text: state.productStockList[productStockUpdateIndex].note),
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
                add(HomeEvent.supplierSelectionEvent(
                    supplierIndex: supplierIndex,
                    context: event.context,
                    supplierSaleIndex: supplierSaleIndex));
              }
            }
            try {
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
                    "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[state.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
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
                    "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[state.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
                type: SnackBarType.FAILURE);
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          }
        }
      } else if (event is _ChangeNoteOfProduct) {
        if (state.productStockUpdateIndex != -1) {
          List<ProductStockModel> productStockList =
              state.productStockList.toList(growable: false);
          productStockList[state.productStockUpdateIndex] =
              productStockList[state.productStockUpdateIndex]
                  .copyWith(note: /*event.newNote*/ state.noteController.text);
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
          List<ProductStockModel> productStockList =
              state.productStockList.toList(growable: true);

          productStockList[state.productStockUpdateIndex] =
              productStockList[state.productStockUpdateIndex].copyWith(
                  productSupplierIds:
                      /*supplierList[event.supplierIndex].selectedIndex ==
                              event.supplierSaleIndex
                          ? ''
                          : */
                      supplierList[event.supplierIndex].supplierId,
                  totalPrice: event.supplierSaleIndex == -2
                      ? supplierList[event.supplierIndex].basePrice
                      : /*supplierList[event.supplierIndex].selectedIndex ==
                              event.supplierSaleIndex
                          ? supplierList[event.supplierIndex]
                              .supplierSales[event.supplierSaleIndex]
                              .salePrice
                          :*/
                      supplierList[event.supplierIndex]
                          .supplierSales[event.supplierSaleIndex]
                          .salePrice,
                  stock: supplierList[event.supplierIndex].stock,
                  quantity: 1,
                  productSaleId: event.supplierSaleIndex == -2
                      ? ''
                      : /*supplierList[event.supplierIndex].selectedIndex ==
                              event.supplierSaleIndex
                          ? ''
                          :*/
                      supplierList[event.supplierIndex]
                          .supplierSales[event.supplierSaleIndex]
                          .saleId);
          debugPrint(
              'selected stock supplier = ${productStockList[state.productStockUpdateIndex]}');
          supplierList = supplierList
              .map((supplier) => supplier.copyWith(selectedIndex: -1))
              .toList();
          debugPrint('selected supplier = ${supplierList}');
          supplierList[event.supplierIndex] =
              supplierList[event.supplierIndex].copyWith(
                  selectedIndex: /*event.supplierSaleIndex == -2
                      ? -2
                      : supplierList[event.supplierIndex].selectedIndex ==
                              event.supplierSaleIndex
                          ? -1
                          : */
                      event.supplierSaleIndex);
          debugPrint(
              'selected supplier[${event.supplierIndex}] = ${supplierList[event.supplierIndex]}');
          emit(state.copyWith(
              productSupplierList: supplierList,
              productStockList: productStockList));
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
        // List<String> cartProductList = preferences.getCartProductList();
        // List<String> cartProductIdList = preferences.getCartProductIdList();
        // List<String> cartProductQuantityList =
        //     preferences.getCartProductQuantityList();
        //update or insert cart API
        if (_isProductInCart /*cartProductList.contains(
            state.productStockList[state.productStockUpdateIndex].productId)*/
            ) {
          debugPrint('update cart');
          try {
            // int lastQuantityIndex = cartProductList.indexOf(state
            //     .productStockList[state.productStockUpdateIndex].productId);
            // debugPrint('last quantity = $lastQuantityIndex');
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
                  _productQuantity /*int.parse(cartProductQuantityList[lastQuantityIndex])*/,
              cartProductId:
                  _cartProductId /*cartProductIdList[cartProductList.indexOf(state
                  .productStockList[state.productStockUpdateIndex].productId)]*/
              ,
            );
            final res = await DioClient(event.context).post(
              '${AppUrls.updateCartProductUrl}${preferences.getCartId()}',
              data: request,
            );
            UpdateCartResModel response = UpdateCartResModel.fromJson(res);
            if (response.status == 201) {
              Vibration.vibrate();
              emit(state.copyWith(isLoading: false));
              // cartProductQuantityList[lastQuantityIndex] =
              //     "${int.parse(cartProductQuantityList[lastQuantityIndex]) + state.productStockList[state.productStockUpdateIndex].quantity}";
              // debugPrint(
              //     'cart product quantity List = ${cartProductQuantityList}');
              // debugPrint(
              //     'update last quantity = ${cartProductQuantityList[lastQuantityIndex]}');
              // await preferences.setCartProductQuantityList(
              //     cartProductQuantityList: cartProductQuantityList);
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
          debugPrint('insert cart');
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
              //await HapticFeedback.heavyImpact();
              //
              Vibration.vibrate();

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

              // List<String> cartProductList = preferences.getCartProductList();
              // List<String> cartProductIdList =
              //     preferences.getCartProductIdList();
              // List<String> cartProductQuantityList =
              //     preferences.getCartProductQuantityList();
              //
              // cartProductList.add(state
              //     .productStockList[state.productStockUpdateIndex].productId);
              emit(state.copyWith(
                  isLoading: false,
                  productStockList: productStockList,
                  isCartCountChange: true));
              emit(state.copyWith(isCartCountChange: false));
              add(HomeEvent.setCartCountEvent());

              /*if (await Vibration.hasVibrator()) {
              Vibration.vibrate();
            }*/
              Navigator.pop(event.context);
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message!.toLocalization(), event.context),
                  type: SnackBarType.SUCCESS);
            } else if (response.status == 403) {
              emit(state.copyWith(isLoading: false));
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
        }
      } else if (event is _SetCartCountEvent) {
        await preferences.setCartCount(count: preferences.getCartCount() + 1);
        emit(state.copyWith(cartCount: preferences.getCartCount()));
        await preferences.setIsAnimation(isAnimation: true);
        debugPrint('cart count = ${state.cartCount}');
      } else if (event is _getWalletRecordEvent) {
        try {
          WalletRecordReqModel reqMap =
              WalletRecordReqModel(userId: preferences.getUserId());
          debugPrint('WalletRecordReqModel = $reqMap}');
          final res = await DioClient(event.context).post(
            AppUrls.walletRecordUrl,
            data: reqMap,
          );

          debugPrint('WalletRecord url  = ${AppUrls.walletRecordUrl}');
          WalletRecordResModel response = WalletRecordResModel.fromJson(res);
          debugPrint('WalletRecordResModel  = $response');

          if (response.status == 200) {
            emit(state.copyWith(
                thisMonthExpense:
                    response.data?.currentMonth?.totalExpenses?.toDouble() ?? 0,
                lastMonthExpense:
                    response.data?.previousMonth?.totalExpenses?.toDouble() ??
                        0,
                balance: response.data?.balanceAmount?.toDouble() ?? 0,
                totalCredit: response.data?.totalCredit?.toDouble() ?? 0,
                expensePercentage: double.parse(
                    response.data?.currentMonth!.expensePercentage ?? '')));
          }
        } on ServerException {
        } catch (e) {}
      } else if (event is _getOrderCountEvent) {
        try {
          int daysInMonth(DateTime date) => DateTimeRange(
                  start: DateTime(date.year, date.month, 1),
                  end: DateTime(date.year, date.month + 1))
              .duration
              .inDays;

          var now = DateTime.now();

          GetOrderCountReqModel reqMap = GetOrderCountReqModel(
            startDate: DateTime(now.year, now.month, 1),
            endDate: DateTime(now.year, now.month, daysInMonth(DateTime.now())),
          );

          debugPrint('getOrdersCount reqMap = $reqMap}');

          final res = await DioClient(event.context).post(
            AppUrls.getOrdersCountUrl,
            data: reqMap,
          );

          debugPrint('getOrdersCountUrl url  = ${AppUrls.getOrdersCountUrl}');
          GetOrderCountResModel response = GetOrderCountResModel.fromJson(res);
          debugPrint('getOrdersCount response  = ${response}');

          if (response.status == 200) {
            emit(state.copyWith(orderThisMonth: response.data!.toInt()));
          }
        } on ServerException {
        } catch (e) {}
      } else if (event is _GetMessageListEvent) {
        try {
          emit(state.copyWith(isMessageShimmering: true));
          final res = await DioClient(event.context).post(
              AppUrls.getNotificationMessageUrl,
              data: GetMessagesReqModel(pageNum: 1, pageLimit: 2).toJson(),
              options: Options(
                headers: {
                  HttpHeaders.authorizationHeader:
                      'Bearer ${preferences.getAuthToken()}',
                },
              ));
          GetMessagesResModel response = GetMessagesResModel.fromJson(res);
          if (response.status == 200) {
            List<MessageData> messageList = [];
            messageList.addAll(response.data
                    ?.map((message) => MessageData(
                          id: message.id,
                          isRead: message.isRead,
                          message: Message(
                              id: message.message?.id ?? '',
                              title: message.message?.title ?? '',
                              summary: message.message?.summary ?? '',
                              body: message.message?.body ?? '',
                              messageImage:
                                  message.message?.messageImage ?? ''),
                          createdAt: message.createdAt,
                          updatedAt: message.updatedAt,
                        ))
                    .toList() ??
                []);
            /* messageList.removeWhere(
                (message) => (message.isPushNotification ?? false) == false);*/
            debugPrint('new message list len = ${messageList.length}');
            emit(state.copyWith(
                messageList: messageList, isMessageShimmering: false));
          } else {
          }
        } on ServerException {}
      } else if (event is _SetMessageCountEvent) {

        emit(state.copyWith(
            messageCount: state.messageCount + event.messageCount));
      } else if (event is _RemoveOrUpdateMessageEvent) {
        List<MessageData> messageList =
            state.messageList.toList(growable: true);
        debugPrint('message list len before delete = ${messageList.length}');
        SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());
        debugPrint('message count = ${preferencesHelper.getMessageCount()}');
        debugPrint(
            'message actual status = ${messageList[messageList.indexOf(messageList.firstWhere((message) => message.id == event.messageId))].isRead}');
        if (event.isRead) {
          if (messageList[messageList.indexOf(messageList
                      .firstWhere((message) => message.id == event.messageId))]
                  .isRead ==
              false) {
            await preferencesHelper.setMessageCount(
                count: preferencesHelper.getMessageCount() - 1);
            messageList[messageList.indexOf(messageList
                    .firstWhere((message) => message.id == event.messageId))] =
                messageList[messageList.indexOf(messageList.firstWhere(
                        (message) => message.id == event.messageId))]
                    .copyWith(isRead: true);
            emit(state.copyWith(messageCount: state.messageCount - 1));
          }
        }
        if (event.isDelete) {
          messageList.removeWhere((message) => message.id == event.messageId);
          debugPrint('message list len after delete = ${messageList.length}');
        }
        emit(state.copyWith(messageList: []));
        emit(state.copyWith(messageList: messageList));
      } else if (event is _UpdateImageIndexEvent) {
        emit(state.copyWith(imageIndex: event.index));
      } else if (event is _UpdateMessageListEvent) {
        if (event.messageIdList.isNotEmpty) {
          List<MessageData> messageList =
              state.messageList.toList(growable: true);
          messageList.removeWhere(
              (message) => event.messageIdList.contains(message.id));
          debugPrint('message len = ${messageList.length}');
          emit(state.copyWith(messageList: messageList));
        }
      } else if (event is _ToggleNoteEvent) {
        List<ProductStockModel> productStockList =
            state.productStockList.toList(growable: true);
        productStockList[state.productStockUpdateIndex] =
            productStockList[state.productStockUpdateIndex].copyWith(
                isNoteOpen: !productStockList[state.productStockUpdateIndex]
                    .isNoteOpen);
        emit(state.copyWith(productStockList: productStockList));
      }
    });
  }
}