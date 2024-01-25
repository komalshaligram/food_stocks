import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/error/exceptions.dart';
import 'package:food_stock/data/model/req_model/planogram_req_model/planogram_req_model.dart';
import 'package:food_stock/data/model/req_model/product_subcategories_req_model/product_subcategories_req_model.dart';
import 'package:food_stock/data/model/res_model/planogram_res_model/planogram_res_model.dart';
import 'package:food_stock/data/model/res_model/product_subcategories_res_model/product_subcategories_res_model.dart';
import 'package:food_stock/repository/dio_client.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
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
import '../../data/model/req_model/product_categories_req_model/product_categories_req_model.dart';
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/req_model/update_cart/update_cart_req_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/get_planogram_by_id/get_planogram_by_id_model.dart';
import '../../data/model/res_model/get_planogram_product/get_planogram_product_model.dart';
import '../../data/model/res_model/global_search_res_model/global_search_res_model.dart';
import '../../data/model/res_model/insert_cart_res_model/insert_cart_res_model.dart';
import '../../data/model/res_model/product_categories_res_model/product_categories_res_model.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';
import '../../data/model/res_model/update_cart_res/update_cart_res_model.dart';
import '../../data/model/search_model/search_model.dart';
import '../../data/model/supplier_sale_model/supplier_sale_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'store_category_event.dart';

part 'store_category_state.dart';

part 'store_category_bloc.freezed.dart';

