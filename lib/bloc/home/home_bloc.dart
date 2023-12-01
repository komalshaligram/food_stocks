import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/req_model/product_sales_req_model/product_sales_req_model.dart';
import 'package:food_stock/data/model/res_model/message_count_res_model/message_count_res_model.dart';
import 'package:food_stock/data/model/res_model/product_details_res_model/product_details_res_model.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/error/exceptions.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/product_supplier_model/product_supplier_model.dart';
import '../../data/model/req_model/get_messages_req_model/get_messages_req_model.dart';
import '../../data/model/req_model/get_order_count/get_order_count_req_model.dart';
import '../../data/model/req_model/insert_cart_req_model/insert_cart_req_model.dart'
    as InsertCartModel;
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/req_model/wallet_record_req/wallet_record_req_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/get_messages_res_model/get_messages_res_model.dart';
import '../../data/model/res_model/insert_cart_res_model/insert_cart_res_model.dart';
import '../../data/model/res_model/order_count/get_order_count_res_model.dart';
import '../../data/model/res_model/product_sales_res_model/product_sales_res_model.dart';
import '../../data/model/res_model/wallet_record_res/wallet_record_res_model.dart';
import '../../data/model/supplier_sale_model/supplier_sale_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

part 'home_event.dart';

part 'home_state.dart';

