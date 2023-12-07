import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/data/error/exceptions.dart';
import 'package:food_stock/data/model/req_model/supplier_products_req_model/supplier_products_req_model.dart';
import 'package:food_stock/data/model/res_model/supplier_products_res_model/supplier_products_res_model.dart';
import 'package:food_stock/repository/dio_client.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html/parser.dart';
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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'supplier_products_event.dart';

part 'supplier_products_state.dart';

part 'supplier_products_bloc.freezed.dart';

class SupplierProductsBloc
    extends Bloc<SupplierProductsEvent, SupplierProductsState> {
  SupplierProductsBloc() : super(SupplierProductsState.initial()) {
    on<SupplierProductsEvent>((event, emit) async {
      if (event is _GetSupplierProductsIdEvent) {
        emit(
            state.copyWith(supplierId: event.supplierId, search: event.search));
        debugPrint(
            'supplier id = ${state.supplierId}, search = ${state.search}');
      } else if (event is _GetSupplierProductsListEvent) {
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
              search: state.search);
          Map<String, dynamic> req = request.toJson();
          req.removeWhere((key, value) {
            if (value != null) {
              debugPrint("[$key] = $value");
            }
            return value == '';
          });
          debugPrint('supplier products req = $req');
          final res = await DioClient(event.context)
              .post(AppUrls.getSupplierProductsUrl, data: req);
          SupplierProductsResModel response =
              SupplierProductsResModel.fromJson(res);
          debugPrint('supplier Products res = ${response.data}');
          if (response.status == 200) {
            List<Datum> productList = state.productList.toList(growable: true);
            productList.addAll(response.data ?? []);
            List<ProductStockModel> productStockList =
                state.productStockList.toList(growable: true);
            productStockList.addAll(response.data?.map((product) =>
                    ProductStockModel(
                        productId: product.productId ?? '',
                        stock: product.productStock?.toInt() ?? 0)) ??
                []);
            debugPrint('new product list len = ${productList.length}');
            debugPrint(
                'new product stock list len = ${productStockList.length}');
            debugPrint(
                'new product stock list len = ${productStockList.where((element) {
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
            showSnackBar(
                context: event.context,
                title: response.message ?? '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                bgColor: AppColors.redColor);
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
      } else if (event is _GetProductDetailsEvent) {
        debugPrint('product details id = ${event.productId}');
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
            debugPrint(
                'supplier list stock = ${response.product?.first.supplierSales?.map((e) => e.productStock)}');
            List<ProductSupplierModel> supplierList = [];
            debugPrint(
                'supplier id = ${state.productStockList[productStockUpdateIndex].productSupplierIds}');
            response.product?.first.supplierSales?.forEach((supplier) {
              if (supplier.supplierId == state.supplierId) {
                supplierList.add(ProductSupplierModel(
                  supplierId: supplier.supplierId ?? '',
                  companyName: supplier.supplierCompanyName ?? '',
                  basePrice: double.parse(supplier.productPrice ?? '0.0'),
                  stock: int.parse(supplier.productStock ?? '0'),
                  selectedIndex: (supplier.supplierId ?? '') ==
                          state.productStockList[productStockUpdateIndex]
                              .productSupplierIds
                      ? supplier.saleProduct
                                  ?.indexOf(supplier.saleProduct?.firstWhere(
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
                          : supplier.saleProduct
                                  ?.indexOf(supplier.saleProduct?.firstWhere(
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
                              salePrice:
                                  double.parse(sale.discountedPrice ?? '0.0'),
                              saleDiscount: double.parse(
                                  sale.discountPercentage ?? '0.0')))
                          .toList() ??
                      [],
                ));
                debugPrint('supplier found');
                return;
              }
            });
            // supplierList.addAll(response.product?.first.supplierSales
            //     ?.map((supplier) => ProductSupplierModel(
            // supplierId: supplier.supplierId ?? '',
            // companyName: supplier.supplierCompanyName ?? '',
            // basePrice:
            // double.parse(supplier.productPrice ?? '0.0'),
            // selectedIndex: (supplier.supplierId ?? '') ==
            // state
            //     .productStockList[productStockUpdateIndex]
            //     .productSupplierIds
            // ? supplier.saleProduct?.indexOf(
            // supplier.saleProduct?.firstWhere(
            // (sale) =>
            // sale.saleId ==
            // state
            //     .productStockList[
            // productStockUpdateIndex]
            //     .productSaleId,
            // orElse: () => SaleProduct(),
            // ) ??
            // SaleProduct()) ==
            // -1
            // ? -2
            //     : supplier.saleProduct?.indexOf(
            // supplier.saleProduct?.firstWhere(
            // (sale) =>
            // sale.saleId ==
            // state
            //     .productStockList[
            // productStockUpdateIndex]
            //     .productSaleId,
            // orElse: () => SaleProduct(),
            // ) ??
            // SaleProduct()) ??
            // -1
            //     : -1,
            // supplierSales: supplier.saleProduct
            //     ?.map((sale) => SupplierSaleModel(
            // saleId: sale.saleId ?? '',
            // saleName: sale.saleName ?? '',
            // saleDescription:
            // parse(sale.salesDescription ?? '')
            //     .body
            //     ?.text ??
            // '',
            // salePrice: double.parse(
            // sale.discountedPrice ?? '0.0'),
            // saleDiscount: double.parse(
            // sale.discountPercentage ?? '0.0')))
            //     .toList() ??
            // [],
            // ))
            //     .toList() ??
            // []);
            debugPrint(
                'response list = ${response.product?.first.supplierSales?.length}');
            debugPrint('supplier list = ${supplierList.length}');
            debugPrint(
                'supplier select index = ${supplierList.map((e) => e.selectedIndex)}');
            emit(state.copyWith(
                productDetails: response.product ?? [],
                productStockUpdateIndex: productStockUpdateIndex,
                productSupplierList: supplierList,
                isProductLoading: false));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                bgColor: AppColors.redColor);
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
              showSnackBar(
                  context: event.context,
                  title: '${AppLocalizations.of(event.context)!.please_select_supplier}',
                  bgColor: AppColors.redColor);
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
                'product quantity = ${productStockList[state.productStockUpdateIndex].quantity}');
            emit(state.copyWith(productStockList: productStockList));
          } else {
            showSnackBar(
                context: event.context,
                title: '${AppLocalizations.of(event.context)!.you_have_reached_maximum_quantity}',
                bgColor: AppColors.redColor);
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
      } else if (event is _ChangeNoteOfProduct) {
        if (state.productStockUpdateIndex != -1) {
          List<ProductStockModel> productStockList =
              state.productStockList.toList(growable: false);
          productStockList[state.productStockUpdateIndex] =
              productStockList[state.productStockUpdateIndex]
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
          List<ProductStockModel> productStockList =
              state.productStockList.toList(growable: true);

          productStockList[state.productStockUpdateIndex] =
              productStockList[state.productStockUpdateIndex].copyWith(
                  productSupplierIds:
                      supplierList[event.supplierIndex].supplierId,
                  stock: supplierList[event.supplierIndex].stock,
                  quantity: 0,
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
      } else if (event is _AddToCartProductEvent) {
        if (state.productStockList[state.productStockUpdateIndex]
            .productSupplierIds.isEmpty) {
          showSnackBar(
              context: event.context,
              title: '${AppLocalizations.of(event.context)!.please_select_supplier}',
              bgColor: AppColors.redColor);
          return;
        }
        if (state.productStockList[state.productStockUpdateIndex].quantity ==
            0) {
          showSnackBar(
              context: event.context,
              title:'${AppLocalizations.of(event.context)!.add_1_quantity}',
              bgColor: AppColors.redColor);
          return;
        }
        try {
          emit(state.copyWith(isLoading: true));
          InsertCartModel.InsertCartReqModel insertCartReqModel =
              InsertCartModel.InsertCartReqModel(products: [
            InsertCartModel.Product(
                productId: state
                    .productStockList[state.productStockUpdateIndex].productId,
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
                note: state.productStockList[state.productStockUpdateIndex].note
                        .isEmpty
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
            // List<ProductStockModel> productStockList =
            //     state.productStockList.toList(growable: true);
            // productStockList[state.productStockUpdateIndex] =
            //     productStockList[state.productStockUpdateIndex].copyWith(
            //         note: '',
            //         quantity: 0,
            //         productSupplierIds: '',
            //         totalPrice: 0.0,
            //         productSaleId: '');
            add(SupplierProductsEvent.setCartCountEvent());
            emit(state.copyWith(
                isLoading: false /*, productStockList: productStockList*/));
            showSnackBar(
                context: event.context,
                title: response.message ??
                    '${AppLocalizations.of(event.context)!.product_added_to_cart}',
                bgColor: AppColors.mainColor);
            Navigator.pop(event.context);
          } else if (response.status == 403) {
            emit(state.copyWith(isLoading: false));
            showSnackBar(
                context: event.context,
                title: response.message ?? '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                bgColor: AppColors.redColor);
          } else {
            emit(state.copyWith(isLoading: false));
            showSnackBar(
                context: event.context,
                title: response.message ?? '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
                bgColor: AppColors.redColor);
          }
        } on ServerException {
          debugPrint('url1 = ');
          emit(state.copyWith(isLoading: false));
        }
      } else if (event is _SetCartCountEvent) {
        SharedPreferencesHelper preferences = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());
        await preferences.setCartCount(count: preferences.getCartCount() + 1);
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
    });
  }
}