class StoreCategoryBloc extends Bloc<StoreCategoryEvent, StoreCategoryState> {
  bool _isProductInCart = false;
  String _cartProductId = '';
  int _productQuantity = 0;
  String isSubCategoryString = '';
 String categoryId = '';
 String parentCategoryId = '';
  StoreCategoryBloc() : super(StoreCategoryState.initial()) {
    on<StoreCategoryEvent>((event, emit) async {

      if (event is _isCategoryEvent) {
        emit(state.copyWith(isSubCategory: event.isSubCategory));
      }
      if (event is _ChangeCategoryExpansionEvent) {
        print('event.isOpened123___${event.isOpened}');
        if (event.isOpened != null) {
          emit(state.copyWith(isCategoryExpand: event.isOpened ?? false,isBottomOfPlanoGrams: false,isBottomOfSubCategory : false,planoGramsList : []));
          print('state.categoryPlanogramList___${state.categoryPlanogramList}');
        } else {
          emit(state.copyWith(isCategoryExpand: !state.isCategoryExpand,isBottomOfPlanoGrams: false,isBottomOfSubCategory : false,planoGramsList : []));
          print('state.categoryPlanogramList_qww__${state.categoryPlanogramList}');

        }
      }
      else if (event is _ChangeSubCategoryOrPlanogramEvent) {
        emit(state.copyWith(isSubCategory: event.isSubCategory));
        if(categoryId != ''){
          add(StoreCategoryEvent.changeCategoryDetailsEvent(context:event.context , isSubCategory: 'true', categoryName: '' ,categoryId: parentCategoryId));
        }
      } else if (event is _ChangeCategoryDetailsEvent) {
        emit(state.copyWith(
            isSubCategory: state.isSubCategory,
           categoryId: event.categoryId ,
            categoryName: event.categoryName,
            subCategoryList: [],
            planoGramsList : [],
            subCategoryPageNum: 0,
            planogramPageNum : 0,
            isBottomOfSubCategory: false,
            isBottomOfPlanoGrams: false,
            productStockList: [
              [ProductStockModel(productId: '')]
            ]));
        if(event.isSubCategory == ''){
          add(StoreCategoryEvent.getPlanoGramProductsEvent(context: event.context));

        }
        else{
          print('state.isSubCategory_____${state.isSubCategory}');
          isSubCategoryString = event.isSubCategory;
          categoryId = event.categoryId;
          add(StoreCategoryEvent.getPlanogramByIdEvent(context: event.context));
        }
      }
      else if (event is _GetProductCategoriesListEvent) {
        try {
          emit(state.copyWith(isSearching: true));
          final res = await DioClient(event.context).post(
              AppUrls.getProductCategoriesUrl,
              data: ProductCategoriesReqModel(
                      pageNum: 1, pageLimit: AppConstants.searchPageLimit)
                  .toJson());
          ProductCategoriesResModel response =
              ProductCategoriesResModel.fromJson(res);
          debugPrint('product categories = ${response.data?.categories}');
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
            emit(state.copyWith(
                productCategoryList: response.data?.categories ?? [],
                searchList: searchList,
                isSearching: false));
          } else {
            emit(state.copyWith(isSearching: false));
          }
        } on ServerException {
          emit(state.copyWith(isSearching: false));
        } catch (exc) {
          emit(state.copyWith(isSearching: false));
        }
      }
      else if (event is _ChangeSubCategoryDetailsEvent) {
        debugPrint(
            'sub category ${event.subCategoryId}(${event.subCategoryName})');
        if (event.subCategoryId != state.subCategoryId) {
          emit(state.copyWith(
            subCategoryId: event.subCategoryId,
            subCategoryName: event.subCategoryName,
            planoGramsList: [],
            productStockList: [
              [ProductStockModel(productId: '')]
            ],
            productStockUpdateIndex: -1,
            planoGramUpdateIndex: -1,
            planogramPageNum: 0,
            isBottomOfPlanoGrams: false,
          ));
          add(StoreCategoryEvent.getPlanoGramProductsEvent(context: event.context));
        }
        emit(state.copyWith(isSubCategory: false));
      }
      else if (event is _GetSubCategoryListEvent) {
        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfSubCategory) {
          return;
        }
        try {
          emit(state.copyWith(
              isSubCategoryShimmering:
                  state.subCategoryPageNum == 0 ? true : false,
              isLoadMore: state.subCategoryPageNum == 0 ? false : true));
          final res = await DioClient(event.context).post(
              AppUrls.getSubCategoriesUrl,
              data: ProductSubcategoriesReqModel(
                      parentCategoryId: state.categoryId,
                      pageNum: state.subCategoryPageNum + 1,
                      pageLimit: AppConstants.productSubCategoryPageLimit)
                  .toJson());
          ProductSubcategoriesResModel response =
              ProductSubcategoriesResModel.fromJson(res);
          if (response.status == 200) {

            List<SubCategory> subCategoryList =
                state.subCategoryList.toList(growable: true);
            subCategoryList.addAll(response.data?.subCategories ?? []);
            debugPrint('new sub category List = ${subCategoryList.length}');
            emit(state.copyWith(
              subCategoryList: subCategoryList,
              subCategoryPageNum: state.subCategoryPageNum + 1,
              isSubCategoryShimmering: false,
              isLoadMore: false,
            categoryName: response.data?.subCategories?[0].parentCategoryName ?? ''
            ));
            emit(state.copyWith(
                isBottomOfSubCategory:
                    subCategoryList.length == (response.data?.totalRecords ?? 0)
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
        state.subCategoryRefreshController.refreshCompleted();
        state.subCategoryRefreshController.loadComplete();
      }
      else if (event is _SubCategoryRefreshListEvent) {
        emit(state.copyWith(
            subCategoryPageNum: 0,
            subCategoryList: [],
            isBottomOfSubCategory: false));
        add(StoreCategoryEvent.getPlanoGramProductsEvent(context: event.context));

      }
      else if (event is _GetPlanoGramProductsEvent) {
        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfPlanoGrams) {
          return;
        }
        try {
          emit(state.copyWith(
              isPlanogramShimmering: state.planogramPageNum == 0 ? true : false,
              isLoadMore: state.planogramPageNum == 0 ? false : true));
          PlanogramReqModel planogramReqModel =  isSubCategoryString == '' && !state.isSubCategory  ? PlanogramReqModel(
              pageNum: state.planogramPageNum + 1,
              pageLimit: AppConstants.planogramProductPageLimit,
              sortOrder: AppStrings.ascendingString,
              sortField: AppStrings.planogramSortFieldString,
              categoryId: state.categoryId ,
              subCategoryId: state.subCategoryId
          ): state.isSubCategory && isSubCategoryString == ''? PlanogramReqModel(
              pageNum: state.planogramPageNum + 1,
             pageLimit: AppConstants.planogramProductPageLimit,
              sortOrder: AppStrings.ascendingString,
             sortField: AppStrings.planogramSortFieldString,
              categoryId: state.categoryId
          )  : PlanogramReqModel(
              pageNum: state.planogramPageNum + 1,
              pageLimit: AppConstants.planogramProductPageLimit,
              sortOrder: AppStrings.ascendingString,
              sortField: AppStrings.planogramSortFieldString,
              id: categoryId
          ) ;

          Map<String, dynamic> req = planogramReqModel.toJson();
          req.removeWhere((key, value) {
            if (value != null) {
              debugPrint("[$key] = $value");
            }
            return value == null;
          });
          debugPrint('sub category req = $req');
          final res = await DioClient(event.context)
              .post(AppUrls.getPlanogramProductsUrl, data: req);
          PlanogramResModel response = PlanogramResModel.fromJson(res);

          if (response.status == 200) {
            if(state.isSubCategory){
              add(StoreCategoryEvent.getSubCategoryListEvent(context: event.context));
            }
            else{
              add(StoreCategoryEvent.getPlanogramAllProductEvent(context: event.context));
            }
            emit(state.copyWith(categoryPlanogramList: []));
            List<PlanogramDatum> planoGramsList =
                state.planoGramsList.toList(growable: true);
            List<Planogramproduct> categoryPlanogramList =
            state.categoryPlanogramList.toList(growable: true);
            planoGramsList.addAll(response.data ?? []);
            List<List<ProductStockModel>> productStockList =
                state.productStockList.toList(growable: true);
            List<ProductStockModel> barcodeStock =
                productStockList.removeLast();
            for (int i = 0; i < (response.data?.length ?? 0); i++) {
              List<ProductStockModel> stockList = [];
              stockList.addAll(response.data![i].planogramproducts?.map(
                      (product) => ProductStockModel(
                          productId: product.id ?? '',
                          stock: product.productStock ?? 0)) ??
                  []);
              // debugPrint('stockList[$i] = $stockList');
              productStockList.addAll([stockList]);
            }
            productStockList.add(barcodeStock);
            // productStockList.add(barcodeStock.isNotEmpty ? barcodeStock : [ProductStockModel(productId: '')]);
            debugPrint('planogram list = ${planoGramsList.length}');
            debugPrint('planogram stock list = ${productStockList.length}');
            if((response.data?.length ?? 0) > 0){
              categoryPlanogramList.addAll(response.data?[0].planogramproducts ?? []);
            }

            emit(state.copyWith(
                planoGramsList: planoGramsList,
                productStockList: productStockList,
                planogramPageNum: state.planogramPageNum + 1,
                isPlanogramShimmering: false,
                isLoadMore: false,


            ));
            emit(state.copyWith(
                isBottomOfPlanoGrams: planoGramsList.length ==
                    (response.metaData?.totalFilteredCount ?? 0)
                    ? true
                    : false));
          } else {
            emit(state.copyWith(isLoadMore: false));
           /* CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                type: SnackBarType.FAILURE);*/
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
        state.planogramRefreshController.refreshCompleted();
        state.planogramRefreshController.loadComplete();
      }
      else if (event is _PlanogramRefreshListEvent) {
        emit(state.copyWith(
            planogramPageNum: 0,
            planoGramsList: [],
            productStockList: [
              [ProductStockModel(productId: '')]
            ],
            isBottomOfPlanoGrams: false));
        add(StoreCategoryEvent.getPlanoGramProductsEvent(
            context: event.context));
        add(StoreCategoryEvent.getPlanogramAllProductEvent(context: event.context));

      }
      else if (event is _GetProductDetailsEvent) {
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
            // 0 planogram
            //1 product
            //2 barcode
            List<List<ProductStockModel>> productStockList =
                state.productStockList.toList(growable: true);
            int planoGramIndex = event.planoGramIndex;
            int productStockUpdateIndex = state.productStockList[planoGramIndex]
                .indexWhere((productStock) =>
                    productStock.productId == event.productId);
            if (productStockUpdateIndex == -1 && (event.isBarcode ?? false)) {
              List<List<ProductStockModel>> productStockList =
                  state.productStockList.toList(growable: false);
              productStockList[productStockList.indexOf(productStockList.last)]
                  [0] = productStockList[
                      productStockList.indexOf(productStockList.last)][0]
                  .copyWith(
                quantity: 1,
                      productId: response.product?.first.id ??
                          '' /*,
                  stock: response.product?.first.numberOfUnit ?? 0*/
                      );
              emit(state.copyWith(productStockList: productStockList));
              debugPrint('new index = ${state.productStockList.last}');
              productStockUpdateIndex = 0;
              planoGramIndex = productStockList.indexOf(productStockList.last);
              /*productStockList[planoGramIndex].indexOf(productStockList[planoGramIndex].last);*/
              debugPrint(
                  'new index = ${planoGramIndex},$productStockUpdateIndex');
            }
            // productStockList[planoGramIndex][productStockUpdateIndex] =
            //     productStockList[planoGramIndex][productStockUpdateIndex]
            //         .copyWith(stock: response.product?.first.numberOfUnit ?? 0);
            debugPrint(
                'stock ${productStockList[planoGramIndex][productStockUpdateIndex].stock}');
            debugPrint(
                'supplier list stock = ${response.product?.first.supplierSales?.map((e) => e.productStock)}');
            List<ProductSupplierModel> supplierList = [];
            debugPrint(
                'supplier id = ${state.productStockList[planoGramIndex][productStockUpdateIndex].productSupplierIds}');
            supplierList.addAll(response.product?.first.supplierSales
                    ?.map((supplier) => ProductSupplierModel(
                          supplierId: supplier.supplierId ?? '',
                          companyName: supplier.supplierCompanyName ?? '',
                          basePrice:
                              double.parse(supplier.productPrice ?? '0.0'),
                          stock: int.parse(supplier.productStock ?? '0'),
                          selectedIndex: (supplier.supplierId ?? '') ==
                                  state
                                      .productStockList[planoGramIndex]
                                          [productStockUpdateIndex]
                                      .productSupplierIds
                              ? supplier.saleProduct?.indexOf(
                                          supplier.saleProduct?.firstWhere(
                                                (sale) =>
                                                    sale.saleId ==
                                                    state
                                                        .productStockList[
                                                            planoGramIndex][
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
                                                            planoGramIndex][
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
                        planoGramIndex
                    ? ''
                    : productStockList[planoGramIndex][0].note;
            emit(state.copyWith(productStockList: []));

            emit(state.copyWith(
                productDetails: response.product ?? [],
                productStockList: productStockList,
                productStockUpdateIndex: productStockUpdateIndex,
                noteController: TextEditingController(text: note),
                productSupplierList: supplierList,
                planoGramUpdateIndex: planoGramIndex,
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
                add(StoreCategoryEvent.supplierSelectionEvent(
                    supplierIndex: supplierIndex,
                    context: event.context,
                    supplierSaleIndex: supplierSaleIndex));
              }
            }
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
                response.data?.data?.forEach((cartProduct) {
                  if (cartProduct.id ==
                      state
                          .productStockList[state.planoGramUpdateIndex]
                              [state.productStockUpdateIndex]
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
        } catch (e) {
          debugPrint('bs error = $e');
          // Navigator.pop(event.context);
        }
      }
      else if (event is _IncreaseQuantityOfProduct) {
        List<List<ProductStockModel>> productStockList =
            state.productStockList.toList(growable: false);
        if (state.productStockUpdateIndex != -1) {
          if (productStockList[state.planoGramUpdateIndex]
                      [state.productStockUpdateIndex]
                  .quantity <
              productStockList[state.planoGramUpdateIndex]
                      [state.productStockUpdateIndex]
                  .stock) {
            if (productStockList[state.planoGramUpdateIndex]
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
            productStockList[state.planoGramUpdateIndex]
                    [state.productStockUpdateIndex] =
                productStockList[state.planoGramUpdateIndex]
                        [state.productStockUpdateIndex]
                    .copyWith(
                        quantity: productStockList[state.planoGramUpdateIndex]
                                    [state.productStockUpdateIndex]
                                .quantity +
                            1);
            debugPrint(
                'product quantity = ${productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].quantity}');
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          } else {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
                // '${AppLocalizations.of(event.context)!.you_have_reached_maximum_quantity}',
                type: SnackBarType.FAILURE);
          }
        }
      }
      else if (event is _DecreaseQuantityOfProduct) {
        List<List<ProductStockModel>> productStockList =
            state.productStockList.toList(growable: false);
        if (state.productStockUpdateIndex != -1) {
          if (productStockList[state.planoGramUpdateIndex]
                      [state.productStockUpdateIndex]
                  .quantity >
              0) {
            productStockList[state.planoGramUpdateIndex]
                    [state.productStockUpdateIndex] =
                productStockList[state.planoGramUpdateIndex]
                        [state.productStockUpdateIndex]
                    .copyWith(
                        quantity: productStockList[state.planoGramUpdateIndex]
                                    [state.productStockUpdateIndex]
                                .quantity -
                            1);
            debugPrint(
                'product quantity = ${productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].quantity}');
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
              productStockList[state.planoGramUpdateIndex]
                      [state.productStockUpdateIndex]
                  .stock) {
            productStockList[state.planoGramUpdateIndex]
                    [state.productStockUpdateIndex] =
                productStockList[state.planoGramUpdateIndex]
                        [state.productStockUpdateIndex]
                    .copyWith(quantity: newQuantity);
            debugPrint(
                'product quantity update = ${productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].quantity}');
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          } else {
            productStockList[state.planoGramUpdateIndex]
                    [state.productStockUpdateIndex] =
                productStockList[state.planoGramUpdateIndex]
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
                    "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
                type: SnackBarType.FAILURE);
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          }
        }
      }
      else if (event is _ChangeNoteOfProduct) {
        if (state.productStockUpdateIndex != -1) {
          List<List<ProductStockModel>> productStockList =
              state.productStockList.toList(growable: false);
          productStockList[state.planoGramUpdateIndex]
                  [state.productStockUpdateIndex] =
              productStockList[state.planoGramUpdateIndex]
                      [state.productStockUpdateIndex]
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
        List<ProductSupplierModel> supplierList =
            state.productSupplierList.toList(growable: true);
        List<List<ProductStockModel>> productStockList =
            state.productStockList.toList(growable: true);
        productStockList[state.planoGramUpdateIndex]
                [state.productStockUpdateIndex] =
            productStockList[state.planoGramUpdateIndex]
                    [state.productStockUpdateIndex]
                .copyWith(
                    productSupplierIds:
                        supplierList[event.supplierIndex].supplierId,
                    stock: supplierList[event.supplierIndex].stock,
                    quantity: 1,
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
            'stock supplier id = ${productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].productSupplierIds}');
        debugPrint(
            'stock supplier sale id = ${productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].productSaleId}');
        supplierList = supplierList
            .map((supplier) => supplier.copyWith(selectedIndex: -1))
            .toList();
        supplierList[event.supplierIndex] = supplierList[event.supplierIndex]
            .copyWith(
                selectedIndex:
                    supplierList[event.supplierIndex].selectedIndex ==
                            event.supplierSaleIndex
                        ? -1
                        : event.supplierSaleIndex);
        debugPrint(
            'supplier[${event.supplierIndex}] = ${supplierList[event.supplierIndex].selectedIndex}');
        emit(state.copyWith(
            productSupplierList: supplierList,
            productStockList: productStockList));
      }
      else if (event is _AddToCartProductEvent) {
        if (state
            .productStockList[state.planoGramUpdateIndex]
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
        if (state
                .productStockList[state.planoGramUpdateIndex]
                    [state.productStockUpdateIndex]
                .quantity ==
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
              productId: state
                  .productStockList[state.planoGramUpdateIndex]
                      [state.productStockUpdateIndex]
                  .productId,
              supplierId: state
                  .productStockList[state.planoGramUpdateIndex]
                      [state.productStockUpdateIndex]
                  .productSupplierIds,
              saleId: state
                          .productStockList[state.planoGramUpdateIndex]
                              [state.productStockUpdateIndex]
                          .productSaleId ==
                      ''
                  ? null
                  : state
                      .productStockList[state.planoGramUpdateIndex]
                          [state.productStockUpdateIndex]
                      .productSaleId,
              quantity: state
                      .productStockList[state.planoGramUpdateIndex]
                          [state.productStockUpdateIndex]
                      .quantity +
                  _productQuantity,
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
              emit(state.copyWith(isLoading: false));
              Navigator.pop(event.context);
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
          try {
            emit(state.copyWith(isLoading: true));
            InsertCartModel.InsertCartReqModel insertCartReqModel =
                InsertCartModel.InsertCartReqModel(products: [
              InsertCartModel.Product(
                  productId: state
                      .productStockList[state.planoGramUpdateIndex]
                          [state.productStockUpdateIndex]
                      .productId,
                  quantity: state
                      .productStockList[state.planoGramUpdateIndex]
                          [state.productStockUpdateIndex]
                      .quantity,
                  supplierId: state
                      .productStockList[state.planoGramUpdateIndex]
                          [state.productStockUpdateIndex]
                      .productSupplierIds,
                  note: state
                          .productStockList[state.planoGramUpdateIndex]
                              [state.productStockUpdateIndex]
                          .note
                          .isEmpty
                      ? null
                      : state
                          .productStockList[state.planoGramUpdateIndex]
                              [state.productStockUpdateIndex]
                          .note,
                  saleId: state
                          .productStockList[state.planoGramUpdateIndex]
                              [state.productStockUpdateIndex]
                          .productSaleId
                          .isEmpty
                      ? null
                      : state
                          .productStockList[state.planoGramUpdateIndex]
                              [state.productStockUpdateIndex]
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
              List<List<ProductStockModel>> productStockList =
                  state.productStockList.toList(growable: true);
              productStockList[state.planoGramUpdateIndex]
                      [state.productStockUpdateIndex] =
                  productStockList[state.planoGramUpdateIndex]
                          [state.productStockUpdateIndex]
                      .copyWith(
                note: '',
                isNoteOpen: false,
                // quantity: 0,
                // productSupplierIds: '',
                // totalPrice: 0.0,
                // productSaleId: '',
              );
              add(StoreCategoryEvent.setCartCountEvent());
              emit(state.copyWith(
                  isLoading: false, productStockList: productStockList));
              Navigator.pop(event.context);
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  /*  title: response.message ??
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
      }
      else if (event is _SetCartCountEvent) {
        SharedPreferencesHelper preferences = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());
        await preferences.setCartCount(count: preferences.getCartCount() + 1);
        await preferences.setIsAnimation(isAnimation: true);
        debugPrint('cart count = ${preferences.getCartCount()}');
      }
      else if (event is _GlobalSearchEvent) {
        emit(state.copyWith(search: state.searchController.text));
        debugPrint('data1 = ${state.search}');
        try {
          GlobalSearchReqModel globalSearchReqModel =
              GlobalSearchReqModel(search: state.search);
          emit(state.copyWith(isSearching: true));
          final res = await DioClient(event.context).post(
              AppUrls.getGlobalSearchResultUrl,
              data: globalSearchReqModel.toJson());
          GlobalSearchResModel response = GlobalSearchResModel.fromJson(res);
          if (state.searchController.text.length == 0) {
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
          if (response.status == 200) {
            List<SearchModel> searchList = [];
            //category search result
            searchList.addAll(response.data?.categoryData
                    ?.map((category) => SearchModel(
                        searchId: category.id ?? '',
                        name: category.categoryName ?? '',
                        searchType: SearchTypes.category,
                        image: category.categoryImage ?? ''))
                    .toList() ??
                []);
            //company search result
            searchList.addAll(response.data?.companyData
                    ?.map((company) => SearchModel(
                        searchId: company.id ?? '',
                        name: company.brandName ?? '',
                        searchType: SearchTypes.company,
                        image: company.brandLogo ?? ''))
                    .toList() ??
                []);
            // supplier search result
            searchList.addAll(response.data?.supplierData
                    ?.map((supplier) => SearchModel(
                        searchId: supplier.id ?? '',
                        name: supplier.supplierDetail?.companyName ?? '',
                        searchType: SearchTypes.supplier,
                        image: supplier.logo ?? ''))
                    .toList() ??
                []);
            //sale search result
            searchList.addAll(response.data?.saleData
                    ?.map((sale) => SearchModel(
                        searchId: sale.id ?? '',
                        name: sale.productName ?? '',
                        searchType: SearchTypes.sale,
                        image: sale.mainImage ?? ''))
                    .toList() ??
                []);
            //supplier products result
            searchList.addAll(response.data?.supplierProductData
                    ?.map((supplier) => SearchModel(
                        searchId: supplier.productId ?? '',
                        name: supplier.productName ?? '',
                        searchType: SearchTypes.product,
                        image: supplier.mainImage ?? ''))
                    .toList() ??
                []);
            debugPrint('store cat search list = ${searchList.length}');
            emit(state.copyWith(
                searchList: searchList,
                // previousSearch: state.searchController.text,
                isSearching: false));
          } else {
            // emit(state.copyWith(searchList: []));
            emit(state.copyWith(isSearching: false));
            // CustomSnackBar.showSnackBar(
            //     context: event.context,
            //     title: response.message ?? '${AppLocalizations.of(event.context)!.something_is_wrong_try_again}',
            //     type: SnackBarType.SUCCESS);
          }
        } on ServerException {
          emit(state.copyWith(isSearching: false));
        } catch (e) {
          emit(state.copyWith(isSearching: false));
        }
      }
      else if (event is _UpdateImageIndexEvent) {
        emit(state.copyWith(imageIndex: event.index));
      }
      else if (event is _UpdateGlobalSearchEvent) {
        emit(state.copyWith(
            searchController: TextEditingController(text: event.search),
            searchList: event.searchList));
        if (state.searchController.text == '') {
          add(StoreCategoryEvent.getProductCategoriesListEvent(
              context: event.context));
        }
      }
      else if (event is _ToggleNoteEvent) {
        List<List<ProductStockModel>> productStockList =
            state.productStockList.toList(growable: true);
        if (event.isBarcode) {
          debugPrint(
              'toggled,${productStockList.indexOf(productStockList.last)}');
          productStockList[productStockList.indexOf(productStockList.last)][0] =
              productStockList[productStockList.indexOf(productStockList.last)]
                      [0]
                  .copyWith(
                      isNoteOpen: !productStockList[productStockList
                              .indexOf(productStockList.last)][0]
                          .isNoteOpen);
        } else {
          debugPrint(
              'toggled,${state.planoGramUpdateIndex},${state.productStockUpdateIndex}');
          productStockList[state.planoGramUpdateIndex]
                  [state.productStockUpdateIndex] =
              productStockList[state.planoGramUpdateIndex]
                      [state.productStockUpdateIndex]
                  .copyWith(
                      isNoteOpen: !productStockList[state.planoGramUpdateIndex]
                              [state.productStockUpdateIndex]
                          .isNoteOpen);
        }
        emit(state.copyWith(productStockList: []));
        emit(state.copyWith(productStockList: productStockList));
      }

      else if(event is _getPlanogramByIdEvent){
        try {
          final res = await DioClient(event.context)
              .get(path: '${AppUrls.getPlanoramByIdUrl}${categoryId}');


          debugPrint('url_____${AppUrls.getPlanoramByIdUrl}${categoryId}');

          GetPlanogramByIdModel response = GetPlanogramByIdModel.fromJson(res);

          if (response.status == 200) {
            add(StoreCategoryEvent.getPlanoGramProductsEvent(context: event.context));
            add(StoreCategoryEvent.getPlanogramAllProductEvent(context: event.context));
            parentCategoryId = response.data?.planogram?.categoryId ?? '';
            emit(state.copyWith(
                categoryName : response.data?.planogram?.categoryName ?? '',
                subCategoryName : response.data?.planogram?.subCategoryName ?? '',
              categoryId: response.data?.planogram?.categoryId ?? '',
              subCategoryId: response.data?.planogram?.subCategoryId ?? ''
            ));
          } else {
            emit(state.copyWith(isLoadMore: false));
            /*CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                type: SnackBarType.FAILURE);*/
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }

      }

      else if(event is _getPlanogramAllProductEvent){
        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfPlanoGrams) {
          return;
        }
        try{
          List<PlanogramAllProduct> planogramProductList =
          state.planogramProductList.toList(growable: true);

          PlanogramReqModel planogramReqModel =  PlanogramReqModel(
            categoryId : state.categoryId,
            subCategoryId: state.subCategoryId,
          );

          final res = await DioClient(event.context)
              .post('${AppUrls.getPlanogramAllProductUrl}',
          data: planogramReqModel
          );

          debugPrint('getPlanogramAllProductUrl_____${AppUrls.getPlanogramAllProductUrl}');
          debugPrint('req_____${planogramReqModel}');
          GetPlanogramProductModel response = GetPlanogramProductModel.fromJson(res);
          debugPrint('getPlanogramAllProduct response_____${response}');

          if(response.status == 200){
            List<List<ProductStockModel>> productStockList =
            state.productStockList.toList(growable: true);
            List<ProductStockModel> barcodeStock =
            productStockList.removeLast();
            for (int i = 0; i < (response.data?.length ?? 0); i++) {
              List<ProductStockModel> stockList = [];
              stockList.addAll(response.data?.map(
                      (product) => ProductStockModel(
                      productId: product.id ?? '',
                      stock: int.parse(product.numberOfUnit  ?? '0') )) ??
                  []);
              // debugPrint('stockList[$i] = $stockList');
              productStockList.addAll([stockList]);
            }
            productStockList.add(barcodeStock);
           planogramProductList.addAll(response.data ?? []);
            emit(state.copyWith(planogramProductList: planogramProductList,productStockList: productStockList ));
            emit(state.copyWith(
                isBottomOfPlanoGrams: planogramProductList.length ==
                    (response.metaData?.totalFilteredCount ?? 0)
                    ? true
                    : false));
          }
          else{
            emit(state.copyWith(isLoadMore: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                type: SnackBarType.FAILURE);
          }
        }
        on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
        catch(e){
          emit(state.copyWith(isLoadMore: false));
        }

      }



    });
  }
}
