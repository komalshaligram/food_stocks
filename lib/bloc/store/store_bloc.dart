import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../../data/model/req_model/company_req_model/company_req_model.dart';
import '../../data/model/req_model/global_search_req_model/global_search_req_model.dart';
import '../../data/model/req_model/insert_cart_req_model/insert_cart_req_model.dart'
    as insert;
import '../../data/model/req_model/previous_order_products_req_model/previous_order_products_req_model.dart';
import '../../data/model/req_model/product_categories_req_model/product_categories_req_model.dart';
import '../../data/model/req_model/product_sales_req_model/product_sales_req_model.dart';
import '../../data/model/req_model/recommendation_products_req_model/recommendation_products_req_model.dart';
import '../../data/model/req_model/suppliers_req_model/suppliers_req_model.dart';
import '../../data/model/res_model/company_res_model/company_res_model.dart';
import '../../data/model/res_model/insert_cart_res_model/insert_cart_res_model.dart';
import '../../data/model/res_model/product_categories_res_model/product_categories_res_model.dart';
import '../../data/model/res_model/product_sales_res_model/product_sales_res_model.dart';
import '../../data/model/res_model/setting_res_model/setting_res_model.dart';
import '../../data/model/search_model/search_model.dart';
import '../../data/model/supplier_sale_model/supplier_sale_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/req_model/update_cart/update_cart_req_model.dart';
import '../../data/model/res_model/account_permission/account_permission_res_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/global_search_res_model/global_search_res_model.dart';
import '../../data/model/res_model/previous_order_products_res_model/previous_order_products_res_model.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';
import '../../data/model/res_model/recommendation_products_res_model/recommendation_products_res_model.dart';
import '../../data/model/res_model/related_product_res_model/related_product_res_model.dart';
import '../../data/model/res_model/suppliers_res_model/suppliers_res_model.dart';
import '../../data/model/res_model/update_cart_res/update_cart_res_model.dart';
import '../../data/model/res_model/verify_client_res_model/verify_client_res_model.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/themes/app_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../bottom_nav/bottom_nav_bloc.dart';

part 'store_event.dart';

part 'store_state.dart';

