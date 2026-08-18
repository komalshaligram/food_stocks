import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../../data/model/req_model/insert_cart_req_model/insert_cart_req_model.dart' as insert;
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/res_model/insert_cart_res_model/insert_cart_res_model.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';
import '../../data/model/res_model/supplier_payment_type_res_model/supplier_payment_type_res_model.dart';
import '../../data/model/supplier_sale_model/supplier_sale_model.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/order_model/product_details_model.dart';
import '../../data/model/req_model/update_cart/update_cart_req_model.dart';
import '../../data/model/res_model/account_permission/account_permission_res_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/related_product_res_model/related_product_res_model.dart';
import '../../data/model/res_model/setting_res_model/setting_res_model.dart';
import '../../data/model/res_model/update_cart_res/update_cart_res_model.dart';
import '../../data/model/res_model/verify_client_res_model/verify_client_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../bottom_nav/bottom_nav_bloc.dart';
import '../../data/model/res_model/profile_details_res_model/profile_details_res_model.dart' as res_get;
import '../../data/model/req_model/profile_details_req_model/profile_details_req_model.dart' as req;
part 'basket_event.dart';
part 'basket_state.dart';
part 'basket_bloc.freezed.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  bool _isProductInCart = false;
  String _cartProductId = '';
  int _productQuantity = 0;
  String paymentType = '';

  BasketBloc() : super(BasketState.initial()) {
    on<BasketEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      res_get.ProfileDetailsResModel response = const res_get.ProfileDetailsResModel();
      if (event is _getPreferencesDataEvent) {
        emit(state.copyWith(clubAgentId: preferences.getClubAgentId()));
      }
      if (preferences.getGuestUser()) {
      } else {
        if (event is _getAllCartEvent) {
          add(BasketEvent.getProfileDetailsEvent(context: event.context));
          emit(state.copyWith(
              isSubUserCanCreateOrder: preferences.getCanCreateOrder(),
              updatePaymentMethod: false,
              isPaymentFail: false,
              paymentTypesList: preferences.getPaymentMethodTypes(),
              context: event.context,
              isSubUserAddToBasket: preferences.getCanAddToBasket(),
              isAllPaymentAvailable: preferences.getAvailablePayment()));

          emit(state.copyWith(
              isShimmering: event.isFromUpdate == true ? false : true,
              isAnimation: false,
              language: preferences.getAppLanguage(),
              cartCount: preferences.getCartCount()));
          try {
            final res = await DioClient(event.context).post('${AppUrlEndPoints.getAllCartUrl}${preferences.getCartId()}');

            GetAllCartResModel response = GetAllCartResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              emit(state.copyWith(cartItemList: response, isShimmering: false, isQtyUpdated: false));
              List<ProductDetailsModel> temp = [];
              List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);
              if (productStockList.isNotEmpty) {
                productStockList[0] = [];
              }
              if (response.data?.data?.isNotEmpty == true) {
                add(BasketEvent.getSupplierPaymentTypeEvent(
                    context: event.context, id: response.data!.data!.first.suppliers?.first.id ?? '', index: 0));
              }

              List<ProductStockModel> stockList = [];
              stockList.addAll(response.data?.data?.map((product) => ProductStockModel(
                      maxQty: (product.sale?.isSale ?? false) ? int.parse(product.sale?.saleMaxQuantity.toString() ?? '0') : 0,
                      quantity: product.totalQuantity ?? 0,
                      productId: product.id ?? '',
                      cartProductId: product.cartProductId ?? '',
                      stock: product.productStock.toString(),
                      lowStock: product.lowStock.toString())) ??
                  []);
              if (productStockList.isEmpty) {
                productStockList.add(stockList);
              } else {
                productStockList[0].addAll(stockList);
              }
              response.data?.data?.forEach((element) {
                temp.add(ProductDetailsModel(
                    saleDesc: element.sale?.saleDescription ?? '',
                    isSale: element.sale?.isSale ?? false,
                    discountPrice: element.sale?.isSale ?? false ? double.parse(element.sale?.salePrice.toString() ?? '0.0') : 0.0,
                    isPesach: element.productDetails?.isPesach ?? false,
                    totalQuantity: element.totalQuantity,
                    productName: element.productDetails?.productName ?? '',
                    mainImage: element.productDetails?.mainImage,
                    totalPayment: double.parse(element.totalAmount.toString()),
                    cartProductId: element.cartProductId ?? '',
                    weight: element.productDetails?.itemsWeight?.toDouble() ?? 0,
                    lowStock: element.lowStock,
                    scales: '',
                    productStock: element.productStock?.toDouble(),
                    supplierName: element.suppliers?.first.contactName ?? '',
                    numberOfUnits: element.productDetails?.numberOfUnit!.toString() ?? '0',
                    scaleType: element.productDetails?.scaleType));
              });

              await preferences.setCartCount(count: temp.isEmpty ? preferences.getCartCount() : temp.length);

              emit(state.copyWith(isAnimation: true));
              emit(state.copyWith(
                  vatPercentage: response.data!.vatPercentage?.toDouble() ?? 0.0,
                  bottleQty: response.data?.cart?.first.bottleQuantities,
                  bottleTax: response.data?.bottleTax ?? 0,
                  basketProductList: temp,
                  productStockList: productStockList,
                  totalPayment: response.data?.cart?.first.totalAmount!.toDouble() ?? 0,
                  supplierCount: response.data?.cart?.first.suppliers ?? 1,
                  supplierId: response.data?.data?.isNotEmpty == true ? response.data?.data?.first.suppliers?.first.id ?? '' : '',
                  isAnimation: false,
                  draftReturnExists: response.data?.cart?.first.draftReturnExists! ?? false));
            } else {
              emit(state.copyWith(isShimmering: false));
            }
          } on ServerException {
            emit(state.copyWith(isShimmering: false));
          }

          try {
            final res = await DioClient(event.context)
                .post(AppUrlEndPoints.getProfileDetailsUrl, data: req.ProfileDetailsReqModel(id: preferences.getUserId()).toJson());
            response = res_get.ProfileDetailsResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              paymentType = response.data!.clients![0].clientDetail!.paymentType!;
            } else {
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                  type: SnackBarType.failure);
              emit(state.copyWith(isShimmering: false));
            }
          } on ServerException {
            emit(state.copyWith(isShimmering: false));
          }
        } else if (event is _productUpdateEvent) {
          List<ProductDetailsModel> list = [];
          list = [...state.basketProductList];

          try {
            list[event.listIndex].isProcess = true;
            emit(state.copyWith(isLoading: true, basketProductList: list, isQtyUpdated: false));
            UpdateCartReqModel reqMap = const UpdateCartReqModel();
            if (event.saleId != '') {
              reqMap = UpdateCartReqModel(
                  supplierId: event.supplierId,
                  quantity: event.productWeight,
                  productId: event.productId,
                  cartProductId: event.cartProductId,
                  saleId: event.saleId);
            } else {
              reqMap = UpdateCartReqModel(
                  supplierId: event.supplierId, quantity: event.productWeight, productId: event.productId, cartProductId: event.cartProductId);
            }

            final res = await DioClient(event.context).post('${AppUrlEndPoints.updateCartProductUrl}${preferences.getCartId()}', data: reqMap);

            UpdateCartResModel response = UpdateCartResModel.fromJson(res);

            if (response.status == AppConstants.code_201) {
              add(BasketEvent.getAllCartEvent(context: event.context, isFromUpdate: true));
              List<ProductDetailsModel> list = [];
              list = [...state.basketProductList];
              int quantity = list[event.listIndex].totalQuantity ?? 1;
              double payment = list[event.listIndex].totalPayment ?? 0;
              list[event.listIndex].totalQuantity = response.data?.cartProduct?.quantity;
              list[event.listIndex].totalPayment = ((payment / quantity) * (response.data?.cartProduct?.quantity ?? 1));
              double newAmount = (payment / quantity);
              double totalAmount = 0;
              if ((list[event.listIndex].totalPayment ?? 0) > payment) {
                totalAmount = event.totalPayment + newAmount;
              } else {
                totalAmount = event.totalPayment - newAmount;
              }
              list[event.listIndex].isProcess = false;
              emit(state.copyWith(basketProductList: list, totalPayment: totalAmount, isLoading: false));
            } else {
              list[event.listIndex].isProcess = false;
              emit(state.copyWith(basketProductList: list, isLoading: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message ?? '', event.context),
                  type: SnackBarType.failure);
            }
          } on ServerException {
            list[event.listIndex].isProcess = false;
            emit(state.copyWith(basketProductList: list, isLoading: false));
          }
        } else if (event is _supplierSelectionEvent) {
          if (event.supplierIndex >= 0) {
            List<ProductSupplierModel> supplierList = state.productSupplierList.toList(growable: true);
            List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);

            productStockList[state.productListIndex][state.productStockUpdateIndex] =
                productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
                    productSupplierIds: supplierList[event.supplierIndex].supplierId,
                    totalPrice: event.supplierSaleIndex == -2
                        ? supplierList[event.supplierIndex].basePrice
                        : supplierList[event.supplierIndex].supplierSales[event.supplierSaleIndex].salePrice,
                    stock: supplierList[event.supplierIndex].stock,
                    maxQty: supplierList[event.supplierIndex].maxQty,
                    quantity: supplierList[event.supplierIndex].quantity != 0 ? supplierList[event.supplierIndex].quantity : 1,
                    productSaleId:
                        event.supplierSaleIndex == -2 ? '' : supplierList[event.supplierIndex].supplierSales[event.supplierSaleIndex].saleId);

            supplierList = supplierList.map((supplier) => supplier.copyWith(selectedIndex: -1)).toList();
            supplierList[event.supplierIndex] = supplierList[event.supplierIndex].copyWith(selectedIndex: event.supplierSaleIndex);
            emit(state.copyWith(productSupplierList: supplierList, productStockList: productStockList));
          }
        } else if (event is _addToCartProductEvent) {
          if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSupplierIds.isEmpty) {
            return;
          }
          if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity == 0) {
            CustomSnackBar.showSnackBar(
                context: event.context, title: AppLocalizations.of(event.context)!.add_1_quantity, type: SnackBarType.failure);
            return;
          }
          if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].maxQty > 0) {
            if (state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity >
                state.productStockList[state.productListIndex][state.productStockUpdateIndex].maxQty) {
              CustomSnackBar.showSnackBar(
                  context: event.context, title: AppLocalizations.of(event.context)!.not_add_more_than_max_qty, type: SnackBarType.failure);
              return;
            }
          }
          if (_isProductInCart) {
            try {
              emit(state.copyWith(isLoading: true));
              UpdateCartReqModel request = UpdateCartReqModel(
                  productId: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productId == ''
                      ? event.productId
                      : state.productStockList[state.productListIndex][state.productStockUpdateIndex].productId,
                  supplierId: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSupplierIds,
                  saleId: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSaleId == ''
                      ? null
                      : state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSaleId,
                  quantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                  cartProductId: _cartProductId);
              final res = await DioClient(event.context).post('${AppUrlEndPoints.updateCartProductUrl}${preferences.getCartId()}', data: request);
              UpdateCartResModel response = UpdateCartResModel.fromJson(res);
              if (response.status == AppConstants.code_201) {
                Vibration.vibrate();

                List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);
                productStockList[state.productListIndex][state.productStockUpdateIndex] =
                    productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
                        note: '',
                        quantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                        productSupplierIds: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSupplierIds,
                        totalPrice: state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice,
                        productSaleId: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSaleId);
                emit(state.copyWith(isLoading: false, productStockList: productStockList, cartCount: preferences.getCartCount()));
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                    type: SnackBarType.success);
              } else {
                emit(state.copyWith(isLoading: false));
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                    type: SnackBarType.failure);
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
                    saleId: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSaleId.isEmpty
                        ? null
                        : state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSaleId,
                    note: state.productStockList[state.productListIndex][state.productStockUpdateIndex].note.isEmpty
                        ? null
                        : state.productStockList[state.productListIndex][state.productStockUpdateIndex].note)
              ]);
              Map<String, dynamic> req = insertCartReqModel.toJson();
              req.removeWhere((key, value) {
                if (value != null) {}
                return value == null;
              });

              final res = await DioClient(event.context).post('${AppUrlEndPoints.insertProductInCartUrl}${preferences.getCartId()}', data: req);
              InsertCartResModel response = InsertCartResModel.fromJson(res);
              if (response.status == AppConstants.code_201) {
                add(BasketEvent.getAllCartEvent(context: event.context, isFromUpdate: false));
                Vibration.vibrate();
                Navigator.pop(event.context);
                List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);
                productStockList[state.productListIndex][state.productStockUpdateIndex] =
                    productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(
                        note: '',
                        productIsInCart: true,
                        quantity: state.productStockList[state.productListIndex][state.productStockUpdateIndex].quantity,
                        productSupplierIds: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSupplierIds,
                        totalPrice: state.productStockList[state.productListIndex][state.productStockUpdateIndex].totalPrice,
                        productSaleId: state.productStockList[state.productListIndex][state.productStockUpdateIndex].productSaleId);

                emit(state.copyWith(isLoading: false, productStockList: productStockList, isCartCountChange: false));
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                    type: SnackBarType.success);
              } else if (response.status == AppConstants.code_403) {
                emit(state.copyWith(isLoading: false));
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                    type: SnackBarType.failure);
              } else {
                emit(state.copyWith(isLoading: false));
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                    type: SnackBarType.failure);
              }
            } on ServerException {
              emit(state.copyWith(isLoading: false));
            } catch (e) {
              emit(state.copyWith(isLoading: false));
            }
          }
        } else if (event is _getProductDetailsEvent) {
          emit(state.copyWith(isCartCountChange: false));
          add(const BasketEvent.removeRelatedProductEvent());
          _isProductInCart = false;
          _cartProductId = '';
          _productQuantity = 0;

          try {
            emit(state.copyWith(isProductLoading: true, isSelectSupplier: false));

            final res = await DioClient(event.context)
                .post(AppUrlEndPoints.getProductDetailsUrl, data: ProductDetailsReqModel(params: event.productId).toJson());
            ProductDetailsResModel response = ProductDetailsResModel.fromJson(res);

            if (response.status == AppConstants.code_200) {
              //0 for basket product.
              //1 related product.
              if (response.product != []) {
                List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);
                int productListIndex = event.productListIndex;
                int productStockUpdateIndex = 0;
                productStockUpdateIndex =
                    state.productStockList[productListIndex].indexWhere((productStock) => productStock.productId == event.productId);
                emit(state.copyWith(productListIndex: productListIndex, productStockUpdateIndex: productStockUpdateIndex));

                try {
                  final res = await DioClient(event.context).post('${AppUrlEndPoints.getAllCartUrl}${preferences.getCartId()}');
                  GetAllCartResModel response = GetAllCartResModel.fromJson(res);
                  if (response.status == AppConstants.code_200) {
                    response.data?.data?.forEach((cartProduct) {
                      if (cartProduct.id == event.productId ||
                          cartProduct.id == state.productStockList[state.productListIndex][state.productStockUpdateIndex].productId) {
                        _isProductInCart = true;
                        _cartProductId = cartProduct.cartProductId ?? '';
                        _productQuantity = cartProduct.totalQuantity ?? 0;
                        return;
                      }
                    });
                  }
                } catch (_) {}
                if (response.product != []) {
                  add(BasketEvent.relatedProductsEvent(context: event.context, productId: response.product?.first.id ?? ''));
                }
                if ((event.isBarcode)) {
                  productStockList[0][0] = productStockList[0][0].copyWith(
                      quantity: _productQuantity,
                      maxQty: (response.product?.first.sale?.isSale ?? false) ? int.parse(response.product?.first.sale?.saleMaxQuantity ?? '0') : 0,
                      productId: response.product?.first.id ?? '',
                      stock: (response.product?.first.supplierSales?.first.productStock.toString() ?? ''));
                  emit(state.copyWith(productStockList: productStockList));
                }

                List<ProductSupplierModel> supplierList = [];
                supplierList.addAll(response.product?.first.supplierSales?.map((supplier) {
                      return ProductSupplierModel(
                        supplierId: supplier.supplierId ?? '',
                        companyName: supplier.supplierCompanyName ?? '',
                        basePrice: double.parse(supplier.productPrice ?? ''),
                        quantity: _productQuantity,
                        stock: supplier.productStock.toString(),
                        maxQty: (response.product?.first.sale?.isSale ?? false)
                            ? int.parse(response.product?.first.sale?.saleMaxQuantity.toString() ?? '0')
                            : 0,
                        selectedIndex: (supplier.supplierId) == state.productStockList[productListIndex][productStockUpdateIndex].productSupplierIds
                            ? !supplier.saleProduct!.contains(supplier.saleProduct?.firstWhere(
                                        (sale) => sale.saleId == state.productStockList[productListIndex][productStockUpdateIndex].productSaleId,
                                        orElse: () => const SaleProduct(
                                            isSale: false,
                                            saleDescription: '',
                                            saleFromDate: '',
                                            saleMaxQuantity: '0',
                                            salePrice: '0',
                                            saleUntilDate: '')) ??
                                    const SaleProduct(
                                        isSale: false,
                                        saleDescription: '',
                                        saleFromDate: '',
                                        saleMaxQuantity: '0',
                                        salePrice: '0',
                                        saleUntilDate: ''))
                                ? -2
                                : supplier.saleProduct?.indexOf(supplier.saleProduct?.firstWhere(
                                            (sale) => sale.saleId == state.productStockList[productListIndex][productStockUpdateIndex].productSaleId,
                                            orElse: () => const SaleProduct(
                                                isSale: false,
                                                saleDescription: '',
                                                saleFromDate: '',
                                                saleMaxQuantity: '0',
                                                salePrice: '0',
                                                saleUntilDate: '')) ??
                                        const SaleProduct(
                                            isSale: false,
                                            saleDescription: '',
                                            saleFromDate: '',
                                            saleMaxQuantity: '0',
                                            salePrice: '0',
                                            saleUntilDate: '')) ??
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
                                    saleDiscount: double.parse(sale.discountPercentage ?? '0.0')))
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
                    isProductLoading: false));
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
                    add(BasketEvent.supplierSelectionEvent(
                        supplierIndex: supplierIndex, context: event.context, supplierSaleIndex: supplierSaleIndex));
                  }
                }
              } else {
                emit(state.copyWith(isProductLoading: false));
              }
            } else {
              emit(state.copyWith(isProductLoading: false));
              Navigator.pop(event.context);
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? '', event.context),
                  type: SnackBarType.failure);
            }
          } on ServerException {
            Navigator.pop(event.context);
          }
        } else if (event is _increaseQuantityOfProduct) {
          List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: false);
          if (state.productStockUpdateIndex != -1) {
            if (productStockList[state.productListIndex][state.productStockUpdateIndex].quantity <
                double.parse(productStockList[state.productListIndex][state.productStockUpdateIndex].stock.toString())) {
              if (productStockList[state.productListIndex][state.productStockUpdateIndex].productSupplierIds.isEmpty) {
                return;
              }
              if (productStockList[state.productListIndex][state.productStockUpdateIndex].maxQty != 0) {
                if (productStockList[state.productListIndex][state.productStockUpdateIndex].quantity >=
                    productStockList[state.productListIndex][state.productStockUpdateIndex].maxQty) {
                  CustomSnackBar.showSnackBar(
                      context: event.context, title: AppLocalizations.of(event.context)!.not_add_more_than_max_qty, type: SnackBarType.failure);
                  return;
                }
              }
              productStockList[state.productListIndex][state.productStockUpdateIndex] = productStockList[state.productListIndex]
                      [state.productStockUpdateIndex]
                  .copyWith(quantity: productStockList[state.productListIndex][state.productStockUpdateIndex].quantity + 1);
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
        } else if (event is _decreaseQuantityOfProduct) {
          List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: false);
          if (state.productStockUpdateIndex != -1) {
            if (productStockList[state.productListIndex][state.productStockUpdateIndex].quantity > 0) {
              productStockList[state.productListIndex][state.productStockUpdateIndex] = productStockList[state.productListIndex]
                      [state.productStockUpdateIndex]
                  .copyWith(quantity: productStockList[state.productListIndex][state.productStockUpdateIndex].quantity - 1);
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
              productStockList[state.productListIndex][state.productStockUpdateIndex] =
                  productStockList[state.productListIndex][state.productStockUpdateIndex].copyWith(quantity: newQuantity);
              emit(state.copyWith(productStockList: []));
              emit(state.copyWith(productStockList: productStockList));
            } else {
              productStockList[state.productListIndex][state.productStockUpdateIndex] = productStockList[state.productListIndex]
                      [state.productStockUpdateIndex]
                  .copyWith(quantity: int.tryParse(quantityString.substring(0, quantityString.length - 1)) ?? 0);

              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title:
                      "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[state.productListIndex][state.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
                  type: SnackBarType.failure);
              emit(state.copyWith(productStockList: []));
              emit(state.copyWith(productStockList: productStockList));
            }
          }
        } else if (event is _removeCartProductEvent) {
          emit(state.copyWith(isRemoveProcess: true));
          try {
            final player = AudioPlayer();
            final response = await DioClient(event.context)
                .post(AppUrlEndPoints.removeCartProductUrl, data: {AppStrings.cartProductIdString: event.cartProductId});

            if (response[AppStrings.statusString] == AppConstants.code_200) {
              add(BasketEvent.getAllCartEvent(context: event.context, isFromUpdate: true));
              Navigator.pop(event.dialogContext);
              player.play(AssetSource(AppStrings.deleteSound));
              add(const BasketEvent.setCartCountEvent(isClearCart: false));
              List<ProductDetailsModel> list = [];

              list = [...state.basketProductList];
              list.removeAt(event.listIndex);
              emit(state.copyWith(basketProductList: list, totalPayment: state.totalPayment - event.totalAmount, isRemoveProcess: false));
            } else {
              Navigator.pop(event.dialogContext);
              emit(state.copyWith(isRemoveProcess: false, isLoading: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(response[AppStrings.messageString].toString().toLocalization(), event.context),
                  type: SnackBarType.failure);
            }
          } on ServerException {
            emit(state.copyWith(isRemoveProcess: false, isLoading: false));
            Navigator.pop(event.dialogContext);
          }
        } else if (event is _clearCartEvent) {
          emit(state.copyWith(isRemoveProcess: true));
          try {
            final res = await DioClient(event.context).post('${AppUrlEndPoints.clearCartUrl}${preferences.getCartId()}');
            if (res[AppStrings.statusString] == AppConstants.code_201) {
              add(const BasketEvent.setCartCountEvent(isClearCart: true));
              List<ProductDetailsModel> list = [];
              list = [...state.basketProductList];
              list.clear();
              Navigator.pop(event.context);
              emit(state.copyWith(basketProductList: list, isRemoveProcess: false, productStockList: [], isAnimation: false));
            } else {
              Navigator.pop(event.context);
              emit(state.copyWith(isRemoveProcess: false));
            }
          } on ServerException {
            Navigator.pop(event.context);
            emit(state.copyWith(isRemoveProcess: false));
          }
        } else if (event is _setCartCountEvent) {
          await preferences.setCartCount(count: event.isClearCart ? 0 : preferences.getCartCount() - 1);
          emit(state.copyWith(isAnimation: true));
        } else if (event is _updateImageIndexEvent) {
          emit(state.copyWith(productImageIndex: event.index));
        } else if (event is _relatedProductsEvent) {
          emit(state.copyWith(isRelatedShimmering: true));
          final res =
              await DioClient(event.context).post(AppUrlEndPoints.relatedProductsUrl, data: {AppStrings.mainProductIdString: event.productId});
          RelatedProductResModel response = RelatedProductResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            final cartMap = await fetchCartQuantities(event.context);
            List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);

            final newRelatedList = response.data?.map((product) {
                  return ProductStockModel(productId: product.id ?? '', stock: product.productStock.toString(), quantity: cartMap[product.id] ?? 0);
                }).toList() ??
                [];

            productStockList[1] = productStockList[1].map((product) {
              return product.copyWith(
                  productSupplierIds: product.productSupplierIds,
                  productId: product.productId,
                  stock: product.stock.toString(),
                  quantity: event.productId == product.productId ? product.quantity : cartMap[product.productId] ?? 0);
            }).toList();
            productStockList[1] = [...productStockList[1], ...newRelatedList];

            emit(state.copyWith(relatedProductList: response.data ?? [], isRelatedShimmering: false, productStockList: productStockList));
          } else {
            emit(state.copyWith(isRelatedShimmering: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? '', event.context),
                type: SnackBarType.success);
          }
        } else if (event is _removeRelatedProductEvent) {
          emit(state.copyWith(relatedProductList: []));
        } else if (event is _refreshEvent) {
          emit(state.copyWith(isOrderPending: false, isPaymentFail: false, updatePaymentMethod: false));
        } else if (event is _getPermissionList) {
          if (preferences.getSubUser()) {
            try {
              final res = await DioClient(event.context).get(path: '${AppUrlEndPoints.getAccountPermissionUrl}${preferences.getSubUserId()}');
              AccountPermissionResModel response = AccountPermissionResModel.fromJson(res);
              if (response.status == AppConstants.code_200) {
                var res = response.data?.permissions;
                if (preferences.getAppLanguage() == AppStrings.englishString && preferences.getCanSeeWallet() != res?.canSeeWallet) {
                  event.context.read<BottomNavBloc>().add(BottomNavEvent.changePage(index: 2, context: event.context));
                }
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
                emit(state.copyWith(
                    isAccountPermissionShimmering: false,
                    isSubUserCanCreateOrder: preferences.getCanCreateOrder(),
                    isSubUserAddToBasket: preferences.getCanAddToBasket()));
              } else {
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                    type: SnackBarType.failure);
              }
            } catch (e) {
              CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
            }
          }
        } else if (event is _userApproveEvent) {
          try {
            final res =
                await DioClient(event.context).post(AppUrlEndPoints.verifyClientUrl, data: {AppStrings.clientIdString: preferences.getUserId()});
            VerifyClientResModel response = VerifyClientResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              if (!(response.data?.isFilledForms ?? false) || !(response.data?.isRegisterForm ?? false)) {
                Navigator.pushNamed(event.context, RouteDefine.formDataScreen.name);
              } else if (!(response.data?.isUploadedFiles ?? false) &&
                  (response.data?.isRegisterForm ?? false) &&
                  (response.data?.isFilledForms ?? false)) {
                Navigator.pushNamed(event.context, RouteDefine.fileUploadScreen.name);
              }
            }
          } catch (_) {}
        } else if (event is _updateMaintenanceEvent) {
          emit(state.copyWith(isDialogOpen: true));
        } else if (event is _generalSettings) {
          try {
            emit(state.copyWith(retryLoading: event.isRetryLoading));
            final res = await DioClient(event.context).get(path: AppUrlEndPoints.generalSettingUrl);
            SettingResModel response = SettingResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              if (preferences.getAppOnMaintenance() && !(response.data?.isAppOnMaintenance ?? false)) {
                add(BasketEvent.updateMaintenanceEvent(context: event.context));
                Navigator.pop(event.dialogContext);
                preferences.setIsAppOnMaintenance(isAppOnMaintenance: false);
                emit(state.copyWith(isDialogOpen: false, isAppOnMaintenance: false, retryLoading: false, updatePaymentMethod: false));
                return;
              } else {
                if (!state.isDialogOpen && !(response.data?.isAppOnMaintenance ?? false)) {
                  emit(state.copyWith(isDialogOpen: true));
                } else {
                  emit(state.copyWith(isDialogOpen: false));
                }
              }
              preferences.setIsSaleOn(isSaleOn: response.data?.isSaleOn ?? false);
              preferences.setIsIncludedVat(isIncludedVat: (response.data?.showVatApplication?.contains(AppStrings.appName) ?? false) ? true : false);
              preferences.setBottleTax(bottleDeposit: response.data?.bottlePrice ?? 0.0);
              preferences.setIsAppOnMaintenance(isAppOnMaintenance: response.data?.isAppOnMaintenance ?? false);

              emit(state.copyWith(
                  language: preferences.getAppLanguage(),
                  isIncludedVat: preferences.getIsIncludedVat(),
                  isSaleOn: preferences.getShowSale(),
                  retryLoading: false,
                  bankTransferInfo: preferences.getBankTransferDetail(),
                  isAppOnMaintenance: preferences.getAppOnMaintenance()));
            }
          } catch (e) {
            CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
          }
        } else if (event is _getSupplierPaymentTypeEvent) {
          try {
            final res = await DioClient(event.context).get(path: '${AppUrlEndPoints.getSupplierPaymentTypesUrl}${event.id}');
            SupplierPaymentTypeResModel response = SupplierPaymentTypeResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              preferences.setBankTransferDetail(details: response.data!.paymentDetails?.bankTransferPopupText ?? '');
              emit(state.copyWith(
                  paymentTypesList: response.data?.paymentDetails?.paymentTypes ?? [],
                  bankTransferInfo: response.data!.paymentDetails?.bankTransferPopupText ?? ''));
            } else {
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                  type: SnackBarType.failure);
            }
          } catch (_) {}
        } else if (event is _increaseListQuantityOfProductEvent) {
          List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: false);
          if (event.productStockUpdateIndex != -1) {
            if (productStockList[event.productListIndex][event.productStockUpdateIndex].quantity <
                double.parse(productStockList[event.productListIndex][event.productStockUpdateIndex].stock.toString())) {
              if (event.productSupplierIds.isEmpty) {
                return;
              }

              if (productStockList[event.productListIndex][event.productStockUpdateIndex].maxQty != 0) {
                if (productStockList[event.productListIndex][event.productStockUpdateIndex].quantity >=
                    productStockList[event.productListIndex][event.productStockUpdateIndex].maxQty) {
                  CustomSnackBar.showSnackBar(
                      context: event.context, title: AppLocalizations.of(event.context)!.not_add_more_than_max_qty, type: SnackBarType.failure);
                  return;
                }
              }

              productStockList[event.productListIndex][event.productStockUpdateIndex] = productStockList[event.productListIndex]
                      [event.productStockUpdateIndex]
                  .copyWith(quantity: productStockList[event.productListIndex][event.productStockUpdateIndex].quantity + 1);
              emit(state.copyWith(productStockList: []));
              emit(state.copyWith(productStockList: productStockList));
            } else {
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title:
                      "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[event.productListIndex][event.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
                  type: SnackBarType.failure);
            }
          }
        } else if (event is _decreaseListQuantityOfProductEvent) {
          List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: false);
          if (event.productStockUpdateIndex != -1) {
            if (productStockList[event.productListIndex][event.productStockUpdateIndex].quantity > 0) {
              productStockList[event.productListIndex][event.productStockUpdateIndex] = productStockList[event.productListIndex]
                      [event.productStockUpdateIndex]
                  .copyWith(quantity: productStockList[event.productListIndex][event.productStockUpdateIndex].quantity - 1);
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
              productStockList[event.productListIndex][event.productStockUpdateIndex] =
                  productStockList[event.productListIndex][event.productStockUpdateIndex].copyWith(quantity: newQuantity);
              emit(state.copyWith(productStockList: []));
              emit(state.copyWith(productStockList: productStockList));
            } else {
              productStockList[event.productListIndex][event.productStockUpdateIndex] = productStockList[event.productListIndex]
                      [event.productStockUpdateIndex]
                  .copyWith(quantity: int.tryParse(quantityString.substring(0, quantityString.length - 1)) ?? 0);
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title:
                      "${AppLocalizations.of(event.context)!.this_supplier_have}${productStockList[event.productListIndex][event.productStockUpdateIndex].stock}${AppLocalizations.of(event.context)!.quantity_in_stock}",
                  type: SnackBarType.failure);
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
            if (state.productStockList[event.productListIndex][event.productStockUpdateIndex].quantity >
                state.productStockList[event.productListIndex][event.productStockUpdateIndex].maxQty) {
              CustomSnackBar.showSnackBar(
                  context: event.context, title: AppLocalizations.of(event.context)!.not_add_more_than_max_qty, type: SnackBarType.failure);
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
                        final response = await DioClient(event.context)
                            .post(AppUrlEndPoints.removeCartProductUrl, data: {AppStrings.cartProductIdString: cartProductId});

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
            CustomSnackBar.showSnackBar(
                context: event.context, title: AppLocalizations.of(event.context)!.record_deleted_successfully, type: SnackBarType.success);
          } else {
            try {
              final res = await DioClient(event.context).post('${AppUrlEndPoints.getAllCartUrl}${preferences.getCartId()}');
              GetAllCartResModel response = GetAllCartResModel.fromJson(res);
              if (response.status == AppConstants.code_200) {
                response.data?.data?.forEach((cartProduct) {
                  if (cartProduct.id == event.productId ||
                      cartProduct.id == state.productStockList[event.productListIndex][event.productStockUpdateIndex].productId) {
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
                    saleId: state.productStockList[event.productListIndex][event.productStockUpdateIndex].productSaleId == ''
                        ? null
                        : state.productStockList[event.productListIndex][event.productStockUpdateIndex].productSaleId,
                    quantity: state.productStockList[event.productListIndex][event.productStockUpdateIndex].quantity,
                    cartProductId: _cartProductId);
                final res = await DioClient(event.context).post('${AppUrlEndPoints.updateCartProductUrl}${preferences.getCartId()}', data: request);
                UpdateCartResModel response = UpdateCartResModel.fromJson(res);
                if (response.status == AppConstants.code_201) {
                  Vibration.vibrate();
                  List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);
                  productStockList[event.productListIndex][event.productStockUpdateIndex] =
                      productStockList[event.productListIndex][event.productStockUpdateIndex].copyWith(
                          note: '',
                          productIsInCart: false,
                          productSupplierIds: event.productSupplierIds,
                          quantity: productStockList[event.productListIndex][event.productStockUpdateIndex].quantity,
                          totalPrice: productStockList[event.productListIndex][event.productStockUpdateIndex].totalPrice,
                          productSaleId: productStockList[event.productListIndex][event.productStockUpdateIndex].productSaleId);
                  emit(state.copyWith(productStockList: productStockList));

                  CustomSnackBar.showSnackBar(
                      context: event.context,
                      title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                      type: SnackBarType.success);
                } else {
                  Navigator.pop(event.context);
                  CustomSnackBar.showSnackBar(
                      context: event.context,
                      title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                      type: SnackBarType.failure);
                }
              } catch (_) {}
            } else {
              try {
                insert.InsertCartReqModel insertCartReqModel = insert.InsertCartReqModel(products: [
                  insert.Product(
                      productId: event.productId,
                      quantity: state.productStockList[event.productListIndex][event.productStockUpdateIndex].quantity,
                      supplierId: event.productSupplierIds,
                      saleId: state.productStockList[event.productListIndex][event.productStockUpdateIndex].productSaleId.isEmpty
                          ? null
                          : state.productStockList[event.productListIndex][event.productStockUpdateIndex].productSaleId,
                      note: state.productStockList[event.productListIndex][event.productStockUpdateIndex].note.isEmpty
                          ? null
                          : state.productStockList[event.productListIndex][event.productStockUpdateIndex].note),
                ]);
                Map<String, dynamic> req = insertCartReqModel.toJson();
                req.removeWhere((key, value) {
                  if (value != null) {}
                  return value == null;
                });
                final res = await DioClient(event.context).post('${AppUrlEndPoints.insertProductInCartUrl}${preferences.getCartId()}', data: req);
                InsertCartResModel response = InsertCartResModel.fromJson(res);
                if (response.status == AppConstants.code_201) {
                  Vibration.vibrate();
                  List<List<ProductStockModel>> productStockList = state.productStockList.toList(growable: true);
                  productStockList[event.productListIndex][event.productStockUpdateIndex] =
                      productStockList[event.productListIndex][event.productStockUpdateIndex].copyWith(
                          note: '',
                          productIsInCart: true,
                          quantity: state.productStockList[event.productListIndex][event.productStockUpdateIndex].quantity,
                          productSupplierIds: state.productStockList[event.productListIndex][event.productStockUpdateIndex].productSupplierIds,
                          totalPrice: productStockList[event.productListIndex][event.productStockUpdateIndex].totalPrice,
                          productSaleId: productStockList[event.productListIndex][event.productStockUpdateIndex].productSaleId);

                  emit(state.copyWith(productStockList: productStockList));
                  await Future.delayed(const Duration(milliseconds: 500));
                  CustomSnackBar.showSnackBar(
                      context: event.context,
                      title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                      type: SnackBarType.success);
                } else if (response.status == AppConstants.code_403) {
                } else {
                  CustomSnackBar.showSnackBar(
                      context: event.context,
                      title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context),
                      type: SnackBarType.failure);
                }
              } catch (_) {}
            }
          }
        } else if (event is _getProfileDetailsEvent) {
          try {
            final res = await DioClient(event.context).post(AppUrlEndPoints.getProfileDetailsUrl,
                data: req.ProfileDetailsReqModel(id: preferences.getUserId()).toJson(),
                options: Options(headers: {HttpHeaders.authorizationHeader: 'Bearer ${preferences.getAuthToken()}'}));
            res_get.ProfileDetailsResModel response = res_get.ProfileDetailsResModel.fromJson(res);
            if (response.status == AppConstants.code_200) {
              emit(state.copyWith(
                  clubAgentId: preferences.getClubAgentId(),
                  isAvailableAllPayments: response.data?.clients?.first.clientDetail?.isAvailableAllPayments ?? false));
            }
          } catch (_) {}
        }
      }
    });
  }
}
