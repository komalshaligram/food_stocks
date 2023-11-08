import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/data/error/exceptions.dart';
import 'package:food_stock/data/model/product_supplier_model/product_supplier_model.dart';
import 'package:food_stock/data/model/req_model/company_req_model/company_req_model.dart';
import 'package:food_stock/data/model/req_model/product_categories_req_model/product_categories_req_model.dart';
import 'package:food_stock/data/model/req_model/product_sales_req_model/product_sales_req_model.dart';
import 'package:food_stock/data/model/req_model/suppliers_req_model/suppliers_req_model.dart';
import 'package:food_stock/data/model/res_model/company_res_model/company_res_model.dart';
import 'package:food_stock/data/model/res_model/product_categories_res_model/product_categories_res_model.dart';
import 'package:food_stock/data/model/res_model/product_sales_res_model/product_sales_res_model.dart';
import 'package:food_stock/data/model/search_model/search_model.dart';
import 'package:food_stock/data/model/supplier_sale_model/supplier_sale_model.dart';
import 'package:food_stock/repository/dio_client.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_colors.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/req_model/product_stock_verify_req_model/product_stock_verify_req_model.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';
import '../../data/model/res_model/product_stock_verify_res_model/product_stock_verify_res_model.dart';
import '../../data/model/res_model/suppliers_res_model/suppliers_res_model.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_strings.dart';

part 'store_event.dart';

part 'store_state.dart';

