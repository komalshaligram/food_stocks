import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/data/error/exceptions.dart';
import 'package:food_stock/data/model/req_model/planogram_req_model/planogram_req_model.dart';
import 'package:food_stock/data/model/req_model/supplier_products_req_model/supplier_products_req_model.dart';
import 'package:food_stock/data/model/res_model/supplier_products_res_model/supplier_products_res_model.dart';
import 'package:food_stock/repository/dio_client.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../../data/model/req_model/global_search_req_model/global_search_req_model.dart';
import '../../data/model/req_model/insert_cart_req_model/insert_cart_req_model.dart'
as InsertCartModel;
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/req_model/update_cart/update_cart_req_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/global_search_res_model/global_search_res_model.dart';
import '../../data/model/res_model/insert_cart_res_model/insert_cart_res_model.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';
import '../../data/model/res_model/related_product_res_model/related_product_res_model.dart';
import '../../data/model/res_model/update_cart_res/update_cart_res_model.dart';
import '../../data/model/search_model/search_model.dart';
import '../../data/model/supplier_sale_model/supplier_sale_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:food_stock/data/model/res_model/product_categories_res_model/product_categories_res_model.dart';
import '../../ui/utils/themes/app_strings.dart';

part 'supplier_products_event.dart';

part 'supplier_products_state.dart';

part 'supplier_products_bloc.freezed.dart';

