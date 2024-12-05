
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/planogram_req_model/planogram_req_model.dart';
import '../../data/model/req_model/product_subcategories_req_model/product_subcategories_req_model.dart';
import '../../data/model/res_model/planogram_res_model/planogram_res_model.dart';
import '../../data/model/res_model/product_subcategories_res_model/product_subcategories_res_model.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../../data/model/req_model/get_sub_categories_product/get_sub_categories_product_req_model.dart';
import '../../data/model/req_model/global_search_req_model/global_search_req_model.dart';
import '../../data/model/req_model/insert_cart_req_model/insert_cart_req_model.dart'
as InsertCartModel;
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/req_model/update_cart/update_cart_req_model.dart';
import '../../data/model/res_model/account_permission/account_permission_res_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/get_planogram_by_id/get_planogram_by_id_model.dart';
import '../../data/model/res_model/get_planogram_product/get_planogram_product_model.dart';
import '../../data/model/res_model/global_search_res_model/global_search_res_model.dart';
import '../../data/model/res_model/insert_cart_res_model/insert_cart_res_model.dart';
import '../../data/model/res_model/product_categories_res_model/product_categories_res_model.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';
import '../../data/model/res_model/related_product_res_model/related_product_res_model.dart';
import '../../data/model/res_model/update_cart_res/update_cart_res_model.dart';
import '../../data/model/res_model/verify_client_res_model/verify_client_res_model.dart';
import '../../data/model/search_model/search_model.dart';
import '../../data/model/supplier_sale_model/supplier_sale_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../routes/app_routes.dart';

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
      SharedPreferencesHelper preferences = SharedPreferencesHelper(
          prefs: await SharedPreferences.getInstance());

      if (event is _isCategoryEvent) {
        emit(state.copyWith(isSubCategory: event.isSubCategory ,isGridView: preferences.getIsGridView(),
            isGuestUser: preferences.getGuestUser(),bottleDeposit: preferences.getBottleTax(),
          isSubUserAddToBasket: preferences.getCanAddToBasket(), isIncludedVat: preferences.getIsIncludedVat(),
          isSaleOn: preferences.getShowSale(),
        ));
      }
      if (event is _changeCategoryExpansionEvent) {
        if(event.isOpened == false){
          emit(state.copyWith(searchList: []));
        }
        if (event.isOpened != null) {
          emit(state.copyWith(isCategoryExpand: event.isOpened ?? false,isBottomOfPlanoGrams: false,isBottomOfSubCategory : false));

        } else {
          emit(state.copyWith(isCategoryExpand: !state.isCategoryExpand,isBottomOfPlanoGrams: false,isBottomOfSubCategory : false));

        }
      }
      else if (event is _changeSubCategoryOrPlanogramEvent) {

        emit( state.copyWith(isSubCategory: event.isSubCategory, subCategoryId: ''));

        if(categoryId != ''){
          add(StoreCategoryEvent.changeCategoryDetailsEvent(context:event.context , isSubCategory: 'true', categoryName: state.categoryName ,categoryId: parentCategoryId));
        }
        else{
          emit(state.copyWith(planogramPageNum : 0 , isBottomOfPlanoGrams: false));
          add(StoreCategoryEvent.changeCategoryDetailsEvent(context:event.context , isSubCategory: '', categoryName: state.categoryName ,categoryId: state.categoryId));

        }

      } else if (event is _changeCategoryDetailsEvent) {

        emit(state.copyWith(
            cartCount: preferences.getCartCount(),
            isSubCategory: state.isSubCategory,
            categoryId: event.categoryId,
            categoryName: event.categoryName,
            planoGramsList : [],
            subPlanoGramsList: [],
            planogramProductList:[],
            subCategoryPageNum: 0,
            planogramPageNum : 0,
            bottleDeposit:preferences.getBottleTax(),
            subPlanogramPageNum: 0,
            isBottomOfSubCategory: false,
            isBottomOfPlanoGrams: false,
            isBottomOfProducts: false,
            productStockList: [
              [ ProductStockModel(productId: '')],
              [],
              [],
              []
            ]));
        if(event.isSubCategory == ''){
          add(StoreCategoryEvent.getPlanoGramProductsEvent(context: event.context));
        }
        else if(event.isSubCategory != '' && state.isSubCategory){
          add(StoreCategoryEvent.getPlanoGramProductsEvent(context: event.context));
        }
        else{
          isSubCategoryString = event.isSubCategory;
          categoryId = event.categoryId;
          add(StoreCategoryEvent.getPlanogramByIdEvent(context: event.context));
        }
      }

      else if (event is _changeSubCategoryDetailsEvent) {

        if (event.subCategoryId != state.subCategoryId) {
          emit(state.copyWith(
            subCategoryId: event.subCategoryId,
            subCategoryName: event.subCategoryName,
            //    planoGramsList: [],
            subPlanoGramsList: [],
            subCategoryList: [],
            productStockList: [
              state.productStockList[0],
              state.productStockList[1],
              [],
              [],
            ],
              bottleDeposit:preferences.getBottleTax(),
            planogramProductList:[],
            subProductPageNum: 0,
            productStockUpdateIndex: -1,
            planoGramUpdateIndex: -1,
            planogramPageNum: 0,
            isBottomOfPlanoGrams: false,
            isBottomOfProducts: false
          ));
          add(StoreCategoryEvent.getPlanoGramProductsEvent(context: event.context));
        }
        emit(state.copyWith(isSubCategory: false));
      }
      else if (event is _getSubCategoryListEvent) {
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
              AppUrlEndPoints.getSubCategoriesUrl,
              data: ProductSubcategoriesReqModel(
                  parentCategoryId: state.categoryId,
                  pageNum: state.subCategoryPageNum + 1,
                  pageLimit: AppConstants.productSubCategoryPageLimit)
                  .toJson());
          ProductSubcategoriesResModel response =
          ProductSubcategoriesResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            List<SubCategory> subCategoryList =
            state.subCategoryList.toList(growable: true);
            subCategoryList.addAll(response.data?.subCategories ?? []);
            emit(state.copyWith(
              subCategoryList: subCategoryList,
              subCategoryPageNum: state.subCategoryPageNum + 1,
              isSubCategoryShimmering: false,
              isLoadMore: false,
                bottleDeposit:preferences.getBottleTax(),
              categoryName: response.data!.subCategories!.isNotEmpty ? (response.data?.subCategories?[0].parentCategoryName ?? '' ) : state.categoryName,
            ) );
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
                type: SnackBarType.failure);
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
        state.subCategoryRefreshController.refreshCompleted();
        state.subCategoryRefreshController.loadComplete();
      }
      else if (event is _subCategoryRefreshListEvent) {
        add(StoreCategoryEvent.getPermissionList(context: event.context));
        emit(state.copyWith(
            subCategoryPageNum: 0,
            subCategoryList: [],
            planogramPageNum : 0,
            planoGramsList : [],
            isBottomOfPlanoGrams: false,
            isBottomOfSubCategory: false));
        add(StoreCategoryEvent.getPlanoGramProductsEvent(context: event.context));

      }

      else if (event is _getPlanoGramProductsEvent) {


        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfPlanoGrams) {
          if(state.isSubCategory){
            add(StoreCategoryEvent.getSubCategoryListEvent(context: event.context));
          }
          else{

            add(StoreCategoryEvent.getPlanogramAllProductEvent(context: event.context));
          }
          return;
        }
        try {
          emit(state.copyWith(
              isPlanogramShimmering: state.planogramPageNum == 0 ? true : false,
              isLoadMore: state.planogramPageNum == 0 ? false : true));
          PlanogramReqModel planogramReqModel =  isSubCategoryString == '' && !state.isSubCategory  ? PlanogramReqModel(
              pageNum: state.planogramPageNum + 1,
              pageLimit: AppConstants.orderPageLimit,
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
              printData("[$key] = $value");
            }
            return value == null;
          });
          final res = await DioClient(event.context)
              .post(AppUrlEndPoints.getPlanogramProductsUrl, data: req);
          PlanogramResModel response = PlanogramResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            if(state.isSubCategory){
              add(StoreCategoryEvent.getSubCategoryListEvent(context: event.context));
            }
            else{
              add(StoreCategoryEvent.getPlanogramAllProductEvent(context: event.context));
            }
            emit(state.copyWith(categoryPlanogramList: []));
            List<PlanogramDatum> planoGramsList =[];
            planoGramsList.addAll(state.planoGramsList);
            List<PlanogramDatum> subPlanoGramList =
            state.subPlanoGramsList.toList(growable: true);
            if(isSubCategoryString == '' && !state.isSubCategory){
              subPlanoGramList.addAll(response.data ?? []);
              emit(state.copyWith(subPlanoGramsList: subPlanoGramList,));
            }
            else if(isSubCategoryString != '' && !state.isSubCategory){
              subPlanoGramList.addAll(response.data ?? []);
              emit(state.copyWith(subPlanoGramsList: subPlanoGramList,));
            }
            else{
              planoGramsList.addAll(response.data ?? []);
              emit(state.copyWith(planoGramsList: planoGramsList,));
            }

            List<List<ProductStockModel>> productStockList =
            state.productStockList.toList(growable: true);

            List<ProductStockModel> stockList = [];
            for (int i = 0; i < (response.data?.length ?? 0); i++) {
              stockList.addAll(response.data![i].planogramproducts?.map(
                      (product) => ProductStockModel(
                      productId: product.id ?? '',
                      maxQty: (product.sale?.isSale ?? false) ? int.parse(product.sale?.saleMaxQuantity.toString() ?? '0') : -1,
                      stock: product.productStock.toString())) ??
                  []);

            }
            if(isSubCategoryString == '' && !state.isSubCategory){
              productStockList[2] = stockList;
            }
            else if(isSubCategoryString != '' && !state.isSubCategory ){
              productStockList[2] = stockList;
            }
            else{
              productStockList[1] = stockList;
            }

            emit(state.copyWith(
              subPlanoGramsList: state.subPlanoGramsList,
              planoGramsList: state.planoGramsList,
              productStockList: productStockList,
              planogramPageNum: state.planogramPageNum + 1,
              isPlanogramShimmering: false,
              isLoadMore: false,
                isBottomOfPlanoGrams: planoGramsList.length ==
                    (response.metaData?.totalFilteredCount ?? 0)
                    ? true
                    : false
            ));

          } else {
            emit(state.copyWith(isLoadMore: false));
          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }
        if(!state.isSubCategory){
          state.planogramRefreshController.refreshCompleted();
          state.planogramRefreshController.loadComplete();
        }

      }
      else if (event is _planogramRefreshListEvent) {
        emit(state.copyWith(
            planogramPageNum: 0,
            planoGramsList: [],
            productCategoryList: [],
            subPlanoGramsList: isSubCategoryString != '' && !state.isSubCategory ? [] : isSubCategoryString != '' && state.isSubCategory ? [] :  isSubCategoryString == '' && !state.isSubCategory ? [] : state.subPlanoGramsList,
            subProductPageNum: 0,
            planogramProductList: [],
            isBottomOfProducts:false,

            isBottomOfPlanoGrams: false));
        add(StoreCategoryEvent.getPlanoGramProductsEvent(
            context: event.context));
      }
      else if (event is _getProductDetailsEvent) {
        add(const StoreCategoryEvent.removeRelatedProductEvent());
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

          printData('GetProductDetails_____$response');
          if (response.status == AppConstants.code_200) {
            /// 0 planogram
            ///1 product
            ///2 barcode

            ///new chanegs
            ///0 for barcode and search
            ///1 for planogram above sub cat.
            ///2 for planogram above grid/list products.
            ///3 for grid/list products.
            if(response.product!.isNotEmpty){

            List<List<ProductStockModel>> productStockList =
            state.productStockList.toList(growable: true);
            int planoGramIndex  = event.planoGramIndex;

            int productStockUpdateIndex = 0;

            if(event.isBarcode ){
              productStockUpdateIndex = 0;
              productStockList[0][0] =  productStockList[0][0]
                  .copyWith(
                quantity: _productQuantity,
                productId: response.product?.first.id ?? '',
                stock: (response.product?.first.supplierSales?.first.productStock.toString()  ?? '0'),
                maxQty: (response.product?.first.sale?.isSale ?? false) ? int.parse(response.product?.first.sale?.saleMaxQuantity ?? '0') : -1,
              );
            }
            else{
              productStockUpdateIndex = state.productStockList[planoGramIndex]
                  .indexWhere((productStock) =>
              productStock.productId == event.productId);
            }

            emit(state.copyWith(planoGramUpdateIndex:planoGramIndex,productStockUpdateIndex:productStockUpdateIndex));

            try {

              final res = await DioClient(event.context).post(
                  '${AppUrlEndPoints.getAllCartUrl}${preferences.getCartId()}',
                 );
              GetAllCartResModel response = GetAllCartResModel.fromJson(res);
              if (response.status == AppConstants.code_200) {
                response.data?.data?.forEach((cartProduct) {
                  if (cartProduct.id == event.productId ||
                      cartProduct.id == state.productStockList[state.planoGramUpdateIndex]
                      [state.productStockUpdateIndex].productId
                  ) {
                    _isProductInCart = true;
                    _cartProductId = cartProduct.cartProductId ?? '';
                    _productQuantity = cartProduct.totalQuantity ?? 0;
                    return;
                  }
                });
                printData(
                    '1)exist = $_isProductInCart\n2)id = $_cartProductId\n3) quan = $_productQuantity');
              }
            } on ServerException {}
            emit(state.copyWith(isProductLoading: false,productDetails: response.product??[]));

            if ( (event.isBarcode )) {

              productStockList[0][0] =  productStockList[0][0]
                  .copyWith(
                quantity: _productQuantity,
                productId: response.product?.first.id ?? '',
                stock: (response.product?.first.supplierSales?.first.productStock.toString()  ?? '0'),
                maxQty: (response.product?.first.sale?.isSale ?? false) ? int.parse(response.product?.first.sale?.saleMaxQuantity ?? '0') : -1,
              );

              emit(state.copyWith(productStockList: productStockList));

            }

            if(response.product!.isNotEmpty){
              add(StoreCategoryEvent.relatedProductsEvent(context: event.context, productId: response.product?.first.id ?? ''));
            }

            List<ProductSupplierModel> supplierList = [];
            supplierList.addAll(response.product?.first.supplierSales
                ?.map((supplier) => ProductSupplierModel(
              supplierId: supplier.supplierId ?? '',
              companyName: supplier.supplierCompanyName ?? '',
              basePrice:
              double.parse(supplier.productPrice ?? '0.0'),
              quantity: _productQuantity,
              maxQty: (response.product?.first.sale?.isSale ?? false) ?  int.parse(response.product?.first.sale?.saleMaxQuantity ?? '') : -1,
              stock: supplier.productStock.toString(),
              selectedIndex: (supplier.supplierId ?? '') ==
                  state
                      .productStockList[planoGramIndex]
                  [productStockUpdateIndex]
                      .productSupplierIds
                  ? !supplier.saleProduct!.contains(
                  supplier.saleProduct?.firstWhere(
                        (sale) =>
                    sale.saleId ==
                        state
                            .productStockList[
                        planoGramIndex][
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
                        state
                            .productStockList[
                        planoGramIndex][
                        productStockUpdateIndex]
                            .productSaleId,
                    orElse: () => const SaleProduct(isSale: false,saleDescription: '',saleFromDate: '',saleMaxQuantity: '0',salePrice: '0',saleUntilDate:'' ),
                  ) ??
                      const SaleProduct(isSale: false,saleDescription: '',saleFromDate: '',saleMaxQuantity: '0',salePrice: '0',saleUntilDate:'' ),) ??
                  -1
                  : -1,
              supplierSales: supplier.saleProduct?.map((sale) => SupplierSaleModel(
                  saleId: sale.saleId ?? '',
                  saleName: sale.saleName ?? '',
                  maxQty: sale.saleMaxQuantity??'',
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
            supplierList.removeWhere((supplier) => supplier.stock == '0');

            String note = productStockList.isEmpty
                ? ''
                : productStockList.indexOf(state.productStockList.last) ==
                planoGramIndex
                ? ''
                : productStockList[planoGramIndex][0].note;
            emit(state.copyWith(productStockList: []));

            emit(state.copyWith(
                bottleDeposit:preferences.getBottleTax(),
                productDetails: response.product ?? [],
                productStockList: productStockList,
                productStockUpdateIndex: productStockUpdateIndex,
                noteController: TextEditingController(text: note),
                productSupplierList: supplierList,
                planoGramUpdateIndex: planoGramIndex,
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

              if (!isSupplierSelected || state.planoGramUpdateIndex == 0) {
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

                add(StoreCategoryEvent.supplierSelectionEvent(
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
                type: SnackBarType.failure);
          }
        } on ServerException {
          Navigator.pop(event.context);
        }
      }
      else if (event is _increaseQuantityOfProduct) {
        List<List<ProductStockModel>> productStockList =
        state.productStockList.toList(growable: false);
        if (state.productStockUpdateIndex != -1) {
          if (productStockList[state.planoGramUpdateIndex]
          [state.productStockUpdateIndex]
              .quantity <
              double.parse(productStockList[state.planoGramUpdateIndex]
              [state.productStockUpdateIndex]
                  .stock.toString())) {
            if (productStockList[state.planoGramUpdateIndex]
            [state.productStockUpdateIndex]
                .productSupplierIds
                .isEmpty) {
              return;
            }
            if(productStockList[state.planoGramUpdateIndex]
            [state.productStockUpdateIndex]
                .maxQty!=-1){
              if (productStockList[state.planoGramUpdateIndex]
              [state.productStockUpdateIndex]
                  .quantity >=
                  productStockList[state.planoGramUpdateIndex]
                  [state.productStockUpdateIndex]
                      .maxQty) {
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppLocalizations.of(event.context)!.not_add_more_than_max_qty,
                    type: SnackBarType.failure);
                return;
              }
            }
            productStockList[state.planoGramUpdateIndex]
            [state.productStockUpdateIndex] =
                productStockList[state.planoGramUpdateIndex]
                [state.productStockUpdateIndex].copyWith(
                    quantity: productStockList[state.planoGramUpdateIndex]
                    [state.productStockUpdateIndex]
                        .quantity +
                        1);
     
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          } else {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
                type: SnackBarType.failure);
          }
        }
      }

      else if (event is _decreaseQuantityOfProduct) {
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
              double.parse(productStockList[state.planoGramUpdateIndex]
              [state.productStockUpdateIndex]
                  .stock.toString())) {
            productStockList[state.planoGramUpdateIndex]
            [state.productStockUpdateIndex] =
                productStockList[state.planoGramUpdateIndex]
                [state.productStockUpdateIndex]
                    .copyWith(quantity: newQuantity);

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

            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
                type: SnackBarType.failure);
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          }
        }
      }
      else if (event is _changeNoteOfProduct) {
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
      else if (event is _changeSupplierSelectionExpansionEvent) {
        emit(state.copyWith(
            isSelectSupplier:
            event.isSelectSupplier ?? !state.isSelectSupplier));
      }
      else if (event is _supplierSelectionEvent) {
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
                maxQty: supplierList[event.supplierIndex].maxQty,
                quantity:supplierList[event.supplierIndex].quantity != 0 ?supplierList[event.supplierIndex].quantity : 1 ,
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
            .copyWith(
            selectedIndex:
            supplierList[event.supplierIndex].selectedIndex ==
                event.supplierSaleIndex
                ? -1
                : event.supplierSaleIndex);

        emit(state.copyWith(
            productSupplierList: supplierList,
            productStockList: productStockList));
      }
      else if (event is _addToCartProductEvent) {
        if (state
            .productStockList[state.planoGramUpdateIndex]
        [state.productStockUpdateIndex]
            .productSupplierIds
            .isEmpty) {

          return;
        }
        if (state
            .productStockList[state.planoGramUpdateIndex]
        [state.productStockUpdateIndex]
            .quantity ==
            0) {
          CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppLocalizations.of(event.context)!.add_1_quantity,
              type: SnackBarType.failure);
          return;
        }
        if(state.productStockList[state.planoGramUpdateIndex]
        [state.productStockUpdateIndex].maxQty > 0){
          if (state.productStockList[state.planoGramUpdateIndex]
          [state.productStockUpdateIndex].quantity >
              state.productStockList[state.planoGramUpdateIndex]
              [state.productStockUpdateIndex].maxQty
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
              productId: state.productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].productId == ''? event.productId :state.productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].productId,
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
            //  Navigator.pop(event.context);
              List<List<ProductStockModel>> productStockList =
              state.productStockList.toList(growable: true);
              productStockList[state.planoGramUpdateIndex]
              [state.productStockUpdateIndex] =
                  productStockList[state.planoGramUpdateIndex]
                  [state.productStockUpdateIndex]
                      .copyWith(
                    note: '',
                    productIsInCart: true,
                    quantity: state
                        .productStockList[state.planoGramUpdateIndex]
                    [state.productStockUpdateIndex]
                        .quantity,
                    productSupplierIds: state.productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].productSupplierIds,

                    totalPrice: state
                        .productStockList[state.planoGramUpdateIndex]
                    [state.productStockUpdateIndex]
                        .totalPrice,
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
            printData('err = $e');
            emit(state.copyWith(isLoading: false));
          }
        } else {
          try {
            emit(state.copyWith(isLoading: true));
            InsertCartModel.InsertCartReqModel insertCartReqModel =
            InsertCartModel.InsertCartReqModel(products: [
              InsertCartModel.Product(
                  productId: state.productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].productId == ''? event.productId :state.productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].productId,
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
                printData("[$key] = $value");
              }
              return value == null;
            });
            SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
                prefs: await SharedPreferences.getInstance());

            final res = await DioClient(event.context).post(
                '${AppUrlEndPoints.insertProductInCartUrl}${preferencesHelper.getCartId()}',
                data: req,
                );
            InsertCartResModel response = InsertCartResModel.fromJson(res);
            if (response.status == AppConstants.code_201) {
              Vibration.vibrate();
              if(!state
                  .productStockList[state.planoGramUpdateIndex]
              [state.productStockUpdateIndex].productIsInCart){
                add(const StoreCategoryEvent.setCartCountEvent());
              }
            //  Navigator.pop(event.context);
              List<List<ProductStockModel>> productStockList =
              state.productStockList.toList(growable: true);
              productStockList[state.planoGramUpdateIndex]
              [state.productStockUpdateIndex] =
                  productStockList[state.planoGramUpdateIndex]
                  [state.productStockUpdateIndex]
                      .copyWith(
                    note: '',
                    productIsInCart: true,
                    quantity: state
                        .productStockList[state.planoGramUpdateIndex]
                    [state.productStockUpdateIndex]
                        .quantity,
                    productSupplierIds: state.productStockList[state.planoGramUpdateIndex][state.productStockUpdateIndex].productSupplierIds,                    totalPrice: state
                        .productStockList[state.planoGramUpdateIndex]
                    [state.productStockUpdateIndex]
                        .totalPrice,
                    productSaleId: '',
                  );
              add(const StoreCategoryEvent.getCartCountEvent());
              emit(state.copyWith(isLoading: false, productStockList: productStockList , duringCelebration: true));

              await Future.delayed(const Duration(milliseconds: 2000));
              emit(state.copyWith(duringCelebration: false));

              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          response.message!,
                      event.context),
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
        
        printData('cart count store cate= ${preferences.getCartCount()}');
      }
      else if (event is _globalSearchEvent) {
        emit(state.copyWith(search: state.searchController.text,bottleDeposit: preferences.getBottleTax()));
        printData('data1 = ${state.search}');
        try {
          GlobalSearchReqModel globalSearchReqModel =
          GlobalSearchReqModel(search: state.search,
              sortField: AppStrings.sortFieldString,
              sortOrder: AppStrings.sortOrderString
          );
          emit(state.copyWith(isSearching: true));
          final res = await DioClient(event.context).post(
              AppUrlEndPoints.getPlanogramAllProductForSearchUrl,
              data: globalSearchReqModel.toJson());
          GlobalSearchResModel response = GlobalSearchResModel.fromJson(res);
          if (state.searchController.text.isEmpty) {
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
                name: supplier.supplierDetail?.companyName?? '',
                searchType: SearchTypes.supplier,
                isPesach: supplier.isPesach??false,

                image: supplier.logo ?? ''))
                .toList() ??
                []);
            //sale search result
            searchList.addAll(response.data?.saleData
                ?.map((sale) => SearchModel(
                searchId: sale.id ?? '',
                name: sale.productName ?? '',
                searchType: SearchTypes.sale,
                isPesach: sale.isPesach??false,
                salesDesc:  parse(sale.salesDescription ?? '')
                    .body
                    ?.text ??
                    '',
                numberOfUnits: int.parse(sale.numberOfUnit.toString()) ,
                image: sale.mainImage ?? ''))
                .toList() ??
                []);*/
            //supplier products result
            searchList.addAll(response.data?.map((supplier) => SearchModel(
                searchId: supplier.id ?? '',
                isPesach: supplier.isPesach??false,
                name: supplier.productName ?? '',
                searchType: SearchTypes.product,
                productStock:  supplier.productStock.toString(),
                lowStock: supplier.lowStock.toString(),
                numberOfUnits: int.parse(supplier.numberOfUnit.toString()),
                priceOfBox: double.parse(supplier.productPrice.toString()),
                salePrice: double.parse(supplier.sale?.salePrice.toString() ?? '0'),
                salesDesc:  parse(supplier.sale?.saleDescription ?? '')
                    .body
                    ?.text ??
                    '',
                image: supplier.mainImage ?? '')).toList() ??
                []);
            printData('store cat search list = ${searchList.length}');
            emit(state.copyWith(
                searchList: searchList,
                isSearching: false));
          } else {
            emit(state.copyWith(isSearching: false));
          }
        } on ServerException {
          emit(state.copyWith(isSearching: false));
        } catch (e) {
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
        if (state.searchController.text == '') {
          add(StoreCategoryEvent.getProductCategoriesListEvent(
              context: event.context));
        }
      }
      else if(event is _getPlanogramByIdEvent){
        try {
          final res = await DioClient(event.context)
              .get(path: '${AppUrlEndPoints.getPlanogramByIdUrl}$categoryId');


          printData('url_____${AppUrlEndPoints.baseUrl}${AppUrlEndPoints.getPlanogramByIdUrl}$categoryId');

          GetPlanogramByIdModel response = GetPlanogramByIdModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            add(StoreCategoryEvent.getPlanoGramProductsEvent(context: event.context));
            parentCategoryId = response.data?.planogram?.categoryId ?? '';
            emit(state.copyWith(
                categoryName : response.data?.planogram?.categoryName ?? '',
                subCategoryName : response.data?.planogram?.subCategoryName ?? '',
                categoryId: response.data?.planogram?.categoryId ?? '',
                subCategoryId: response.data?.planogram?.subCategoryId ?? ''
            ));
          } else {
            emit(state.copyWith(isLoadMore: false));

          }
        } on ServerException {
          emit(state.copyWith(isLoadMore: false));
        }

      }

      else if(event is _getPlanogramAllProductEvent){
        add(StoreCategoryEvent.getPermissionList(context: event.context));
        if (state.isLoadMore) {
          return;
        }
          if (state.isBottomOfProducts) {
          return;
         }
        printData('Here');
        try{
          List<PlanogramAllProduct> planogramProductList =
          state.planogramProductList.toList(growable: true);
          emit(state.copyWith(isPlanogramProductShimmering: true));

          GetSubCategoriesProductReqModel getSubCategoriesProductReqModel = GetSubCategoriesProductReqModel(
              subCategoryId: state.subCategoryId,
              pageNum: state.subProductPageNum + 1,
              pageLimit: AppConstants.orderPageLimit,
            );

          final  res = await DioClient(event.context)
                .post(AppUrlEndPoints.getSubCategoryProductsUrl,
                data: getSubCategoriesProductReqModel
            );

          GetPlanogramProductModel response = GetPlanogramProductModel.fromJson(res);

          if(response.status == AppConstants.code_200){
            List<List<ProductStockModel>> productStockList =
            state.productStockList.toList(growable: true);

            List<ProductStockModel> stockList = [];

            stockList.addAll(response.data?.map(
                    (product) {
                      return ProductStockModel(
                    productId: product.productId ?? '',
                    maxQty: (product.product.sale?.isSale ?? false) ? int.parse(product.product.sale?.saleMaxQuantity.toString() ?? '0') : -1 ,
                    stock:(product.product.productStock.toString()));
                    }) ?? []);
            productStockList[3].addAll(stockList);

            planogramProductList.addAll(response.data ?? []);

            emit(state.copyWith(planogramProductList: planogramProductList,productStockList: productStockList,
                isPlanogramProductShimmering: false,isPlanogramShimmering: false,subProductPageNum: state.subProductPageNum + 1,
            ));

            emit(state.copyWith(
                isBottomOfProducts: planogramProductList.length >=
                    (response.metaData?.totalFilteredCount ?? 0)
                    ? true
                    : false));
            state.planogramRefreshController.refreshCompleted();
            state.planogramRefreshController.loadComplete();
          }
          else{
            emit(state.copyWith(isLoadMore: false,isPlanogramProductShimmering: false));
          }
        }
        on ServerException {
          emit(state.copyWith(isLoadMore: false,isPlanogramProductShimmering: false));
        }
        catch(e){
          emit(state.copyWith(isLoadMore: false,isPlanogramProductShimmering: false));
        }
      }

      else if(event is _changeGridToListViewEvent){
        preferences.setIsGridView(isGridView: !state.isGridView);
        emit(state.copyWith(isGridView: !state.isGridView));
      }

      else if (event is _getCartCountEvent) {
        emit(
            state.copyWith(cartCount: preferences.getCartCount()));
      }
      else if(event is _relatedProductsEvent){
        emit(state.copyWith(isRelatedShimmering:true));
        final res = await DioClient(event.context).post(
            AppUrlEndPoints.relatedProductsUrl,
            data: {AppStrings.mainProductIdString:event.productId});
        RelatedProductResModel response =
        RelatedProductResModel.fromJson(res);

        if (response.status == AppConstants.code_200) {
          List<List<ProductStockModel>> productStockList =
          state.productStockList.toList(growable: true);
          List<ProductStockModel> stockList = [];
          stockList.addAll(response.data?.map(
                  (product) {
                return ProductStockModel(
                    productId: product.id ?? '' ,
                    stock:(product.productStock.toString()));
              }) ?? [] );
          productStockList[3].addAll(stockList);
          emit(state.copyWith(
              relatedProductList:response.data  ?? [],isProductLoading: false,
              isRelatedShimmering: false,productStockList: productStockList));
        } else {
          emit(state.copyWith(isRelatedShimmering: false,isProductLoading: false,));
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: AppStrings.getLocalizedStrings(
                response.message?.toLocalization() ?? '',
                event.context),
            type: SnackBarType.failure,
          );
        }
      }
      else if(event is _removeRelatedProductEvent){
        emit(state.copyWith(relatedProductList: []));
      }
      else  if(event is _getPermissionList){
        if(preferences.getSubUser() ){
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

      else if(event is _userApproveEvent){
        if(!preferences.getGuestUser()) {
          try {
            final res = await DioClient(event.context).post(
                AppUrlEndPoints.verifyClientUrl,
                data: {AppStrings.clientIdString: preferences.getUserId()}
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