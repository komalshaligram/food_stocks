import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/data/model/product_stock_model/product_stock_model.dart';
import 'package:food_stock/data/model/product_supplier_model/product_supplier_model.dart';
import 'package:food_stock/data/model/req_model/insert_cart_req_model/insert_cart_req_model.dart' as InsertCartModel;

import 'package:food_stock/data/model/req_model/order_send_req_model/order_send_req_model.dart' as OrderSendModel;
import 'package:food_stock/data/model/req_model/product_details_req_model/product_details_req_model.dart';
import 'package:food_stock/data/model/res_model/insert_cart_res_model/insert_cart_res_model.dart';
import 'package:food_stock/data/model/res_model/product_details_res_model/product_details_res_model.dart';
import 'package:food_stock/data/model/supplier_sale_model/supplier_sale_model.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/order_model/product_details_model.dart';

import '../../data/model/req_model/update_cart/update_cart_req_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/order_send_res_model/order_send_res_model.dart';
import '../../data/model/res_model/related_product_res_model/related_product_res_model.dart';
import '../../data/model/res_model/update_cart_res/update_cart_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'basket_event.dart';
part 'basket_state.dart';
part 'basket_bloc.freezed.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  bool _isProductInCart = false;
  String _cartProductId = '';
  int _productQuantity = 0;
  BasketBloc() : super(BasketState.initial()) {
    on<BasketEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if(preferencesHelper.getGuestUser()){
        debugPrint('basket_guestUser_____${preferencesHelper.getGuestUser()}');

      }
      else{
        if (event is _getAllCartEvent) {
          debugPrint('cartId____${preferencesHelper.getCartId()}');

          emit(state.copyWith(
              isShimmering: true,
              language: preferencesHelper.getAppLanguage(),
              cartCount: preferencesHelper.getCartCount()));
          try {
            final res = await DioClient(event.context).post(
              '${AppUrls.getAllCartUrl}${preferencesHelper.getCartId()}',
            );

            GetAllCartResModel response = GetAllCartResModel.fromJson(res);

            if (response.status == 200) {
              emit(state.copyWith(CartItemList: response, isShimmering: false,isQtyUpdated: false));
              List<ProductDetailsModel> temp = [];
              List<ProductStockModel> productStockList =
              state.productStockList.toList(growable: true);
             // ProductStockModel barcodeStock = productStockList.removeLast();
              productStockList.clear();
              productStockList.addAll(response.data?.data?.map(
                      (recommendationProduct) =>
                      ProductStockModel(
                        quantity: recommendationProduct.totalQuantity?? 0,
                          productId: recommendationProduct.id ?? '',
                          stock: recommendationProduct.productStock.toString())) ??

                  []);
              //productStockList.add(barcodeStock);
              state.CartItemList.data?.data?.forEach((element) {
                temp.add(ProductDetailsModel(
                  totalQuantity: element.totalQuantity,
                  productName: element.productDetails?.productName ?? '',
                  mainImage: element.productDetails?.mainImage ?? '',
                  totalPayment:
                  double.parse(element.totalAmount?.toString() ?? '0'),
                  cartProductId: element.cartProductId ?? '',
                  scales: element.productDetails?.scales ?? '',
                  weight: element.productDetails?.itemsWeight ?? 0,
                ));
              });

               debugPrint('productStockList____${productStockList}');

              await preferencesHelper.setCartCount(
                  count: temp.isEmpty
                      ? preferencesHelper.getCartCount()
                      : temp.length);
              emit(state.copyWith(
                vatPercentage: response.data?.vatPercentage ?? 0,
                bottleQty: response.data?.cart?.first.bottleQuantities,
                bottleTax: response.data?.bottleTax ?? 0,
                basketProductList: temp,
                isRefresh: !state.isRefresh,
                productStockList: productStockList,
                totalPayment: response.data?.cart?.first.totalAmount ?? 0,
                supplierCount: response.data?.cart?.first.suppliers ?? 1,
              ));


            } else {
               emit(state.copyWith( isShimmering: false));
            }
          } on ServerException {}
        }
        else if (event is _productUpdateEvent) {
          List<ProductDetailsModel> list = [];
          list = [...state.basketProductList];
          list[event.listIndex].isProcess = true;

          emit(state.copyWith(isLoading: true, basketProductList: list,isQtyUpdated: false));

          try {
            UpdateCartReqModel reqMap = UpdateCartReqModel();
            if (event.saleId != '') {
              reqMap = UpdateCartReqModel(
                  supplierId: event.supplierId,
                  quantity: event.productWeight,
                  productId: event.productId,
                  cartProductId: event.cartProductId,
                  saleId: event.saleId);
            } else {
              reqMap = UpdateCartReqModel(
                supplierId: event.supplierId,
                quantity: event.productWeight,
                productId: event.productId,
                cartProductId: event.cartProductId,
              );
            }

             debugPrint('UpdateCart reqMap    ${reqMap}');

            final res = await DioClient(event.context).post(
              '${AppUrls.updateCartProductUrl}${preferencesHelper.getCartId()}',
              data: reqMap,
            );

            UpdateCartResModel response = UpdateCartResModel.fromJson(res);

            if (response.status == 201) {

              add(BasketEvent.getAllCartEvent(context: event.context));
              List<ProductDetailsModel> list = [];
              list = [...state.basketProductList];
              int quantity = list[event.listIndex].totalQuantity!;
              double payment = list[event.listIndex].totalPayment!;
              list[event.listIndex].totalQuantity =
                  response.data!.cartProduct!.quantity;
              list[event.listIndex].totalPayment =
              ((payment / quantity) * response.data!.cartProduct!.quantity!);
              double newAmount = (payment / quantity);
              double totalAmount = 0;
              if (list[event.listIndex].totalPayment! > payment) {
                totalAmount = event.totalPayment + newAmount;
                await preferencesHelper.setIsAnimation(isAnimation: true);
              } else {
                totalAmount = event.totalPayment - newAmount;
              }
              list[event.listIndex].isProcess = false;
              emit(state.copyWith(
                basketProductList: list,
                totalPayment: totalAmount,
                isLoading: false,
              ));
            } else {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ?? response.message!,
                      event.context),
                  type: SnackBarType.FAILURE);
            }
            if(event.isFromCart){
              Navigator.pop(event.context);
            }
          } on ServerException {
            emit(state.copyWith(isLoading: false));
          }
        }
        else if (event is _IncreaseQuantityOfProduct) {
          List<ProductStockModel> productStockList =
          state.productStockList.toList(growable: false);
       //   if (state.productStockUpdateIndex != -1) {
            if (productStockList[state.productStockUpdateIndex].quantity <
                double.parse(productStockList[state.productStockUpdateIndex].stock.toString())) {
            /*  if (productStockList[state.productStockUpdateIndex]
                  .productSupplierIds
                  .isEmpty) {
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title:
                    '${AppLocalizations.of(event.context)!
                        .please_select_supplier}',
                    type: SnackBarType.FAILURE);
                return;
              }*/
              productStockList[state.productStockUpdateIndex] =
                  productStockList[state.productStockUpdateIndex].copyWith(
                      quantity: productStockList[state.productStockUpdateIndex]
                          .quantity +
                          1);
              debugPrint(
                  'product quantity = ${productStockList[state
                      .productStockUpdateIndex].quantity}');
              emit(state.copyWith(productStockList: productStockList,isQtyUpdated: true));
            } else {
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title:
                  "${AppLocalizations.of(event.context)!
                      .this_supplier_have}${productStockList[state
                      .productStockUpdateIndex].stock}${AppLocalizations.of(
                      event.context)!.quantity_in_stock}",
                  // '${AppLocalizations.of(event.context)!.you_have_reached_maximum_quantity}',
                  type: SnackBarType.FAILURE);
            }
          //}
        }
        else if (event is _SupplierSelectionEvent) {
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
                    quantity: supplierList[event.supplierIndex].quantity != 0 ? supplierList[event.supplierIndex].quantity :1,
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
                'selected stock supplier = ${productStockList[state
                    .productStockUpdateIndex]}');
            supplierList = supplierList
                .map((supplier) => supplier.copyWith(selectedIndex: -1))
                .toList();
            debugPrint('selected supplier = ${supplierList}');
            supplierList[event.supplierIndex] =
                supplierList[event.supplierIndex]
                    .copyWith(selectedIndex: event.supplierSaleIndex);
            debugPrint(
                'selected supplier[${event
                    .supplierIndex}] = ${supplierList[event.supplierIndex]}');
            emit(state.copyWith(
                productSupplierList: supplierList,
                productStockList: productStockList));
          }
        }
        else if (event is _AddToCartProductEvent) {
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
            debugPrint('quantity__${state.productStockList[state.productStockUpdateIndex]
                .quantity}');
            try {
              // int lastQuantityIndex = cartProductList.indexOf(state
              //     .productStockList[state.productStockUpdateIndex].productId);
              // debugPrint('last quantity = $lastQuantityIndex');
              emit(state.copyWith(isLoading: true));
              UpdateCartReqModel request = UpdateCartReqModel(
                productId: event.productId,
                supplierId: state.productStockList[state
                    .productStockUpdateIndex]
                    .productSupplierIds,
                saleId: state.productStockList[state.productStockUpdateIndex]
                    .productSaleId ==
                    ''
                    ? null
                    : state.productStockList[state.productStockUpdateIndex]
                    .productSaleId,
                quantity: state.productStockList[state.productStockUpdateIndex]
                    .quantity/* + _productQuantity */,
                cartProductId:
                _cartProductId /*cartProductIdList[cartProductList.indexOf(state
                  .productStockList[state.productStockUpdateIndex].productId)]*/,
              );

               debugPrint('UpdateCartReqModel_____${request}');
               debugPrint('getCartId_____${preferencesHelper.getCartId()}');
              final res = await DioClient(event.context).post(
                '${AppUrls.updateCartProductUrl}${preferencesHelper.getCartId()}',
                data: request,
              );
              UpdateCartResModel response = UpdateCartResModel.fromJson(res);
              if (response.status == 201) {
                Vibration.vibrate();
                add(BasketEvent.getAllCartEvent(
                  context: event.context,
                ));
                Navigator.pop(event.context);
                List<ProductStockModel> productStockList =
                state.productStockList.toList(growable: true);
                productStockList[state.productStockUpdateIndex] =
                    productStockList[state.productStockUpdateIndex].copyWith(
                      note: '',
                      isNoteOpen: false,
                      quantity: 0,
                      productSupplierIds: '',
                      totalPrice: 0.0,
                      productSaleId: '',
                    );
                emit(state.copyWith(
                    isLoading: false, productStockList: productStockList));
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(
                        response.message?.toLocalization() ??
                            response.message!,
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
            debugPrint('insert cart');
            try {
              emit(state.copyWith(isLoading: true));
              InsertCartModel.InsertCartReqModel insertCartReqModel =
              InsertCartModel.InsertCartReqModel(products: [
                InsertCartModel.Product(
                    productId: state.productStockList[state.productStockUpdateIndex].productId == ''? event.productId :state.productStockList[state.productStockUpdateIndex].productId,
                    quantity: state
                        .productStockList[state.productStockUpdateIndex]
                        .quantity,
                    supplierId: state
                        .productStockList[state.productStockUpdateIndex]
                        .productSupplierIds,
                    note: state.productStockList[state.productStockUpdateIndex]
                        .note.isEmpty
                        ? null
                        : state
                        .productStockList[state.productStockUpdateIndex].note,
                    saleId: state.productStockList[state
                        .productStockUpdateIndex]
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
                  'insert cart url1 = ${AppUrls
                      .insertProductInCartUrl}${preferencesHelper
                      .getCartId()}');
              debugPrint(
                  'insert cart url1 auth = ${preferencesHelper
                      .getAuthToken()}');
              final res = await DioClient(event.context).post(
                  '${AppUrls.insertProductInCartUrl}${preferencesHelper
                      .getCartId()}',
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
                add(BasketEvent.getAllCartEvent(context: event.context));
                List<ProductStockModel> productStockList =
                state.productStockList.toList(growable: true);
                productStockList[state.productStockUpdateIndex] =
                    productStockList[state.productStockUpdateIndex].copyWith(
                      note: '',
                      isNoteOpen: false,
                      quantity: 0,
                      productSupplierIds: '',
                      totalPrice: 0.0,
                      productSaleId: '',
                    );

                emit(state.copyWith(
                    isLoading: false,
                    productStockList: productStockList,
                    isCartCountChange: true));
                emit(state.copyWith(isCartCountChange: false));
                add(BasketEvent.setCartCountEvent(isClearCart: false));
                Navigator.pop(event.context);
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(
                        response.message?.toLocalization() ??
                            response.message!,
                        event.context),
                    type: SnackBarType.SUCCESS);
              } else if (response.status == 403) {
                emit(state.copyWith(isLoading: false));
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
          }
        }
        else if (event is _GetProductDetailsEvent) {
          add(BasketEvent.RemoveRelatedProductEvent());
          debugPrint('product details id = ${event.productId}');
          _isProductInCart = false;
          _cartProductId = '';
          _productQuantity = 1;
          try {
           emit(state.copyWith(
                isProductLoading: true, isSelectSupplier: false));
            final res = await DioClient(event.context).post(
                AppUrls.getProductDetailsUrl,
                data: ProductDetailsReqModel(params: event.productId).toJson());
            ProductDetailsResModel response =
            ProductDetailsResModel.fromJson(res);
             debugPrint('ProductDetailsResModel______${response}');
             debugPrint('_productQuantity______${_productQuantity}');
            if (response.status == 200) {
              int productStockUpdateIndex = 0;
                productStockUpdateIndex = state.productStockList.indexWhere(
                      (productStock) =>
                  productStock.productId == event.productId,);

               debugPrint('productStockUpdateIndex____${productStockUpdateIndex}');
              emit(state.copyWith(productStockUpdateIndex: productStockUpdateIndex ));
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

                  debugPrint('state.productStockUpdateIndex = ${state.productStockList[state.productStockUpdateIndex].productId}');

                  response.data?.data?.forEach((cartProduct) {
                    debugPrint('cart id : ${cartProduct.id}');
                    if ( cartProduct.id == event.productId
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
                add(BasketEvent.RelatedProductsEvent(productId: event.productId,context: event.context));
              }
              if (/*productStockUpdateIndex == -1 &&*/ (event.isBarcode)) {
                List<ProductStockModel> productStockList =
                state.productStockList.toList(growable: false);
                productStockList[productStockList
                    .indexOf(productStockList.last)] = productStockList[
                productStockList.indexOf(productStockList.last)]
                    .copyWith(
                  quantity: _productQuantity,
                  productId: response.product?.first.id ?? '',
                  stock: (response.product?.first.supplierSales?.first.productStock.toString() ?? '0'),
                  productSaleId: '',
                  productSupplierIds: '',
                  note: '',
                  isNoteOpen: false,
                );


                emit(state.copyWith(productStockList: productStockList));
                debugPrint('new index = ${state.productStockList.last}');
                productStockUpdateIndex =
                    productStockList.indexOf(productStockList.last);

                debugPrint('barcode stock = ${state.productStockList.last}');
                debugPrint('barcode stock 1= ${state.productStockList.last.quantity}');
                debugPrint(
                    'barcode stock update index = ${state.productStockList
                        .length}');
                debugPrint(
                    'barcode stock update index = $productStockUpdateIndex');
              }
              debugPrint(
                  'product stock update index = $productStockUpdateIndex');
              debugPrint(
                  'product stock = ${state
                      .productStockList[productStockUpdateIndex].stock}');
              debugPrint(
                  'supplier list stock = ${response.product?.first.supplierSales
                      ?.map((e) => e.productStock)}');
              List<ProductSupplierModel> supplierList = [];
              debugPrint(
                  'supplier id = ${state
                      .productStockList[productStockUpdateIndex]
                      .productSupplierIds}');

              supplierList.addAll(response.product?.first.supplierSales
                  ?.map((supplier) =>
                  ProductSupplierModel(
                    supplierId: supplier.supplierId ?? '',
                    companyName: supplier.supplierCompanyName ?? '',
                    basePrice:
                    double.parse(supplier.productPrice ?? '0.0'),
                    stock: supplier.productStock.toString(),
                    quantity: _productQuantity,
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
                        ?.map((sale) =>
                        SupplierSaleModel(
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
                  'response list = ${response.product?.first.supplierSales
                      ?.length}');
              debugPrint('supplier list = ${supplierList.length}');
              debugPrint(
                  'supplier select index = ${supplierList.map((e) =>
                  e.selectedIndex)}');
              state.productStockList.indexOf(state.productStockList.last) ==
                  productStockUpdateIndex
                  ? ''
                  : state.productStockList[productStockUpdateIndex].note;
              emit(state.copyWith(
                  productStockList: state.productStockList,
                  productDetails: response.product ?? [],
                  productStockUpdateIndex: productStockUpdateIndex,
                //  noteController: TextEditingController(text: note),
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
                debugPrint('isSupplierSelected = ${state.productDetails}');
                if (!isSupplierSelected) {
                  int supplierIndex = 0;
                  int supplierSaleIndex = -1;
                  double cheapestPrice = supplierList.first.basePrice;
                  supplierList.forEach(
                          (supplier) =>
                          supplier.supplierSales.forEach((sale) {
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
                  add(BasketEvent.supplierSelectionEvent(
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
                type: SnackBarType.FAILURE,

              );
            }
          } on ServerException {
            // emit(state.copyWith(isProductLoading: false));
            Navigator.pop(event.context);
          } catch (e) {
         /*   CustomSnackBar.showSnackBar(
              context: event.context,
              title: e.toString(),
              type: SnackBarType.FAILURE,
            );*/
            //  Navigator.pop(event.context);
          }
        }
        else if (event is _DecreaseQuantityOfProduct) {
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
                  'product quantity = ${productStockList[state
                      .productStockUpdateIndex].quantity}');
              emit(state.copyWith(productStockList: productStockList));
            } else {}
          }
        }
        else if (event is _UpdateQuantityOfProduct) {
         emit(state.copyWith(isQtyUpdated: true));

          List<ProductStockModel> productStockList =
          state.productStockList.toList(growable: false);
        //  if (state.productStockUpdateIndex != -1) {
            String quantityString = event.quantity;
            if (quantityString.length == 2 && quantityString.startsWith('0')) {
              quantityString = quantityString.substring(1);
            }
            int newQuantity = int.tryParse(quantityString) ?? 0;
            debugPrint('new quantity = $newQuantity');
            if (newQuantity <=
                double.parse(productStockList[state.productStockUpdateIndex].stock.toString())) {
              productStockList[state.productStockUpdateIndex] =
                  productStockList[state.productStockUpdateIndex]
                      .copyWith(quantity: newQuantity);
              debugPrint(
                  'product quantity update = ${productStockList[state
                      .productStockUpdateIndex].quantity}');
              emit(state.copyWith(productStockList: productStockList));
            } else {
              productStockList[state.productStockUpdateIndex] =
                  productStockList[state.productStockUpdateIndex].copyWith(
                      quantity: int.tryParse(quantityString.substring(
                          0, quantityString.length - 1)) ??
                          0);
              debugPrint(
                  'product max quantity update = ${int.tryParse(
                      quantityString.substring(0, quantityString.length - 1)) ??
                      0}');
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title:
                  "${AppLocalizations.of(event.context)!
                      .this_supplier_have}${productStockList[state
                      .productStockUpdateIndex].stock}${AppLocalizations.of(
                      event.context)!.quantity_in_stock}",
                  type: SnackBarType.FAILURE);
              emit(state.copyWith(productStockList: []));
              emit(state.copyWith(productStockList: productStockList));
            }
         // }
        }
        else if (event is _removeCartProductEvent) {
          emit(state.copyWith(isRemoveProcess: true));
          try {
            final player = AudioPlayer();
            final response = await DioClient(event.context).post(
              AppUrls.removeCartProductUrl,
              data: {AppStrings.cartProductIdString: event.cartProductId},
            );
            if (response['status'] == 200) {
              add(BasketEvent.getAllCartEvent(context: event.context));
              Navigator.pop(event.dialogContext);
              player.play(AssetSource('audio/delete_sound.mp3'));
              add(BasketEvent.setCartCountEvent(isClearCart: false));
              List<ProductDetailsModel> list = [];
              list = [...state.basketProductList];
              list.removeAt(event.listIndex);
              emit(state.copyWith(
                basketProductList: list,
                isRefresh: !state.isRefresh,
                totalPayment: state.totalPayment - event.totalAmount,
                isRemoveProcess: false,
              ));
            } else {
              Navigator.pop(event.dialogContext);
              emit(state.copyWith(
                isRemoveProcess: false,
              ));
            }
          } on ServerException {
            emit(state.copyWith(
              isRemoveProcess: false,
            ));
            Navigator.pop(event.dialogContext);
          }
        }
        else if (event is _clearCartEvent) {
          emit(state.copyWith(isRemoveProcess: true));
          try {
            final res = await DioClient(event.context)
                .post('${AppUrls.clearCartUrl}${preferencesHelper.getCartId()}');
            if (res["status"] == 201) {
              add(BasketEvent.setCartCountEvent(isClearCart: true));
              List<ProductDetailsModel> list = [];
              list = [...state.basketProductList];
              list.clear();
              Navigator.pop(event.context);
              emit(state.copyWith(
                  basketProductList: list,
                  isRefresh: !state.isRefresh,
                  isRemoveProcess: false));
            } else {
              Navigator.pop(event.context);
              emit(state.copyWith(isRemoveProcess: false));
            }
          } on ServerException {
            Navigator.pop(event.context);
            emit(state.copyWith(isRemoveProcess: false));
          }
        }
        else if (event is _SetCartCountEvent) {
          await preferencesHelper.setCartCount(
              count:
              event.isClearCart ? 0 : preferencesHelper.getCartCount() - 1);
        }
        else if (event is _updateImageIndexEvent) {
          emit(state.copyWith(productImageIndex: event.index));
        }
        else if (event is _refreshListEvent) {
          Navigator.pop(event.context);
          emit(state.copyWith(CartItemList: state.CartItemList));
        }
        else if (event is _orderSendEvent) {
          List<OrderSendModel.Product> ProductReqMap = [];
          emit(state.copyWith(isLoading: true));

          state.CartItemList.data?.data?.forEach((element) {
            ProductReqMap.add(OrderSendModel.Product(
              supplierId: element.suppliers?.first.id ?? '',
              productId: element.productDetails?.id ?? '',
              quantity: element.totalQuantity,
              saleId: (element.sales?.length == 0)
                  ? ''
                  : (element.sales?.first.id ?? ''),
            ));
          });

          try {
            OrderSendModel.OrderSendReqModel reqMap = OrderSendModel.OrderSendReqModel(products: ProductReqMap);
            debugPrint('OrderSendReqModel = $reqMap}');
            final res = await DioClient(event.context).post(
              AppUrls.createOrderUrl,
              data: reqMap,
            );

            debugPrint(
                'Order create url  = ${DioClient.baseUrl}${AppUrls.createOrderUrl}');
            OrderSendResModel response = OrderSendResModel.fromJson(res);
            debugPrint('OrderSendResModel  = $response');

            if (response.status == 201) {
              try {
                final res = await DioClient(event.context).post(
                  '${AppUrls.clearCartUrl}${preferencesHelper.getCartId()}',
                );
                debugPrint('clear cart response_______${res}');
                if (res["status"] == 201) {
                  preferencesHelper.setCartCount(count: 0);
                  Navigator.pushNamed(
                      event.context, RouteDefine.orderSuccessfulScreen.name);
                }
              } on ServerException {}
            } else if (response.status == 403) {
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ?? response.message!,
                    event.context),
                type: SnackBarType.FAILURE,
              );
              emit(state.copyWith(isLoading: false));
            } else {
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ?? response.message!,
                      event.context),
                  type: SnackBarType.FAILURE);
              emit(state.copyWith(isLoading: false));
            }
          } on ServerException {
            emit(state.copyWith(isLoading: false));
          }
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

            List<ProductStockModel> productStockList =
            state.productStockList.toList(growable: true);
            productStockList.addAll(response.data.map(
                    (Product) =>
                    ProductStockModel(
                      productId: Product.id,
                      stock: Product.productStock.toString() ,
                    )));

            emit(state.copyWith(
                relatedProductList:response.data,
                isRelatedShimmering: false,productStockList: productStockList));
          } else {
            emit(state.copyWith(isRelatedShimmering: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(
                  response.message.toLocalization(),
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
