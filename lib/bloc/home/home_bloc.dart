import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:food_stock/data/model/req_model/product_sales_req_model/product_sales_req_model.dart';
import 'package:food_stock/data/model/req_model/update_cart/update_cart_req_model.dart';
import 'package:food_stock/data/model/res_model/message_count_res_model/message_count_res_model.dart';
import 'package:food_stock/data/model/res_model/product_details_res_model/product_details_res_model.dart';
import 'package:food_stock/data/model/res_model/related_product_res_model/related_product_res_model.dart';
import 'package:food_stock/data/model/res_model/setting_res_model/setting_res_model.dart';
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
import '../../data/model/res_model/account_permission/account_permission_res_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/get_messages_res_model/get_messages_res_model.dart';
import '../../data/model/res_model/global_search_res_model/global_search_res_model.dart';
import '../../data/model/res_model/insert_cart_res_model/insert_cart_res_model.dart';
import '../../data/model/res_model/order_count/get_order_count_res_model.dart';
import '../../data/model/res_model/product_sales_res_model/product_sales_res_model.dart';
import '../../data/model/res_model/profile_details_res_model/profile_details_res_model.dart';
import '../../data/model/res_model/update_cart_res/update_cart_res_model.dart';
import '../../data/model/res_model/verify_client_res_model/verify_client_res_model.dart';
import '../../data/model/res_model/wallet_record_res/wallet_record_res_model.dart';
import '../../data/model/search_model/search_model.dart';
import '../../data/model/supplier_sale_model/supplier_sale_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';
import '../../data/model/res_model/recommendation_products_res_model/recommendation_products_res_model.dart';
import 'package:food_stock/data/model/res_model/product_categories_res_model/product_categories_res_model.dart';

