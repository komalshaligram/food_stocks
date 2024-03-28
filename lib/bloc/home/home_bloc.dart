import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/req_model/update_cart/update_cart_req_model.dart';
import 'package:food_stock/data/model/res_model/message_count_res_model/message_count_res_model.dart';
import 'package:food_stock/data/model/res_model/product_details_res_model/product_details_res_model.dart';
import 'package:food_stock/data/model/res_model/related_product_res_model/related_product_res_model.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_version_checker/store_version_checker.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../../data/model/req_model/get_messages_req_model/get_messages_req_model.dart';
import '../../data/model/req_model/get_order_count/get_order_count_req_model.dart';
import '../../data/model/req_model/global_search_req_model/global_search_req_model.dart';
import '../../data/model/req_model/insert_cart_req_model/insert_cart_req_model.dart'
    as InsertCartModel;
import '../../data/model/req_model/product_categories_req_model/product_categories_req_model.dart';
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/req_model/profile_details_req_model/profile_details_req_model.dart';
import '../../data/model/req_model/recommendation_products_req_model/recommendation_products_req_model.dart';
import '../../data/model/req_model/wallet_record_req/wallet_record_req_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/get_messages_res_model/get_messages_res_model.dart';
import '../../data/model/res_model/global_search_res_model/global_search_res_model.dart';
import '../../data/model/res_model/insert_cart_res_model/insert_cart_res_model.dart';
import '../../data/model/res_model/order_count/get_order_count_res_model.dart';
import '../../data/model/res_model/product_sales_res_model/product_sales_res_model.dart';
import '../../data/model/res_model/profile_details_res_model/profile_details_res_model.dart';
import '../../data/model/res_model/update_cart_res/update_cart_res_model.dart';
import '../../data/model/res_model/wallet_record_res/wallet_record_res_model.dart';
import '../../data/model/search_model/search_model.dart';
import '../../data/model/supplier_sale_model/supplier_sale_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';
import '../../data/model/res_model/recommendation_products_res_model/recommendation_products_res_model.dart';
import 'package:food_stock/data/model/res_model/product_categories_res_model/product_categories_res_model.dart';

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

      if (preferences.getGuestUser()) {

      }
      else {
        if (event is _getPreferencesDataEvent) {
          debugPrint(
              'getUserImageUrl ${preferences.getUserImageUrl()}');
          debugPrint(
              'getUserCompanyLogoUrl ${preferences.getUserCompanyLogoUrl()}');
          debugPrint('cart count ${preferences.getCartCount()}');
          debugPrint('message count ${preferences.getMessageCount()}');
          emit(state.copyWith(
            UserImageUrl: preferences.getUserImageUrl(),
            UserCompanyLogoUrl: preferences.getUserCompanyLogoUrl(),
            messageCount: preferences.getMessageCount(),
            cartCount: preferences.getCartCount(),
          ));
        }
        else if (event is _GetCartCountEvent) {
          try {
            final res = await DioClient(event.context).post(
                '${AppUrls.getAllCartUrl}${preferences.getCartId()}',
              );
            GetAllCartResModel response = GetAllCartResModel.fromJson(res);
            if (response.status == 200) {
              debugPrint('cart1 = ${response.data}');
              debugPrint('main cart count = ${response.data?.data?.length}');
              await preferences.setCartCount(
                  count: response.data?.data?.length ??
                      preferences.getCartCount());
              emit(state.copyWith(cartCount: preferences.getCartCount()));
            }
          } on ServerException {}
          //message count
          try {
            final res = await DioClient(event.context).post(
                AppUrls.getUnreadMessageCountUrl,
               );

            MessageCountResModel response = MessageCountResModel.fromJson(res);
            if (response.status == 200) {
              debugPrint('unread message count = ${response.data}');
              await preferences.setMessageCount(
                  count: response.data ?? preferences.getMessageCount());
              emit(state.copyWith(messageCount: response.data ?? 0));
            }
          } on ServerException {} catch (e) {}
        }
        else if (event is _GetProductDetailsEvent) {
          emit(state.copyWith(isCartCountChange: false));
          add(HomeEvent.RemoveRelatedProductEvent());
          debugPrint('product details id = ${event.productId}');
          debugPrint('productListIndex = ${event.productListIndex}');
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

            debugPrint('GetProductDetails_____${response}');
            if (response.status == 200) {

              //new chanegs
              //0 for barcode and search
              //1 for recommendation product.
              //2 related product.

              List<List<ProductStockModel>> productStockList =
              state.productStockList.toList(growable: true);
              int productListIndex  = event.productListIndex;
              debugPrint('productStockList___${productStockList[2].length}');
              debugPrint('productListIndex___${event.productListIndex}');
              int productStockUpdateIndex = 0;
              if(event.isBarcode ){
                productStockUpdateIndex = 0;
                debugPrint('responseproductid____${response.product?.first.id}');
                productStockList[0][0] =productStockList[0][0].copyWith(
                    quantity: _productQuantity,
                    productId: response.product?.first.id ?? '' ,
                    stock: (response.product?.first.supplierSales?.first.productStock.toString() ?? "0") ,
                    totalPrice: double.parse(response.product?.first.supplierSales?.first.productPrice.toString() ?? '0')
                );
              }
              else{
                productStockUpdateIndex = state.productStockList[productListIndex]
                    .indexWhere((productStock) =>
                productStock.productId == event.productId);
              }

              emit(state.copyWith(productListIndex:productListIndex,productStockUpdateIndex:productStockUpdateIndex));
              debugPrint('planoGramUpdateIndex___${state.productListIndex}');
              debugPrint('productStockUpdateIndex___${state.productStockUpdateIndex}');
              try {

                final res = await DioClient(event.context).post(
                    '${AppUrls.getAllCartUrl}${preferences.getCartId()}',
                  );
                GetAllCartResModel response = GetAllCartResModel.fromJson(res);
                if (response.status == 200) {
                  debugPrint('cart before = ${response.data}');
                  response.data?.data?.forEach((cartProduct) {
                    if (cartProduct.id == event.productId ||
                        cartProduct.id == state.productStockList[state.productListIndex]
                        [state.productStockUpdateIndex].productId
                    ) {
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
              if(response.product != null){
                add(HomeEvent.RelatedProductsEvent(context: event.context, productId: response.product?.first.id ?? ''));
              }
              if ( (event.isBarcode )) {

                productStockList[0][0] =  productStockList[0][0]
                    .copyWith(
                    quantity: _productQuantity,
                    productId: response.product?.first.id ?? '' ,
                    stock: (response.product?.first.supplierSales?.first.productStock.toString() ?? "0")
                );

                emit(state.copyWith(productStockList: productStockList));

              }


              List<ProductSupplierModel> supplierList = [];

              supplierList.addAll(response.product?.first.supplierSales
                  ?.map((supplier) => ProductSupplierModel(
                supplierId: supplier.supplierId ?? '',
                companyName: supplier.supplierCompanyName ?? '',
                basePrice:
                double.parse(supplier.productPrice ?? '0.0'),
                quantity: _productQuantity,
                stock: supplier.productStock.toString(),
                selectedIndex: (supplier.supplierId ?? '') ==
                    state
                        .productStockList[productListIndex]
                    [productStockUpdateIndex]
                        .productSupplierIds
                    ? supplier.saleProduct?.indexOf(
                    supplier.saleProduct?.firstWhere(
                          (sale) =>
                      sale.saleId ==
                          state
                              .productStockList[
                          productListIndex][
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
                          productListIndex][
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
              debugPrint('supplier list = ${supplierList}');
              // debugPrint(
              //     'supplier select index = ${supplierList.map((e) => e.selectedIndex)}');
              String note = productStockList.isEmpty
                  ? ''
                  : productStockList.indexOf(state.productStockList.last) ==
                  productListIndex
                  ? ''
                  : productStockList[productListIndex][0].note;
              emit(state.copyWith(productStockList: []));

              emit(state.copyWith(
                  productDetails: response.product ?? [],
                  productStockList: productStockList,
                  productStockUpdateIndex: productStockUpdateIndex,
                  productSupplierList: supplierList,
                  productListIndex: productListIndex,
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
                debugPrint('isSupplierSelected = ${state.productListIndex}');
                if (!isSupplierSelected || state.productListIndex == 0) {
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
            } else {
              Navigator.pop(event.context);
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          response.message!,
                      event.context),
                  type: SnackBarType.FAILURE);
            }
          } on ServerException {
            Navigator.pop(event.context);
            // emit(state.copyWith(isProductLoading: false));
          } /*catch (e) {
          debugPrint('bs error = $e');
          // Navigator.pop(event.context);
        }*/
        }

        else if (event is _IncreaseQuantityOfProduct) {
          List<List<ProductStockModel>> productStockList =
          state.productStockList.toList(growable: false);
          if (state.productStockUpdateIndex != -1) {
            if (productStockList[state.productListIndex]
            [state.productStockUpdateIndex]
                .quantity <
                double.parse(productStockList[state.productListIndex]
                [state.productStockUpdateIndex]
                    .stock.toString())) {
              if (productStockList[state.productListIndex]
              [state.productStockUpdateIndex]
                  .productSupplierIds
                  .isEmpty) {
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title:
                    '${AppLocalizations.of(event.context)!.please_select_supplier}',
                    type: SnackBarType.FAILURE);
                return;
              }
              productStockList[state.productListIndex]
              [state.productStockUpdateIndex] =
                  productStockList[state.productListIndex]
                  [state.productStockUpdateIndex].copyWith(
                      quantity: productStockList[state.productListIndex]
                      [state.productStockUpdateIndex]
                          .quantity +
                          1);
              debugPrint(
                  'product quantity = ${productStockList[state.productListIndex][state.productStockUpdateIndex].quantity}');
              emit(state.copyWith(productStockList: []));
              emit(state.copyWith(productStockList: productStockList));
            } else {
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title:
                  "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[state.productListIndex][state.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
                  // '${AppLocalizations.of(event.context)!.you_have_reached_maximum_quantity}',
                  type: SnackBarType.FAILURE);
            }
          }
        }
        else if (event is _DecreaseQuantityOfProduct) {
          List<List<ProductStockModel>> productStockList =
          state.productStockList.toList(growable: false);
          if (state.productStockUpdateIndex != -1) {
            if (productStockList[state.productListIndex]
            [state.productStockUpdateIndex]
                .quantity >
                0) {
              productStockList[state.productListIndex]
              [state.productStockUpdateIndex] =
                  productStockList[state.productListIndex]
                  [state.productStockUpdateIndex]
                      .copyWith(
                      quantity: productStockList[state.productListIndex]
                      [state.productStockUpdateIndex]
                          .quantity -
                          1);
              debugPrint(
                  'product quantity = ${productStockList[state.productListIndex][state.productStockUpdateIndex].quantity}');
              emit(state.copyWith(productStockList: []));
              emit(state.copyWith(productStockList: productStockList));
            } else {}
          }
        }
        else if (event is _UpdateQuantityOfProduct) {
          List<List<ProductStockModel>> productStockList =
          state.productStockList.toList(growable: false);
          if (state.productStockUpdateIndex != -1) {
            String quantityString = event.quantity;
            if (quantityString.length == 2 && quantityString.startsWith('0')) {
              quantityString = quantityString.substring(1);
            }
            int newQuantity = int.tryParse(quantityString) ?? 0;
            debugPrint('new quantity = $newQuantity');
            if (newQuantity <=
                double.parse(productStockList[state.productListIndex]
                [state.productStockUpdateIndex]
                    .stock.toString())) {
              productStockList[state.productListIndex]
              [state.productStockUpdateIndex] =
                  productStockList[state.productListIndex]
                  [state.productStockUpdateIndex]
                      .copyWith(quantity: newQuantity);
              debugPrint(
                  'product quantity update = ${productStockList[state.productListIndex][state.productStockUpdateIndex].quantity}');
              emit(state.copyWith(productStockList: []));
              emit(state.copyWith(productStockList: productStockList));
            } else {
              productStockList[state.productListIndex]
              [state.productStockUpdateIndex] =
                  productStockList[state.productListIndex]
                  [state.productStockUpdateIndex]
                      .copyWith(
                      quantity: int.tryParse(quantityString.substring(
                          0, quantityString.length - 1)) ??
                          0);
              debugPrint(
                  'product max quantity update = ${int.tryParse(quantityString.substring(0, quantityString.length - 1)) ?? 0}');
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title:
                  "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[state.productListIndex][state.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
                  type: SnackBarType.FAILURE);
              emit(state.copyWith(productStockList: []));
              emit(state.copyWith(productStockList: productStockList));
            }
          }
        }

        else if (event is _ChangeSupplierSelectionExpansionEvent) {
          emit(state.copyWith(
              isSelectSupplier:
              event.isSelectSupplier ?? !state.isSelectSupplier));
          debugPrint('supplier selection : ${state.isSelectSupplier}');
        }
        else if (event is _SupplierSelectionEvent) {
          debugPrint(
              'supplier[${event.supplierIndex}][${event.supplierSaleIndex}]');
          if (event.supplierIndex >= 0) {
            List<ProductSupplierModel> supplierList =
            state.productSupplierList.toList(growable: true);
            List< List<ProductStockModel>> productStockList =
            state.productStockList.toList(growable: true);

            productStockList[state.productListIndex][state.productStockUpdateIndex] =
                productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
                    productSupplierIds:
                    supplierList[event.supplierIndex].supplierId,
                    totalPrice: event.supplierSaleIndex == -2
                        ? supplierList[event.supplierIndex].basePrice
                        : supplierList[event.supplierIndex]
                        .supplierSales[event.supplierSaleIndex]
                        .salePrice,
                    stock: supplierList[event.supplierIndex].stock,
                    quantity:  supplierList[event.supplierIndex].quantity != 0 ? supplierList[event.supplierIndex].quantity : 1,
                    productSaleId: event.supplierSaleIndex == -2
                        ? ''
                        : supplierList[event.supplierIndex]
                        .supplierSales[event.supplierSaleIndex]
                        .saleId);
            /*debugPrint(
              'selected stock supplier = ${productStockList[state.productStockUpdateIndex]}');*/
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
        }
        else if (event is _AddToCartProductEvent) {
          if (state.productStockList[state.productListIndex][state.productStockUpdateIndex]
              .productSupplierIds.isEmpty) {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                '${AppLocalizations.of(event.context)!.please_select_supplier}',
                type: SnackBarType.FAILURE);
            return;
          }
          if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity ==
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
                productId: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productId == ''? event.productId :state.productStockList[state.productListIndex][state.productStockUpdateIndex].productId,
                supplierId: state.productStockList[state.productListIndex][state.productStockUpdateIndex]
                    .productSupplierIds,
                saleId: state.productStockList[state.productListIndex][state.productStockUpdateIndex]
                    .productSaleId ==
                    ''
                    ? null
                    : state.productStockList[state.productListIndex][state.productStockUpdateIndex]
                    .productSaleId,
                quantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex]
                    .quantity /*+ _productQuantity*/,
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
                Navigator.pop(event.context);
                List<List<ProductStockModel>> productStockList =
                state.productStockList.toList(growable: true);
                productStockList[state.productListIndex][state.productStockUpdateIndex] =
                    productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
                      isNoteOpen: false,
                      quantity:  _productQuantity,
                      productSupplierIds: '',
                      totalPrice: productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice,
                      productSaleId: '',
                    );
                emit(state.copyWith(
                    isLoading: false, productStockList: productStockList,cartCount: preferences.getCartCount()));
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(
                        response.message?.toLocalization() ?? response.message!,
                        event.context),
                    type: SnackBarType.SUCCESS);
              } else {
                emit(state.copyWith(isLoading: false));
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(
                        response.message?.toLocalization() ??
                            response.message!,
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
                        .productStockList[state.productListIndex][state.productStockUpdateIndex]
                        .productId,
                    quantity: state
                        .productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                    supplierId: state
                        .productStockList[state.productListIndex][state.productStockUpdateIndex]
                        .productSupplierIds,
                    saleId: state.productStockList[state.productListIndex][state.productStockUpdateIndex]
                        .productSaleId.isEmpty
                        ? null
                        : state.productStockList[state.productListIndex][state.productStockUpdateIndex]
                        .productSaleId,
                    note: state.productStockList[state.productListIndex][state.productStockUpdateIndex]
                        .note.isEmpty
                        ? null
                        : state
                        .productStockList[state.productListIndex][state.productStockUpdateIndex].note)
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
                );
              InsertCartResModel response = InsertCartResModel.fromJson(res);
              if (response.status == 201) {
                add(HomeEvent.setCartCountEvent());
                Vibration.vibrate();
                Navigator.pop(event.context);
                List<List<ProductStockModel>> productStockList =
                state.productStockList.toList(growable: true);
                debugPrint('quandjfd____${state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity}');
                productStockList[state.productListIndex][state.productStockUpdateIndex] =
                    productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
                      isNoteOpen: false,
                      quantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                      productSupplierIds: '',
                      totalPrice: productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice,
                      productSaleId: '',
                    );

                emit(state.copyWith(
                    isLoading: false, productStockList: productStockList,isCartCountChange: false));
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(
                        response.message?.toLocalization() ?? response.message!, event.context),
                    type: SnackBarType.SUCCESS);
              } else if (response.status == 403) {
                emit(state.copyWith(isLoading: false));
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(
                        response.message?.toLocalization() ??
                            response.message!,
                        event.context),
                    type: SnackBarType.FAILURE);
              } else {
                emit(state.copyWith(isLoading: false));
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(
                        response.message?.toLocalization() ??
                            response.message!,
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
        }
        else if (event is _SetCartCountEvent) {
          await preferences.setIsAnimation(isAnimation: true);
          await preferences.setCartCount(count: preferences.getCartCount() + 1);
          emit(state.copyWith(cartCount: preferences.getCartCount(),isCartCountChange: true));
          debugPrint('cart count home = ${state.cartCount}');
        }
        else if (event is _getWalletRecordEvent) {
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
          } on ServerException {} catch (e) {}
        }
        else if (event is _getOrderCountEvent) {
          try {
            int daysInMonth(DateTime date) =>
                DateTimeRange(
                    start: DateTime(date.year, date.month, 1),
                    end: DateTime(date.year, date.month + 1))
                    .duration
                    .inDays;

            var now = DateTime.now();

            GetOrderCountReqModel reqMap = GetOrderCountReqModel(
              startDate: DateTime(now.year, now.month, 1),
              endDate: DateTime(
                  now.year, now.month, daysInMonth(DateTime.now())),
            );

            debugPrint('getOrdersCount reqMap = $reqMap}');

            final res = await DioClient(event.context).post(
              AppUrls.getOrdersCountUrl,
              data: reqMap,
            );

            debugPrint('getOrdersCountUrl url  = ${AppUrls.getOrdersCountUrl}');
            GetOrderCountResModel response = GetOrderCountResModel.fromJson(
                res);
            debugPrint('getOrdersCount response  = ${response}');

            if (response.status == 200) {
              emit(state.copyWith(orderThisMonth: response.data!.toInt()));
            }
          } on ServerException {} catch (e) {}
        }
        else if (event is _GetMessageListEvent) {

          try {
            final res = await DioClient(event.context).post(
                AppUrls.getNotificationMessageUrl,
                data: GetMessagesReqModel(
                    pageNum: 1,
                    pageLimit: 2).toJson(),
              );

            GetMessagesResModel response = GetMessagesResModel.fromJson(res);


            debugPrint('getMessage response  = ${response}');
            if (response.status == 200) {
              List<MessageData> messageList =
              state.messageList.toList(growable: true);
              if(response.data?.isNotEmpty  ?? false){
                messageList.addAll(response.data
                    ?.map((message) => MessageData(
                  id: message.id,
                  isRead: message.isRead,
                  message: Message(
                      id: message.message?.id ?? '',
                      title: message.message?.title ?? '',
                      summary: message.message?.summary ?? '',
                      body: message.message?.body ?? '',
                      messageImage: message.message?.messageImage ?? '',
                      subPage: message.message?.subPage?? '',
                      mainPage: message.message?.mainPage ?? '',
                      navigationId: message.message?.navigationId ?? ''
                  ),
                  createdAt: message.createdAt,
                  updatedAt: message.updatedAt,
                ))
                    .toList() ??
                    []);
              }
              debugPrint('new message list len = ${messageList.length}');
              emit(state.copyWith(
                  messageList: messageList, isMessageShimmering: false));
            } else {}
          } on ServerException {}
        }
        else if (event is _SetMessageCountEvent) {
          emit(state.copyWith(
              messageCount: state.messageCount + event.messageCount));
        }
        else if (event is _RemoveOrUpdateMessageEvent) {
          List<MessageData> messageList =
          state.messageList.toList(growable: true);
          debugPrint('message list len before delete = ${messageList.length}');
          SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
              prefs: await SharedPreferences.getInstance());
          debugPrint('message count = ${preferencesHelper.getMessageCount()}');
          debugPrint(
              'message actual status = ${messageList[messageList.indexOf(
                  messageList.firstWhere((message) =>
                  message.id == event.messageId))].isRead}');
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
        }
        else if (event is _UpdateImageIndexEvent) {
          emit(state.copyWith(imageIndex: event.index));
        }
        else if (event is _UpdateMessageListEvent) {
          if (event.messageIdList.isNotEmpty) {
            List<MessageData> messageList =
            state.messageList.toList(growable: true);
            messageList.removeWhere(
                    (message) => event.messageIdList.contains(message.id));
            debugPrint('message len = ${messageList.length}');
            emit(state.copyWith(messageList: messageList));
          }
        }

        else if (event is _getProfileDetailsEvent) {

          try {
            debugPrint('req = ${preferences.getUserId()}');
            final res = await DioClient(event.context).post(
                AppUrls.getProfileDetailsUrl,
                data: ProfileDetailsReqModel(id: preferences.getUserId())
                    .toJson(),
                options: Options(
                  headers: {
                    HttpHeaders.authorizationHeader:
                    'Bearer ${preferences.getAuthToken()}',
                  },
                ));
            debugPrint('res = ${res}');
            ProfileDetailsResModel response =
            ProfileDetailsResModel.fromJson(res);
            if (response.status == 200) {
              debugPrint(
                  'image = ${response.data?.clients?.first.profileImage}');
              preferences.setUserImageUrl(imageUrl: response.data?.clients
                  ?.first.profileImage ?? '');
              preferences.setUserCompanyLogoUrl(logoUrl: response.data?.clients
                  ?.first.logo ?? '');
              preferences.setEmailId(userEmailId: response.data?.clients?.first
                  .email ?? '');
              emit(
                state.copyWith(
                    UserImageUrl: response.data?.clients?.first.profileImage ??
                        '',
                    UserCompanyLogoUrl: response.data?.clients?.first.logo ?? ''
                ),
              );
            } else {

            }
          } on ServerException {
          } catch (e) {
          }
        }

        else if (event is _GetRecommendationProductsListEvent) {
          try {
            emit(state.copyWith(isShimmering: true));
            final res = await DioClient(event.context).post(
              AppUrls.getRecommendationProductsUrl,
              data: RecommendationProductsReqModel(
                  pageNum: 1, pageLimit: AppConstants.defaultPageLimit)
                  .toJson(),
            );
            RecommendationProductsResModel response =
            RecommendationProductsResModel.fromJson(res);
            debugPrint('getRecommendationProductsUrl       ${AppUrls.baseUrl}${AppUrls.getRecommendationProductsUrl}');
            debugPrint('response       ${response.status}');
            if (response.status == 200) {
              List<List<ProductStockModel>> productStockList =
              state.productStockList.toList(growable: true);
              List<ProductStockModel>stockList = [];
              /*ProductStockModel barcodeStock = productStockList.removeLast();*/
              stockList.addAll(response.data?.map(
                      (recommendationProduct) =>
                      ProductStockModel(
                          productId: recommendationProduct.id ?? '',
                          stock: recommendationProduct.productStock.toString(),
                      )) ??
                  []);
              productStockList[1].addAll(stockList);
              //productStockList.add(barcodeStock);
              emit(state.copyWith(
                  recommendedProductsList: response.data ?? [],
                  productStockList: productStockList,
                  isShimmering: false));
            } else {
              emit(state.copyWith(isShimmering: false));
              /*CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                '${AppLocalizations.of(event.context)!
                    .something_is_wrong_try_again}',
                type: SnackBarType.SUCCESS,
              );*/
            }
          } on ServerException {
            emit(state.copyWith(isShimmering: false));
          } catch (exc) {
            emit(state.copyWith(isShimmering: false));
          }
        }

        else if (event is _ChangeCategoryExpansion) {
          if (event.isOpened != null) {
            emit(state.copyWith(isCategoryExpand: event.isOpened ?? false));
          } else {
            emit(state.copyWith(isCategoryExpand: !state.isCategoryExpand));
          }
        }
        else if (event is _GlobalSearchEvent) {
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
            debugPrint(
                'sub cat len = ${response.data?.subCategoryData?.length}');
            debugPrint('com len = ${response.data?.companyData?.length}');
            debugPrint('sale len = ${response.data?.saleData?.length}');
            debugPrint('sup len = ${response.data?.supplierData?.length}');
            debugPrint(
                'sup stag len = ${response.data?.supplierProductData?.length}');
            if (state.searchController.text == '') {
              List<SearchModel> searchList = [];
              searchList.addAll(state.productCategoryList.map((category) =>
                  SearchModel(
                      searchId: category.id ?? '',
                      name: category.categoryName ?? '',
                      searchType: SearchTypes.category,
                      image: category.categoryImage ?? '',
                  )));
              emit(state.copyWith(searchList: searchList, isSearching: false));
              return;
            }
            debugPrint('store search list =${response.status}');
            if (response.status == 200) {
              List<SearchModel> searchList = [];
              //category search result
              searchList.addAll(response.data?.categoryData
                  ?.map((category) =>
                  SearchModel(
                      searchId: category.id ?? '',
                      name: category.categoryName ?? '',
                      searchType: SearchTypes.category,
                      image: category.categoryImage ?? ''))
                  .toList() ??
                  []);
              //subcategory search result
              searchList.addAll(response.data?.subCategoryData
                  ?.map((subCategory) =>
                  SearchModel(
                    searchId: subCategory.id ?? '',
                    name: subCategory.subCategoryName ?? '',
                    searchType: SearchTypes.subCategory,
                    image: '',
                    categoryId: subCategory.parentCategoryId ?? '',
                    categoryName: subCategory.parentCategoryName ?? '',

                  ))
                  .toList() ??
                  []);
              //company search result
              searchList.addAll(response.data?.companyData
                  ?.map((company) =>
                  SearchModel(
                    searchId: company.id ?? '',
                    name: company.brandName ?? '',
                    searchType: SearchTypes.company,
                    image: company.brandLogo ?? '',
                  ))
                  .toList() ??
                  []);
              // supplier search result
              searchList.addAll(response.data?.supplierData
                  ?.map((supplier) =>
                  SearchModel(
                    searchId: supplier.id ?? '',
                    name: supplier.supplierDetail?.companyName ?? '',
                    searchType: SearchTypes.supplier,
                    image: supplier.logo ?? '',
                  ))
                  .toList() ??
                  []);
              //sale search result
              searchList.addAll(response.data?.saleData
                  ?.map((sale) =>
                  SearchModel(
                    searchId: sale.id ?? '',
                    name: sale.productName ?? '',
                    searchType: SearchTypes.sale,
                    image: sale.mainImage ?? '',
                    numberOfUnits: int.parse(sale.numberOfUnit.toString()),
                  ))
                  .toList() ??
                  []);
              //supplier products result
              searchList.addAll(response.data?.supplierProductData
                  ?.map((supplier) =>
                  SearchModel(
                      searchId: supplier.productId ?? '',
                      name: supplier.productName ?? '',
                      searchType: SearchTypes.product,
                      image: supplier.mainImage ?? '',
                      productStock: supplier.productStock.toString(),
                    numberOfUnits: int.parse(supplier.numberOfUnit.toString()) ,
                    priceOfBox: double.parse(supplier.productPrice.toString()),
                    lowStock: supplier.lowStock.toString()

                  ))
                  .toList() ??
                  []);
              debugPrint('store search list = ${searchList.length}');
              emit(state.copyWith(
                  searchList: searchList,
                  search: state.searchController.text,
                  isSearching: false));
            } else {
              emit(state.copyWith(isSearching: false));
            }
          } on ServerException {
            CustomSnackBar.showSnackBar(
              context: event.context,
              title:
              '${AppLocalizations.of(event.context)!
                  .something_is_wrong_try_again}',
              type: SnackBarType.FAILURE,
            );
            emit(state.copyWith(isSearching: false));
          } catch (exc) {
            CustomSnackBar.showSnackBar(
              context: event.context,
              title:
              '${AppLocalizations.of(event.context)!
                  .something_is_wrong_try_again}',
              type: SnackBarType.FAILURE,
            );
            emit(state.copyWith(isSearching: false));
          }
        }
        else if (event is _UpdateGlobalSearchEvent) {
          emit(state.copyWith(
              searchController: TextEditingController(text: event.search),
              searchList: event.searchList));
        }

        else if (event is _GetProductCategoriesListEvent) {
          try {
            emit(state.copyWith(isShimmering: true));
            final res = await DioClient(event.context).post(
                AppUrls.getProductCategoriesUrl,
                data: ProductCategoriesReqModel(
                    pageNum: 1, pageLimit: 18)
                    .toJson());
            ProductCategoriesResModel response =
            ProductCategoriesResModel.fromJson(res);
            debugPrint('product categories = ${response.data?.categories!.length
                .toString()}');
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
              bool productVisible = response.data?.categories?.any((
                  element) => element.isHomePreference == true) ?? true;

              emit(state.copyWith(
                  isCatVisible: productVisible,
                  productCategoryList: response.data?.categories ?? [],
                  searchList: searchList,
                  isShimmering: false));
            } else {
              emit(state.copyWith(isShimmering: false));
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                type: SnackBarType.SUCCESS,

              );
            }
          } on ServerException {
            emit(state.copyWith(isShimmering: false));
          } catch (exc) {
            emit(state.copyWith(isShimmering: false));
          }
        }

       else if (event is _checkVersionOfAppEvent) {
          final _checker = StoreVersionChecker();
          _checker.checkUpdate().then((value) {
            debugPrint('update available');
            debugPrint(value.canUpdate.toString()); //return true if update is available
            debugPrint(value.currentVersion); //return current app version
            debugPrint(value.newVersion); //return the new app version
            debugPrint(value.appURL); //return the app url
            debugPrint(value.errorMessage);
            if(value.canUpdate && Platform.isAndroid){
              customShowUpdateDialog(
                  event.context, preferences.getAppLanguage(),value.appURL ?? 'https://play.google.com/store/apps/details?id=com.foodstock.dev');
            }else if(value.canUpdate && Platform.isIOS){
                customShowUpdateDialog(
                    event.context, preferences.getAppLanguage(),value.appURL ?? 'https://apps.apple.com/ua/app/tavili/id6468264054');
              }
          });
        }

        else if(event is _RelatedProductsEvent){
          emit(state.copyWith(isRelatedShimmering:true));
          debugPrint('productId____${event.productId}');
          final res = await DioClient(event.context).post(
              AppUrls.relatedProductsUrl,
              data: {'mainProductId':event.productId});
          RelatedProductResModel response =
          RelatedProductResModel.fromJson(res);
          debugPrint('product categories = ${response.data.length
              .toString()}');
          if (response.status == 200) {
            List<List<ProductStockModel>> productStockList =
            state.productStockList.toList(growable: true);
            List<ProductStockModel>stockList = [];
            stockList.addAll(response.data.map(
                    (Product) =>
                    ProductStockModel(
                      productId: Product.id,
                      stock: (Product.productStock.toString()),
                    )));
            productStockList[2].addAll(stockList);
            print('productStockList[2] length____${productStockList[2].length}');
            print('productStockList[0] length____${productStockList[0].length}');
            print('productStockList[1] length____${productStockList[1].length}');
            emit(state.copyWith(
                relatedProductList:response.data,
                isRelatedShimmering: false,productStockList: productStockList));
          } else {
            emit(state.copyWith(isRelatedShimmering: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(
                  response.message.toLocalization() ,
                  event.context),
              type: SnackBarType.SUCCESS,
            );
          }
        }
        else if(event is _RemoveRelatedProductEvent){
          emit(state.copyWith(relatedProductList: []));
        }
      }
    });
  }
}