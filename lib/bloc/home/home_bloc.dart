import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import '../../data/model/req_model/product_sales_req_model/product_sales_req_model.dart';
import '../../data/model/req_model/suppliers_req_model/suppliers_req_model.dart';
import '../../data/model/req_model/update_cart/update_cart_req_model.dart';
import '../../data/model/res_model/message_count_res_model/message_count_res_model.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';
import '../../data/model/res_model/related_product_res_model/related_product_res_model.dart';
import '../../data/model/res_model/setting_res_model/setting_res_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_version_checker/store_version_checker.dart';
import 'package:vibration/vibration.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../../data/model/req_model/get_messages_req_model/get_messages_req_model.dart';
import '../../data/model/req_model/get_order_count/get_order_count_req_model.dart';
import '../../data/model/req_model/global_search_req_model/global_search_req_model.dart';
import '../../data/model/req_model/insert_cart_req_model/insert_cart_req_model.dart' as insert;
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/req_model/profile_details_req_model/profile_details_req_model.dart';
import '../../data/model/req_model/recommendation_products_req_model/recommendation_products_req_model.dart';
import '../../data/model/res_model/account_permission/account_permission_res_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/get_messages_res_model/get_messages_res_model.dart';
import '../../data/model/res_model/global_search_res_model/global_search_res_model.dart';
import '../../data/model/res_model/insert_cart_res_model/insert_cart_res_model.dart';
import '../../data/model/res_model/order_count/get_order_count_res_model.dart';
import '../../data/model/res_model/product_sales_res_model/product_sales_res_model.dart';
import '../../data/model/res_model/profile_details_res_model/profile_details_res_model.dart';
import '../../data/model/res_model/suppliers_list_response_model/suppliers_list_response_model.dart';
import '../../data/model/res_model/update_cart_res/update_cart_res_model.dart';
import '../../data/model/res_model/verify_client_res_model/verify_client_res_model.dart';
import '../../data/model/search_model/search_model.dart';
import '../../data/model/supplier_sale_model/supplier_sale_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../data/model/res_model/recommendation_products_res_model/recommendation_products_res_model.dart';
import '../../data/model/res_model/product_categories_res_model/product_categories_res_model.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
import '../bottom_nav/bottom_nav_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  bool _isProductInCart = false;
  String _cartProductId = '';
  int _productQuantity = 0;
  String _productId = '';
  String _supplierId = "";

  HomeBloc() : super(HomeState.initial()) {
    on<HomeEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (preferences.getGuestUser()) {
      } else {
        if (event is _getPreferencesDataEvent) {
          emit(state.copyWith(
            isIncludedVat: preferences.getIsIncludedVat(),
            isSaleOn: preferences.getShowSale(),
            isSubUserSeeWallet: preferences.getCanSeeWallet(),
            isSubUserAddToBasket: preferences.getCanAddToBasket(),
            userImageUrl: preferences.getUserImageUrl(),
            userCompanyLogoUrl: preferences.getUserCompanyLogoUrl(),
            messageCount: preferences.getMessageCount(),
            cartCount: preferences.getCartCount(),
            bottlePrice: preferences.getBottleTax(),
            clubAgentId: preferences.getClubAgentId(),
          ));
        } else if (event is _getProductDetailsEvent) {
          emit(state.copyWith(isCartCountChange: false));
          add(const HomeEvent.removeRelatedProductEvent());

          _isProductInCart = false;
          _cartProductId = '';
          _productQuantity = 0;
          _productId = '';
          _supplierId = '';
          try {
            emit(state.copyWith(isProductLoading: true));

            final res = await DioClient(event.context).post(AppUrlEndPoints.getProductDetailsUrl, data: ProductDetailsReqModel(params: event.productId).toJson());
            ProductDetailsResModel response = ProductDetailsResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              //new changes
              //0 for barcode and search
              //1 for recommendation product.
              //2 related product.
              //3 sales product.

              if (response.product?.isNotEmpty ?? false) {
                List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);
                int productListIndex = event.productListIndex;
                int productStockUpdateIndex = 0;
                var productDetailData = response.product?.first;
                if (event.isBarcode) {
                  productStockUpdateIndex = 0;
                  productStockList[0][0] = productStockList[0][0].copyWith(
                    quantity: _productQuantity,
                    productId: productDetailData?.id ?? '',
                    stock: (productDetailData?.supplierSales?.first.productStock.toString() ?? '0'),
                    maxQty: (productDetailData?.sale?.isSale ?? false) ? int.parse(productDetailData?.sale?.saleMaxQuantity ?? '0') : 0,
                  );
                } else {
                  productStockUpdateIndex = state.productStockList[productListIndex].indexWhere((productStock) => productStock.productId == event.productId);
                }

                emit(state.copyWith(productListIndex: productListIndex, productStockUpdateIndex: productStockUpdateIndex));
                try {
                  final res = await DioClient(event.context).post('${AppUrlEndPoints.getAllCartUrl}${preferences.getCartId()}');
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

                if (event.isBarcode) {
                  productStockList[0][0] = productStockList[0][0].copyWith(
                    quantity: _productQuantity,
                    productId: productDetailData?.id ?? '',
                    stock: (productDetailData?.supplierSales?.first.productStock.toString() ?? '0'),
                    maxQty: (productDetailData?.sale?.isSale ?? false) ? int.parse(productDetailData?.sale?.saleMaxQuantity ?? '0') : 0,
                  );
                  emit(state.copyWith(productStockList: productStockList));
                }

                List<ProductSupplierModel> supplierList = [];
                supplierList.addAll(productDetailData?.supplierSales?.map((supplier) {
                      return ProductSupplierModel(
                        supplierId: supplier.supplierId ?? '',
                        companyName: supplier.supplierCompanyName ?? '',
                        basePrice: double.parse(supplier.productPrice ?? ''),
                        quantity: _productQuantity,
                        stock: supplier.productStock.toString(),
                        maxQty: (productDetailData.sale?.isSale ?? false) ? int.parse(productDetailData.sale?.saleMaxQuantity.toString() ?? '') : 0,
                        selectedIndex: (supplier.supplierId) == state.productStockList[productListIndex][productStockUpdateIndex].productSupplierIds
                            ? supplier.saleProduct!.contains(
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
                                      saleDiscount: double.parse(sale.discountPercentage ?? '0.0'),
                                    ))
                                .toList() ??
                            [],
                      );
                    }).toList() ??
                    []);
                supplierList.removeWhere((supplier) => supplier.stock == '0');
                emit(state.copyWith(productStockList: []));
                emit(state.copyWith(
                  productDetails: response.product ?? [],
                  productStockList: productStockList,
                  productStockUpdateIndex: productStockUpdateIndex,
                  productSupplierList: supplierList,
                  productListIndex: productListIndex,
                ));
                if (response.product!.isNotEmpty) {
                  add(HomeEvent.relatedProductsEvent(context: event.context, productId: productDetailData?.id ?? ''));
                } else {
                  emit(state.copyWith(isProductLoading: false));
                }
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
                    add(HomeEvent.supplierSelectionEvent(supplierIndex: supplierIndex, context: event.context, supplierSaleIndex: supplierSaleIndex));
                  }
                }
              } else {
                emit(state.copyWith(isProductLoading: false, productDetails: []));
              }
            } else {
              emit(state.copyWith(isProductLoading: false));
              Navigator.pop(event.context);
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? '', event.context),
                type: SnackBarType.failure,
              );
            }
          } on ServerException {
            Navigator.pop(event.context);
            emit(state.copyWith(isProductLoading: false));
          }
        } else if (event is _getProductSalesListEvent) {
          try {
            emit(state.copyWith(isProductSaleShimmering: true));
            final res = await DioClient(event.context).post(
              AppUrlEndPoints.getSaleProductsUrl,
              data: const ProductSalesReqModel(pageNum: 1, pageLimit: AppConstants.defaultPageLimit).toJson(),
            );

            final response = ProductSalesResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              final cartMap = await fetchCartQuantities(event.context);

              List<ProductSale> productSaleList = response.data ?? [];
              List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);

              final stockList = productSaleList.map((saleProduct) {
                final productId = saleProduct.id ?? '';
                return ProductStockModel(
                  maxQty: (saleProduct.sale?.isSale ?? false) ? int.parse(saleProduct.sale?.saleMaxQuantity ?? '0') : 0,
                  productId: productId,
                  stock: saleProduct.productStock.toString(),
                  quantity: cartMap[productId] ?? 0,
                );
              }).toList();
              productStockList[3] = stockList;
              emit(state.copyWith(productSalesList: productSaleList, productStockList: productStockList, isProductSaleShimmering: false, allShimmering: false));
            } else {
              emit(state.copyWith(isProductSaleShimmering: false, allShimmering: false));
            }
          } catch (_) {
            emit(state.copyWith(isProductSaleShimmering: false, allShimmering: false));
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
                  CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.not_add_more_than_max_qty, type: SnackBarType.failure);
                  return;
                }
              }
              productStockList[state.productListIndex][state.productStockUpdateIndex] = productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(quantity: productStockList[state.productListIndex][state.productStockUpdateIndex].quantity + 1);
              emit(state.copyWith(productStockList: []));
              emit(state.copyWith(productStockList: productStockList));
            } else {
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: "${AppLocalizations.of(event.context)!.this_supplier_have}"
                    "${productStockList[state.productListIndex][state.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
                type: SnackBarType.failure,
              );
            }
          }
        } else if (event is _decreaseQuantityOfProduct) {
          List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: false);
          if (state.productStockUpdateIndex != -1) {
            if (productStockList[state.productListIndex][state.productStockUpdateIndex].quantity > 0) {
              productStockList[state.productListIndex][state.productStockUpdateIndex] = productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(quantity: productStockList[state.productListIndex][state.productStockUpdateIndex].quantity - 1);
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
              productStockList[state.productListIndex][state.productStockUpdateIndex] = productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(quantity: newQuantity);
              emit(state.copyWith(productStockList: []));
              emit(state.copyWith(productStockList: productStockList));
            } else {
              productStockList[state.productListIndex][state.productStockUpdateIndex] = productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(quantity: int.tryParse(quantityString.substring(0, quantityString.length - 1)) ?? 0);
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: "${AppLocalizations.of(event.context)!.this_supplier_have}"
                    "${productStockList[state.productListIndex][state.productStockUpdateIndex].stock}"
                    "${AppLocalizations.of(event.context)!.quantity_in_stock}",
                type: SnackBarType.failure,
              );
              emit(state.copyWith(productStockList: []));
              emit(state.copyWith(productStockList: productStockList));
            }
          }
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
                state.productStockList[state.productListIndex][state.productStockUpdateIndex] = state.productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
                  note: '',
                  productIsInCart: false,
                  productSupplierIds: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSupplierIds,
                  quantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                  totalPrice: state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice,
                  productSaleId: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSaleId,
                );
                emit(state.copyWith(isLoading: false, productStockList: productStockList));
                if (event.context.mounted) {
                  BlocProvider.of<BottomNavBloc>(event.context).add(BottomNavEvent.updateCartCountEvent(context: event.context));
                }
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
                emit(state.copyWith(isLoading: false));
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
                ),
              ]);
              Map<String, dynamic> req = insertCartReqModel.toJson();
              req.removeWhere((key, value) {
                if (value != null) {}
                return value == null;
              });
              final res = await DioClient(event.context).post('${AppUrlEndPoints.insertProductInCartUrl}${preferences.getCartId()}', data: req);
              InsertCartResModel response = InsertCartResModel.fromJson(res);
              if (response.status == AppConstants.code_201) {
                if (_productId == '' && _supplierId == '') {
                  add(const HomeEvent.setCartCountEvent());
                }
                _productId = state.productStockList[state.productListIndex][state.productStockUpdateIndex].productId;
                _supplierId = state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSupplierIds;
                Vibration.vibrate();
                List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);
                productStockList[state.productListIndex][state.productStockUpdateIndex] = productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
                  note: '',
                  productIsInCart: true,
                  quantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                  productSupplierIds: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSupplierIds,
                  totalPrice: productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice,
                  productSaleId: productStockList[state.productListIndex][state.productStockUpdateIndex].productSaleId,
                );
                emit(state.copyWith(isLoading: false, productStockList: productStockList, isCartCountChange: false));
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
          await preferences.setCartCount(count: preferences.getCartCount() + 1);
          emit(state.copyWith(cartCount: preferences.getCartCount(), isCartCountChange: true));
        } else if (event is _getOrderCountEvent) {
          try {
            int daysInMonth(DateTime date) => DateTimeRange(start: DateTime(date.year, date.month, 1), end: DateTime(date.year, date.month + 1)).duration.inDays;
            var now = DateTime.now();
            GetOrderCountReqModel reqMap = GetOrderCountReqModel(
              startDate: DateTime(now.year, now.month, 1),
              endDate: DateTime(now.year, now.month, daysInMonth(DateTime.now())),
            );
            final res = await DioClient(event.context).post(AppUrlEndPoints.getOrdersCountUrl, data: reqMap);
            GetOrderCountResModel response = GetOrderCountResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              emit(state.copyWith(orderThisMonth: response.data!.toInt()));
            }
          } catch (_) {}
        } else if (event is _getMessageListEvent) {
          try {
            final res = await DioClient(event.context).post(AppUrlEndPoints.getNotificationMessageUrl, data: const GetMessagesReqModel(pageNum: 1, pageLimit: 2).toJson());
            if (res != null) {
              GetMessagesResModel response = GetMessagesResModel.fromJson(res);
              if (response.status == AppConstants.code_200) {
                emit(state.copyWith(messageList: []));
                List<MessageData> messageList = state.messageList.toList(growable: true);
                if (response.data?.isNotEmpty ?? false) {
                  messageList.addAll(response.data
                          ?.map((message) => MessageData(
                                id: message.id,
                                isRead: message.isRead,
                                message: Message(
                                  id: message.message?.id ?? '',
                                  title: message.message?.title ?? '',
                                  summary: message.message?.summary ?? '',
                                  body: message.message?.body ?? '',
                                  messageImage: message.message?.messageImage ?? '',
                                  subPage: message.message?.subPage ?? '',
                                  mainPage: message.message?.mainPage ?? '',
                                  navigationId: message.message?.navigationId ?? '',
                                ),
                                createdAt: message.createdAt,
                                updatedAt: message.updatedAt,
                              ))
                          .toList() ??
                      []);
                }
                emit(state.copyWith(messageList: messageList, isMessageShimmering: false));
              }
            }
          } catch (_) {}
        } else if (event is _removeOrUpdateMessageEvent) {
          List<MessageData> messageList = state.messageList.toList(growable: true);
          if (event.isRead) {
            if (messageList[messageList.indexOf(messageList.firstWhere((message) => message.id == event.messageId))].isRead == false) {
              await preferences.setMessageCount(count: preferences.getMessageCount() - 1);
              messageList[messageList.indexOf(messageList.firstWhere((message) => message.id == event.messageId))] = messageList[messageList.indexOf(messageList.firstWhere((message) => message.id == event.messageId))].copyWith(
                isRead: true,
              );
              emit(state.copyWith(messageCount: state.messageCount - 1));
            }
          }
          if (event.isDelete) {
            messageList.removeWhere((message) => message.id == event.messageId);
          }
          emit(state.copyWith(messageList: []));
          emit(state.copyWith(messageList: messageList));
        } else if (event is _updateMessageListEvent) {
          if (event.messageIdList.isNotEmpty) {
            List<MessageData> messageList = state.messageList.toList(growable: true);
            messageList.removeWhere((message) => event.messageIdList.contains(message.id));
            emit(state.copyWith(messageList: messageList));
          }
        } else if (event is _getProfileDetailsEvent) {
          try {
            final res = await DioClient(event.context).post(AppUrlEndPoints.getProfileDetailsUrl,
                data: ProfileDetailsReqModel(id: preferences.getUserId()).toJson(),
                options: Options(
                  headers: {HttpHeaders.authorizationHeader: 'Bearer ${preferences.getAuthToken()}'},
                ));
            ProfileDetailsResModel response = ProfileDetailsResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              var clientData = response.data?.clients?.first;

              preferences.setAvailableAllPayment(isAvailableAllPayment: clientData?.clientDetail?.isAvailableAllPayments ?? false);
              preferences.setPaymentMethod(method: clientData?.clientDetail?.paymentType ?? '');
              preferences.setClientDataOnApp(showClientDataOnApp: clientData?.clientDetail?.showClientDataOnApp ?? false);
              preferences.setDocumentScanOnApp(showDocumentScanOnApp: clientData?.clientDetail?.showDocumentScanOnApp ?? false);
              preferences.setPaymentMethodTypes(methods: clientData?.clientDetail?.availablePaymentTypes ?? []);
              preferences.setPaymentMethodCount(count: clientData?.clientDetail?.availablePaymentTypes.length.toString() ?? '0');
              preferences.setBusinessName(businessName: clientData?.clientDetail?.bussinessName ?? '');
              preferences.setEmailId(userEmailId: clientData?.email ?? '');
              emit(state.copyWith(showClientDataOnApp: clientData?.clientDetail?.showClientDataOnApp ?? false));
              if (!preferences.getSubUser()) {
                preferences.setUserImageUrl(imageUrl: clientData?.profileImage ?? '');
                emit(state.copyWith(userImageUrl: clientData?.profileImage ?? '', context: event.context));
              }
              String? phoneNumber = await Smartlook.instance.user.properties.getString(AppStrings.userPhoneNum);

              if (phoneNumber == '' || phoneNumber == null) {
                Smartlook.instance.user.setIdentifier(preferences.getUserId());
                Smartlook.instance.user.setEmail(preferences.getPhoneNumber());
                Smartlook.instance.user.setName(preferences.getUserName());
                Smartlook.instance.user.properties.putString(AppStrings.userBusinessName, value: preferences.getBusinessName());
                Smartlook.instance.user.properties.putString(AppStrings.userPhoneNum, value: preferences.getPhoneNumber());
              }

              final supplierDetails = clientData?.supplierCustomerDetails ?? [];
              emit(state.copyWith(supplierCustomerDetails: supplierDetails, noMinimumDialogEventKey: DateTime.now().millisecondsSinceEpoch.toString()));
              add(HomeEvent.getPermissionList(context: event.context));
              if (!state.isAppOnMaintenance) {
                add(HomeEvent.generalSettings(context: event.context, dialogContext: event.context, isRetryLoading: false));
              }
              add(const HomeEvent.getPreferencesDataEvent());
              add(HomeEvent.getCartCountEvent(context: event.context));
              add(HomeEvent.getMessageListEvent(context: event.context));
              add(HomeEvent.getOrderCountEvent(context: event.context));
              add(HomeEvent.checkVersionOfAppEvent(context: event.context));
            }
          } catch (_) {}
        } else if (event is _getRecommendationProductsListEvent) {
          try {
            emit(state.copyWith(isShimmering: true));

            final res = await DioClient(event.context).post(
              AppUrlEndPoints.getRecommendationProductsUrl,
              data: const RecommendationProductsReqModel(pageNum: 1, pageLimit: AppConstants.defaultPageLimit).toJson(),
            );
            final response = RecommendationProductsResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              final cartMap = await fetchCartQuantities(event.context);
              List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);
              final stockList = response.data?.map((recommendationProduct) {
                final productId = recommendationProduct.id ?? '';
                return ProductStockModel(
                  maxQty: (recommendationProduct.sale?.isSale ?? false) ? int.parse(recommendationProduct.sale?.saleMaxQuantity ?? '0') : 0,
                  productId: productId,
                  stock: recommendationProduct.productStock.toString(),
                  quantity: cartMap[productId] ?? 0,
                );
              }).toList();
              productStockList[1] = stockList ?? [];
              emit(state.copyWith(recommendedProductsList: response.data ?? [], productStockList: productStockList, isShimmering: false));
            } else {
              emit(state.copyWith(isShimmering: false, allShimmering: false));
            }
          } catch (_) {
            emit(state.copyWith(isShimmering: false));
          }
        } else if (event is _changeCategoryExpansion) {
          if (event.isOpened == false) {
            emit(state.copyWith(searchList: []));
          }
          if (event.isOpened != null) {
            emit(state.copyWith(isCategoryExpand: event.isOpened ?? false));
          } else {
            emit(state.copyWith(isCategoryExpand: !state.isCategoryExpand));
          }
        } else if (event is _globalSearchEvent) {
          emit(state.copyWith(search: state.searchController.text));
          try {
            GlobalSearchReqModel globalSearchReqModel = GlobalSearchReqModel(
              search: state.searchController.text,
              sortField: AppStrings.sortFieldString,
              sortOrder: AppStrings.sortOrderString,
            );
            emit(state.copyWith(isSearching: true, bottlePrice: preferences.getBottleTax()));
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
            emit(state.copyWith(isSearching: false));
          } catch (exc) {
            emit(state.copyWith(isSearching: false));
          }
        } else if (event is _updateGlobalSearchEvent) {
          emit(state.copyWith(searchController: TextEditingController(text: event.search), searchList: event.searchList));
        } else if (event is _checkVersionOfAppEvent) {
          final checker = StoreVersionChecker();
          checker.checkUpdate().then((value) {
            printData("check here $value");
            printData("check here currentVersion ${value.currentVersion}"); //return current app version
            printData("check here newVersion ${value.newVersion}"); //return the new app version
            printData("check here appURL ${value.appURL}"); //return the app url
            printData("check here errorMessage ${value.errorMessage}"); //return error message if found else it will return null
            if (value.canUpdate && Platform.isAndroid) {
              customShowUpdateDialog(event.context, preferences.getAppLanguage(), value.appURL ?? 'https://play.google.com/store/apps/details?id=com.foodstock.dev');
            } else if (value.canUpdate && Platform.isIOS) {
              customShowUpdateDialog(event.context, preferences.getAppLanguage(), value.appURL ?? 'https://apps.apple.com/ua/app/tavili/id6468264054');
            }
          });
        } else if (event is _relatedProductsEvent) {
          emit(state.copyWith(isRelatedShimmering: true));
          final res = await DioClient(event.context).post(AppUrlEndPoints.relatedProductsUrl, data: {AppStrings.mainProductIdString: event.productId});
          final response = RelatedProductResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            final cartMap = await fetchCartQuantities(event.context);
            List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);

            final newRelatedList = response.data?.map((product) {
                  return ProductStockModel(productId: product.id ?? '', stock: product.productStock.toString(), quantity: cartMap[product.id] ?? 0);
                }).toList() ??
                [];
            productStockList[2] = productStockList[2].map((product) {
              return product.copyWith(
                productSupplierIds: product.productSupplierIds,
                productId: product.productId,
                stock: product.stock.toString(),
                quantity: event.productId == product.productId ? product.quantity : cartMap[product.productId] ?? 0,
              );
            }).toList();
            productStockList[2].addAll(newRelatedList);
            emit(state.copyWith(relatedProductList: response.data ?? [], isRelatedShimmering: false, productStockList: productStockList, isProductLoading: false));
          } else {
            emit(state.copyWith(isRelatedShimmering: false, isProductLoading: false));
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? '', event.context),
              type: SnackBarType.success,
            );
          }
        } else if (event is _removeRelatedProductEvent) {
          emit(state.copyWith(relatedProductList: []));
        } else if (event is _updateMaintenanceEvent) {
          emit(state.copyWith(isDialogOpen: true));
        } else if (event is _generalSettings) {
          try {
            emit(state.copyWith(pesachBannerShimmering: true, retryLoading: event.isRetryLoading));
            final res = await DioClient(event.context).get(path: AppUrlEndPoints.generalSettingUrl);
            SettingResModel response = SettingResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              if (preferences.getAppOnMaintenance() && !(response.data?.isAppOnMaintenance ?? false)) {
                add(HomeEvent.updateMaintenanceEvent(context: event.context));
                Navigator.pop(event.dialogContext);
                preferences.setIsAppOnMaintenance(isAppOnMaintenance: false);
                preferences.setBankTransferDetail(details: response.data?.taviliRivchitDetails?.bankTransferInfoText ?? '');
                emit(state.copyWith(isDialogOpen: false, isAppOnMaintenance: false, retryLoading: false));
                return;
              } else {
                if (!state.isDialogOpen && !(response.data?.isAppOnMaintenance ?? false)) {
                  emit(state.copyWith(isDialogOpen: true));
                }
              }
              preferences.setIsSaleOn(isSaleOn: response.data?.isSaleOn ?? false);
              preferences.setIsIncludedVat(isIncludedVat: (response.data?.showVatApplication?.contains(AppStrings.appName) ?? false) ? true : false);
              preferences.setBottleTax(bottleDeposit: response.data?.bottlePrice ?? 0.0);
              preferences.setIsAppOnMaintenance(isAppOnMaintenance: response.data?.isAppOnMaintenance ?? false);
              emit(state.copyWith(
                language: preferences.getAppLanguage(),
                pesachBannerShimmering: false,
                pesachBannerURL: response.data?.pesachBanner ?? '',
                showPesachBanner: response.data?.isShowPesachBanner ?? false,
                bottlePrice: response.data?.bottlePrice ?? 0.0,
                isIncludedVat: preferences.getIsIncludedVat(),
                isSaleOn: preferences.getShowSale(),
                retryLoading: false,
                isAppOnMaintenance: preferences.getAppOnMaintenance(),
                buttonEnglishText: response.data?.dataWebViewSettings?.buttonEnglishText ?? state.buttonEnglishText ?? '',
                buttonHebrewText: response.data?.dataWebViewSettings?.buttonHebrewText ?? state.buttonHebrewText ?? '',
              ));
            } else {
              emit(state.copyWith(pesachBannerShimmering: false, retryLoading: false));
            }
          } on ServerException {
            emit(state.copyWith(pesachBannerShimmering: false, retryLoading: false));
          } catch (exc) {
            emit(state.copyWith(pesachBannerShimmering: false, retryLoading: false));
          }
        } else if (event is _getPermissionList) {
          if (preferences.getSubUser()) {
            try {
              final res = await DioClient(event.context).get(path: '${AppUrlEndPoints.getAccountPermissionUrl}${preferences.getSubUserId()}');
              AccountPermissionResModel response = AccountPermissionResModel.fromJson(res);
              if (response.status == AppConstants.code_200) {
                var res = response.data?.permissions;
                preferences.setCanSeeWallet(isSeeWallet: res?.canSeeWallet ?? false);
                emit(state.copyWith(isAccountPermissionShimmering: true));
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
                emit(state.copyWith(isAccountPermissionShimmering: false, isSubUserSeeWallet: res?.canSeeWallet ?? false, isSubUserAddToBasket: res?.canAddToCart ?? false));
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
                  CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppLocalizations.of(event.context)!.not_add_more_than_max_qty,
                    type: SnackBarType.failure,
                  );
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
              productStockList[event.productListIndex][event.productStockUpdateIndex] = productStockList[event.productListIndex][event.productStockUpdateIndex].copyWith(
                quantity: newQuantity,
              );
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
                          emit(state.copyWith(cartCount: preferences.getCartCount(), isCartCountChange: true));
                          if (event.context.mounted) {
                            BlocProvider.of<BottomNavBloc>(event.context).add(BottomNavEvent.updateCartCountEvent(context: event.context));
                          }
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
                  add(HomeEvent.getCartCountEvent(context: event.context));
                  emit(state.copyWith(productStockList: productStockList));
                  CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                    type: SnackBarType.success,
                  );
                  await _updateCartCountAndNotify(event.context);
                  emit(state.copyWith(isDialog: false));
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
                  add(const HomeEvent.setCartCountEvent());
                  _productId = state.productStockList[event.productListIndex][event.productStockUpdateIndex].productId;
                  _supplierId = state.productStockList[event.productListIndex][event.productStockUpdateIndex].productSupplierIds;
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
                  add(HomeEvent.getCartCountEvent(context: event.context));
                  emit(state.copyWith(productStockList: productStockList, isCartCountChange: false));
                  CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                    type: SnackBarType.success,
                  );
                  await _updateCartCountAndNotify(event.context);
                  emit(state.copyWith(isDialog: false));
                } else if (response.status == AppConstants.code_403) {
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
          try {
            final res = await DioClient(event.context).post('${AppUrlEndPoints.getAllCartUrl}${preferences.getCartId()}');
            if (res != null) {
              GetAllCartResModel response = GetAllCartResModel.fromJson(res);
              if (response.status == AppConstants.code_200) {
                emit(state.copyWith(isCartCountChange: true));
                await preferences.setCartCount(count: response.data?.data?.length ?? preferences.getCartCount());
                emit(state.copyWith(cartCount: preferences.getCartCount(), isCartCountChange: false));
                if (event.context.mounted) {
                  BlocProvider.of<BottomNavBloc>(event.context).add(BottomNavEvent.updateCartCountEvent(context: event.context));
                }
              }
            }
          } catch (_) {
            if (event.context.mounted) {
              BlocProvider.of<BottomNavBloc>(event.context).add(BottomNavEvent.updateCartCountEvent(context: event.context));
            }
          }
          try {
            final res = await DioClient(event.context).post(
              AppUrlEndPoints.getUnreadMessageCountUrl,
              options: Options(headers: {HttpHeaders.authorizationHeader: 'Bearer ${preferences.getAuthToken()}'}),
            );

            MessageCountResModel response = MessageCountResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              await preferences.setMessageCount(count: response.data ?? preferences.getMessageCount());
              emit(state.copyWith(messageCount: response.data ?? 0));
            }
          } catch (_) {}
        } else if (event is _getRecommendationProductsListEvent) {
          emit(state.copyWith(noMinimumDialogEventKey: null));
        } else if (event is _clearNoMinimumDialogTriggerEvent) {
          emit(state.copyWith(noMinimumDialogEventKey: null));
        } else if (event is _getSuppliersDataListEvent) {
          try {
            emit(state.copyWith(isShimmering: true));
            final res = await DioClient(event.context).post(
              AppUrlEndPoints.getSuppliersList,
              data: const SuppliersReqModel(pageNum: 1, pageLimit: AppConstants.defaultPageLimit).toJson(),
            );
            SuppliersListResponseModel response = SuppliersListResponseModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              emit(state.copyWith(suppliersDataList: response.data?.supplierList ?? [], isShimmering: false, context: event.context));
            } else {
              emit(state.copyWith(isShimmering: false, context: event.context));
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                type: SnackBarType.success,
              );
            }
          } on ServerException {
            emit(state.copyWith(isShimmering: false));
          } catch (exc) {
            emit(state.copyWith(isShimmering: false));
          }
        }
      }
    });
  }

  Future<void> _updateCartCountAndNotify(BuildContext context) async {
    add(HomeEvent.getCartCountEvent(context: context));
    if (context.mounted) {
      BlocProvider.of<BottomNavBloc>(context).add(BottomNavEvent.updateCartCountEvent(context: context));
    }
  }
}
