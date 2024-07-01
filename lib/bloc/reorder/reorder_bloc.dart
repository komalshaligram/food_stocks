import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/req_model/previous_order_products_req_model/previous_order_products_req_model.dart';
import 'package:food_stock/data/model/res_model/previous_order_products_res_model/previous_order_products_res_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/filter_model/filter_model.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../../data/model/req_model/global_search_req_model/global_search_req_model.dart';
import '../../data/model/req_model/insert_cart_req_model/insert_cart_req_model.dart'
    as InsertCartModel;
import '../../data/model/req_model/product_categories_req_model/product_categories_req_model.dart';
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/req_model/update_cart/update_cart_req_model.dart';
import '../../data/model/res_model/account_permission/account_permission_res_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/global_search_res_model/global_search_res_model.dart';
import '../../data/model/res_model/insert_cart_res_model/insert_cart_res_model.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';
import '../../data/model/res_model/related_product_res_model/related_product_res_model.dart';
import '../../data/model/res_model/update_cart_res/update_cart_res_model.dart';
import '../../data/model/res_model/verify_client_res_model/verify_client_res_model.dart';
import '../../data/model/search_model/search_model.dart';
import '../../data/model/supplier_sale_model/supplier_sale_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';
import 'package:food_stock/data/model/res_model/product_categories_res_model/product_categories_res_model.dart';

part 'reorder_event.dart';

part 'reorder_state.dart';

part 'reorder_bloc.freezed.dart';

class ReorderBloc extends Bloc<ReorderEvent, ReorderState> {
  bool _isProductInCart = false;
  String _cartProductId = '';
  int _productQuantity = 0;
  ReorderBloc() : super(ReorderState.initial()) {

    on<ReorderEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(
          prefs: await SharedPreferences.getInstance());
      if (event is _GetPreviousOrderProductsEvent) {
        emit(state.copyWith(
            isIncludedVat: preferences.getIsIncludedVat(),
            isSaleOn: preferences.getShowSale(),
            isSubUserAddToBasket :preferences.getCanAddToBasket(),cartCount: preferences.getCartCount(),isGridView: preferences.getReorderProductGrid(),bottleDeposit: preferences.getBottleTax()));
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
          PreviousOrderProductsReqModel request = PreviousOrderProductsReqModel(
              pageLimit: AppConstants.recommendationProductPageLimit,
              pageNum: state.pageNum + 1);
          debugPrint('previous products req = ${request.toJson()}');
          final res = await DioClient(event.context)
              .post(AppUrls.getPreviousOrderProductsUrl,
                  data: request.toJson(),
                );
          PreviousOrderProductsResModel response =
              PreviousOrderProductsResModel.fromJson(res);
          debugPrint(
              'previous order res = ${response.previousProductData}');
          debugPrint('previous order url =${AppUrls.baseUrl} ${AppUrls.getPreviousOrderProductsUrl}');
          if (response.status == 200) {
            List<PreviousOrderProductData> previousOrderProductsList =
                state.previousOrderProductsList.toList(growable: true);
            previousOrderProductsList
                .addAll(response.previousProductData ?? []);
            List<List<ProductStockModel>> productStockList =
                state.productStockList.toList(growable: true);
            List<ProductStockModel> stockList = [];
            stockList.addAll(response.previousProductData?.map(
                    (reorder) => ProductStockModel(
                      maxQty: (reorder.sale?.isSale ?? false) ? int.parse(reorder.sale?.saleMaxQuantity ?? '-1') : -1,
                        productId: reorder.id ?? '',
                        stock: reorder.productStock.toString())) ??
                []);
            productStockList[1].addAll(stockList);
            debugPrint(
                'new product list len = ${previousOrderProductsList.length}');
            debugPrint('new product stock list len = ${productStockList[1].length}');
            debugPrint(
                'new product stock list len = ${productStockList[1].where((element) {
                  debugPrint('ids = ${element.productId}');
                  return true;
                })}}');

