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
              isAnimation : false,
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
              List<List<ProductStockModel>> productStockList =
              state.productStockList.toList(growable: true);
              int cartCount  =  productStockList[0].length;
              productStockList[0].clear();
              List<ProductStockModel>stockList = [];
              stockList.addAll(response.data?.data?.map(
                      (product) =>
                      ProductStockModel(
                        quantity: product.totalQuantity?? 0,
                          productId: product.id ?? '',
                          stock: product.productStock.toString(),
                        lowStock: product.lowStock.toString()
                      )) ??
                  []);
              productStockList[0].addAll(stockList);
              response.data?.data?.forEach((element) {
                temp.add(ProductDetailsModel(
                  totalQuantity: element.totalQuantity,
                  productName: element.productDetails?.productName ?? '',
                  mainImage: element.productDetails?.mainImage ?? '',
                  totalPayment:
                  double.parse(element.totalAmount?.toString() ?? '0'),
                  cartProductId: element.cartProductId ?? '',
                  scales: element.productDetails?.scales ?? '',
                  weight: element.productDetails?.itemsWeight ?? 0,
                  lowStock: element.lowStock ?? '',
                  productStock: element.productStock ?? 0,
                ));
              });

               debugPrint('productStockList____${productStockList}');

                 await preferencesHelper.setCartCount(
                     count: temp.isEmpty
                         ? preferencesHelper.getCartCount()
                         : temp.length);
              if(cartCount != temp.length){
                emit(state.copyWith(isAnimation: true));
              }
              emit(state.copyWith(
                vatPercentage: response.data?.vatPercentage ?? 0,
                bottleQty: response.data?.cart?.first.bottleQuantities,
                bottleTax: response.data?.bottleTax ?? 0,
                basketProductList: temp,
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
              int quantity = list[event.listIndex].totalQuantity ?? 1;
              double payment = list[event.listIndex].totalPayment ?? 0;
              list[event.listIndex].totalQuantity =
                  response.data?.cartProduct?.quantity;
              list[event.listIndex].totalPayment =
              ((payment / quantity) * (response.data?.cartProduct?.quantity ?? 1) );
              double newAmount = (payment / quantity);
              double totalAmount = 0;
              if ((list[event.listIndex].totalPayment ?? 0) > payment) {
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
                      response.message?.toLocalization() ?? response.message ?? '',
                      event.context),
                  type: SnackBarType.FAILURE);
            }
          } on ServerException {
            emit(state.copyWith(isLoading: false));
          }
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
                add(BasketEvent.getAllCartEvent(context: event.context));
                List<List<ProductStockModel>> productStockList =
                state.productStockList.toList(growable: true);
                productStockList[state.productListIndex][state.productStockUpdateIndex] =
                    productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
                      isNoteOpen: false,
                      quantity: _productQuantity,
                      productSupplierIds: '',
                      totalPrice: state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice,
                      productSaleId: '',
                    );
                Navigator.pop(event.context);
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

                add(BasketEvent.getAllCartEvent(context: event.context));
                Vibration.vibrate();
                Navigator.pop(event.context);
                List<List<ProductStockModel>> productStockList =
                state.productStockList.toList(growable: true);
                productStockList[state.productListIndex][state.productStockUpdateIndex] =
                    productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
                      isNoteOpen: false,
                      quantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                      productSupplierIds: '',
                      totalPrice: state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice,
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
        else if (event is _GetProductDetailsEvent) {
          emit(state.copyWith(isCartCountChange: false));
          add(BasketEvent.RemoveRelatedProductEvent());
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

              //0 for basket product.
              //1 related product.

              List<List<ProductStockModel>> productStockList =
              state.productStockList.toList(growable: true);
              int productListIndex  = event.productListIndex;
              debugPrint('productListIndex___${event.productListIndex}');
              int productStockUpdateIndex = 0;


                productStockUpdateIndex = state.productStockList[productListIndex]
                    .indexWhere((productStock) =>
                productStock.productId == event.productId);


              emit(state.copyWith(productListIndex:productListIndex,productStockUpdateIndex:productStockUpdateIndex));
              debugPrint('planoGramUpdateIndex___${state.productListIndex}');
              debugPrint('productStockUpdateIndex___${state.productStockUpdateIndex}');
              try {

                final res = await DioClient(event.context).post(
                    '${AppUrls.getAllCartUrl}${preferencesHelper.getCartId()}',
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
                add(BasketEvent.RelatedProductsEvent(context: event.context, productId: response.product?.first.id ?? ''));
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
              count: event.isClearCart ? 0 : preferencesHelper.getCartCount() - 1);
        }
        else if (event is _updateImageIndexEvent) {
          emit(state.copyWith(productImageIndex: event.index));
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
                'Order create url  = ${AppUrls.baseUrl}${AppUrls.createOrderUrl}');
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
            List<List<ProductStockModel>> productStockList =
            state.productStockList.toList(growable: true);
            List<ProductStockModel>stockList = [];
            stockList.addAll(response.data.map(
                    (Product) =>
                    ProductStockModel(
                      productId: Product.id,
                      stock: (Product.productStock.toString()),
                    )));
            productStockList[1].addAll(stockList);
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