part 'store_bloc.freezed.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreState.initial()) {
    on<StoreEvent>((event, emit) async {
      if (event is _ChangeCategoryExpansion) {
        if (event.isOpened != null) {
          emit(state.copyWith(isCategoryExpand: false));
        } else {
          emit(state.copyWith(isCategoryExpand: !state.isCategoryExpand));
        }
      } else if (event is _ChangeSupplierSelectionExpansionEvent) {
        emit(state.copyWith(
            isSelectSupplier:
                event.isSelectSupplier ?? !state.isSelectSupplier));
        debugPrint('supplier selection : ${state.isSelectSupplier}');
      } else if (event is _GetProductCategoriesListEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).post(
              AppUrls.getProductCategoriesUrl,
              data: ProductCategoriesReqModel(
                      pageNum: 1,
                      pageLimit: AppConstants.productCategoryPageLimit)
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
                    image: category.categoryImage ?? '')) ??
                []);
            debugPrint('store search list = ${searchList.length}');
            emit(state.copyWith(
                productCategoryList: response.data?.categories ?? [],
                searchList: searchList,
                isShimmering: false));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
      } else if (event is _ChangeSearchListEvent) {
        emit(state.copyWith(searchList: event.newSearchList));
      } else if (event is _GetProductSalesListEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).post(
              AppUrls.getSaleProductsUrl,
              data: ProductSalesReqModel(
                  pageNum: 1, pageLimit: AppConstants.defaultPageLimit)
                  .toJson());
          ProductSalesResModel response = ProductSalesResModel.fromJson(res);
          if (response.status == 200) {
            List<ProductStockModel> productStockList = [];
            if ((response.metaData?.totalFilteredCount ?? 0) > 0) {
              for (int i = 0; i < (response.data?.length ?? 0); i++) {
                productStockList.add(
                    ProductStockModel(productId: response.data?[i].id ?? ''));
              }
            }
            emit(state.copyWith(
                productSalesList: response,
                productStockList: productStockList,
                isShimmering: false));
          } else {
            showSnackBar(
                context: event.context,
                title: AppStrings.somethingWrongString,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
      } else if (event is _GetSuppliersListEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).post(
              AppUrls.getSuppliersUrl,
              data: SuppliersReqModel(
                      pageNum: 1, pageLimit: AppConstants.defaultPageLimit)
                  .toJson());
          SuppliersResModel response = SuppliersResModel.fromJson(res);
          debugPrint('suppliers = ${response.data}');
          if (response.status == 200) {
            emit(state.copyWith(suppliersList: response, isShimmering: false));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
      } else if (event is _GetCompaniesListEvent) {
        try {
          emit(state.copyWith(isShimmering: true));
          final res = await DioClient(event.context).post(
              AppUrls.getCompaniesUrl,
              data: CompanyReqModel(
                  pageNum: 1, pageLimit: AppConstants.companyPageLimit)
                  .toJson());
          CompanyResModel response = CompanyResModel.fromJson(res);
          debugPrint('companies = ${response.data}');
          if (response.status == 200) {
            emit(state.copyWith(
                companiesList: response.data?.brandList ?? [],
                isShimmering: false));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
      } else if (event is _GetProductDetailsEvent) {
        debugPrint('product details id = ${event.productId}');
        try {
          emit(state.copyWith(isProductLoading: true));
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
            // debugPrint('product details res = ${response.product}');
            List<ProductSupplierModel> supplierList = [];
            debugPrint(
                'abcd = ${response.product?.first.supplierSales?.supplier?.id ?? ''}');
            debugPrint(
                'abcd = ${state.productStockList[productStockUpdateIndex].productSupplierIds}');
            //state.productStockList[productStockUpdateIndex].productSaleId
            supplierList.addAll(response.product
                    ?.map((supplier) => ProductSupplierModel(
                          supplierId:
                              supplier.supplierSales?.supplier?.id ?? '',
                          companyName:
                              supplier.supplierSales?.supplier?.companyName ??
                                  '',
                          selectedIndex: (supplier
                                          .supplierSales?.supplier?.id ??
                                      '') ==
                                  (state
                                          .productStockList[
                                              productStockUpdateIndex]
                                          .productSupplierIds
                                          .isNotEmpty
                                      ? state
                                          .productStockList[
                                              productStockUpdateIndex]
                                          .productSupplierIds
                                          .first
                                      : '')
                              ? supplier.supplierSales?.supplier?.sale?.indexOf(
                                      supplier.supplierSales?.supplier?.sale
                                              ?.firstWhere((sale) =>
                                                  sale.saleId ==
                                                  state
                                                      .productStockList[
                                                          productStockUpdateIndex]
                                                      .productSaleId) ??
                                          Sale()) ??
                                  -1
                              : -1,
                          supplierSales: supplier.supplierSales?.supplier?.sale
                                  ?.map((sale) => SupplierSaleModel(
                                      saleId: sale.saleId ?? '',
                                      saleName: sale.salesName ?? '',
                                      saleDescription:
                                          sale.salesDescription ?? '',
                                      saleDiscount:
                                          sale.discountPercentage?.toDouble() ??
                                              0.0))
                                  .toList() ??
                              [],
                        ))
                    .toList() ??
                []);
            debugPrint('response list = ${response.product?.length}');
            debugPrint('supplier list = ${supplierList.length}');
            debugPrint(
                'supplier select index = ${supplierList.map((e) => e.selectedIndex)}');
            emit(state.copyWith(
                productDetails: response,
                productStockUpdateIndex: productStockUpdateIndex,
                productSupplierList: supplierList,
                isSelectSupplier: false,
                isProductLoading: false));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
          }
        } on ServerException {
          // emit(state.copyWith(isProductLoading: false));
        }
      } else if (event is _IncreaseQuantityOfProduct) {
        List<ProductStockModel> productStockList =
            state.productStockList.toList(growable: false);
        if (state.productStockUpdateIndex != -1) {
          // if (productStockList[state.productStockUpdateIndex].quantity < 30) {
          productStockList[state.productStockUpdateIndex] =
              productStockList[state.productStockUpdateIndex].copyWith(
                  quantity:
                      productStockList[state.productStockUpdateIndex].quantity +
                          1);
          debugPrint(
              'product quantity = ${productStockList[state.productStockUpdateIndex].quantity}');
          emit(state.copyWith(productStockList: productStockList));
          // } else {
          //   showSnackBar(
          //       context: event.context,
          //       title: AppStrings.maxQuantityAllowString,
          //       bgColor: AppColors.mainColor);
          // }
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
      } else if (event is _VerifyProductStockEvent) {
        if (state.productStockList[state.productStockUpdateIndex].quantity ==
            0) {
          showSnackBar(
              context: event.context,
              title: AppStrings.minQuantityMsgString,
              bgColor: AppColors.mainColor);
          return;
        }
        try {
          emit(state.copyWith(isLoading: true));
          ProductStockVerifyReqModel req = ProductStockVerifyReqModel(
              quantity: state
                  .productStockList[state.productStockUpdateIndex].quantity,
              supplierId: [
                state.productDetails.product?.first.supplierSales?.supplier
                        ?.id ??
                    ''
              ],
              productId: state
                  .productStockList[state.productStockUpdateIndex].productId);
          debugPrint('verify stock req = $req');
          final res = await DioClient(event.context)
              .post(AppUrls.verifyProductStockUrl, data: req.toJson());
          ProductStockVerifyResModel response =
              ProductStockVerifyResModel.fromJson(res);
          if (response.status == 200) {
            emit(state.copyWith(isLoading: false));
            if (state.productStockList[state.productStockUpdateIndex].quantity <
                (response.data?.stock?.first.data?.productStock ?? 0)) {
              showSnackBar(
                  context: event.context,
                  title: AppStrings.doneString,
                  bgColor: AppColors.mainColor);
              Navigator.pop(event.context);
            } else {
              showSnackBar(
                  context: event.context,
                  title: response.data?.stock?.first.message ??
                      AppStrings.somethingWrongString,
                  bgColor: AppColors.redColor);
            }
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
          }
        } on ServerException {
          Navigator.pop(event.context);
        }
      } else if (event is _GetScanProductDetailsEvent) {
      } else if (event is _SupplierSelectionEvent) {
        debugPrint(
            'supplier[${event.supplierIndex}][${event.supplierSaleIndex}]');
        if (event.supplierIndex >= 0) {
          List<ProductSupplierModel> supplierList =
              state.productSupplierList.toList(growable: true);
          if (event.supplierSaleIndex >= 0) {
            //sale avail then supplier sale selection
            List<ProductStockModel> stockList =
                state.productStockList.toList(growable: true);
            stockList[state.productStockUpdateIndex] =
                stockList[state.productStockUpdateIndex].copyWith(
                    productSupplierIds: [
                  supplierList[event.supplierIndex].selectedIndex ==
                          event.supplierSaleIndex
                      ? ''
                      : supplierList[event.supplierIndex].supplierId
                ],
                    productSaleId:
                        supplierList[event.supplierIndex].selectedIndex ==
                                event.supplierSaleIndex
                            ? ''
                            : supplierList[event.supplierIndex]
                                .supplierSales[event.supplierSaleIndex]
                                .saleId);
            debugPrint(
                'stock supplier id = ${stockList[state.productStockUpdateIndex].productSupplierIds}');
            debugPrint(
                'stock supplier sale id = ${stockList[state.productStockUpdateIndex].productSaleId}');
            supplierList[event.supplierIndex] =
                supplierList[event.supplierIndex].copyWith(
                    selectedIndex:
                        supplierList[event.supplierIndex].selectedIndex ==
                                event.supplierSaleIndex
                            ? -1
                            : event.supplierSaleIndex);
            debugPrint(
                'supplier[${event.supplierIndex}] = ${supplierList[event.supplierIndex].selectedIndex}');
            emit(state.copyWith(
                productSupplierList: supplierList,
                productStockList: stockList));
          } else {
            //no sale avail then supplier base price selection
          }
        }
      }
    });
  }
}