part 'store_bloc.freezed.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  bool _isProductInCart = false;
  String _cartProductId = '';
  int _productQuantity = 0;
  String _productId = '';
  String _supplierId = "";


  StoreBloc() : super(StoreState.initial()) {
    on<StoreEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
      SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _changeCategoryExpansion) {
        if(event.isOpened == false){
          emit(state.copyWith(searchList: []));
        }
        if(event.isOpened == false ){
          state.searchController.clear();
          emit(state.copyWith(searchController: state.searchController,search: '',));
        }
        if (event.isOpened != null) {
          emit(state.copyWith(isCategoryExpand: event.isOpened ?? false));
        } else {
          emit(state.copyWith(isCategoryExpand: !state.isCategoryExpand));
        }
      }
      else if (event is _changeSupplierSelectionExpansionEvent) {
        emit(state.copyWith(
            isSelectSupplier:
                event.isSelectSupplier ?? !state.isSelectSupplier));
        printData('supplier selection : ${state.isSelectSupplier}');
      }
      else if (event is _getProductCategoriesListEvent) {
        emit(state.copyWith(isGuestUser: preferencesHelper.getGuestUser(),
        isSubUserAddToBasket: preferencesHelper.getCanAddToBasket(),
          isSaleOn: preferencesHelper.getShowSale(),
        ));
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).post(
              AppUrlEndPoints.getProductCategoriesUrl,
              data: const ProductCategoriesReqModel(
                      pageNum: 1, pageLimit: 18)
                  .toJson());
          ProductCategoriesResModel response =
              ProductCategoriesResModel.fromJson(res);
          printData('product categories = ${response.data?.categories!.length.toString()}');
          if (response.status == AppConstants.code_200) {
            List<SearchModel> searchList = [];
            searchList.addAll(response.data?.categories?.map((category) =>
                    SearchModel(
                        searchId: category.id ?? '',
                        name: category.categoryName ?? '',
                        searchType: SearchTypes.category,
                        image: category.categoryImage ?? '')) ??
                []);
            printData('store search list = ${searchList.length}');
            bool productVisible = response.data?.categories?.any((element) => element.isHomePreference==true)??true;
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
                type: SnackBarType.success,

            );
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      }
      else if (event is _changeSearchListEvent) {
        emit(state.copyWith(searchList: event.newSearchList));
      }
      else if (event is _getProductSalesListEvent) {
        try {
          emit(state.copyWith(isShimmering: true,isSaleShimmering: true));
          final res = await DioClient(event.context).post(
              AppUrlEndPoints.getSaleProductsUrl,
              data: const ProductSalesReqModel(
                      pageNum: 1, pageLimit: AppConstants.defaultPageLimit)
                  .toJson());
          ProductSalesResModel response = ProductSalesResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {

            List<ProductStockModel> productStockList =
                state.productStockList.toList(growable: true);
            ProductStockModel barcodeStock = productStockList.removeLast();
            productStockList.addAll(response.data?.map((saleProduct) =>
                    ProductStockModel(
                      maxQty: int.parse(saleProduct.sale?.saleMaxQuantity ?? '0'),
                        productId: saleProduct.id ?? '',
                        stock: (saleProduct.productStock.toString()))) ?? []);
            productStockList.add(barcodeStock);
            emit(state.copyWith(
                productSalesList: response.data ?? [] ,
                productStockList: productStockList,
                isShimmering: false,isSaleShimmering:false));
          } else {
            emit(state.copyWith(isShimmering: false,isSaleShimmering:false));
            /*CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    AppLocalizations.of(event.context)!.something_is_wrong_try_again,
                type: SnackBarType.failure,
            );*/
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false,isSaleShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false,isSaleShimmering: false));
        }
      }

      else if (event is _getRecommendationProductsListEvent) {

        if(!preferencesHelper.getGuestUser()){
          try {
            emit(state.copyWith(isRecommendedShimmering: true));
            final res = await DioClient(event.context).post(
                AppUrlEndPoints.getRecommendationProductsUrl,
                data: const RecommendationProductsReqModel(
                    pageNum: 1, pageLimit: AppConstants.defaultPageLimit)
                    .toJson(),);
            RecommendationProductsResModel response =
            RecommendationProductsResModel.fromJson(res);

            if (response.status == AppConstants.code_200) {
              List<ProductStockModel> productStockList =
              state.productStockList.toList(growable: true);
              ProductStockModel barcodeStock = productStockList.removeLast();
              productStockList.addAll(response.data?.map(
                      (recommendationProduct) => ProductStockModel(
                        maxQty: (recommendationProduct.sale?.isSale ?? false) ? int.parse(recommendationProduct.sale?.saleMaxQuantity ?? '0') : 0,
                      productId: recommendationProduct.id ?? '',
                      stock: recommendationProduct.productStock.toString())) ?? []);
              productStockList.add(barcodeStock);

              emit(state.copyWith(
                  recommendedProductsList: response.data ?? [],
                  isRecommendedShimmering:false,
                  productStockList: productStockList,
                  isShimmering: false));
            } else {
              emit(state.copyWith(isShimmering: false, isRecommendedShimmering:false,));
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ?? '',
                    event.context),
                type: SnackBarType.failure,
              );
            }
          } on ServerException {
            emit(state.copyWith(isShimmering: false, isRecommendedShimmering:false,));
          } catch (exc) {
            emit(state.copyWith(isShimmering: false, isRecommendedShimmering:false,));
          }
        }

      }

      else if (event is _getSuppliersListEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).post(
              AppUrlEndPoints.getSuppliersUrl,
              data: const SuppliersReqModel(
                      pageNum: 1, pageLimit: AppConstants.defaultPageLimit)
                  .toJson());
          SuppliersResModel response = SuppliersResModel.fromJson(res);
          printData('suppliers = ${response.data}');
          if (response.status == AppConstants.code_200) {
            bool productVisible = response.data?.any((element) => element.supplierDetail?.isHomePreference==true)??true;
            emit(state.copyWith(suppliersList: response, isShimmering: false,isSupplierVisible: productVisible,context: event.context));
          } else {
            emit(state.copyWith(isShimmering: false,context: event.context));
            CustomSnackBar.showSnackBar(
                context: event.context,
              title: AppStrings.getLocalizedStrings(
                  response.message?.toLocalization() ??
                      response.message!,
                  event.context),
                type: SnackBarType.success,

            );
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      }

      else if (event is _getCompaniesListEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).post(
              AppUrlEndPoints.getCompaniesUrl,
              data: const CompanyReqModel(
                      pageNum: 1, pageLimit: AppConstants.companyPageLimit)
                  .toJson());
          CompanyResModel response = CompanyResModel.fromJson(res);
          printData('companies = ${response.data}');
          if (response.status == AppConstants.code_200) {
           bool company = response.data?.brandList?.any((element) => element.isHomePreference==true)??true;
            emit(state.copyWith(isCompanyVisible: company));
            emit(state.copyWith(
                companiesList: response.data?.brandList ?? [],
                isShimmering: false));
          } else {
            emit(state.copyWith(isShimmering: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
              title: AppStrings.getLocalizedStrings(
                  response.message?.toLocalization() ??
                      response.message!,
                  event.context),
                type: SnackBarType.success,
            );
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      }
      else if (event is _getProductDetailsEvent) {

        add(const StoreEvent.removeRelatedProductEvent());
        _isProductInCart = false;
        _cartProductId = '';
        _productQuantity = 0;
        _productId = '';
        _supplierId = '';
        try {
          emit(state.copyWith(isProductLoading: true, isSelectSupplier: false,));
          final res = await DioClient(event.context).post(
              AppUrlEndPoints.getProductDetailsUrl,
              data: ProductDetailsReqModel(params: event.productId).toJson());
          ProductDetailsResModel response =
              ProductDetailsResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            if(response.product!.isNotEmpty) {
              int productStockUpdateIndex = -1;

              if (event.isBarcode ?? false) {
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
                  maxQty: (response.product?.first.sale?.isSale ?? false) ? int.parse(
                      response.product?.first.sale?.saleMaxQuantity ?? '0') : 0,
                  productId: response.product?.first.id ?? '',
                  stock: (response.product?.first.supplierSales?.first
                      .productStock.toString() ?? ''),
                  productSaleId: '',
                  productSupplierIds: '',
                  totalPrice: double.parse(
                      response.product?.first.supplierSales?.first.productPrice
                          .toString() ?? '')
              );

              emit(state.copyWith(productStockList: productStockList,));

              try {
                SharedPreferencesHelper preferences = SharedPreferencesHelper(
                    prefs: await SharedPreferences.getInstance());
                final res = await DioClient(event.context).post(
                    '${AppUrlEndPoints.getAllCartUrl}${preferences.getCartId()}',
                    options: Options(headers: {
                      HttpHeaders.authorizationHeader:
                      'Bearer ${preferences.getAuthToken()}'
                    }));
                GetAllCartResModel response = GetAllCartResModel.fromJson(res);
                if (response.status == AppConstants.code_200) {
                  printData('cart before = ${response.data}');
                  response.data?.data?.forEach((cartProduct) {
                    if (cartProduct.id ==
                        state.productStockList[state.productStockUpdateIndex]
                            .productId ||
                        cartProduct.id ==
                            state.productStockList[state.productStockList
                                .length - 1].productId
                        || cartProduct.id == event.productId) {
                      _isProductInCart = true;
                      _cartProductId = cartProduct.cartProductId ?? '';
                      _productQuantity = cartProduct.totalQuantity  ?? 0;

                      return;
                    }
                  });
                  printData(
                      '1)exist = $_isProductInCart\n2)id = $_cartProductId\n3) quan = $_productQuantity');
                }
              } on ServerException {}
              emit(state.copyWith(productDetails: response.product??[],isProductLoading:false ));

              if ((event.isBarcode ?? false)) {
                List<ProductStockModel> productStockList =
                state.productStockList.toList(growable: false);
                productStockList[productStockList
                    .indexOf(productStockList.last)] = productStockList[
                productStockList.indexOf(productStockList.last)]
                    .copyWith(
                  quantity: _productQuantity,
                  maxQty: (response.product?.first.sale?.isSale ?? false)? int.parse(
                     ( response.product?.first.sale?.saleMaxQuantity ?? '0')) : 0,
                  productId: response.product?.first.id ?? '',
                  stock: (response.product?.first.supplierSales?.first
                      .productStock.toString() ?? '0'),
                  productSaleId: '',
                  productSupplierIds: '',
                  note: '',
                  productIsInCart: true,
                );

                emit(state.copyWith(productStockList: productStockList));
                productStockUpdateIndex =
                    productStockList.indexOf(productStockList.last);
              }

              List<ProductSupplierModel> supplierList = [];

              supplierList.addAll(response.product?.first.supplierSales?.map((supplier) =>
                  ProductSupplierModel(
                    supplierId: supplier.supplierId ?? '',
                    companyName: supplier.supplierCompanyName ?? '',
                    maxQty: (response.product?.first.sale?.isSale ?? false)
                        ? int.parse(
                        response.product?.first.sale?.saleMaxQuantity.toString() ?? '0')
                        : 0,
                    basePrice: double.parse(supplier.productPrice ?? ''),
                    stock: supplier.productStock.toString(),
                    quantity: _productQuantity,
                    selectedIndex: (supplier.supplierId) ==
                        state
                            .productStockList[productStockUpdateIndex]
                            .productSupplierIds
                        ? !supplier.saleProduct!.contains(
                      supplier.saleProduct?.firstWhere(
                            (sale) =>
                        sale.saleId ==
                            state
                                .productStockList[
                            productStockUpdateIndex]
                                .productSaleId,
                        orElse: () => const SaleProduct(isSale: false,
                            saleDescription: '',
                            saleFromDate: '',
                            saleMaxQuantity: '0',
                            salePrice: '0',
                            saleUntilDate: ''),
                      ) ??
                          const SaleProduct(isSale: false,
                              saleDescription: '',
                              saleFromDate: '',
                              saleMaxQuantity: '0',
                              salePrice: '0',
                              saleUntilDate: ''),)
                        ? -2 : supplier.saleProduct?.indexOf(
                      supplier.saleProduct?.firstWhere(
                            (sale) =>
                        sale.saleId ==
                            state.productStockList[productStockUpdateIndex]
                                .productSaleId,
                        orElse: () => const SaleProduct(isSale: false,saleDescription: '',saleFromDate: '',saleMaxQuantity: '0',salePrice: '0',saleUntilDate:'' ),
                      ) ??
                          const SaleProduct(isSale: false,saleDescription: '',saleFromDate: '',saleMaxQuantity: '0',salePrice: '0',saleUntilDate:'' ),) ??
                        -1
                        : -1,
                    supplierSales: supplier.saleProduct?.map((sale) =>
                        SupplierSaleModel(
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
                        .toList() ?? [],
                  ))
                  .toList() ?? []) ;

              supplierList.removeWhere((supplier) => supplier.stock == '0');

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
                  /*isProductLoading: false*/
              ));
              if (response.product!.isNotEmpty) {
                add(StoreEvent.relatedProductsEvent(context: event.context,
                    productId: response.product?.first.id ?? ''));
              }

              if (supplierList.isNotEmpty) {
                bool isSupplierSelected = false;
                for (var supplier in supplierList) {
                  if (supplier.selectedIndex != -1) {
                    isSupplierSelected = true;
                    continue;
                  }
                }
                if (!isSupplierSelected) {
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

                  add(StoreEvent.supplierSelectionEvent(
                      supplierIndex: supplierIndex,
                      context: event.context,
                      supplierSaleIndex: supplierSaleIndex));
                }
              }
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
                  response.message?.toLocalization() ??
                      response.message!,
                  event.context),
                type: SnackBarType.failure,

            );
          }
        } on ServerException {
          // emit(state.copyWith(isProductLoading: false));
          Navigator.pop(event.context);
        } catch (e) {
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: e.toString(),
            type: SnackBarType.failure,

          );
        //  Navigator.pop(event.context);
        }
      }


      else if (event is _increaseQuantityOfProduct) {

        List<ProductStockModel> productStockList =
            state.productStockList.toList(growable: false);
        if (state.productStockUpdateIndex != -1) {
          if (productStockList[state.productStockUpdateIndex].quantity <
             double.parse( productStockList[state.productStockUpdateIndex].stock.toString())) {
            if (productStockList[state.productStockUpdateIndex]
                .productSupplierIds
                .isEmpty) {

              return;
            }
             if(productStockList[state.productStockUpdateIndex]
                 .maxQty!=0){
               if (productStockList[state.productStockUpdateIndex]
                   .quantity >=
                   productStockList[state.productStockUpdateIndex]
                       .maxQty) {
                 CustomSnackBar.showSnackBar(
                     context: event.context,
                     title: AppLocalizations.of(event.context)!.not_add_more_than_max_qty,
                     type: SnackBarType.failure);
                 return;
               }
             }
            productStockList[state.productStockUpdateIndex] =
                productStockList[state.productStockUpdateIndex].copyWith(
                    quantity: productStockList[state.productStockUpdateIndex]
                            .quantity +
                        1);
            printData(
                'product quantity = ${productStockList[state.productStockUpdateIndex].quantity}');
            emit(state.copyWith(productStockList: productStockList));
          } else {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[state.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
                // '${AppLocalizations.of(event.context)!.you_have_reached_maximum_quantity}',
                type: SnackBarType.failure,

            );
          }
        }
      }
      else if (event is _decreaseQuantityOfProduct) {
        List<ProductStockModel> productStockList =
            state.productStockList.toList(growable: false);
        if (state.productStockUpdateIndex != -1) {
          if (productStockList[state.productStockUpdateIndex].quantity > 0) {
            productStockList[state.productStockUpdateIndex] =
                productStockList[state.productStockUpdateIndex].copyWith(
                    quantity: productStockList[state.productStockUpdateIndex]
                            .quantity -
                        1);

            emit(state.copyWith(productStockList: productStockList));
          } else {}
        }
      }
      else if (event is _updateQuantityOfProduct) {
        List<ProductStockModel> productStockList =
            state.productStockList.toList(growable: false);
        if (state.productStockUpdateIndex != -1) {
          String quantityString = event.quantity;
          if (quantityString.length == 2 && quantityString.startsWith('0')) {
            quantityString = quantityString.substring(1);
          }
          int newQuantity = int.tryParse(quantityString) ?? 0;

          if (newQuantity <=
             double.parse( productStockList[state.productStockUpdateIndex].stock.toString())) {
            productStockList[state.productStockUpdateIndex] =
                productStockList[state.productStockUpdateIndex]
                    .copyWith(quantity: newQuantity);

            emit(state.copyWith(productStockList: productStockList));
          } else {
            productStockList[state.productStockUpdateIndex] =
                productStockList[state.productStockUpdateIndex].copyWith(
                    quantity: int.tryParse(quantityString.substring(
                            0, quantityString.length - 1)) ??
                        0);

            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[state.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
                type: SnackBarType.failure,

            );
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          }
        }
      }
      else if (event is _changeNoteOfProduct) {
        if (state.productStockUpdateIndex != -1) {
          List<ProductStockModel> productStockList =
              state.productStockList.toList(growable: false);
          productStockList[state.productStockUpdateIndex] =
              productStockList[state.productStockUpdateIndex]
                  .copyWith(note: /*event.newNote*/ state.noteController.text);
          emit(state.copyWith(productStockList: productStockList));
        }
      }
      else if (event is _addToCartProductEvent) {
        if (state.productStockList[state.productStockUpdateIndex].productSupplierIds.isEmpty) {
          return;
        }
        if (state.productStockList[state.productStockUpdateIndex].quantity == 0) {
          CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.add_1_quantity, type: SnackBarType.failure);
          return;
        }
        if (state.productStockList[state.productStockUpdateIndex].maxQty > 0) {
          if (state.productStockList[state.productStockUpdateIndex].quantity > state.productStockList[state.productStockUpdateIndex].maxQty) {
            CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.not_add_more_than_max_qty, type: SnackBarType.failure);
            return;
          }
        }

        if (_isProductInCart) {
          try {
            emit(state.copyWith(isLoading: true));
            UpdateCartReqModel request = UpdateCartReqModel(
              productId: state.productStockList[state.productStockUpdateIndex].productId == '' ? event.productId : state.productStockList[state.productStockUpdateIndex].productId,
              supplierId: state.productStockList[state.productStockUpdateIndex].productSupplierIds,
              saleId: state.productStockList[state.productStockUpdateIndex].productSaleId == '' ? null : state.productStockList[state.productStockUpdateIndex].productSaleId,
              quantity: state.productStockList[state.productStockUpdateIndex].quantity /*+ _productQuantity*/,
              cartProductId: _cartProductId,
            );
            SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
            final res = await DioClient(event.context).post(
              '${AppUrlEndPoints.updateCartProductUrl}${preferences.getCartId()}',
              data: request,
            );
            UpdateCartResModel response = UpdateCartResModel.fromJson(res);
            if (response.status == AppConstants.code_201) {
              Vibration.vibrate();
              //  Navigator.pop(event.context);
              List<ProductStockModel> productStockList = state.productStockList.toList(growable: true);
              productStockList[state.productStockUpdateIndex] = productStockList[state.productStockUpdateIndex].copyWith(
                note: '',
                productIsInCart: false,
                productSupplierIds: productStockList[state.productStockUpdateIndex].productSupplierIds,
                quantity: productStockList[state.productStockUpdateIndex].quantity,
                totalPrice: productStockList[state.productStockUpdateIndex].totalPrice,
                productSaleId: '',
              );
              emit(state.copyWith(isLoading: false, productStockList: productStockList));

              CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.success);
            } else {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.failure);
            }
          } on ServerException {
            emit(state.copyWith(isLoading: false));
          } catch (e) {
            printData('err = $e');
            emit(state.copyWith(isLoading: false));
          }
        } else {
          try {
            emit(state.copyWith(isLoading: true));
            insert.InsertCartReqModel insertCartReqModel = insert.InsertCartReqModel(products: [insert.Product(productId: state.productStockList[state.productStockUpdateIndex].productId, quantity: state.productStockList[state.productStockUpdateIndex].quantity, supplierId: state.productStockList[state.productStockUpdateIndex].productSupplierIds, saleId: state.productStockList[state.productStockUpdateIndex].productSaleId.isEmpty ? null : state.productStockList[state.productStockUpdateIndex].productSaleId, note: state.productStockList[state.productStockUpdateIndex].note.isEmpty ? null : state.productStockList[state.productStockUpdateIndex].note)]);
            Map<String, dynamic> req = insertCartReqModel.toJson();
            req.removeWhere((key, value) {
              if (value != null) {
                printData("[$key] = $value");
              }
              return value == null;
            });
            SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
            final res = await DioClient(event.context).post(
              '${AppUrlEndPoints.insertProductInCartUrl}${preferencesHelper.getCartId()}',
              data: req,
            );
            InsertCartResModel response = InsertCartResModel.fromJson(res);
            if (response.status == AppConstants.code_201) {
              if(_productId == '' && _supplierId == ''){
                add(const StoreEvent.setCartCountEvent());
              }
              _productId =  state.productStockList[state.productStockUpdateIndex].productId;
              _supplierId = state.productStockList[state.productStockUpdateIndex].productSupplierIds;

              Vibration.vibrate();
              // Navigator.pop(event.context);
             List<ProductStockModel> productStockList = state.productStockList.toList(growable: true);
              productStockList[state.productStockUpdateIndex]= productStockList[state.productStockUpdateIndex].copyWith(
                note: '',
                productIsInCart: true,
                quantity: state.productStockList[state.productStockUpdateIndex].quantity,
                productSupplierIds: state.productStockList[state.productStockUpdateIndex].productSupplierIds,
                totalPrice: productStockList[state.productStockUpdateIndex].totalPrice,
                productSaleId: '',
              );

              emit(state.copyWith(isLoading: false, productStockList: productStockList, isCartCountChange: false));
              CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.success);
            } else if (response.status == AppConstants.code_403) {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.failure);
            } else {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.failure);
            }
          } on ServerException {
            printData('url1 = ');
            emit(state.copyWith(isLoading: false));
          } catch (e) {
            printData('err = $e');
            emit(state.copyWith(isLoading: false));
          }
        }
      }
      else if (event is _setCartCountEvent) {
        SharedPreferencesHelper preferences = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());
        await preferences.setCartCount(count: preferences.getCartCount() + 1);
        emit(state.copyWith(isCartCountChange: true));

      }
      else if (event is _supplierSelectionEvent) {

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
                  quantity:  supplierList[event.supplierIndex].quantity != 0 ? supplierList[event.supplierIndex].quantity : 1,
                  maxQty: supplierList[event.supplierIndex].maxQty,
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
      else if (event is _globalSearchEvent) {
        emit(state.copyWith(search: state.searchController.text,bottlePrice: preferencesHelper.getBottleTax()));
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
          printData('store search list =${response.status}');
          if (response.status == AppConstants.code_200) {
            List<SearchModel> searchList = [];
           //category search result
            /*searchList.addAll(response.data?.categoryData
                    ?.map((category) => SearchModel(
                        searchId: category.id ?? '',
                        name: category.categoryName ?? '',
                        searchType: SearchTypes.category,
                isPesach: category.isPesach??false,
                        image: category.categoryImage ?? ''))
                    .toList() ??
                []);
            //subcategory search result
            searchList.addAll(response.data?.subCategoryData
                    ?.map((subCategory) => SearchModel(
                        searchId: subCategory.id ?? '',
                        name: subCategory.subCategoryName ?? '',
                        searchType: SearchTypes.subCategory,
                        image: '',
                        categoryId: subCategory.parentCategoryId ?? '',
                        categoryName: subCategory.parentCategoryName ?? '',
                isPesach: subCategory.isPesach??false
            ))
                    .toList() ??
                []);
            //company search result
            searchList.addAll(response.data?.companyData
                    ?.map((company) => SearchModel(
                        searchId: company.id ?? '',
                        name: company.brandName ?? '',
                        searchType: SearchTypes.company,
                        image: company.brandLogo ?? '',

            ))
                    .toList() ??
                []);
            // supplier search result
            searchList.addAll(response.data?.supplierData
                    ?.map((supplier) => SearchModel(
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
                    ?.map((sale) => SearchModel(
                        searchId: sale.id ?? '',
                        name: sale.productName ?? '',
                        searchType: SearchTypes.sale,
              numberOfUnits: int.parse(sale.numberOfUnit.toString()),
                        image: sale.mainImage ?? '',
                isPesach: sale.isPesach??false,
              salesDesc:  parse(sale.salesDescription ?? '')
                  .body
                  ?.text ??
                  '',

            ))
                    .toList() ??
                []);*/
            //supplier products result
            searchList.addAll(response.data
                    ?.map((supplier) => SearchModel(
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
            )).toList() ??
                []);
            emit(state.copyWith(
                searchList: searchList,
                search: state.searchController.text,
                isSearching: false));
          } else {
            emit(state.copyWith(isSearching: false));
          }
        } on ServerException {
       /*   CustomSnackBar.showSnackBar(
            context: event.context,
            title:
                AppLocalizations.of(event.context)!.something_is_wrong_try_again,
            type: SnackBarType.failure,
          );*/
          emit(state.copyWith(isSearching: false));
        } catch (exc) {
        /*  CustomSnackBar.showSnackBar(
            context: event.context,
            title:
                AppLocalizations.of(event.context)!.something_is_wrong_try_again,
            type: SnackBarType.failure,
          );*/
          emit(state.copyWith(isSearching: false));
        }
      }
      else if (event is _updateImageIndexEvent) {
        emit(state.copyWith(imageIndex: event.index));
      }
      else if (event is _updateGlobalSearchEvent) {
        emit(state.copyWith(
            searchController: TextEditingController(text: event.search),
            searchList: event.searchList));
      }

      else if (event is _resetGlobalSearchEvent) {
        List<SearchModel> searchList = [];
        searchList.addAll(state.productCategoryList.map((category) =>
            SearchModel(
                searchId: category.id ?? '',
                name: category.categoryName ?? '',
                searchType: SearchTypes.category,
                image: category.categoryImage ?? '')));
        emit(state.copyWith(
            searchList: searchList, searchController: TextEditingController()));
      }


          else  if (event is _getPreviousOrderProductsListEvent) {

            if(!preferencesHelper.getGuestUser()){
              try {
                emit(state.copyWith(isPreviousOrderShimmering: true));
                final res = await DioClient(event.context).post(
                  AppUrlEndPoints.getPreviousOrderProductsUrl,
                  data: const PreviousOrderProductsReqModel(
                      pageNum: 1, pageLimit: AppConstants.defaultPageLimit)
                      .toJson(),
                );
                PreviousOrderProductsResModel response =
                PreviousOrderProductsResModel.fromJson(res);

                if (response.status == AppConstants.code_200) {

                  List<ProductStockModel> productStockList =
                  state.productStockList.toList(growable: true);
                  ProductStockModel barcodeStock = productStockList.removeLast();
                  productStockList.addAll(response.previousProductData?.map(
                          (previousOrderProduct) => ProductStockModel(
                          productId: previousOrderProduct.id ?? '',
                          stock: previousOrderProduct.productStock.toString())) ??
                      []);
                  productStockList.add(barcodeStock);
                  emit(state.copyWith(
                      previousOrderProductsList: response.previousProductData ?? [],
                      productStockList: productStockList,
                      isPreviousOrderShimmering: false));

                } else {
                  emit(state.copyWith(isShimmering: false,isPreviousOrderShimmering:false));
                  CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(
                        response.message?.toLocalization() ??
                            response.message!,
                        event.context),
                    type: SnackBarType.failure,

                  );
                }
              } on ServerException {
                emit(state.copyWith(isShimmering: false,isPreviousOrderShimmering:false));
              } catch (exc) {
                emit(state.copyWith(isShimmering: false,isPreviousOrderShimmering:false));
              }
            }

            }

      else if(event is _relatedProductsEvent){
        if(event.productId != ''){
          emit(state.copyWith(isRelatedShimmering:true));
          final res = await DioClient(event.context).post(
              AppUrlEndPoints.relatedProductsUrl,
              data: {AppStrings.mainProductIdString:event.productId});
          RelatedProductResModel response =
          RelatedProductResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            List<ProductStockModel> productStockList =
            state.productStockList.toList(growable: true);
            productStockList.addAll(response.data?.map(
                    (product) =>
                    ProductStockModel(
                      productId: product.id ?? '' ,
                      stock: (product.productStock.toString()),
                    )) ?? []);

            emit(state.copyWith(
                relatedProductList:response.data ?? [], isProductLoading: false,
                isRelatedShimmering: false,productStockList: productStockList));
          } else {
            emit(state.copyWith(isRelatedShimmering: false,isProductLoading: false,));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(
                  response.message?.toLocalization() ?? '',
                  event.context),
              type: SnackBarType.success,
            );
          }
        }
      }
      else if(event is _removeRelatedProductEvent){
        emit(state.copyWith(relatedProductList: []));
      }
      else if(event is _updateMaintenanceEvent){
        emit(state.copyWith(isDialogOpen: true));
      }
      else if(event is _generalSettings){
        try {
          emit(state.copyWith(pesachBannerShimmering: true,retryLoading: event.isRetryLoading));

          final res = await DioClient(event.context).get(path: AppUrlEndPoints.generalSettingUrl);
          SettingResModel response = SettingResModel.fromJson(res);
          preferencesHelper.setBankTransferDetail(details: response.data?.taviliRivchitDetails?.bankTransferInfoText??'');
          if (response.status == AppConstants.code_200) {
            if(preferencesHelper.getAppOnMaintenance() &&  !(response.data?.isAppOnMaintenance??false)){
              add(StoreEvent.updateMaintenanceEvent(context: event.context));
              Navigator.pop(event.dialogContext);
              preferencesHelper.setIsAppOnMaintenance(isAppOnMaintenance: false);
              emit(state.copyWith(isDialogOpen: false,isAppOnMaintenance: false,retryLoading: false));
              return;
            }else{
              if(!state.isDialogOpen && !(response.data?.isAppOnMaintenance??false)  ){
                emit(state.copyWith(isDialogOpen: true));
              }else{
                emit(state.copyWith(isDialogOpen: false));
              }
            }
            preferencesHelper.setIsSaleOn(isSaleOn:  response.data?.isSaleOn ?? false);
            preferencesHelper.setIsIncludedVat(isIncludedVat:
            (response.data?.showVatApplication?.contains(AppStrings.appName) ?? false) ? true : false);
            preferencesHelper.setBottleTax(bottleDeposit: response.data?.bottlePrice ?? 0.0);
            preferencesHelper.setIsAppOnMaintenance(isAppOnMaintenance: response.data?.isAppOnMaintenance??false);

            emit(state.copyWith(
                language: preferencesHelper.getAppLanguage(),
                pesachBannerShimmering:false,
                pesachBannerURL:response.data?.pesachBanner ?? '',
                showPesachBanner: response.data?.isShowPesachBanner ?? false,
                bottlePrice:response.data?.bottlePrice ?? 0.0,
                isIncludedVat: preferencesHelper.getIsIncludedVat(),
                isSaleOn: preferencesHelper.getShowSale(),
                retryLoading: false,
                isAppOnMaintenance: preferencesHelper.getAppOnMaintenance()
            ));
          } else {
            emit(state.copyWith(pesachBannerShimmering: false, retryLoading:false));
          }
        } on ServerException {
          emit(state.copyWith(pesachBannerShimmering: false,retryLoading:false));
        } catch (e) {
          emit(state.copyWith(pesachBannerShimmering: false,retryLoading:false));
          CustomSnackBar.showSnackBar(
              context: event.context,
              title: e.toString(),
              type: SnackBarType.failure);
        }
      }

      else  if(event is _getPermissionList){

          if (preferencesHelper.getSubUser()) {
            try {
              final res = await DioClient(event.context).get(
                  path: '${AppUrlEndPoints.getAccountPermissionUrl}${preferencesHelper
                      .getSubUserId()}');
              AccountPermissionResModel response = AccountPermissionResModel
                  .fromJson(res);

              if (response.status == AppConstants.code_200) {
                var res = response.data?.permissions;
                if (preferencesHelper.getAppLanguage() ==
                    AppStrings.englishString &&
                    preferencesHelper.getCanSeeWallet() != res?.canSeeWallet) {
                  event.context.read<BottomNavBloc>().add(
                      BottomNavEvent.changePage(
                          index: 1, context: event.context));
                }
                preferencesHelper.setCanSeeWallet(
                    isSeeWallet: res?.canSeeWallet ?? false);
                emit(state.copyWith(isAccountPermissionShimmering: true));
                preferencesHelper.setCanAddBasket(
                    isAddBasket: res?.canAddToCart ?? false);
                preferencesHelper.setCanCreateOrder(
                    isCreateOrder: res?.canCreateOrder ?? false);
                preferencesHelper.setCanSeeOrder(
                    isSeeOrder: res?.canSeeOrders ?? false);
                preferencesHelper.setCanDuplicateOrder(
                    isDuplicateOrder: res?.canDuplicateOrders ?? false);
                preferencesHelper.setCanUpdateBusinessInfo(
                    isUpdateBusinessInfo: res?.canSeeAndUpdateBusinessInfo ??
                        false);
                preferencesHelper.setCanUpdateAdditionalInfo(
                    isUpdateAdditionalInfo: res
                        ?.canSeeAndUpdateAdditionalInfo ?? false);
                preferencesHelper.setCanUpdateTimeInfo(
                    isUpdateTimeInfo: res?.canSeeAndUpdateTimesInfo ?? false);
                preferencesHelper.setCanSeeFormsFiles(
                    isSeeFormsFiles: res?.canSeeFileAndForms ?? false);
                preferencesHelper.setManageSubUser(
                    isManageSubUser: res?.canManageSubUsers ?? false);
                emit(state.copyWith(isAccountPermissionShimmering: false,
                    isSubUserAddToBasket: preferencesHelper.getCanAddToBasket()
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

      else if(event is _userApproveEvent){
        if(!preferencesHelper.getGuestUser()) {
          try {

            final res = await DioClient(event.context).post(
                AppUrlEndPoints.verifyClientUrl,
                data: {AppStrings.clientIdString: preferencesHelper.getUserId()}
            );
            VerifyClientResModel response = VerifyClientResModel.fromJson(res);

            if (response.status == AppConstants.code_200) {
              if (!(response.data?.isFilledForms ?? false) ||
                  !(response.data?.isRegisterForm ?? false)) {
                Navigator.pushNamed(
                    event.context, RouteDefine.formDataScreen.name);
              }
              else if (!(response.data?.isUploadedFiles ?? false) &&
                  (response.data?.isRegisterForm ?? false) &&
                  (response.data?.isFilledForms ?? false)) {
                Navigator.pushNamed(
                    event.context, RouteDefine.fileUploadScreen.name);
              }
            }
          }
          catch (e) {
            printData('catch____$e');
          }
        }
      }

    });
  }
}
