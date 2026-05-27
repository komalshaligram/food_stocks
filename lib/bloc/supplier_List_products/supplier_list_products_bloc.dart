import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/res_model/message_count_res_model/message_count_res_model.dart';
import '../../data/model/res_model/supplier_list_products_response_model/supplier_list_products_response_model.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../../data/model/req_model/global_search_req_model/global_search_req_model.dart';
import '../../data/model/req_model/insert_cart_req_model/insert_cart_req_model.dart' as insert;
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
import '../../ui/utils/constants/app_strings.dart';

part 'supplier_list_products_event.dart';
part 'supplier_list_products_state.dart';
part 'supplier_list_products_bloc.freezed.dart';

class SupplierListProductsBloc extends Bloc<SupplierListProductsEvent, SupplierListProductsState> {
  bool _isProductInCart = false;
  String _cartProductId = '';
  int _productQuantity = 0;

  SupplierListProductsBloc() : super(SupplierListProductsState.initial()) {
    on<SupplierListProductsEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (event is _getPreferencesDataEvent) {
        emit(state.copyWith(
          isIncludedVat: preferences.getIsIncludedVat(),
          isSubUserAddToBasket: preferences.getCanAddToBasket(),
          isSaleOn: preferences.getShowSale(),
          cartCount: preferences.getCartCount(),
          bottlePrice: preferences.getBottleTax(),
          language: preferences.getAppLanguage(),
          bottleDeposit: preferences.getBottleTax(),
        ));
      } else if (event is _getSupplierProductsIdEvent) {
        emit(state.copyWith(supplierId: event.supplierId, searchArg: event.search, language: preferences.getAppLanguage()));
      } else if (event is _getSupplierProductsListEvent) {
        final isNewBrand = event.brandId != null && event.brandId!.isNotEmpty && event.brandId != state.selectedBrandId;

        if (!isNewBrand) {
          if (state.isLoadMore || state.isBottomOfProducts || state.isProgress) return;
        }
        emit(state.copyWith(
          isGuestUser: preferences.getGuestUser(),
          isSubUserAddToBasket: preferences.getCanAddToBasket(),
          isGridView: preferences.getSupplierProductGrid(),
          bottleDeposit: preferences.getBottleTax(),
          bottlePrice: preferences.getBottleTax(),
          isIncludedVat: preferences.getIsIncludedVat(),
          isSaleOn: preferences.getShowSale(),
          searchType: event.searchType,
        ));

        try {
          final nextPage = isNewBrand ? 1 : state.pageNum + 1;
          emit(state.copyWith(
            selectedBrandId: event.brandId ?? state.selectedBrandId,
            productList: isNewBrand ? [] : state.productList,
            productStockList: isNewBrand ? [[], []] : state.productStockList,
            isBottomOfProducts: isNewBrand ? false : state.isBottomOfProducts,
            isShimmering: nextPage == 1,
            isLoadMore: nextPage != 1,
            isProgress: true,
            cartCount: preferences.getCartCount(),
          ));

          final body = {
            "supplierId": state.supplierId,
            "pageNum": nextPage,
            "pageLimit": AppConstants.supplierProductPageLimit,
            if (event.brandId != null && event.brandId!.isNotEmpty) "brandId": event.brandId,
          };
          final res = await DioClient(event.context).post(AppUrlEndPoints.getSupplierBrandProducts, data: body);
          final response = SupplierListProductsResponseModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            final newProducts = response.data?.products ?? [];
            final cartMap = await fetchCartQuantities(event.context);
            final stockList = newProducts.map((product) {
              return ProductStockModel(
                productId: product.id ?? '',
                stock: product.productStock?.toString() ?? '0',
                quantity: cartMap[product.id ?? ''] ?? 0,
                maxQty: (product.sale?.isSale ?? false) ? int.tryParse(product.sale?.saleMaxQuantity ?? '0') ?? 0 : 0,
              );
            }).toList();

            final updatedStockList = state.productStockList.map((e) => List<ProductStockModel>.from(e)).toList();
            if (updatedStockList.length < 2) {
              updatedStockList.add([]);
              updatedStockList.add([]);
            }

            if (isNewBrand) {
              updatedStockList[1] = stockList;
            } else {
              updatedStockList[1].addAll(stockList);
            }
            final updatedProducts = isNewBrand ? newProducts : [...state.productList, ...newProducts];
            emit(state.copyWith(
              productList: updatedProducts,
              productStockList: updatedStockList,
              pageNum: nextPage,
              isShimmering: false,
              isLoadMore: false,
              isProgress: false,
              isBottomOfProducts: updatedProducts.length >= (response.metaData?.totalFilteredCount ?? 0),
              brandList: response.data?.brands ?? state.brandList,
            ));
          } else if (response.status == AppConstants.code_403) {
            emit(state.copyWith(isLoading: false, productList: [], isShimmering: false));
          } else {
            emit(state.copyWith(isLoadMore: false, isProgress: false));
          }
        } catch (e) {
          emit(state.copyWith(isLoadMore: false, isProgress: false));
        }
        state.refreshController.refreshCompleted();
        state.refreshController.loadComplete();
      } else if (event is _refreshListEvent) {
        add(SupplierListProductsEvent.getPermissionList(context: event.context));
        emit(state.copyWith(isShimmering: true, pageNum: 0, productList: [], productStockList: [state.productStockList[0], [], []], isBottomOfProducts: false));
        add(SupplierListProductsEvent.getSupplierProductsListEvent(context: event.context, searchType: state.searchType, brandId: ''));
      } else if (event is _getProductDetailsEvent) {
        if (event.productListIndex != 2) {
          add(const SupplierListProductsEvent.removeRelatedProductEvent());
        }
        _isProductInCart = false;
        _cartProductId = '';
        _productQuantity = 0;

        try {
          emit(state.copyWith(isProductLoading: true, isSelectSupplier: false));
          final res = await DioClient(event.context).post(AppUrlEndPoints.getProductDetailsUrl, data: ProductDetailsReqModel(params: event.productId).toJson());
          ProductDetailsResModel response = ProductDetailsResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            //new changes
            //0 for barcode and search
            //1 for recommendation product.
            //2 related product.
            if (response.product!.isNotEmpty) {
              List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);
              int productListIndex = event.productListIndex;
              int productStockUpdateIndex = 0;
              if (event.isBarcode) {
                productStockUpdateIndex = 0;
                productStockList[0][0] = productStockList[0][0].copyWith(
                  quantity: _productQuantity,
                  productId: response.product?.first.id ?? '',
                  stock: (response.product?.first.supplierSales?.first.productStock.toString() ?? '0'),
                  maxQty: (response.product?.first.sale?.isSale ?? false) ? int.parse(response.product?.first.sale?.saleMaxQuantity ?? '0') : 0,
                );
              } else {
                productStockUpdateIndex = state.productStockList[productListIndex].indexWhere((productStock) => productStock.productId == event.productId);
              }
              emit(state.copyWith(productListIndex: productListIndex, productStockUpdateIndex: productStockUpdateIndex));
              try {
                final res = await DioClient(event.context).post('${AppUrlEndPoints.getAllCartUrl}${preferences.getCartId()}',
                    options: Options(
                      headers: {HttpHeaders.authorizationHeader: 'Bearer ${preferences.getAuthToken()}'},
                    ));
                GetAllCartResModel response = GetAllCartResModel.fromJson(res);
                if (response.status == AppConstants.code_200) {
                  response.data?.data?.forEach((cartProduct) {
                    if (cartProduct.id == event.productId || cartProduct.id == state.productStockList[state.productListIndex][state.productStockUpdateIndex].productId) {
                      _isProductInCart = true;
                      _cartProductId = cartProduct.cartProductId ?? '';
                      _productQuantity = cartProduct.totalQuantity ?? 0;
                      return;
                    }
                  });
                }
              } catch (_) {}
              emit(state.copyWith(isProductLoading: false, productDetails: response.product ?? []));
              if ((event.isBarcode)) {
                productStockList[0][0] = productStockList[0][0].copyWith(
                  quantity: _productQuantity,
                  productId: response.product?.first.id ?? '',
                  stock: (response.product?.first.supplierSales?.first.productStock.toString() ?? '0'),
                  maxQty: (response.product?.first.sale?.isSale ?? false) ? int.parse(response.product?.first.sale?.saleMaxQuantity ?? '0') : 0,
                );
                emit(state.copyWith(productStockList: productStockList));
              }

              List<ProductSupplierModel> supplierList = [];
              if (response.product!.isNotEmpty && event.productListIndex != 2) {
                add(SupplierListProductsEvent.relatedProductsEvent(context: event.context, productId: response.product?.first.id ?? ''));
              }
              supplierList.addAll(response.product?.first.supplierSales?.map((supplier) {
                    return ProductSupplierModel(
                        supplierId: supplier.supplierId ?? '',
                        companyName: supplier.supplierCompanyName ?? '',
                        basePrice: double.parse(supplier.productPrice ?? ''),
                        quantity: _productQuantity,
                        stock: supplier.productStock.toString(),
                        maxQty: (response.product?.first.sale?.isSale ?? false) ? int.parse(response.product?.first.sale?.saleMaxQuantity.toString() ?? '0') : 0,
                        selectedIndex: (supplier.supplierId) == state.productStockList[productListIndex][productStockUpdateIndex].productSupplierIds
                            ? !supplier.saleProduct!.contains(
                                supplier.saleProduct?.firstWhere(
                                      (sale) => sale.saleId == state.productStockList[productListIndex][productStockUpdateIndex].productSaleId,
                                      orElse: () => const SaleProduct(isSale: false, saleDescription: '', saleFromDate: '', saleMaxQuantity: '0', salePrice: '0', saleUntilDate: ''),
                                    ) ??
                                    const SaleProduct(isSale: false, saleDescription: '', saleFromDate: '', saleMaxQuantity: '0', salePrice: '0', saleUntilDate: ''),
                              )
                                ? -2
                                : supplier.saleProduct?.indexOf(
                                      supplier.saleProduct?.firstWhere(
                                            (sale) => sale.saleId == state.productStockList[productListIndex][productStockUpdateIndex].productSaleId,
                                            orElse: () => const SaleProduct(isSale: false, saleDescription: '', saleFromDate: '', saleMaxQuantity: '0', salePrice: '0', saleUntilDate: ''),
                                          ) ??
                                          const SaleProduct(isSale: false, saleDescription: '', saleFromDate: '', saleMaxQuantity: '0', salePrice: '0', saleUntilDate: ''),
                                    ) ??
                                    -1
                            : -1,
                        supplierSales: supplier.saleProduct
                                ?.map((sale) => SupplierSaleModel(
                                    productStock: sale.productStock ?? 0,
                                    quantity: _productQuantity,
                                    saleId: sale.saleId ?? '',
                                    saleName: sale.saleName ?? '',
                                    maxQty: sale.saleMaxQuantity,
                                    saleDescription: parse(sale.salesDescription ?? '').body?.text ?? '',
                                    salePrice: double.parse(sale.discountedPrice ?? '0.0'),
                                    saleDiscount: double.parse(
                                      sale.discountPercentage ?? '0.0',
                                    )))
                                .toList() ??
                            []);
                  }).toList() ??
                  []);
              supplierList.removeWhere((supplier) => supplier.stock == '0');

              String note = productStockList.isEmpty
                  ? ''
                  : productStockList.indexOf(state.productStockList.last) == productListIndex
                      ? ''
                      : productStockList[productListIndex][0].note;
              emit(state.copyWith(productStockList: []));
              emit(state.copyWith(
                productDetails: response.product ?? [],
                productStockList: productStockList,
                productStockUpdateIndex: productStockUpdateIndex,
                noteController: TextEditingController(text: note),
                productSupplierList: supplierList,
                productListIndex: productListIndex,
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
                        supplierSaleIndex = supplier.supplierSales.indexOf(sale);
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
                  add(SupplierListProductsEvent.supplierSelectionEvent(supplierIndex: supplierIndex, context: event.context, supplierSaleIndex: supplierSaleIndex));
                }
              }
            } else {
              emit(state.copyWith(isProductLoading: false, productDetails: []));
            }
          } else {
            emit(state.copyWith(isProductLoading: false, productDetails: []));
            Navigator.pop(event.context);
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? '', event.context), type: SnackBarType.failure);
          }
        } on ServerException {
          Navigator.pop(event.context);
        }
      } else if (event is _increaseQuantityOfProduct) {
        List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: false);
        if (state.productStockUpdateIndex != -1) {
          if (productStockList[state.productListIndex][state.productStockUpdateIndex].quantity < double.parse(productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString())) {
            if (productStockList[state.productListIndex][state.productStockUpdateIndex].productSupplierIds.isEmpty) {
              return;
            }
            if (productStockList[state.productListIndex][state.productStockUpdateIndex].maxQty != 0) {
              if (productStockList[state.productListIndex][state.productStockUpdateIndex].quantity >= productStockList[state.productListIndex][state.productStockUpdateIndex].maxQty) {
                CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppLocalizations.of(event.context)!.not_add_more_than_max_qty,
                  type: SnackBarType.failure,
                );
                return;
              }
            }
            productStockList[state.productListIndex][state.productStockUpdateIndex] = productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
              quantity: productStockList[state.productListIndex][state.productStockUpdateIndex].quantity + 1,
            );
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          } else {
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[state.productListIndex][state.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
              type: SnackBarType.failure,
            );
          }
        }
      } else if (event is _decreaseQuantityOfProduct) {
        List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: false);
        if (state.productStockUpdateIndex != -1) {
          if (productStockList[state.productListIndex][state.productStockUpdateIndex].quantity > 0) {
            productStockList[state.productListIndex][state.productStockUpdateIndex] = productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
              quantity: productStockList[state.productListIndex][state.productStockUpdateIndex].quantity - 1,
            );
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          }
        }
      } else if (event is _updateQuantityOfProduct) {
        List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: false);
        if (state.productStockUpdateIndex != -1) {
          String quantityString = event.quantity;
          if (quantityString.length == 2 && quantityString.startsWith('0')) {
            quantityString = quantityString.substring(1);
          }
          int newQuantity = int.tryParse(quantityString) ?? 0;
          if (newQuantity <= double.parse(productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString())) {
            productStockList[state.productListIndex][state.productStockUpdateIndex] = productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
              quantity: newQuantity,
            );
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          } else {
            productStockList[state.productListIndex][state.productStockUpdateIndex] = productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
              quantity: int.tryParse(quantityString.substring(0, quantityString.length - 1)) ?? 0,
            );
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[state.productListIndex][state.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
              type: SnackBarType.failure,
            );
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          }
        }
      } else if (event is _changeNoteOfProduct) {
        if (state.productStockUpdateIndex != -1) {
          List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: false);
          productStockList[state.productListIndex][state.productStockUpdateIndex] = productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
            note: state.noteController.text,
          );
          emit(state.copyWith(productStockList: productStockList));
        }
      } else if (event is _changeSupplierSelectionExpansionEvent) {
        emit(state.copyWith(isSelectSupplier: event.isSelectSupplier ?? !state.isSelectSupplier));
      } else if (event is _supplierSelectionEvent) {
        if (event.supplierIndex >= 0) {
          List<ProductSupplierModel> supplierList = state.productSupplierList.toList(growable: true);
          List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);
          productStockList[state.productListIndex][state.productStockUpdateIndex] = productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
            productSupplierIds: supplierList[event.supplierIndex].supplierId,
            totalPrice: event.supplierSaleIndex == -2 ? supplierList[event.supplierIndex].basePrice : supplierList[event.supplierIndex].supplierSales[event.supplierSaleIndex].salePrice,
            stock: supplierList[event.supplierIndex].stock,
            maxQty: supplierList[event.supplierIndex].maxQty,
            quantity: supplierList[event.supplierIndex].quantity != 0 ? supplierList[event.supplierIndex].quantity : 1,
            productSaleId: event.supplierSaleIndex == -2 ? '' : supplierList[event.supplierIndex].supplierSales[event.supplierSaleIndex].saleId,
          );
          supplierList = supplierList.map((supplier) => supplier.copyWith(selectedIndex: -1)).toList();
          supplierList[event.supplierIndex] = supplierList[event.supplierIndex].copyWith(selectedIndex: event.supplierSaleIndex);
          emit(state.copyWith(productSupplierList: supplierList, productStockList: productStockList));
        }
      } else if (event is _addToCartProductEvent) {
        if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSupplierIds.isEmpty) {
          return;
        }
        if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity == 0) {
          CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.add_1_quantity, type: SnackBarType.failure);
          return;
        }
        if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].maxQty > 0) {
          if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity > state.productStockList[state.productListIndex][state.productStockUpdateIndex].maxQty) {
            CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.not_add_more_than_max_qty, type: SnackBarType.failure);
            return;
          }
        }
        if (_isProductInCart) {
          try {
            emit(state.copyWith(isLoading: true));
            UpdateCartReqModel request = UpdateCartReqModel(
              productId: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productId == '' ? event.productId : state.productStockList[state.productListIndex][state.productStockUpdateIndex].productId,
              supplierId: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSupplierIds,
              saleId: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSaleId == '' ? null : state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSaleId,
              quantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
              cartProductId: _cartProductId,
            );
            final res = await DioClient(event.context).post('${AppUrlEndPoints.updateCartProductUrl}${preferences.getCartId()}', data: request);
            UpdateCartResModel response = UpdateCartResModel.fromJson(res);
            if (response.status == AppConstants.code_201) {
              Vibration.vibrate();
              List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);
              productStockList[state.productListIndex][state.productStockUpdateIndex] = productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
                note: '',
                productIsInCart: true,
                quantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                productSupplierIds: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSupplierIds,
                totalPrice: state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice,
                productSaleId: '',
              );
              emit(state.copyWith(isLoading: false, productStockList: productStockList, cartCount: preferences.getCartCount()));
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.success,
              );
            } else {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.failure,
              );
            }
          } on ServerException {
            emit(state.copyWith(isLoading: false));
          } catch (e) {
            emit(state.copyWith(isLoading: false));
          }
        } else {
          try {
            emit(state.copyWith(isLoading: true));
            insert.InsertCartReqModel insertCartReqModel = insert.InsertCartReqModel(products: [
              insert.Product(
                productId: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productId,
                quantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                supplierId: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSupplierIds,
                saleId: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSaleId.isEmpty ? null : state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSaleId,
                note: state.productStockList[state.productListIndex][state.productStockUpdateIndex].note.isEmpty ? null : state.productStockList[state.productListIndex][state.productStockUpdateIndex].note,
              )
            ]);
            Map<String, dynamic> req = insertCartReqModel.toJson();
            req.removeWhere((key, value) {
              if (value != null) {}
              return value == null;
            });
            final res = await DioClient(event.context).post('${AppUrlEndPoints.insertProductInCartUrl}${preferences.getCartId()}',
                data: req,
                options: Options(
                  headers: {HttpHeaders.authorizationHeader: 'Bearer ${preferences.getAuthToken()}'},
                ));
            InsertCartResModel response = InsertCartResModel.fromJson(res);
            if (response.status == AppConstants.code_201) {
              if (!state.productStockList[state.productListIndex][state.productStockUpdateIndex].productIsInCart) {
                add(const SupplierListProductsEvent.setCartCountEvent());
              }
              Vibration.vibrate();
              List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);
              productStockList[state.productListIndex][state.productStockUpdateIndex] = productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
                note: '',
                productIsInCart: true,
                quantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                productSupplierIds: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSupplierIds,
                totalPrice: state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice,
                productSaleId: '',
              );
              add(const SupplierListProductsEvent.getCartCountEvent());
              emit(state.copyWith(isLoading: false, productStockList: productStockList, duringCelebration: true));
              await Future.delayed(const Duration(milliseconds: 500));
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.success,
              );
            } else if (response.status == AppConstants.code_403) {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.failure,
              );
            } else {
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.failure,
              );
            }
          } on ServerException {
            emit(state.copyWith(isLoading: false));
          } catch (e) {
            emit(state.copyWith(isLoading: false));
          }
        }
      } else if (event is _setCartCountEvent) {
        preferences.setCartCount(count: preferences.getCartCount() + 1);
        emit(state.copyWith(isSubUserAddToBasket: preferences.getCanAddToBasket()));
      } else if (event is _updateImageIndexEvent) {
        emit(state.copyWith(imageIndex: event.index));
      } else if (event is _getGridListView) {
        preferences.setSupplierProductGridListView(isSupplierProductGrid: !state.isGridView);
        emit(state.copyWith(isGridView: !state.isGridView));
      } else if (event is _changeCategoryExpansion) {
        if (event.isOpened == false) {
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
      } else if (event is _globalSearchEvent) {
        emit(state.copyWith(search: state.searchController.text, bottleDeposit: preferences.getBottleTax()));
        try {
          GlobalSearchReqModel globalSearchReqModel = GlobalSearchReqModel(
            search: state.searchController.text,
            sortField: AppStrings.sortFieldString,
            sortOrder: AppStrings.sortOrderString,
          );
          emit(state.copyWith(isSearching: true));
          final res = await DioClient(event.context).post(AppUrlEndPoints.getPlanogramAllProductForSearchUrl, data: globalSearchReqModel.toJson());
          GlobalSearchResModel response = GlobalSearchResModel.fromJson(res);
          if (state.searchController.text == '') {
            List<SearchModel> searchList = [];
            searchList.addAll(state.productCategoryList.map((category) => SearchModel(
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

            searchList.addAll(response.data
                    ?.map((supplier) => SearchModel(
                          searchId: supplier.id ?? '',
                          name: supplier.productName ?? '',
                          searchType: SearchTypes.product,
                          image: supplier.mainImage ?? '',
                          productStock: supplier.productStock.toString(),
                          numberOfUnits: int.parse(supplier.numberOfUnit.toString()),
                          scaleType: supplier.scaleType!,
                          priceOfBox: double.parse(supplier.productPrice.toString()),
                          lowStock: supplier.lowStock.toString(),
                          isPesach: supplier.isPesach ?? false,
                          salePrice: double.parse(supplier.sale?.salePrice.toString() ?? '0'),
                          salesDesc: parse(supplier.sale?.saleDescription ?? '').body?.text ?? '',
                          supplierId: supplier.supplierId,
                          isSale: supplier.sale?.isSale,
                          saleMinQuantity: supplier.sale?.saleMinQuantity,
                          saleMaxQuantity: supplier.sale?.saleMaxQuantity,
                          isMixedSale: supplier.sale?.isMixedSale,
                          sameSaleProducts: supplier.sale?.sameSaleProducts,
                          recommendedConsumerOffer: supplier.recommendedConsumerOffer,
                          recommendedRetailPrice: supplier.recommendedRetailPrice,
                        ))
                    .toList() ??
                []);

            final cartMap = await fetchCartQuantities(event.context);
            List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);
            final stockList = response.data?.map((searchProduct) {
              final productId = searchProduct.id ?? '';
              return ProductStockModel(
                maxQty: (searchProduct.sale?.isSale ?? false) ? int.parse(searchProduct.sale?.saleMaxQuantity ?? '0') : 0,
                productId: productId,
                stock: searchProduct.productStock.toString(),
                quantity: cartMap[productId] ?? 0,
              );
            }).toList();
            productStockList[0] = stockList ?? [];
            emit(state.copyWith(searchList: searchList, productStockList: productStockList, search: state.searchController.text, isSearching: false));
          } else {
            emit(state.copyWith(isSearching: false));
          }
        } on ServerException {
          CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.something_is_wrong_try_again, type: SnackBarType.failure);
          emit(state.copyWith(isSearching: false));
        } catch (exc) {
          CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.something_is_wrong_try_again, type: SnackBarType.failure);
          emit(state.copyWith(isSearching: false));
        }
      } else if (event is _updateGlobalSearchEvent) {
        emit(state.copyWith(searchController: TextEditingController(text: event.search), searchList: event.searchList));
      } else if (event is _relatedProductsEvent) {
        emit(state.copyWith(isRelatedShimmering: true));
        try {
          final res = await DioClient(event.context).post(AppUrlEndPoints.relatedProductsUrl, data: {'mainProductId': event.productId});
          RelatedProductResModel response = RelatedProductResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            final cartMap = await fetchCartQuantities(event.context);
            List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);
            while (productStockList.length < 3) {
              productStockList.add([]);
            }

            final freshRelatedStockList = response.data
                    ?.map(
                      (product) => ProductStockModel(productId: product.id ?? '', stock: product.productStock.toString(), quantity: cartMap[product.id] ?? 0),
                    )
                    .toList() ??
                [];
            productStockList[2] = freshRelatedStockList;
            emit(state.copyWith(relatedProductList: response.data ?? [], isRelatedShimmering: false, productStockList: productStockList, isProductLoading: false));
          } else {
            emit(state.copyWith(isRelatedShimmering: false, isProductLoading: false));
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? '', event.context), type: SnackBarType.success);
          }
        } catch (e) {
          emit(state.copyWith(isRelatedShimmering: false, isProductLoading: false));
        }
      } else if (event is _removeRelatedProductEvent) {
        emit(state.copyWith(relatedProductList: []));
      } else if (event is _getPermissionList) {
        if (preferences.getSubUser()) {
          try {
            final res = await DioClient(event.context).get(path: '${AppUrlEndPoints.getAccountPermissionUrl}${preferences.getSubUserId()}');
            AccountPermissionResModel response = AccountPermissionResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              var res = response.data?.permissions;
              preferences.setCanSeeWallet(isSeeWallet: res?.canSeeWallet ?? false);
              preferences.setCanAddBasket(isAddBasket: res?.canAddToCart ?? false);
              preferences.setCanCreateOrder(isCreateOrder: res?.canCreateOrder ?? false);
              preferences.setCanSeeOrder(isSeeOrder: res?.canSeeOrders ?? false);
              preferences.setCanDuplicateOrder(isDuplicateOrder: res?.canDuplicateOrders ?? false);
              preferences.setCanUpdateBusinessInfo(isUpdateBusinessInfo: res?.canSeeAndUpdateBusinessInfo ?? false);
              preferences.setCanUpdateAdditionalInfo(isUpdateAdditionalInfo: res?.canSeeAndUpdateAdditionalInfo ?? false);
              preferences.setCanUpdateTimeInfo(isUpdateTimeInfo: res?.canSeeAndUpdateTimesInfo ?? false);
              preferences.setCanSeeFormsFiles(isSeeFormsFiles: res?.canSeeFileAndForms ?? false);
              preferences.setManageSubUser(isManageSubUser: res?.canManageSubUsers ?? false);
              preferences.setCanSeeInvoices(isCanSeeInvoices: res?.canSeeInvoices ?? false);
              preferences.setCanSeeReturns(isCanSeeReturns: res?.returns ?? false);
              emit(state.copyWith(isSubUserAddToBasket: res?.canAddToCart ?? false));
            } else {
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.failure,
              );
            }
          } catch (e) {
            CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
          }
        }
      } else if (event is _userApproveEvent) {
        if (!preferences.getGuestUser()) {
          try {
            final res = await DioClient(event.context).post(AppUrlEndPoints.verifyClientUrl, data: {AppStrings.clientIdString: preferences.getUserId()});
            VerifyClientResModel response = VerifyClientResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              if (!(response.data?.isFilledForms ?? false) || !(response.data?.isRegisterForm ?? false)) {
                Navigator.pushNamed(event.context, RouteDefine.formDataScreen.name);
              } else if (!(response.data?.isUploadedFiles ?? false) && (response.data?.isRegisterForm ?? false) && (response.data?.isFilledForms ?? false)) {
                Navigator.pushNamed(event.context, RouteDefine.fileUploadScreen.name);
              }
            }
          } catch (_) {}
        }
      } else if (event is _increaseListQuantityOfProductEvent) {
        List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: false);
        if (event.productStockUpdateIndex != -1) {
          if (productStockList[event.productListIndex][event.productStockUpdateIndex].quantity <
              double.parse(
                productStockList[event.productListIndex][event.productStockUpdateIndex].stock.toString(),
              )) {
            if (event.productSupplierIds.isEmpty) {
              return;
            }

            if (productStockList[event.productListIndex][event.productStockUpdateIndex].maxQty != 0) {
              if (productStockList[event.productListIndex][event.productStockUpdateIndex].quantity >= productStockList[event.productListIndex][event.productStockUpdateIndex].maxQty) {
                CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.not_add_more_than_max_qty, type: SnackBarType.failure);
                return;
              }
            }

            productStockList[event.productListIndex][event.productStockUpdateIndex] = productStockList[event.productListIndex][event.productStockUpdateIndex].copyWith(
              quantity: productStockList[event.productListIndex][event.productStockUpdateIndex].quantity + 1,
            );
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          } else {
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[event.productListIndex][event.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
              type: SnackBarType.failure,
            );
          }
        }
      } else if (event is _decreaseListQuantityOfProductEvent) {
        List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: false);
        if (event.productStockUpdateIndex != -1) {
          if (productStockList[event.productListIndex][event.productStockUpdateIndex].quantity > 0) {
            productStockList[event.productListIndex][event.productStockUpdateIndex] = productStockList[event.productListIndex][event.productStockUpdateIndex].copyWith(
              quantity: productStockList[event.productListIndex][event.productStockUpdateIndex].quantity - 1,
            );
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          }
        }
      } else if (event is _updateListQuantityOfProductEvent) {
        List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: false);
        if (event.productStockUpdateIndex != -1) {
          String quantityString = event.quantity;
          if (quantityString.length == 2 && quantityString.startsWith('0')) {
            quantityString = quantityString.substring(1);
          }
          int newQuantity = int.tryParse(quantityString) ?? 0;
          if (newQuantity <= double.parse(productStockList[event.productListIndex][event.productStockUpdateIndex].stock.toString())) {
            productStockList[event.productListIndex][event.productStockUpdateIndex] = productStockList[event.productListIndex][event.productStockUpdateIndex].copyWith(quantity: newQuantity);
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          } else {
            productStockList[event.productListIndex][event.productStockUpdateIndex] = productStockList[event.productListIndex][event.productStockUpdateIndex].copyWith(
                quantity: int.tryParse(quantityString.substring(
                      0,
                      quantityString.length - 1,
                    )) ??
                    0);
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[event.productListIndex][event.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
              type: SnackBarType.failure,
            );
            emit(state.copyWith(productStockList: []));
            emit(state.copyWith(productStockList: productStockList));
          }
        }
      } else if (event is _addToCartListProductEvent) {
        _isProductInCart = false;

        if (event.productSupplierIds.isEmpty) {
          return;
        }

        if (state.productStockList[event.productListIndex][event.productStockUpdateIndex].maxQty > 0) {
          if (state.productStockList[event.productListIndex][event.productStockUpdateIndex].quantity > state.productStockList[event.productListIndex][event.productStockUpdateIndex].maxQty) {
            CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.not_add_more_than_max_qty, type: SnackBarType.failure);
            return;
          }
        }

        if (state.productStockList[event.productListIndex][event.productStockUpdateIndex].quantity == 0) {
          final res = await DioClient(event.context).post('${AppUrlEndPoints.getAllCartUrl}${preferences.getCartId()}');
          if (res != null) {
            final response = GetAllCartResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              final cartList = response.data?.data;

              if (cartList != null && cartList.isNotEmpty) {
                for (var item in cartList) {
                  final productDetails = item.productDetails;
                  if (productDetails != null && productDetails.id == event.productId) {
                    final cartProductId = item.cartProductId;
                    try {
                      final player = AudioPlayer();
                      final response = await DioClient(event.context).post(AppUrlEndPoints.removeCartProductUrl, data: {AppStrings.cartProductIdString: cartProductId});

                      if (response[AppStrings.statusString] == AppConstants.code_200) {
                        player.play(AssetSource(AppStrings.deleteSound));
                        await preferences.setCartCount(count: preferences.getCartCount() - 1);
                        emit(state.copyWith(cartCount: preferences.getCartCount()));
                        break;
                      }
                    } catch (_) {}
                  }
                }
              }
            }
          }
          CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.record_deleted_successfully, type: SnackBarType.success);
        } else {
          try {
            final res = await DioClient(event.context).post('${AppUrlEndPoints.getAllCartUrl}${preferences.getCartId()}');
            GetAllCartResModel response = GetAllCartResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              response.data?.data?.forEach((cartProduct) {
                if (cartProduct.id == event.productId || cartProduct.id == state.productStockList[event.productListIndex][event.productStockUpdateIndex].productId) {
                  _isProductInCart = true;
                  _cartProductId = cartProduct.cartProductId ?? '';
                  _productQuantity = cartProduct.totalQuantity ?? 0;
                  return;
                }
              });
            }
          } catch (_) {}
          if (_isProductInCart) {
            try {
              UpdateCartReqModel request = UpdateCartReqModel(
                productId: event.productId,
                supplierId: event.productSupplierIds,
                saleId: state.productStockList[event.productListIndex][event.productStockUpdateIndex].productSaleId == '' ? null : state.productStockList[event.productListIndex][event.productStockUpdateIndex].productSaleId,
                quantity: state.productStockList[event.productListIndex][event.productStockUpdateIndex].quantity,
                cartProductId: _cartProductId,
              );
              final res = await DioClient(event.context).post('${AppUrlEndPoints.updateCartProductUrl}${preferences.getCartId()}', data: request);
              UpdateCartResModel response = UpdateCartResModel.fromJson(res);
              if (response.status == AppConstants.code_201) {
                Vibration.vibrate();
                List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);
                productStockList[event.productListIndex][event.productStockUpdateIndex] = productStockList[event.productListIndex][event.productStockUpdateIndex].copyWith(
                  note: '',
                  productIsInCart: false,
                  productSupplierIds: event.productSupplierIds,
                  quantity: productStockList[event.productListIndex][event.productStockUpdateIndex].quantity,
                  totalPrice: productStockList[event.productListIndex][event.productStockUpdateIndex].totalPrice,
                  productSaleId: productStockList[event.productListIndex][event.productStockUpdateIndex].productSaleId,
                );
                emit(state.copyWith(productStockList: productStockList));
                CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                  type: SnackBarType.success,
                );
              } else {
                Navigator.pop(event.context);
                CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                  type: SnackBarType.failure,
                );
              }
            } catch (_) {}
          } else {
            try {
              insert.InsertCartReqModel insertCartReqModel = insert.InsertCartReqModel(
                products: [
                  insert.Product(
                    productId: event.productId,
                    quantity: state.productStockList[event.productListIndex][event.productStockUpdateIndex].quantity,
                    supplierId: event.productSupplierIds,
                    saleId: state.productStockList[event.productListIndex][event.productStockUpdateIndex].productSaleId.isEmpty ? null : state.productStockList[event.productListIndex][event.productStockUpdateIndex].productSaleId,
                    note: state.productStockList[event.productListIndex][event.productStockUpdateIndex].note.isEmpty ? null : state.productStockList[event.productListIndex][event.productStockUpdateIndex].note,
                  ),
                ],
              );
              Map<String, dynamic> req = insertCartReqModel.toJson();
              req.removeWhere((key, value) {
                if (value != null) {}
                return value == null;
              });
              final res = await DioClient(event.context).post('${AppUrlEndPoints.insertProductInCartUrl}${preferences.getCartId()}', data: req);
              InsertCartResModel response = InsertCartResModel.fromJson(res);
              if (response.status == AppConstants.code_201) {
                add(const SupplierListProductsEvent.setCartCountEvent());
                Vibration.vibrate();
                List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);
                productStockList[event.productListIndex][event.productStockUpdateIndex] = productStockList[event.productListIndex][event.productStockUpdateIndex].copyWith(
                  note: '',
                  productIsInCart: true,
                  quantity: state.productStockList[event.productListIndex][event.productStockUpdateIndex].quantity,
                  productSupplierIds: state.productStockList[event.productListIndex][event.productStockUpdateIndex].productSupplierIds,
                  totalPrice: productStockList[event.productListIndex][event.productStockUpdateIndex].totalPrice,
                  productSaleId: productStockList[event.productListIndex][event.productStockUpdateIndex].productSaleId,
                );
                add(const SupplierListProductsEvent.getCartCountEvent());
                emit(state.copyWith(productStockList: productStockList, duringCelebration: true));
                await Future.delayed(const Duration(milliseconds: 500));
                emit(state.copyWith(duringCelebration: false));
                CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                  type: SnackBarType.success,
                );
              } else if (response.status == AppConstants.code_403) {
                // CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.failure);
              } else {
                CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                  type: SnackBarType.failure,
                );
              }
            } catch (_) {}
          }
        }
      } else if (event is _getCartCountEvent) {
        emit(state.copyWith(cartCount: preferences.getCartCount(), isSubUserAddToBasket: preferences.getCanAddToBasket()));
      } else if (event is _getCartCountNoEvent) {
        try {
          final res = await DioClient(event.context).post('${AppUrlEndPoints.getAllCartUrl}${preferences.getCartId()}');
          if (res != null) {
            GetAllCartResModel response = GetAllCartResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              emit(state.copyWith(isCartCountChange: true));
              await preferences.setCartCount(count: response.data?.data?.length ?? preferences.getCartCount());
              emit(state.copyWith(cartCount: preferences.getCartCount(), isCartCountChange: false));
            }
          }
        } catch (_) {}
        try {
          final res = await DioClient(event.context).post(AppUrlEndPoints.getUnreadMessageCountUrl,
              options: Options(
                headers: {HttpHeaders.authorizationHeader: 'Bearer ${preferences.getAuthToken()}'},
              ));
          MessageCountResModel response = MessageCountResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            await preferences.setMessageCount(count: response.data ?? preferences.getMessageCount());
            emit(state.copyWith(messageCount: response.data ?? 0));
          }
        } catch (_) {}
      } else if (event is _applyListCartQuantitiesEvent) {
        final cartMap = event.cartQuantities;
        final productStockList = state.productStockList.map((e) => List<ProductStockModel>.from(e)).toList();
        if (productStockList.isNotEmpty && productStockList[0].isNotEmpty) {
          final pid = productStockList[0][0].productId;
          if (pid.isNotEmpty) {
            productStockList[0][0] = productStockList[0][0].copyWith(quantity: cartMap[pid] ?? 0, productSupplierIds: '', productSaleId: '', totalPrice: 0.0, cartProductId: '');
          }
        }
        if (productStockList.length > 1) {
          final prodList = state.productList.length;
          final prodStockList = productStockList[1].length;
          final listLen = prodList < prodStockList ? prodList : prodStockList;
          for (var i = 0; i < listLen; i++) {
            final pid = state.productList[i].id ?? '';
            productStockList[1][i] = productStockList[1][i].copyWith(quantity: cartMap[pid] ?? 0, productSupplierIds: '', productSaleId: '', totalPrice: 0.0, cartProductId: '');
          }
        }
        if (productStockList.length > 2) {
          for (var i = 0; i < productStockList[2].length; i++) {
            final pid = productStockList[2][i].productId;
            if (pid.isNotEmpty) {
              productStockList[2][i] = productStockList[2][i].copyWith(quantity: cartMap[pid] ?? 0, productSupplierIds: '', productSaleId: '', totalPrice: 0.0, cartProductId: '');
            }
          }
        }
        emit(state.copyWith(productStockList: productStockList));
      }
    });
  }
}