part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    on<HomeEvent>((event, emit) async {
      SharedPreferencesHelper preferences =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getPreferencesDataEvent) {
        debugPrint(
            'getUserImageUrl ${AppUrls.baseFileUrl}${preferences.getUserImageUrl()}');
        debugPrint(
            'getUserCompanyLogoUrl ${preferences.getUserCompanyLogoUrl()}');
        debugPrint('cart count ${preferences.getCartCount()}');
        debugPrint('message count ${preferences.getMessageCount()}');
        emit(state.copyWith(
            UserImageUrl: preferences.getUserImageUrl(),
            UserCompanyLogoUrl: preferences.getUserCompanyLogoUrl(),
            messageCount: preferences.getMessageCount(),
            cartCount: preferences.getCartCount()));
      } else if (event is _GetCartCountEvent) {
        try {
          final res = await DioClient(event.context).post(
              '${AppUrls.getAllCartUrl}${preferences.getCartId()}',
              options: Options(headers: {
                HttpHeaders.authorizationHeader:
                    'Bearer ${preferences.getAuthToken()}'
              }));

          GetAllCartResModel response = GetAllCartResModel.fromJson(res);
          if (response.status == 200) {
            debugPrint('main cart count = ${response.data?.data?.length}');
            await preferences.setCartCount(
                count:
                    response.data?.data?.length ?? preferences.getCartCount());
            emit(state.copyWith(cartCount: preferences.getCartCount()));
          }
        } on ServerException {}
        //message count
        try {
          final res = await DioClient(event.context).post(
              AppUrls.getUnreadMessageCountUrl,
              options: Options(headers: {
                HttpHeaders.authorizationHeader:
                    'Bearer ${preferences.getAuthToken()}'
              }));

          MessageCountResModel response = MessageCountResModel.fromJson(res);
          if (response.status == 200) {
            print('unread message count = ${response.data}');
            await preferences.setMessageCount(
                count: response.data ?? preferences.getMessageCount());
            emit(state.copyWith(messageCount: response.data ?? 0));
          }
        } on ServerException {}
      } else if (event is _GetProductSalesListEvent) {
        try {
          emit(state.copyWith(isProductSaleShimmering: true));
          final res = await DioClient(event.context).post(
              AppUrls.getSaleProductsUrl,
              data: ProductSalesReqModel(
                      pageNum: 1, pageLimit: AppConstants.defaultPageLimit)
                  .toJson());
          ProductSalesResModel response = ProductSalesResModel.fromJson(res);
          if (response.status == 200) {
            List<ProductSale> saleProductsList =
                response.data?.toList(growable: true) ?? [];
            saleProductsList.map((sale) => debugPrint('${sale.endDate}'));
           /* saleProductsList.removeWhere(
                (sale) => sale.endDate?.isBefore(DateTime.now()) ?? true);*/
            debugPrint('sale Products = ${saleProductsList.length}');
            debugPrint('sale Products = ${response.data?.length}');
            List<ProductStockModel> productStockList = [];
            productStockList.addAll(response.data?.map((saleProduct) =>
                    ProductStockModel(
                        productId: saleProduct.id ?? '',
                        stock: int.parse(saleProduct.numberOfUnit ?? '0'))) ??
                []);
            debugPrint('stock list len = ${productStockList.length}');
            emit(state.copyWith(
                productSalesList: response.data ?? [],
                productStockList: productStockList,
                isProductSaleShimmering: false));
          } else {
            showSnackBar(
                context: event.context,
                title: AppStrings.somethingWrongString,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
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
            List<ProductSupplierModel> supplierList = [];
            // debugPrint(
            //     'response supplier id = ${response.product?.first.supplierSales?.supplier?.id ?? ''}');
            debugPrint(
                'supplier id = ${state.productStockList[productStockUpdateIndex].productSupplierIds}');
            supplierList.addAll(response.product?.first.supplierSales
                    ?.map((supplier) => ProductSupplierModel(
                          supplierId: supplier.supplierId ?? '',
                          companyName: supplier.supplierCompanyName ?? '',
                          basePrice:
                              double.parse(supplier.productPrice ?? '0.0'),
                          selectedIndex: (supplier.supplierId ?? '') ==
                                  state
                                      .productStockList[productStockUpdateIndex]
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
                          // supplier.supplierSales?.supplier?.sale?.indexOf(
                          //             supplier.supplierSales?.supplier?.sale
                          //                     ?.firstWhere((sale) =>
                          //                         sale.saleId ==
                          //                         state
                          //                             .productStockList[
                          //                                 productStockUpdateIndex]
                          //                             .productSaleId) ??
                          //                 Sale()) ??
                          // -1
                          // : -1,
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
          if (productStockList[state.productStockUpdateIndex].quantity <
              productStockList[state.productStockUpdateIndex].stock) {
            if (productStockList[state.productStockUpdateIndex]
                .productSupplierIds.isEmpty) {
              showSnackBar(
                  context: event.context,
                  title: AppStrings.selectSupplierMsgString,
                  bgColor: AppColors.redColor);
              return;
            }
            productStockList[state.productStockUpdateIndex] =
                productStockList[state.productStockUpdateIndex].copyWith(
                    quantity: productStockList[state.productStockUpdateIndex]
                        .quantity +
                        1);
            debugPrint(
                'product quantity = ${productStockList[state
                    .productStockUpdateIndex].quantity}');
            emit(state.copyWith(productStockList: productStockList));
          } else {
            showSnackBar(
                context: event.context,
                title: AppStrings.maxQuantityMsgString,
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
                      /*supplierList[event.supplierIndex].selectedIndex ==
                              event.supplierSaleIndex
                          ? ''
                          : */
                      supplierList[event.supplierIndex].supplierId,
                  totalPrice: event.supplierSaleIndex == -2
                      ? supplierList[event.supplierIndex].basePrice
                      : /*supplierList[event.supplierIndex].selectedIndex ==
                              event.supplierSaleIndex
                          ? supplierList[event.supplierIndex]
                              .supplierSales[event.supplierSaleIndex]
                              .salePrice
                          :*/
                      supplierList[event.supplierIndex]
                          .supplierSales[event.supplierSaleIndex]
                          .salePrice,
                  productSaleId: event.supplierSaleIndex == -2
                      ? ''
                      : /*supplierList[event.supplierIndex].selectedIndex ==
                              event.supplierSaleIndex
                          ? ''
                          :*/
                      supplierList[event.supplierIndex]
                          .supplierSales[event.supplierSaleIndex]
                          .saleId);
          debugPrint(
              'selected stock supplier = ${productStockList[state.productStockUpdateIndex]}');
          supplierList = supplierList
              .map((supplier) => supplier.copyWith(selectedIndex: -1))
              .toList();
          debugPrint('selected supplier = ${supplierList}');
          supplierList[event.supplierIndex] =
              supplierList[event.supplierIndex].copyWith(
                  selectedIndex: /*event.supplierSaleIndex == -2
                      ? -2
                      : supplierList[event.supplierIndex].selectedIndex ==
                              event.supplierSaleIndex
                          ? -1
                          : */
                      event.supplierSaleIndex);
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
              title: AppStrings.selectSupplierMsgString,
              bgColor: AppColors.redColor);
          return;
        }
        if (state.productStockList[state.productStockUpdateIndex].quantity ==
            0) {
          showSnackBar(
              context: event.context,
              title: AppStrings.minQuantityMsgString,
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
                note: state.productStockList[state.productStockUpdateIndex].note
                        .isEmpty
                    ? null
                    : state
                        .productStockList[state.productStockUpdateIndex].note,
                saleId: state.productStockList[state.productStockUpdateIndex]
                        .productSaleId.isEmpty
                    ? null
                    : state.productStockList[state.productStockUpdateIndex]
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
            List<ProductStockModel> productStockList =
                state.productStockList.toList(growable: true);
            productStockList[state.productStockUpdateIndex] =
                productStockList[state.productStockUpdateIndex].copyWith(
                    note: '',
                    quantity: 0,
                    productSupplierIds: '',
                    totalPrice: 0.0,
                    productSaleId: '');
            emit(state.copyWith(
                isLoading: false,
                productStockList: productStockList,
                isCartCountChange: true));
            emit(state.copyWith(isCartCountChange: false));
            add(HomeEvent.setCartCountEvent());
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.addCartSuccessString,
                bgColor: AppColors.mainColor);
            Navigator.pop(event.context);
          } else if (response.status == 403) {
            emit(state.copyWith(isLoading: false));
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
          } else {
            emit(state.copyWith(isLoading: false));
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.redColor);
          }
        } on ServerException {
          debugPrint('url1 = ');
          emit(state.copyWith(isLoading: false));
        }
      } else if (event is _SetCartCountEvent) {
        await preferences.setCartCount(count: preferences.getCartCount() + 1);
        emit(state.copyWith(cartCount: preferences.getCartCount()));
        debugPrint('cart count = ${state.cartCount}');
      } else if (event is _getWalletRecordEvent) {
        try {
          WalletRecordReqModel reqMap =
              WalletRecordReqModel(userId: preferences.getUserId());
          debugPrint('WalletRecordReqModel = $reqMap}');
          final res = await DioClient(event.context).post(
            AppUrls.walletRecordUrl,
            data: reqMap,
          );

          debugPrint('WalletRecord url  = ${AppUrls.walletRecordUrl}');
          WalletRecordResModel response = WalletRecordResModel.fromJson(res);
          debugPrint('WalletRecordResModel  = $response');

          if (response.status == 200) {
            emit(state.copyWith(
                thisMonthExpense:
                    response.data?.currentMonth?.totalExpenses?.toDouble() ?? 0,
                lastMonthExpense:
                    response.data?.previousMonth?.totalExpenses?.toDouble() ??
                        0,
                balance: response.data?.balanceAmount?.toDouble() ?? 0,
                totalCredit: response.data?.totalCredit?.toDouble() ?? 0,
                expensePercentage : double.parse(response.data?.currentMonth!.expensePercentage ?? '')
            ));

          } else {
            showSnackBar(
                context: event.context,
                title: response.message!,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
      } else if (event is _getOrderCountEvent) {
        try {
          int daysInMonth(DateTime date) => DateTimeRange(
                  start: DateTime(date.year, date.month, 1),
                  end: DateTime(date.year, date.month + 1))
              .duration
              .inDays;

          var now = DateTime.now();

          GetOrderCountReqModel reqMap = GetOrderCountReqModel(
            startDate: DateTime(now.year, now.month, 1),
            endDate: DateTime(now.year, now.month, daysInMonth(DateTime.now())),
          );

          debugPrint('getOrdersCount reqMap = $reqMap}');

          final res =
              await DioClient(event.context).post(AppUrls.getOrdersCountUrl,
                  data: reqMap,
                  options: Options(
                    headers: {
                      HttpHeaders.authorizationHeader:
                          'Bearer ${preferences.getAuthToken()}',
                    },
                  ));

          debugPrint('getOrdersCountUrl url  = ${AppUrls.getOrdersCountUrl}');
          GetOrderCountResModel response = GetOrderCountResModel.fromJson(res);
          debugPrint('getOrdersCount response  = ${response}');

          if (response.status == 200) {
            emit(state.copyWith(orderThisMonth: response.data!.toInt()));
          }
        } on ServerException {}
      } else if (event is _GetMessageListEvent) {
        try {
          emit(state.copyWith(isMessageShimmering: true));
          final res = await DioClient(event.context).post(
              //  AppUrls.getAllMessagesUrl,
              AppUrls.getNotificationMessageUrl,
              data: GetMessagesReqModel(pageNum: 1, pageLimit: 2).toJson(),
              options: Options(
                headers: {
                  HttpHeaders.authorizationHeader:
                      'Bearer ${preferences.getAuthToken()}',
                },
              ));
          GetMessagesResModel response = GetMessagesResModel.fromJson(res);
          if (response.status == 200) {
            List<MessageData> messageList = [];
            messageList.addAll(response.data
                    ?.map((message) => MessageData(
                          id: message.id,
                          isRead: message.isRead,
                          message: Message(
                            id: message.message?.id ?? '',
                            title: message.message?.title ?? '',
                            summary: message.message?.summary ?? '',
                            body: message.message?.body ?? '',
                          ),
                          createdAt: message.createdAt,
                          updatedAt: message.updatedAt,
                        ))
                    .toList() ??
                []);
            /* messageList.removeWhere(
                (message) => (message.isPushNotification ?? false) == false);*/
            debugPrint('new message list len = ${messageList.length}');
            emit(state.copyWith(
                messageList: messageList, isMessageShimmering: false));
          } else {
            showSnackBar(
                context: event.context,
                title: response.message ?? AppStrings.somethingWrongString,
                bgColor: AppColors.mainColor);
          }
        } on ServerException {}
      } else if (event is _SetMessageCountEvent) {
        emit(state.copyWith(
            messageCount: state.messageCount + event.messageCount));
      } else if (event is _RemoveOrUpdateMessageEvent) {
        List<MessageData> messageList =
            state.messageList.toList(growable: true);
        debugPrint('message list len before delete = ${messageList.length}');
        SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());
        debugPrint('message count = ${preferencesHelper.getMessageCount()}');
        debugPrint(
            'message actual status = ${messageList[messageList.indexOf(messageList.firstWhere((message) => message.id == event.messageId))].isRead}');
        if (event.isRead) {
          if (messageList[messageList.indexOf(messageList
                      .firstWhere((message) => message.id == event.messageId))]
                  .isRead ==
              false) {
            await preferencesHelper.setMessageCount(
                count: preferencesHelper.getMessageCount() - 1);
            messageList[messageList.indexOf(messageList
                    .firstWhere((message) => message.id == event.messageId))] =
                messageList[messageList.indexOf(messageList.firstWhere(
                        (message) => message.id == event.messageId))]
                    .copyWith(isRead: true);
            emit(state.copyWith(messageCount: state.messageCount - 1));
          }
        }
        if (event.isDelete) {
          messageList.removeWhere((message) => message.id == event.messageId);
          debugPrint('message list len after delete = ${messageList.length}');
        }
        emit(state.copyWith(messageList: []));
        emit(state.copyWith(messageList: messageList));
      } else if (event is _UpdateImageIndexEvent) {
        emit(state.copyWith(imageIndex: event.index));
      }
    });
  }
  String splitNumber(String price) {
    var splitPrice = price.split(".");
    if (splitPrice[1] == "00") {
      return splitPrice[0];
    } else {
      return price.toString();
    }
  }
}