import '../../ui/widget/common_alert_dialog.dart';

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
      if (preferences.getGuestUser()) {}
      else {

        if (event is _getPreferencesDataEvent) {
          debugPrint(
              'getUserImageUrl ${preferences.getUserImageUrl()}');
          debugPrint(
              'getUserCompanyLogoUrl ${preferences.getUserCompanyLogoUrl()}');
          debugPrint('cart count ${preferences.getCartCount()}');
          debugPrint('message count ${preferences.getMessageCount()}');
          debugPrint('can add basket ${preferences.getCanAddToBasket()}');
          debugPrint('can see wallet ${preferences.getCanSeeWallet()}');
          emit(state.copyWith(
              isIncludedVat: preferences.getIsIncludedVat(),
              isSaleOn: preferences.getShowSale(),
            isSubUserSeeWallet: preferences.getCanSeeWallet(),
              isSubUserAddToBasket :preferences.getCanAddToBasket(),
            UserImageUrl: preferences.getUserImageUrl(),
            UserCompanyLogoUrl: preferences.getUserCompanyLogoUrl(),
            messageCount: preferences.getMessageCount(),
            cartCount: preferences.getCartCount(),
            bottlePrice: preferences.getBottleTax()
          ));
        }
        else if (event is _GetCartCountEvent) {
          debugPrint('id_______${preferences.getUserId()}');
          try {
            final res = await DioClient(event.context).post(
                '${AppUrls.getAllCartUrl}${preferences.getCartId()}',
              );
            GetAllCartResModel response = GetAllCartResModel.fromJson(res);
            if (response.status == 200) {
              debugPrint('cart1 = ${response.data}');
              debugPrint('main cart count = ${response.data?.data?.length}');
              emit(state.copyWith(isCartCountChange: true));
              await preferences.setCartCount(
                  count: response.data?.data?.length ??
                      preferences.getCartCount());
              emit(state.copyWith(cartCount: preferences.getCartCount(),isCartCountChange: false));
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
              //3 sales product.
              print('product___${response.product}');

              if(response.product?.isNotEmpty ?? false){

              List<List<ProductStockModel>> productStockList =
              state.productStockList.toList(growable: true);
              int productListIndex  = event.productListIndex;
              debugPrint('productStockList___${productStockList[2].length}');
              debugPrint('productListIndex___${event.productListIndex}');
              int productStockUpdateIndex = 0;
              if(event.isBarcode ){
                productStockUpdateIndex = 0;
                debugPrint('responseproductid____${response.product?.first.id}');
                productStockList[0][0] =  productStockList[0][0]
                    .copyWith(
                  quantity: _productQuantity,
                  productId: response.product?.first.id ?? '',
                  stock: (response.product?.first.supplierSales?.first.productStock.toString()  ?? '0'),
                  maxQty: (response.product?.first.sale?.isSale ?? false) ? int.parse(response.product?.first.sale?.saleMaxQuantity ?? '0') : -1,
                );
              }
              else{
                productStockUpdateIndex = state.productStockList[productListIndex]
                    .indexWhere((productStock) =>
                productStock.productId == event.productId);
              //  productStockList.elementAt(productListIndex).elementAt(productStockUpdateIndex).maxQty = response.product.first.sale.isSale?int.parse(response.product.first.sale.saleMaxQuantity):-1;
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
                      _productQuantity = cartProduct.totalQuantity  ?? 0;
                      return;
                    }
                  });
                  debugPrint(
                      '1)exist = $_isProductInCart\n2)id = $_cartProductId\n3) quan = $_productQuantity');
                }
              } on ServerException {}
              if(response.product!.isNotEmpty){
                add(HomeEvent.RelatedProductsEvent(context: event.context, productId: response.product?.first.id ?? ''));
              }
              if (event.isBarcode) {

                debugPrint('responseproductid____${response.product?.first.id}');
                productStockList[0][0] =  productStockList[0][0]
                    .copyWith(
                  quantity: _productQuantity,
                  productId: response.product?.first.id ?? '',
                  stock: (response.product?.first.supplierSales?.first.productStock.toString()  ?? '0'),
                  maxQty: (response.product?.first.sale?.isSale ?? false) ? int.parse(response.product?.first.sale?.saleMaxQuantity ?? '0') : -1,
                );

                emit(state.copyWith(productStockList: productStockList));

              }


              List<ProductSupplierModel> supplierList = [];

              supplierList.addAll(response.product?.first.supplierSales?.map((supplier) {
                return ProductSupplierModel(
                  supplierId: supplier.supplierId ?? '',
                  companyName: supplier.supplierCompanyName ?? '',
                  basePrice:
                  double.parse(supplier.productPrice ?? ''),
                  quantity: _productQuantity,
                  stock: supplier.productStock.toString(),
                  maxQty:(response.product?.first.sale?.isSale ?? false) ? int.parse(response.product?.first.sale?.saleMaxQuantity.toString() ?? ''):-1,
                  selectedIndex: (supplier.supplierId ) ==
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
                      orElse: () => SaleProduct(isSale: false,saleDescription: '',saleFromDate: '',saleMaxQuantity: '0',salePrice: '0',saleUntilDate:'' ),
                    ) ??
                        SaleProduct(isSale: false,saleDescription: '',saleFromDate: '',saleMaxQuantity: '0',salePrice: '0',saleUntilDate:'' ),) ==
                      -1
                      ? -2
                      : supplier.saleProduct?.indexOf(
                    supplier.saleProduct?.firstWhere(
                          (sale) =>
                      sale.saleId ==
                          state.productStockList[
                          productListIndex][
                          productStockUpdateIndex]
                              .productSaleId,
                      orElse: () => SaleProduct(isSale: false,saleDescription: '',saleFromDate: '',saleMaxQuantity: '0',salePrice: '0',saleUntilDate:'' ),
                    ) ??
                        SaleProduct(isSale: false,saleDescription: '',saleFromDate: '',saleMaxQuantity: '0',salePrice: '0',saleUntilDate:'' ),) ??
                      -1
                      : -1,
                  supplierSales: supplier.saleProduct?.map((sale) => SupplierSaleModel(
                      productStock: sale.productStock??0,
                      quantity: _productQuantity,
                      saleId: sale.saleId ?? '',
                      saleName: sale.saleName ?? '',
                      maxQty: sale.saleMaxQuantity,
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
                );
              })
                  .toList() ??
                  []);
              supplierList.removeWhere((supplier) => supplier.stock == 0);
              debugPrint(
                  'response list = ${response.product?.first.supplierSales?.length}');
              debugPrint('supplier list = ${supplierList}');
              debugPrint('productStockUpdateIndex$productStockUpdateIndex');
              // debugPrint(
              //     'supplier select index = ${supplierList.map((e) => e.selectedIndex)}');

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
            }
            else{
                emit(state.copyWith(isProductLoading: false,
                  productDetails: []
                ));
              }
            }
              else {
              emit(state.copyWith(isProductLoading: false));
              Navigator.pop(event.context);
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ?? '',
                      event.context),
                  type: SnackBarType.FAILURE);
            }
          } on ServerException {
            Navigator.pop(event.context);
             emit(state.copyWith(isProductLoading: false));
          }
        }
        else if (event is _GetProductSalesListEvent) {
          try {
            emit(state.copyWith(isShimmering: true));
            final res = await DioClient(event.context).post(
                AppUrls.getSaleProductsUrl,
                data: ProductSalesReqModel(
                    pageNum: 1, pageLimit: AppConstants.defaultPageLimit)
                    .toJson());
            ProductSalesResModel response = ProductSalesResModel.fromJson(res);
            debugPrint('sale response____${response}');

            if (response.status == 200) {

              debugPrint('sale Products = ${response.data?.length}');
             List< List<ProductStockModel>> productStockList =
              state.productStockList.toList(growable: true);
              List<ProductStockModel>stockList = [];

              stockList.addAll(response.data?.map(
                      (saleProduct) =>
                      ProductStockModel(
                          maxQty: (saleProduct.sale?.isSale ?? false) ? int.parse(saleProduct.sale?.saleMaxQuantity ?? '0') : -1,
                          productId: saleProduct.id ?? '',
                        stock: (saleProduct.productStock.toString())
                      )) ??
                  []);
              productStockList[3].addAll(stockList);

              emit(state.copyWith(
                  productSalesList: response.data ?? [] ,
                  productStockList: productStockList,
                  isShimmering: false));
            } else {
              emit(state.copyWith(isShimmering: false));
              CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                type: SnackBarType.FAILURE,
              );
            }
          } on ServerException {
            emit(state.copyWith(isShimmering: false));
          } catch (exc) {
            emit(state.copyWith(isShimmering: false));
          }
        }
        else if (event is _IncreaseQuantityOfProduct) {
          debugPrint('maxQty:${ state.productStockList[state.productListIndex]
          [state.productStockUpdateIndex]
              .maxQty}');
          debugPrint('quantity:${ state.productStockList[state.productListIndex]
          [state.productStockUpdateIndex]
              .quantity}');
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

                return;
              }
                if(productStockList[state.productListIndex]
                [state.productStockUpdateIndex]
                    .maxQty!=-1){
                  if (productStockList[state.productListIndex]
                  [state.productStockUpdateIndex]
                      .quantity >=
                      productStockList[state.productListIndex]
                      [state.productStockUpdateIndex]
                          .maxQty) {
                    CustomSnackBar.showSnackBar(
                        context: event.context,
                        title: '${AppLocalizations.of(event.context)!.not_add_more_than_max_qty}',
                        type: SnackBarType.FAILURE);
                    return;
                  }
                }
              debugPrint('hi');
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
                    maxQty: supplierList[event.supplierIndex].maxQty,
                    quantity:  supplierList[event.supplierIndex].quantity != 0 ? supplierList[event.supplierIndex].quantity : 1,
                    productSaleId: event.supplierSaleIndex == -2
                        ? ''
                        : supplierList[event.supplierIndex]
                        .supplierSales[event.supplierSaleIndex]
                        .saleId);
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
          debugPrint('cart id_____${preferences.getCartId()}');
          debugPrint('quantity  quantity :${state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity}');
          if (state.productStockList[state.productListIndex][state.productStockUpdateIndex]
              .productSupplierIds.isEmpty) {
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
          if(state.productStockList[state.productListIndex][state.productStockUpdateIndex].maxQty > 0){
            if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity >
                state.productStockList[state.productListIndex][state.productStockUpdateIndex].maxQty
            ) {
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: '${AppLocalizations.of(event.context)!.not_add_more_than_max_qty}',
                  type: SnackBarType.FAILURE);
              return;
            }
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
                      note: '',
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
                productStockList[state.productListIndex][state.productStockUpdateIndex] =
                    productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
                      note: '',
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
              emit(state.copyWith(messageList: []));
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
        else if (event is _ToggleNoteEvent) {
          List <List<ProductStockModel>> productStockList =
          state.productStockList.toList(growable: true);
          productStockList[state.productListIndex][state.productStockUpdateIndex] =
              productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
                  isNoteOpen: !productStockList[state.productListIndex][state.productStockUpdateIndex]
                      .isNoteOpen);
          emit(state.copyWith(productStockList: productStockList));
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

              preferences.setBusinessName(businessName: response.data?.clients?.first.clientDetail?.bussinessName ?? '');
              preferences.setEmailId(userEmailId: response.data?.clients?.first
                  .email ?? '');
              if(!preferences.getSubUser()){
                preferences.setUserImageUrl(imageUrl: response.data?.clients
                    ?.first.profileImage ?? '');

                emit(
                  state.copyWith(
                    UserImageUrl: response.data?.clients?.first.profileImage ?? '',
                  ),
                );
              }

              String? phoneNumber = await Smartlook.instance.user.properties.getString("User phone number");

              if(phoneNumber == '' || phoneNumber == null) {
                Smartlook.instance.user.setIdentifier(preferences.getUserId());
                Smartlook.instance.user.setEmail(preferences.getEmailId());
                Smartlook.instance.user.setName(preferences.getUserName());
                Smartlook.instance.user.properties.putString('User business name' ,value:preferences.getBusinessName());
                Smartlook.instance.user.properties.putString('User phone number' ,value:preferences.getPhoneNumber());
              }

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
                        maxQty: (recommendationProduct.sale?.isSale?? false) ? int.parse(recommendationProduct.sale?.saleMaxQuantity ?? '0') : -1,
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

              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                type: SnackBarType.FAILURE,
              );
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
            GlobalSearchReqModel(search: state.searchController.text,
                sortField: AppStrings.sortFieldString,
                sortOrder: AppStrings.sortOrderString
            );
            emit(state.copyWith(isSearching: true,bottlePrice: preferences.getBottleTax()));
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
                  /*  salePrice: double.parse(supplier.sale.salePrice.toString()),
                    salesDesc:  parse(supplier.sale.saleDescription ?? '')
                        .body
                        ?.text ??
                        '',*/

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
                    salesDesc:   parse(sale.salesDescription ?? '')
                        .body
                        ?.text ??
                        '',
                  //  salePrice:double.parse(sale.salePrice.toString()),
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
                    priceOfBox: double.parse(supplier.productPrice.toString()) ,
                    lowStock: supplier.lowStock.toString(),
                    isPesach: supplier.isPesach??false,
                    salePrice: double.parse(supplier.sale?.salePrice.toString() ?? '0'),
                    salesDesc:  parse(supplier.sale?.saleDescription ?? '')
                        .body
                        ?.text ??
                        '',
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
          debugPrint('productId__11__${event.productId}');
          final res = await DioClient(event.context).post(
              AppUrls.relatedProductsUrl,
              data: {'mainProductId':event.productId});

          debugPrint('related product url__${AppUrls.relatedProductsUrl}');

          RelatedProductResModel response =
          RelatedProductResModel.fromJson(res);
          debugPrint('product categories = ${response.data?.length
              .toString()}');
          if (response.status == 200) {
            List<List<ProductStockModel>> productStockList =
            state.productStockList.toList(growable: true);
            List<ProductStockModel>stockList = [];
            stockList.addAll(response.data?.map(
                    (Product) =>
                    ProductStockModel(
                      productId: Product.id ?? '',
                      stock: (Product.productStock.toString()),
                    )) ?? []);
            productStockList[2].addAll(stockList);

            emit(state.copyWith(
                relatedProductList:response.data ?? [],
                isRelatedShimmering: false,productStockList: productStockList));
          } else {

            emit(state.copyWith(isRelatedShimmering: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(
                  response.message?.toLocalization() ?? '' ,
                  event.context),
              type: SnackBarType.SUCCESS,
            );
          }
        }
        else if(event is _RemoveRelatedProductEvent){
          emit(state.copyWith(relatedProductList: []));
        }
        else if(event is _updateMaintenanceEvent){
          emit(state.copyWith(isDialogOpen: true));
        }
        else if(event is _GeneralSettings){
          try {
            emit(state.copyWith(pesachBannerShimmering: true,retryLoading:event.isRetryLoading));

            final res = await DioClient(event.context).get(path: AppUrls.generalSettingUrl);
            SettingResModel response = SettingResModel.fromJson(res);

            debugPrint('general settings = ${response.data.toString()}');
            if (response.status == 200) {
              if(preferences.getAppOnMaintenance() &&  !(response.data?.isAppOnMaintenance??false)){
                add(HomeEvent.updateMaintenanceEvent(context: event.context));
                Navigator.pop(event.dialogContext);
                preferences.setIsAppOnMaintenance(isAppOnMaintenance: false);
                emit(state.copyWith(isDialogOpen: false,isAppOnMaintenance: false,retryLoading: false));
                debugPrint('pop dialog');
                return;
              }else{
                if(!state.isDialogOpen && !(response.data?.isAppOnMaintenance??false)  ){
                  debugPrint('here');
                  emit(state.copyWith(isDialogOpen: true));
                }
              }
              preferences.setIsSaleOn(isSaleOn:  response.data?.isSaleOn ?? false);
              preferences.setIsIncludedVat(isIncludedVat:
              (response.data?.showVatApplication?.contains(AppStrings.appName) ?? false) ? true : false);
              preferences.setBottleTax(bottleDeposit: response.data?.bottlePrice ?? 0.0);
              preferences.setIsAppOnMaintenance(isAppOnMaintenance: response.data?.isAppOnMaintenance??false);

              emit(state.copyWith(
                 language: preferences.getAppLanguage(),
                  pesachBannerShimmering:false,
                  pesachBannerURL:response.data?.pesachBanner ?? '',
                  showPesachBanner: response.data?.isShowPesachBanner ?? false,
                  bottlePrice:response.data?.bottlePrice ?? 0.0,
                isIncludedVat: preferences.getIsIncludedVat(),
                isSaleOn: preferences.getShowSale(),
                  retryLoading: false,
                isAppOnMaintenance: preferences.getAppOnMaintenance()
              ));
            } else {
              emit(state.copyWith(pesachBannerShimmering: false,retryLoading:false));
            }
          } on ServerException {
            emit(state.copyWith(pesachBannerShimmering: false,retryLoading:false));
          } catch (exc) {
            emit(state.copyWith(pesachBannerShimmering: false,retryLoading:false));
          }
        }
        else  if(event is _getPermissionList){
        if(preferences.getSubUser()){
          try {
            final res = await DioClient(event.context).get(
                path: '${AppUrls.getAccountPermissionUrl}${preferences.getSubUserId()}');
            AccountPermissionResModel response = AccountPermissionResModel.fromJson(res);
            debugPrint('AccountPermission response = ${response.data.toString()}');
            debugPrint('AccountPermission url = ${AppUrls.baseUrl}${AppUrls.getAccountPermissionUrl}${preferences.getSubUserId()}');
            if (response.status == 200) {
              var res = response.data?.permissions;
              preferences.setCanSeeWallet(isSeeWallet: res?.canSeeWallet ?? false);
              emit(state.copyWith(isAccountPermissionShimmering: true));
              preferences.setCanAddBasket(isAddBasket: res?.canAddToCart ?? false);
              preferences.setCanCreateOrder(isCreateOrder: res?.canCreateOrder ?? false);
              preferences.setCanSeeOrder(isSeeOrder: res?.canSeeOrders ?? false);
              preferences.setCanDuplicateOrder(isDuplicateOrder: res?.canDuplicateOrders ?? false);
              preferences.setCanUpdateBusinessInfo(isUpdateBusinessInfo: res?.canSeeAndUpdateBusinessInfo ?? false);
              preferences.setCanUpdateAdditionalInfo(isUpdateAdditionalInfo: res?.canSeeAndUpdateAdditionalInfo   ?? false);
              preferences.setCanUpdateTimeInfo(isUpdateTimeInfo: res?.canSeeAndUpdateTimesInfo    ?? false);
              preferences.setCanSeeFormsFiles(isSeeFormsFiles: res?.canSeeFileAndForms  ?? false);
              preferences.setManageSubUser(isManageSubUser: res?.canManageSubUsers  ?? false);
              preferences.setCanSeeInvoices(isCanSeeInvoices: res?.canSeeInvoices  ?? false);
              emit(state.copyWith(isAccountPermissionShimmering:false,
                isSubUserSeeWallet: res?.canSeeWallet ?? false,
                isSubUserAddToBasket :res?.canAddToCart ?? false,
              ));
            } else {
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          response.message!,
                      event.context),
                  type: SnackBarType.FAILURE);

            }
          } on ServerException {

          } catch (e) {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: e.toString(),
                type: SnackBarType.FAILURE);
          }
        }
        }

        else if(event is _userApproveEvent){
          try {
            debugPrint('clientId_____${preferences.getUserId()}');
            final res = await DioClient(event.context).post(
              '${AppUrls.verifyClientUrl}',
                data: {AppStrings.clientIdString:preferences.getUserId()}
            );
            VerifyClientResModel response = VerifyClientResModel.fromJson(res);
            debugPrint('verifyClient res_____$response');
            debugPrint('verifyClient url_____${AppUrls.baseUrl}${AppUrls.verifyClientUrl}');
            if (response.status == 200) {
              if(!(response.data?.isFilledForms ?? false) || !(response.data?.isRegisterForm ?? false)){
                Navigator.pushNamed(event.context, RouteDefine.formDataScreen.name);
              }
              else if(!(response.data?.isUploadedFiles ?? false) && (response.data?.isRegisterForm ?? false) && (response.data?.isFilledForms ?? false)){
                Navigator.pushNamed(event.context, RouteDefine.fileUploadScreen.name);
              }

            }
          } on ServerException {}
          catch (e) {
            debugPrint('catch____$e');
          }
        }
      }
    });
  }
}
