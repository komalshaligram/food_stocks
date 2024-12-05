import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/res_model/pesach_products_res_model/pesach_products_res_model.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../../data/model/req_model/global_search_req_model/global_search_req_model.dart';
import '../../data/model/req_model/insert_cart_req_model/insert_cart_req_model.dart'
as insert;
import '../../data/model/req_model/pesach_product_req_model/pesach_product_req_model.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/model/res_model/product_categories_res_model/product_categories_res_model.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/themes/app_strings.dart';

part 'pesach_products_event.dart';

part 'pesach_products_state.dart';

part 'pesach_products_bloc.freezed.dart';

class PesachProductsBloc
    extends Bloc<PesachProductsEvent, PesachProductsState> {
  bool _isProductInCart = false;
  String _cartProductId = '';
  int _productQuantity = 0;



  PesachProductsBloc() : super(PesachProductsState.initial()) {
    on<PesachProductsEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(
          prefs: await SharedPreferences.getInstance());
      if (event is _getSupplierProductsListEvent) {
        emit(state.copyWith(
          isIncludedVat: preferences.getIsIncludedVat(),
          isSaleOn: preferences.getShowSale(),
          isGuestUser: preferences.getGuestUser(),
            bottleDeposit: preferences.getBottleTax(),
            isGridView: preferences.getSupplierProductGrid(),
          isSubUserAddToBasket :preferences.getCanAddToBasket(),
        ));
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
          PesachProductReqModel request = PesachProductReqModel(
              pageLimit: AppConstants.supplierProductPageLimit,
              pageNum: state.pageNum + 1,
              onlySearch: false,
              isPesach : true,
            sortField: AppStrings.sortFieldString,
            sortOrder: AppStrings.sortOrderString
          );

          Map<String, dynamic> req = request.toJson();
          req.removeWhere((key, value) {
            if (value != null) {
              debugPrint("[$key] = $value");
            }
            return value == '';
          });
          PesachProductsResModel response;
          if (event.searchType == SearchTypes.product.toString()) {
            emit(state.copyWith(searchType: event.searchType.toString()));
          }
          final res = await DioClient(event.context)
              .post(AppUrlEndPoints.getPlanogramAllProductUrl, data: req);
          response =
              PesachProductsResModel.fromJson(res);
          emit(state.copyWith(searchType: event.searchType.toString()));

          if (response.status == AppConstants.code_200) {
            List<PesachData> productList =
            state.productList.toList(growable: true);
            productList.addAll(response.data ?? []);
            List<List<ProductStockModel>> productStockList =
            state.productStockList.toList(growable: true);
            List<ProductStockModel>stockList = [];
            stockList.addAll(response.data?.map((product) {
              return ProductStockModel(
                  maxQty:(product.sale?.isSale ?? false) ?  int.parse(product.sale?.saleMaxQuantity.toString() ?? '0') : -1,
                  productId:product.id ?? '',
                  stock:product.productStock.toString());
            }) ??

                []);
            productStockList[1].addAll(stockList);

            emit(state.copyWith(
                
                productList: productList,
                productStockList: productStockList,
                pageNum: state.pageNum + 1,
                isShimmering: false,
                isLoadMore: false));
            emit(state.copyWith(
                isBottomOfProducts: state.productList.length ==
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
                type: SnackBarType.failure);
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
        state.refreshController.refreshCompleted();
        state.refreshController.loadComplete();
      }

      else if (event is _refreshListEvent) {
        add(PesachProductsEvent.getPermissionList(context: event.context));
        emit(state.copyWith(
            pageNum: 0,
            productList: [],
            productStockList: [
              state.productStockList[0],
              [],
              [],
            ],
            isBottomOfProducts: false));
        add(PesachProductsEvent.getSupplierProductsListEvent(
            context: event.context, searchType: state.searchType));
      }
      else if (event is _getProductDetailsEvent) {
        add(const PesachProductsEvent.removeRelatedProductEvent());
        _isProductInCart = false;
        _cartProductId = '';
        _productQuantity = 0;

        try {
          emit(state.copyWith(isProductLoading: true, isSelectSupplier: false));

          final res = await DioClient(event.context).post(
              AppUrlEndPoints.getProductDetailsUrl,
              data: ProductDetailsReqModel(params: event.productId).toJson());

          ProductDetailsResModel response =
          ProductDetailsResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {

            //new changes
            //0 for barcode and search
            //1 for recommendation product.
            //2 related product.
            if(response.product!.isNotEmpty){
            List<List<ProductStockModel>> productStockList =
            state.productStockList.toList(growable: true);
            int productListIndex  = event.productListIndex;
            int productStockUpdateIndex = -1;
            if(event.isBarcode ){
              productStockUpdateIndex = 0;
            }
            else{
              productStockUpdateIndex = state.productStockList[productListIndex]
                  .indexWhere((productStock) =>
              productStock.productId == event.productId);
            }

            emit(state.copyWith(productListIndex:productListIndex,productStockUpdateIndex:productStockUpdateIndex));

            try {
              final res = await DioClient(event.context).post(
                '${AppUrlEndPoints.getAllCartUrl}${preferences.getCartId()}',
              );
              GetAllCartResModel response = GetAllCartResModel.fromJson(res);
              if (response.status == AppConstants.code_200) {
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

              }
            } on ServerException {}
            if(response.product!.isNotEmpty){
              add(PesachProductsEvent.relatedProductsEvent(context: event.context, productId: response.product?.first.id ?? ''));
            }
            if (event.isBarcode) {
              productStockList[0][0] =  productStockList[0][0]
                  .copyWith(
                quantity: _productQuantity,
                productId: response.product?.first.id ?? '',
                stock: (response.product?.first.supplierSales?.first.productStock.toString()  ?? '0'),
                maxQty: (response.product?.first.sale?.isSale ?? false) ? int.parse(response.product?.first.sale?.saleMaxQuantity ?? '0') : -1,
                productSaleId: '',
                productSupplierIds: '',
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
                  ? !supplier.saleProduct!.contains(
                supplier.saleProduct?.firstWhere(
                      (sale) =>
                  sale.saleId ==
                      state
                          .productStockList[
                      productListIndex][
                      productStockUpdateIndex]
                          .productSaleId,
                  orElse: () => const SaleProduct(isSale: false,saleDescription: '',saleFromDate: '',saleMaxQuantity: '0',salePrice: '0',saleUntilDate:'' ),
                ) ??
                    const SaleProduct(isSale: false,saleDescription: '',saleFromDate: '',saleMaxQuantity: '0',salePrice: '0',saleUntilDate:'' ),)
                  ? -2
                   : supplier.saleProduct?.indexOf(
                supplier.saleProduct?.firstWhere(
                      (sale) =>
                  sale.saleId ==
                      state.productStockList[
                      productListIndex][
                      productStockUpdateIndex]
                          .productSaleId,
                  orElse: () => const SaleProduct(isSale: false,saleDescription: '',saleFromDate: '',saleMaxQuantity: '0',salePrice: '0',saleUntilDate:'' ),
                ) ??
                    const SaleProduct(isSale: false,saleDescription: '',saleFromDate: '',saleMaxQuantity: '0',salePrice: '0',saleUntilDate:'' ),) ??
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
            supplierList.removeWhere((supplier) => supplier.stock == '0');

            emit(state.copyWith(
                productDetails: response.product ?? [],
                productStockList: state.productStockList,
                productStockUpdateIndex: productStockUpdateIndex,
                productSupplierList: supplierList,
                productListIndex: productListIndex,
                /*isProductLoading: false*/
            ));
            if (supplierList.isNotEmpty) {
              bool isSupplierSelected = false;
              for (var supplier in supplierList) {
                if (supplier.selectedIndex != -1) {
                  isSupplierSelected = true;
                  continue;
                }
              }

              if (!isSupplierSelected || state.productListIndex == 0) {
                int supplierIndex = 0;
                int supplierSaleIndex = -1;
                double cheapestPrice = supplierList.first.basePrice;
                for (var supplier in supplierList) {
                  for (var sale in supplier.supplierSales) {
                      if (sale.salePrice < cheapestPrice) {
                        cheapestPrice = sale.salePrice;
                        supplierIndex = supplierList.indexOf(supplier);
                        supplierSaleIndex =
                            supplier.supplierSales.indexOf(sale);
                      }
                    }
                }
                for (var supplier in supplierList) {
                  if (supplier.basePrice < cheapestPrice) {
                    cheapestPrice = supplier.basePrice;
                    supplierIndex = supplierList.indexOf(supplier);
                  }
                }
                if (supplierSaleIndex == -1) {
                  supplierSaleIndex = -2;
                }

                add(PesachProductsEvent.supplierSelectionEvent(
                    supplierIndex: supplierIndex,
                    context: event.context,
                    supplierSaleIndex: supplierSaleIndex));
              }}

            }
            else{
              emit(state.copyWith(isProductLoading: false,productDetails: []));
            }
          } else {
            Navigator.pop(event.context);
            emit(state.copyWith(isProductLoading: false,productDetails: []));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                type: SnackBarType.failure);
          }
        } on ServerException {
          Navigator.pop(event.context);
          emit(state.copyWith(isProductLoading: false));
        }
      }
      else if (event is _increaseQuantityOfProduct) {

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
                    title: AppLocalizations.of(event.context)!.not_add_more_than_max_qty,
                    type: SnackBarType.failure);
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

            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          } else {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[state.productListIndex][state.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
                type: SnackBarType.failure);
          }
        }
      }
      else if (event is _decreaseQuantityOfProduct) {
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

            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          } else {}
        }
      }
      else if (event is _updateQuantityOfProduct) {
        List<List<ProductStockModel>> productStockList =
        state.productStockList.toList(growable: false);
        if (state.productStockUpdateIndex != -1) {
          String quantityString = event.quantity;
          if (quantityString.length == 2 && quantityString.startsWith('0')) {
            quantityString = quantityString.substring(1);
          }
          int newQuantity = int.tryParse(quantityString) ?? 0;
          if (newQuantity <=
              double.parse(productStockList[state.productListIndex]
              [state.productStockUpdateIndex]
                  .stock.toString())) {
            productStockList[state.productListIndex]
            [state.productStockUpdateIndex] =
                productStockList[state.productListIndex]
                [state.productStockUpdateIndex]
                    .copyWith(quantity: newQuantity);

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

            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[state.productListIndex][state.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
                type: SnackBarType.failure);
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          }
        }
      }
      else if (event is _changeSupplierSelectionExpansionEvent) {
        emit(state.copyWith(
            isSelectSupplier:
            event.isSelectSupplier ?? !state.isSelectSupplier));
      }
      else if (event is _supplierSelectionEvent) {

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
          supplierList[event.supplierIndex] = supplierList[event.supplierIndex]
              .copyWith(selectedIndex: event.supplierSaleIndex);

          emit(state.copyWith(
              productSupplierList: supplierList,
              productStockList: productStockList));


        }
      }
      else if (event is _addToCartProductEvent) {
        if (state.productStockList[state.productListIndex][state.productStockUpdateIndex]
            .productSupplierIds.isEmpty) {
          return;
        }
        if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity ==
            0) {
          CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppLocalizations.of(event.context)!.add_1_quantity,
              type: SnackBarType.failure);
          return;
        }
        if(state.productStockList[state.productListIndex][state.productStockUpdateIndex].maxQty > 0){
          if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity >
              state.productStockList[state.productListIndex][state.productStockUpdateIndex].maxQty
          ) {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppLocalizations.of(event.context)!.not_add_more_than_max_qty,
                type: SnackBarType.failure);
            return;
          }
        }
        if (_isProductInCart) {
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
              '${AppUrlEndPoints.updateCartProductUrl}${preferences.getCartId()}',
              data: request,
            );
            UpdateCartResModel response = UpdateCartResModel.fromJson(res);
            if (response.status == AppConstants.code_201) {
              Vibration.vibrate();
           //   Navigator.pop(event.context);
              List<List<ProductStockModel>> productStockList =
              state.productStockList.toList(growable: true);
              productStockList[state.productListIndex][state.productStockUpdateIndex] =
                  productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
                    note: '',
                    productIsInCart: true,
                    quantity:_productQuantity,
                    productSupplierIds:  state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSupplierIds,
                    totalPrice: productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice,
                    productSaleId: '',
                  );

              emit(state.copyWith(
                  isLoading: false, productStockList: productStockList));

              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ?? response.message!,
                      event.context),
                  type: SnackBarType.success);
            } else {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          response.message!,
                      event.context),
                  type: SnackBarType.failure);
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
            insert.InsertCartReqModel insertCartReqModel =
            insert.InsertCartReqModel(products: [
              insert.Product(
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
            SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
                prefs: await SharedPreferences.getInstance());

            final res = await DioClient(event.context).post(
                '${AppUrlEndPoints.insertProductInCartUrl}${preferencesHelper.getCartId()}',
                data: req,
                options: Options(
                  headers: {
                    HttpHeaders.authorizationHeader:
                    'Bearer ${preferencesHelper.getAuthToken()}',
                  },
                ));
            InsertCartResModel response = InsertCartResModel.fromJson(res);
            if (response.status == AppConstants.code_201) {
              if(!state.productStockList[state.productListIndex][state.productStockUpdateIndex].productIsInCart){
                add(const PesachProductsEvent.setCartCountEvent());
              }
              Vibration.vibrate();
            //  Navigator.pop(event.context);
              List<List<ProductStockModel>> productStockList =
              state.productStockList.toList(growable: true);
              productStockList[state.productListIndex][state.productStockUpdateIndex] =
                  productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
                    note: '',
                    productIsInCart: true,
                    quantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                    productSupplierIds:  state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSupplierIds,
                    totalPrice: productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice,
                    productSaleId: '',
                  );
                 add(const PesachProductsEvent.getCartCountEvent());
              emit(state.copyWith(isLoading: false, productStockList: productStockList,duringCelebration: true));
              await Future.delayed(const Duration(milliseconds: 500));
              emit(state.copyWith(duringCelebration: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ?? response.message!, event.context),
                  type: SnackBarType.success);
            } else if (response.status == AppConstants.code_403) {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          response.message!,
                      event.context),
                  type: SnackBarType.failure);
            } else {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          response.message!,
                      event.context),
                  type: SnackBarType.failure);
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
      else if (event is _setCartCountEvent) {
        SharedPreferencesHelper preferences = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());
        await preferences.setCartCount(count: preferences.getCartCount() + 1, );
      }
      else if (event is _updateImageIndexEvent) {
        emit(state.copyWith(imageIndex: event.index));
      } 
 
      else if (event is _getGridListView) {
        preferences.setSupplierProductGridListView(
            isSupplierProductGrid: !state.isGridView);
        emit(state.copyWith(isGridView: !state.isGridView));
      }
      else if (event is _changeCategoryExpansion) {
        if(event.isOpened == false){
          emit(state.copyWith(searchList: []));
        }
        if (event.isOpened == false) {
          state.searchController.clear();
          emit(state.copyWith(searchController: state.searchController));
        }
        if (event.isOpened != null) {
          emit(state.copyWith(isCategoryExpand: event.isOpened ?? false));
        } else {
          emit(state.copyWith(isCategoryExpand: !state.isCategoryExpand));
        }
      }
      else if (event is _globalSearchEvent) {
        emit(state.copyWith(search: state.searchController.text,bottleDeposit: state.bottleDeposit));
        debugPrint('data1 = ${state.searchController.text}');
        try {
          GlobalSearchReqModel globalSearchReqModel =
          GlobalSearchReqModel(search: state.searchController.text,
              sortField: AppStrings.sortFieldString,
              sortOrder: AppStrings.sortOrderString
          );
          emit(state.copyWith(isSearching: true));
          final res = await DioClient(event.context).post(
              AppUrlEndPoints.getPlanogramAllProductForSearchUrl,
              data: globalSearchReqModel.toJson());

          GlobalSearchResModel response = GlobalSearchResModel.fromJson(res);

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
          if (response.status == AppConstants.code_200) {
            List<SearchModel> searchList = [];
            //category search result
            /*searchList.addAll(response.data?.categoryData
                ?.map((category) =>
                SearchModel(
                    searchId: category.id ?? '',
                    name: category.categoryName ?? '',
                    searchType: SearchTypes.category,
                    isPesach: category.isPesach??false,
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
                  isPesach: subCategory.isPesach??false,
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
                  name: supplier.supplierDetail?.companyName?? '',
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
                  numberOfUnits: int.parse(sale.numberOfUnit.toString()) ,
                  image: sale.mainImage ?? '',
                  isPesach: sale.isPesach??false,
               //   salePrice: double.parse(supplier.sale.salePrice.toString()),
                  salesDesc:  parse(sale.salesDescription ?? '')
                      .body
                      ?.text ??
                      '',
                ))
                .toList() ??
                []);*/
            //supplier products result
            searchList.addAll(response.data
                ?.map((supplier) =>
                SearchModel(
                  searchId: supplier.id ?? '',
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
            AppLocalizations.of(event.context)!
                .something_is_wrong_try_again,
            type: SnackBarType.failure,
          );
          emit(state.copyWith(isSearching: false));
        } catch (exc) {
          CustomSnackBar.showSnackBar(
            context: event.context,
            title:
            AppLocalizations.of(event.context)!
                .something_is_wrong_try_again,
            type: SnackBarType.failure,
          );
          emit(state.copyWith(isSearching: false));
        }
      }
      else if (event is _updateGlobalSearchEvent) {
        emit(state.copyWith(
            searchController: TextEditingController(text: event.search),
            searchList: event.searchList));
      }
      else if (event is _relatedProductsEvent) {
        emit(state.copyWith(isRelatedShimmering: true));
        final res = await DioClient(event.context).post(
            AppUrlEndPoints.relatedProductsUrl,
            data: {AppStrings.mainProductIdString: event.productId});
        RelatedProductResModel response =
        RelatedProductResModel.fromJson(res);

        if (response.status == AppConstants.code_200) {
          List<List<ProductStockModel>> productStockList =
          state.productStockList.toList(growable: true);
          List<ProductStockModel>stockList = [];
          stockList.addAll(response.data?.map(
                  (product) =>
                  ProductStockModel(
                    productId: product.id ?? '' ,
                    stock: product.productStock.toString(),
                  )) ?? [] );
          productStockList[2].addAll(stockList);
          emit(state.copyWith(
              relatedProductList:response.data ?? [],isProductLoading : false,
              isRelatedShimmering: false,productStockList: productStockList));
        } else {
          emit(state.copyWith(isRelatedShimmering: false,isProductLoading : false,));
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: AppStrings.getLocalizedStrings(
                response.message?.toLocalization() ?? '',
                event.context),
            type: SnackBarType.success,
          );
        }

      }
      else if (event is _removeRelatedProductEvent) {
        emit(state.copyWith(relatedProductList: []));
      }
      else if (event is _getCartCountEvent) {
        emit(
            state.copyWith(cartCount: preferences.getCartCount(), isSubUserAddToBasket :preferences.getCanAddToBasket(),
            ));
      }
      else  if(event is _getPermissionList){
        if(preferences.getSubUser()){
          try {

            final res = await DioClient(event.context).get(
                path: '${AppUrlEndPoints.getAccountPermissionUrl}${preferences.getSubUserId()}');
            AccountPermissionResModel response = AccountPermissionResModel.fromJson(res);

            if (response.status == AppConstants.code_200) {
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
                  type: SnackBarType.failure);

            }
          } catch (e) {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: e.toString(),
                type: SnackBarType.failure);

          }
        }


      }
      else if(event is _userApproveEvent) {
        if (!preferences.getGuestUser() ) {
          try {
            final res = await DioClient(event.context).post(
                AppUrlEndPoints.verifyClientUrl,
                data: {AppStrings.clientIdString: preferences.getUserId()}
            );
            VerifyClientResModel response = VerifyClientResModel.fromJson(res);

            if (response.status == AppConstants.code_200) {
              if (!(response.data?.isFilledForms ?? false) || !(response.data
                  ?.isRegisterForm ?? false)) {
                Navigator.pushNamed(event.context,
                    RouteDefine.formDataScreen.name);
              }
              else if (!(response.data?.isUploadedFiles ?? false) && (response
                  .data?.isRegisterForm ?? false) && (response.data
                  ?.isFilledForms ?? false)) {
                Navigator.pushNamed(
                    event.context, RouteDefine.fileUploadScreen.name);
              }
            }
          }
          catch (e) {
            debugPrint('catch____$e');
          }
        }
      }
    });
  }
}