class SupplierProductsBloc
    extends Bloc<SupplierProductsEvent, SupplierProductsState> {
  bool _isProductInCart = false;
  String _cartProductId = '';
  int _productQuantity = 0;

  SupplierProductsBloc() : super(SupplierProductsState.initial()) {
    on<SupplierProductsEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(
          prefs: await SharedPreferences.getInstance());
      if (event is _GetSupplierProductsIdEvent) {
        emit(
            state.copyWith(supplierId: event.supplierId, search: event.search));
        debugPrint(
            'supplier id = ${state.supplierId}, search = ${state.search}');
      } else if (event is _GetSupplierProductsListEvent) {
        emit(state.copyWith(isGuestUser: preferences.getGuestUser(),
            isGridView: preferences.getSupplierProductGrid()));
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
          SupplierProductsReqModel request = SupplierProductsReqModel(
              supplierId: state.supplierId,
              pageLimit: AppConstants.supplierProductPageLimit,
              pageNum: state.pageNum + 1,
              onlySearch: event.searchType == SearchTypes.product.toString()
                  ? true
                  : false,
              search: state.search);
          Map<String, dynamic> req = request.toJson();
          req.removeWhere((key, value) {
            if (value != null) {
              debugPrint("[$key] = $value");
            }
            return value == '';
          });
          debugPrint('supplier products req = $req');
          SupplierProductsResModel response;
          if (event.searchType == SearchTypes.product.toString()) {
            emit(state.copyWith(searchType: event.searchType.toString()));
            final res = await DioClient(event.context)
                .post(AppUrls.getPlanogramAllProductUrl, data: req);
            response =
                SupplierProductsResModel.fromJson(res);
          } else {
            final res = await DioClient(event.context)
                .post(AppUrls.getSupplierProductsUrl, data: req);
            response =
                SupplierProductsResModel.fromJson(res);
          }
          emit(state.copyWith(searchType: event.searchType.toString()));
          debugPrint('supplier Products res = ${response.data}');
          if (response.status == 200) {
            List<SupplierProductsData> productList =
            state.productList.toList(growable: true);
            productList.addAll(response.data ?? []);
            List<ProductStockModel> productStockList =
            state.productStockList.toList(growable: true);
            productStockList.addAll(response.data?.map((product) {
              return ProductStockModel(
                  productId: event.searchType == SearchTypes.product.toString()
                      ? product.id ?? ''
                      : product.productId ?? '',
                  stock: event.searchType == SearchTypes.product.toString()
                      ? double.parse(product.productStock.toString()).toInt()
                      : double.parse(product.productStock.toString() ?? '0')
                      .toInt());
            }) ??
                []);
            debugPrint('new product list len = ${productList.length}');
            debugPrint(
                'new product stock list len = ${productStockList.length}');
            debugPrint(
                'new product stock list len = ${productStockList.where((
                    element) {
                  debugPrint('ids = ${element.productId}');
                  return true;
                })}}');
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
                type: SnackBarType.FAILURE);
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
        state.refreshController.refreshCompleted();
        state.refreshController.loadComplete();
      } else if (event is _GetAllProductsEvent) {
        try {
          PlanogramReqModel planogramReqModel = PlanogramReqModel(
            pageLimit: AppConstants.supplierProductPageLimit,
            pageNum: state.pageNum + 1,
            sortOrder: AppStrings.ascendingString,
            sortField: AppStrings.planogramSortFieldString,
          );

          emit(state.copyWith(isShimmering: true));

          final res = await DioClient(event.context).post(
              AppUrls.getPlanogramAllProductUrl,
              data: planogramReqModel);
          SupplierProductsResModel response =
          SupplierProductsResModel.fromJson(res);
          debugPrint(
              'product categories = ${response.data!.length.toString()}');
          if (response.status == 200) {
            List<SupplierProductsData> productList =
            state.productList.toList(growable: true);
            productList.addAll(response.data ?? []);
            List<ProductStockModel> productStockList =
            state.productStockList.toList(growable: true);
            productStockList.addAll(response.data?.map((product) =>
                ProductStockModel(
                    productId: product.productId ?? '',
                    stock: int.parse(product.productStock ?? '0'))) ??
                []);
            debugPrint('new product list len = ${productList.length}');
            debugPrint(
                'new product stock list len = ${productStockList.length}');
            debugPrint(
                'new product stock list len = ${productStockList.where((
                    element) {
                  debugPrint('ids = ${element.productId}');
                  return true;
                })}}');
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
                type: SnackBarType.FAILURE);
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      }


      else if (event is _RefreshListEvent) {
        emit(state.copyWith(
            pageNum: 0,
            productList: [],
            productStockList: [],
            isBottomOfProducts: false));
        add(SupplierProductsEvent.getSupplierProductsListEvent(
            context: event.context, searchType: ''));
      }
      else if (event is _GetProductDetailsEvent) {
        add(SupplierProductsEvent.RemoveRelatedProductEvent());
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
          print('ProductDetailsResModel______${response}');
          print('_productQuantity______${_productQuantity}');
          if (response.status == 200) {
            int productStockUpdateIndex = 0;
            if (event.isBarcode) {
              productStockUpdateIndex = 0;
            }
            else {
              productStockUpdateIndex = state.productStockList.indexWhere(
                    (productStock) =>
                productStock.productId == event.productId,);
            }
            emit(state.copyWith(
                productStockUpdateIndex: productStockUpdateIndex));
            List<ProductStockModel> productStockList =
            state.productStockList.toList(growable: false);
            productStockList[productStockList
                .indexOf(productStockList.last)] = productStockList[
            productStockList.indexOf(productStockList.last)]
                .copyWith(
                quantity: _productQuantity,
                productId: response.product?.first.id ?? '',
                stock: int.parse(
                    response.product?.first.supplierSales?.first.productStock
                        .toString() ?? "0") ?? 0,
                productSaleId: '',
                productSupplierIds: '',
                note: '',
                isNoteOpen: false,
                totalPrice: double.parse(
                    response.product?.first.supplierSales?.first.productPrice
                        .toString() ?? '0')
            );
            emit(state.copyWith(productStockList: productStockList));
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

                debugPrint('state.productStockUpdateIndex = ${state
                    .productStockList[state.productStockList.length - 1]
                    .productId}');

                response.data?.data?.forEach((cartProduct) {
                  debugPrint('cart id : ${cartProduct.id}');
                  if (cartProduct.id ==
                      state.productStockList[state.productStockList.length - 1].productId
                      || cartProduct.id == event.productId
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
            //   if(response.product != null){
            add(SupplierProductsEvent.RelatedProductsEvent(
                context: event.context, productId: state.productStockList[state.productStockList.length - 1].productId));
            //   }

            if (/*productStockUpdateIndex == -1 &&*/ (event.isBarcode ??
                false)) {
              List<ProductStockModel> productStockList =
              state.productStockList.toList(growable: false);
              productStockList[productStockList
                  .indexOf(productStockList.last)] = productStockList[
              productStockList.indexOf(productStockList.last)]
                  .copyWith(
                quantity: _productQuantity,
                productId: response.product?.first.id ?? '',
                stock: int.parse(
                    response.product?.first.supplierSales!.first.productStock
                        .toString() ?? "0") ?? 0,
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
              debugPrint(
                  'barcode stock 1= ${state.productStockList.last.quantity}');
              debugPrint(
                  'barcode stock update index = ${state.productStockList
                      .length}');
              debugPrint(
                  'barcode stock update index = $productStockUpdateIndex');
            }
            debugPrint(
                'product stock update index = $productStockUpdateIndex');
            //  debugPrint('product stock = ${state.productStockList[productStockUpdateIndex].stock}');
            debugPrint(
                'supplier list stock = ${response.product?.first.supplierSales
                    ?.map((e) => e.productStock)}');
            List<ProductSupplierModel> supplierList = [];


            supplierList.addAll(response.product?.first.supplierSales
                ?.map((supplier) =>
                ProductSupplierModel(
                  supplierId: supplier.supplierId ?? '',
                  companyName: supplier.supplierCompanyName ?? '',
                  basePrice:
                  double.parse(supplier.productPrice ?? '0.0'),
                  stock: int.parse(supplier.productStock ?? '0'),
                  quantity: _productQuantity,
                  selectedIndex: (supplier.supplierId ?? '') ==
                      state.productStockList[productStockUpdateIndex]
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
            String note =
            state.productStockList.indexOf(state.productStockList.last) ==
                productStockUpdateIndex
                ? ''
                : state.productStockList[productStockUpdateIndex].note;
            emit(state.copyWith(
                productStockList: state.productStockList,
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
                add(SupplierProductsEvent.supplierSelectionEvent(
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
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: e.toString(),
            type: SnackBarType.FAILURE,

          );
          //  Navigator.pop(event.context);
        }
      }
      else if (event is _IncreaseQuantityOfProduct) {
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
                  '${AppLocalizations.of(event.context)!
                      .please_select_supplier}',
                  type: SnackBarType.FAILURE);
              return;
            }
            // if(productStockList[state.productStockUpdateIndex]
            //     .quantity == 0) {
            //   productStockList[state.productStockUpdateIndex] =
            //       productStockList[state.productStockUpdateIndex].copyWith(
            //           quantity: 4999);
            // } else {
            productStockList[state.productStockUpdateIndex] =
                productStockList[state.productStockUpdateIndex].copyWith(
                    quantity: productStockList[state.productStockUpdateIndex]
                        .quantity +
                        1);
            // }
            debugPrint(
                'product quantity = ${productStockList[state
                    .productStockUpdateIndex].quantity}');
            emit(state.copyWith(productStockList: productStockList));
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
                'product quantity = ${productStockList[state
                    .productStockUpdateIndex].quantity}');
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
                  supplierList[event.supplierIndex].supplierId,
                  stock: supplierList[event.supplierIndex].stock,
                  quantity: supplierList[event.supplierIndex].quantity != 0
                      ? supplierList[event.supplierIndex].quantity
                      : 1,
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
          supplierList[event.supplierIndex] = supplierList[event.supplierIndex]
              .copyWith(selectedIndex: event.supplierSaleIndex);
          debugPrint(
              'selected supplier[${event.supplierIndex}] = ${supplierList[event
                  .supplierIndex]}');
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
        if (_isProductInCart) {
          debugPrint('update cart');
          try {
            emit(state.copyWith(isLoading: true));
            UpdateCartReqModel request = UpdateCartReqModel(
              productId: state.productStockList[state.productStockUpdateIndex]
                  .productId == '' ? event.productId : state
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
                  .quantity /*+
                  _productQuantity*/,
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
                  productId: state.productStockList[state
                      .productStockUpdateIndex].productId == '' ? event
                      .productId : state.productStockList[state
                      .productStockUpdateIndex].productId,
                  quantity: state
                      .productStockList[state.productStockUpdateIndex].quantity,
                  supplierId: state
                      .productStockList[state.productStockUpdateIndex]
                      .productSupplierIds,
                  saleId: state.productStockList[state.productStockUpdateIndex]
                      .productSaleId.isEmpty
                      ? null
                      : state.productStockList[state.productStockUpdateIndex]
                      .productSaleId,
                  note: state.productStockList[state.productStockUpdateIndex]
                      .note.isEmpty
                      ? null
                      : state
                      .productStockList[state.productStockUpdateIndex].note)
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
                    .insertProductInCartUrl}${preferencesHelper.getCartId()}');
            debugPrint(
                'insert cart url1 auth = ${preferencesHelper.getAuthToken()}');
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
              Vibration.vibrate();
              Navigator.pop(event.context);
              add(SupplierProductsEvent.setCartCountEvent());
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
                isLoading: false, productStockList: productStockList,));

              CustomSnackBar.showSnackBar(
                  context: event.context,
                  /*title: response.message ??
                    '${AppLocalizations.of(event.context)!.product_added_to_cart}',*/
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          response.message!,
                      event.context),
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
      } else if (event is _SetCartCountEvent) {
        SharedPreferencesHelper preferences = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());
        await preferences.setCartCount(count: preferences.getCartCount() + 1);
        await preferences.setIsAnimation(isAnimation: true);
        debugPrint('cart count = ${preferences.getCartCount()}');
      } else if (event is _UpdateImageIndexEvent) {
        emit(state.copyWith(imageIndex: event.index));
      } else if (event is _ToggleNoteEvent) {
        List<ProductStockModel> productStockList =
        state.productStockList.toList(growable: true);
        productStockList[state.productStockUpdateIndex] =
            productStockList[state.productStockUpdateIndex].copyWith(
                isNoteOpen: !productStockList[state.productStockUpdateIndex]
                    .isNoteOpen);
        emit(state.copyWith(productStockList: productStockList));
      }
      else if (event is _getGridListView) {
        preferences.setSupplierProductGridListView(
            isSupplierProductGrid: !state.isGridView);
        emit(state.copyWith(isGridView: !state.isGridView));
      }
      else if (event is _ChangeCategoryExpansion) {
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
                  numberOfUnits: int.parse(sale.numberOfUnit.toString()) ?? 0,
                  image: sale.mainImage ?? '',

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
                  productStock: int.parse(
                      supplier.productStock ?? 0.toString()),
                  numberOfUnits: int.parse(supplier.numberOfUnit.toString()) ??
                      0,
                  priceOfBox: double.parse(supplier.productPrice.toString()) ??
                      0,
                ))
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
      else if (event is _RelatedProductsEvent) {
        if (event.productId != '') {
          emit(state.copyWith(isRelatedShimmering: true));
          final res = await DioClient(event.context).post(
              AppUrls.relatedProductsUrl,
              data: {'mainProductId': event.productId});
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
                      productId: Product.id ?? '',
                      stock: Product.productStock ?? 0,
                    )) ??
                []);

            emit(state.copyWith(
                relatedProductList:response.data ?? [],
                isRelatedShimmering: false,productStockList: productStockList));
          } else {
            emit(state.copyWith(isRelatedShimmering: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(
                  response.message.toLocalization() ??
                      response.message,
                  event.context),
              type: SnackBarType.SUCCESS,
            );
          }
        }
      }
      else if (event is _RemoveRelatedProductEvent) {
        emit(state.copyWith(relatedProductList: []));
      }
    });
  }
}