            emit(state.copyWith(
                previousOrderProductsList: previousOrderProductsList,
                productStockList: productStockList,
                pageNum: state.pageNum + 1,
                isShimmering: false,
                isLoadMore: false));
            emit(state.copyWith(
                isBottomOfProducts: state.previousOrderProductsList.length ==
                        (response.metaData?.totalFilteredCount ?? 0)
                    ? true
                    : false));
          } else {
            emit(state.copyWith(isLoadMore: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                type: SnackBarType.FAILURE);
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
        state.refreshController.refreshCompleted();
        state.refreshController.loadComplete();
      } else if (event is _RefreshListEvent) {
        add(ReorderEvent.getPermissionList(context: event.context));
        emit(state.copyWith(
            pageNum: 0,
            previousOrderProductsList: [],
            productStockList: [
              state.productStockList[0],
              [],
              [],
            ],
            isBottomOfProducts: false));
        add(ReorderEvent.getPreviousOrderProductsEvent(context: event.context));
      }
      else if (event is _GetProductDetailsEvent) {
        add(ReorderEvent.RemoveRelatedProductEvent());
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

           debugPrint('GetProductDetails_____${response}');
          if (response.status == 200) {

            //new chanegs
            //0 for barcode and search
            //1 for company product.
            //2 related product.
            if(response.product!.isNotEmpty){

            List<List<ProductStockModel>> productStockList =
            state.productStockList.toList(growable: true);
            int productListIndex  = event.productListIndex;

             debugPrint('productStockList___${productStockList[1]}');
             debugPrint('productStockList___${productStockList[2].length}');
             debugPrint('productStockList___${productStockList[0]}');

             debugPrint('productListIndex___${event.productListIndex}');
            int productStockUpdateIndex = 0;


            if(event.isBarcode ){
              productStockUpdateIndex = 0;
               debugPrint('responseproductid____${response.product?.first.id}');
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
            if(response.product!.isNotEmpty){
              add(ReorderEvent.RelatedProductsEvent(context: event.context, productId: response.product?.first.id ?? ''));
            }
            if ( (event.isBarcode )) {
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
            // debugPrint(
            //     'supplier select index = ${supplierList.map((e) => e.selectedIndex)}');
            String note = productStockList.isEmpty
                ? ''
                : productStockList.indexOf(state.productStockList.last) ==
                productListIndex
                ? ''
                : productStockList[productListIndex][0].note;
            emit(state.copyWith(productStockList: [],));

            emit(state.copyWith(
                productDetails: response.product ?? [],
                productStockList: productStockList,
                productStockUpdateIndex: productStockUpdateIndex,
                noteController: TextEditingController(text: note),
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
                add(ReorderEvent.supplierSelectionEvent(
                    supplierIndex: supplierIndex,
                    context: event.context,
                    supplierSaleIndex: supplierSaleIndex));
              }}

            }
            else{
              emit(state.copyWith(isProductLoading: false,productDetails: []));
            }
          } else {
            emit(state.copyWith(isProductLoading: false,productDetails: []));
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
          // emit(state.copyWith(isProductLoading: false));
        } catch (e) {
          debugPrint('bs error = $e');
          // Navigator.pop(event.context);
        }
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

              return;
            }
            if(productStockList[state.productListIndex][state.productStockUpdateIndex]
                .maxQty!=-1){
              if (productStockList[state.productListIndex][state.productStockUpdateIndex]
                  .quantity >=
                  productStockList[state.productListIndex][state.productStockUpdateIndex]
                      .maxQty) {
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: '${AppLocalizations.of(event.context)!.not_add_more_than_max_qty}',
                    type: SnackBarType.FAILURE);
                return;
              }
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
      else if (event is _ChangeNoteOfProduct) {
        if (state.productStockUpdateIndex != -1) {
          List<List<ProductStockModel> >productStockList =
          state.productStockList.toList(growable: false);
          productStockList[state.productListIndex][state.productStockUpdateIndex] =
              productStockList[state.productListIndex][state.productStockUpdateIndex]
                  .copyWith(note: /*event.newNote*/ state.noteController.text);
          emit(state.copyWith(productStockList: productStockList));
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
                  .quantity,
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
                    quantity: /*state.productStockList[state.productStockUpdateIndex]
                    .quantity +*/ _productQuantity,
                    productSupplierIds: '',
                    totalPrice: 0.0,
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
                options: Options(
                  headers: {
                    HttpHeaders.authorizationHeader:
                    'Bearer ${preferencesHelper.getAuthToken()}',
                  },
                ));
            InsertCartResModel response = InsertCartResModel.fromJson(res);
            if (response.status == 201) {
              add(ReorderEvent.setCartCountEvent());
              Vibration.vibrate();
              Navigator.pop(event.context);
              List<List<ProductStockModel>> productStockList =
              state.productStockList.toList(growable: true);
               debugPrint('quandjfd____${state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity}');
              productStockList[state.productListIndex][state.productStockUpdateIndex] =
                  productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
                    note: '',
                    isNoteOpen: false,
                    quantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                    productSupplierIds: '',
                    totalPrice: 0.0,
                    productSaleId: '',
                  );
              add(ReorderEvent.getCartCountEvent());

              emit(state.copyWith(
                  isLoading: false, productStockList: productStockList,duringCelebration: true));
              await Future.delayed(const Duration(milliseconds: 500));
              emit(state.copyWith(duringCelebration: false));
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
        
        debugPrint('cart count reorder = ${preferences.getCartCount()}');
      } else if (event is _UpdateImageIndexEvent) {
        emit(state.copyWith(imageIndex: event.index));
      }  else if (event is _ToggleNoteEvent) {
        List <List<ProductStockModel>> productStockList =
        state.productStockList.toList(growable: true);
        productStockList[state.productListIndex][state.productStockUpdateIndex] =
            productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
                isNoteOpen: !productStockList[state.productListIndex][state.productStockUpdateIndex]
                    .isNoteOpen);
        emit(state.copyWith(productStockList: productStockList));
      }
      else if (event is _getCartCountEvent) {
        emit(
            state.copyWith(cartCount: preferences.getCartCount(),isSubUserAddToBasket :preferences.getCanAddToBasket()));
      }
      else if (event is _getGridListView) {
        preferences.setReorderProductGridListView( isReorderProductGrid: !state.isGridView);
        emit(state.copyWith(isGridView: !state.isGridView));
      }
      else if (event is _ChangeCategoryExpansion) {
        if(event.isOpened == false ){
          state.searchController.clear();
          emit(state.copyWith(searchController: state.searchController));
        }
        if (event.isOpened != null) {
          emit(state.copyWith(isCategoryExpand: event.isOpened ?? false));
        } else {
          emit(state.copyWith(isCategoryExpand: !state.isCategoryExpand));
        }
      }
      else if (event is _GlobalSearchEvent) {
        emit(state.copyWith(search: state.searchController.text,bottleDeposit: preferences.getBottleTax()));
        debugPrint('data1 = ${state.searchController.text}');
        try {
          GlobalSearchReqModel globalSearchReqModel =
          GlobalSearchReqModel(search: state.searchController.text,
              sortField: AppStrings.sortFieldString,
              sortOrder: AppStrings.sortOrderString
          );
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
          debugPrint('store search list =${response.status}');
          if (response.status == 200) {
            List<SearchModel> searchList = [];
            //category search result
            searchList.addAll(response.data?.categoryData
                ?.map((category) =>
                SearchModel(
                    searchId: category.id ?? '',
                    name: category.categoryName ?? '',
                    isPesach: category.isPesach??false,
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
                  isPesach: subCategory.isPesach??false,

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

                  isPesach: supplier.isPesach??false,
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
                  numberOfUnits: int.parse(sale.numberOfUnit.toString()),
                  image: sale.mainImage ?? '',
                  isPesach: sale.isPesach??false,
                  salePrice: double.parse(sale.discountPercentage.toString()),
                  salesDesc:  parse(sale.salesDescription ?? '')
                      .body
                      ?.text ??
                      '',
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
      else if(event is _RelatedProductsEvent){
        emit(state.copyWith(isRelatedShimmering:true));
         debugPrint('productId____${event.productId}');
        final res = await DioClient(event.context).post(
            AppUrls.relatedProductsUrl,
            data: {'mainProductId':event.productId});
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
                response.message?.toLocalization() ?? '',
                event.context),
            type: SnackBarType.SUCCESS,
          );
        }
      }
      else if(event is _RemoveRelatedProductEvent){
        emit(state.copyWith(relatedProductList: []));
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
              emit(state.copyWith(
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
      else if (event is _sortingEvent){
        emit(state.copyWith(sortingField: event.sortField));
      }
      else if (event is _filterEvent){
     emit(state.copyWith(isFilterShimmering: true));
        List<String>sortingList = state.sortingList.toList(growable: true);
        sortingList = ['Lowes price to Highest price','Highest price to Lowes price',
          'A - Z','Z-A'];

        List<FilterModel>filterList = state.filterList.toList(growable: true);
        filterList = [
          FilterModel(brandModel: BrandModel (
              FilterFieldProductList: [
                FilterProductModel(name: 'מיה' ),
                FilterProductModel(name: '6fgd' ),
                FilterProductModel(name: '5fgdf' ),
                FilterProductModel(name: '9dfgd' ),
                FilterProductModel(name: '8dfg' ),
                FilterProductModel(name: '9dfgf' ),
                FilterProductModel(name: '2eewe' ),
                FilterProductModel(name: '1gg0' ),
              ],  filterFieldName: 'brand'),
          ),
          FilterModel(brandModel: BrandModel (
              FilterFieldProductList: [
                FilterProductModel(name: 'sd',
                    subCategoriesList: [
                      SubcategoriesFilterModel( name: 'a'),
                      SubcategoriesFilterModel( name: 'b'),
                      SubcategoriesFilterModel( name: 'e'),
                      SubcategoriesFilterModel( name: 'o'),
                    ] ),
                FilterProductModel(name: 'fv' ,
                    subCategoriesList: [
                      SubcategoriesFilterModel( name: 'i'),
                      SubcategoriesFilterModel( name: 'q'),
                      SubcategoriesFilterModel( name: 'ht'),
                      SubcategoriesFilterModel( name: 'd'),
                      SubcategoriesFilterModel( name: 'ere'),
                      SubcategoriesFilterModel( name: 'ty'),
                      SubcategoriesFilterModel( name: 'asa'),
                      SubcategoriesFilterModel( name: 'oyr'),
                      SubcategoriesFilterModel( name: 'yte'),
                      SubcategoriesFilterModel( name: 'qwe'),
                      SubcategoriesFilterModel( name: 'pi'),
                    ]
                ),
                FilterProductModel(name: 'sd',
                    subCategoriesList: [
                      SubcategoriesFilterModel( name: 'ou'),
                      SubcategoriesFilterModel( name: 'edf'),
                      SubcategoriesFilterModel( name: 'qq'),
                    ]
                ),
                FilterProductModel(name: 'dsf',
                    subCategoriesList: [
                      SubcategoriesFilterModel( name: 'dr'),
                      SubcategoriesFilterModel( name: 'as'),
                    ]
                ),
                FilterProductModel(name: 'retg' ),
                FilterProductModel(name: 'sdf' ),
                FilterProductModel(name: 'ktr' ),
                FilterProductModel(name: 'awrwe' ),
                FilterProductModel(name: 'cfhyu' ),
              ],  filterFieldName: 'categories'),
          ),
          FilterModel(brandModel: BrandModel (
              FilterFieldProductList: [
                FilterProductModel(name: 'sale' ),
                FilterProductModel(name: 'noSale' ),
              ],  filterFieldName: 'sale'),
          ),
          FilterModel(brandModel: BrandModel (
              FilterFieldProductList: [
                FilterProductModel(name: 'pesach' ),
              ],  filterFieldName: 'pesach'),),
          FilterModel(brandModel: BrandModel (
              FilterFieldProductList: [
                FilterProductModel(name: 'Has stock ' ),
                FilterProductModel(name: 'Low stock' ),
                FilterProductModel(name: 'Not in stock' ),
              ],  filterFieldName: 'stock'),
          ),
        ];
        emit(state.copyWith(filterList: filterList,sortingList: sortingList,sortingField:sortingList.first,isFilterShimmering : false));
      }
      else if(event is _selectFilterFieldEvent){
        List<FilterModel>filterList = state.filterList.toList(growable: true);
        if(event.subCatIndex != -1){
          bool? isSelected =  filterList[event.mainIndex].brandModel?.FilterFieldProductList[event.subIndex].subCategoriesList[event.subCatIndex].isSelected;
          filterList[event.mainIndex].brandModel?.FilterFieldProductList[event.subIndex].subCategoriesList[event.subCatIndex].isSelected = !isSelected!;

        }
        else{
          bool? isSelected =  filterList[event.mainIndex].brandModel?.FilterFieldProductList[event.subIndex].isSelected;
          filterList[event.mainIndex].brandModel?.FilterFieldProductList[event.subIndex].isSelected = !isSelected!;
        }

        emit(state.copyWith(filterList: filterList,isRefresh: !state.isRefresh));
      }

      else if(event is _applyFilterEvent){
        List<FilterModel>filterList = state.filterList.toList(growable: true);
        filterList.forEach((element) {
          element.brandModel?.FilterFieldProductList.forEach((element) {
            if(element.isSelected){
              print('element____${element.name}');
            }
            element.subCategoriesList.forEach((element) {
              if(element.isSelected){
                print('element____${element.name}');
              }
            });
          });
        });
      }

      else if(event is _clearFilterEvent){
        List<FilterModel>filterList = state.filterList.toList(growable: true);
        filterList.forEach((element) {
          element.brandModel?.FilterFieldProductList.forEach((element) {
            if(element.isSelected){
             element.isSelected = false;
            }
            element.subCategoriesList.forEach((element) {
              if(element.isSelected){
                element.isSelected = false;
              }
            });
          });
        });
        emit(state.copyWith(filterList: filterList,isRefresh: !state.isRefresh));
      }

      else if(event is _expansionChangeEvent){
        List<FilterModel>filterList = state.filterList.toList(growable: true);
        bool? isExpansion = filterList[event.mainIndex].brandModel?.FilterFieldProductList[event.subIndex].isExpansion;
        filterList[event.mainIndex].brandModel?.FilterFieldProductList[event.subIndex].isExpansion = !isExpansion!;
       emit(state.copyWith(filterList : filterList , isRefresh: !state.isRefresh));
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

    });
  }
}
