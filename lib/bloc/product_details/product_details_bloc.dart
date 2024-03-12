import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/req_model/remove_issue/remove_issue_req_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/order_model/product_details_model.dart';
import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/req_model/create_issue/create_issue_req_model.dart'
    as create;
import '../../data/model/req_model/update_cart/update_cart_req_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/get_order_by_id/get_order_by_id_model.dart';
import '../../data/model/res_model/insert_cart_res_model/insert_cart_res_model.dart';
import '../../data/model/res_model/update_cart_res/update_cart_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../data/model/req_model/insert_cart_req_model/insert_cart_req_model.dart'
as InsertCartModel;
part 'product_details_event.dart';

part 'product_details_state.dart';

part 'product_details_bloc.freezed.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  bool _isProductInCart = false;
  String _cartProductId = '';
  ProductDetailsBloc() : super(ProductDetailsState.initial()) {
    on<ProductDetailsEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getOrderByIdEvent) {
        debugPrint('token___${preferencesHelper.getAuthToken()}');
        debugPrint('orderid___${event.orderId}');
        emit(state.copyWith(isShimmering: true, isLoading: true , language:preferencesHelper.getAppLanguage()));
        try {
          final res = await DioClient(event.context).get(
            path: '${AppUrls.getOrderById}${preferencesHelper.getOrderId()}',
          );
          debugPrint('GetOrderById url   = ${AppUrls.getOrderById}${event.orderId}');
       //   debugPrint('GetOrderById res  = $res');
          GetOrderByIdModel response = GetOrderByIdModel.fromJson(res);
        //  debugPrint('GetOrderByIdModel  = $response');

          if (response.status == 200) {
            emit(state.copyWith(
                orderBySupplierProduct:
                    response.data?.ordersBySupplier?.first ??
                        OrdersBySupplier(),
                orderData: response.data?.orderData?.first ??
                    OrderDatum(),
                isShimmering: false ,isLoading: false ,isRefresh: !state.isRefresh));
          } else {
            emit(state.copyWith(
                isShimmering: false ,isLoading: false));
            CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(
                    response.message?.toLocalization() ??
                        response.message!,
                    event.context),
                type: SnackBarType.SUCCESS);
          }
        } on ServerException {emit(state.copyWith(
            isShimmering: false ,isLoading: false));}
        catch(e){
          emit(state.copyWith(
              isShimmering: false ,isLoading: false));
          CustomSnackBar.showSnackBar(
              context: event.context,
              title: e.toString(),
              type: SnackBarType.SUCCESS);
        }
      }

      if (event is _getProductDataEvent) {
        emit(state.copyWith(
            orderBySupplierProduct: event.orderBySupplierProduct,orderData: event.orderData, language: preferencesHelper.getAppLanguage()));
      }
      else if (event is _productProblemEvent) {
        List<int> index = [];
        bool isAllCheck = false;
        index = [...state.productListIndex];
        if (state.productListIndex.contains(event.index)) {
          index.remove(event.index);
        } else {
          index.add(event.index);
        }
        int length = state.orderBySupplierProduct.products?.length ?? 0;

        if (length == index.length) {
          isAllCheck = true;
        }

        emit(state.copyWith(productListIndex: index, isAllCheck: isAllCheck));
      } else if (event is _radioButtonEvent) {
        emit(state.copyWith(
            selectedRadioTile: event.selectRadioTile,
            isRefresh: !state.isRefresh
        ));
      } else if (event is _productIncrementEvent) {
        if (event.productQuantity > event.messingQuantity) {
          emit(state.copyWith(
              quantity: event.messingQuantity.round() + 1,
              isRefresh: !state.isRefresh,

          ));
        }
        else {
          CustomSnackBar.showSnackBar(
              context: event.context,
              title:  '${AppLocalizations.of(event.context)!.missing_quantity_notmore_than_original}',
              type: SnackBarType.FAILURE);
        }
      }

      else if (event is _productDecrementEvent) {
        if (event.messingQuantity >= 1) {
          emit(state.copyWith(
              quantity: event.messingQuantity.round() - 1,
              isRefresh: !state.isRefresh,
          missingQuantity: event.messingQuantity.round() - 1
          ));
        }


      }
      else if (event is _createIssueEvent) {
        emit(state.copyWith(isLoading: true));
        if (event.issue != '') {
          create.CreateIssueReqModel reqMap = create.CreateIssueReqModel(
            supplierId: event.supplierId,
            products: [
              create.Product(
                productId: event.productId,
                issue: event.issue,
                missingQuantity: event.missingQuantity,
              )
            ],
          );

          try {
            final response = await DioClient(event.context).post(
              '${AppUrls.createIssueUrl}${event.orderId}',
              data: reqMap,
            );

            debugPrint(
                'createIssue url  = ${DioClient.baseUrl}${AppUrls.createIssueUrl}${event.orderId}');
            debugPrint('createIssue Req  = $reqMap');
            debugPrint('[order Id ] = ${event.orderId}');
            if (response['status'] == 201) {

              add(ProductDetailsEvent.getOrderByIdEvent(context: event.context, orderId: preferencesHelper.getOrderId()));
              emit(state.copyWith(isLoading: false));

                Navigator.pop(event.BottomSheetContext,{AppStrings.issueString : event.issue});

              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response[AppStrings.messageString]
                          .toString()
                          .toLocalization(),
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
                  type: SnackBarType.SUCCESS);
            }
          } on ServerException {}
        } else {
          emit(state.copyWith(isLoading: false));
          Navigator.pop(event.context);
          CustomSnackBar.showSnackBar(
              context: event.context,
              title: '${AppLocalizations.of(event.context)!.select_issue}',
              type: SnackBarType.FAILURE);
        }
      } else if (event is _checkAllEvent) {
        List<int> number = [];
        if (state.isAllCheck == false) {
          int length = state.orderBySupplierProduct.products?.length ?? 0;
          number = List<int>.generate(length, (i) => i);
        } else {
          number = [];
        }
        emit(state.copyWith(
            productListIndex: number, isAllCheck: !state.isAllCheck));
      }

      else if(event is _getBottomSheetDataEvent){
        TextEditingController note = TextEditingController();
        note.text = event.note;
        emit(state.copyWith(addNoteController: note));
      }
      else if(event is _removeIssueEvent){
        emit(state.copyWith(isRemoveProcess: true));

          RemoveIssueReqModel reqMap = RemoveIssueReqModel(
            supplierId: event.supplierId,
          orderId: event.orderId,
            products: event.Product
          );

          try {
            final response = await DioClient(event.context).post(
              '${AppUrls.removeIssueUrl}',
              data: reqMap,
            );

            debugPrint(
                'removeIssue url  = ${DioClient.baseUrl}${AppUrls.removeIssueUrl}${event.orderId}');
            debugPrint('removeIssue Req  = $reqMap');
            debugPrint('[order Id ] = ${event.orderId}');
            if (response['status'] == 200) {

              add(ProductDetailsEvent.getOrderByIdEvent(context: event.context, orderId: preferencesHelper.getOrderId()));
              emit(state.copyWith(isRemoveProcess: false));
              Navigator.pop(event.BottomSheetContext,{AppStrings.issueString : 'issue'});

              // Navigator.pop(event.context);
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response[AppStrings.messageString]
                          .toString()
                          .toLocalization(),
                      event.context),
                  type: SnackBarType.SUCCESS);
            } else {
              emit(state.copyWith(isRemoveProcess: false));
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response[AppStrings.messageString].toLocalization() ??
                          response[AppStrings.messageString],
                      event.context),
                  type: SnackBarType.SUCCESS);
            }
          } on ServerException {  emit(state.copyWith(isRemoveProcess: false));}
        catch(e){
          CustomSnackBar.showSnackBar(
              context: event.context,
              title:e.toString(),
              type: SnackBarType.SUCCESS);
        }
        }

      else if (event is _duplicateButtonEvent) {
        add(ProductDetailsEvent.getAllCartEvent(context: event.context));
        List<InsertCartModel.Product> insertList = [];
        List<InsertCartModel.Product> updateList = [];

        state.orderBySupplierProduct.products?.forEach((element) {
          for(int i = 0 ; i > (state.productStockList.length ) ; i++ ){
            if(element.productId == state.productStockList[i].productId){
              insertList.add(
                InsertCartModel.Product(
                  productId: element.productId,
                  quantity: element.quantity,
                  saleId: '',
                  supplierId: state.orderBySupplierProduct.id,
                )
              );
            }
            else{
              updateList.add(
                  InsertCartModel.Product(
                    productId: element.productId,
                    quantity: element.quantity,
                    saleId: '',
                    supplierId: state.orderBySupplierProduct.id,
                  )
              );
            }
          }
        });

        add(ProductDetailsEvent.updateQuantityOfProduct(context: event.context));
        add(ProductDetailsEvent.addToCartProductEvent(context: event.context, productId: ''));






        if (_isProductInCart /*cartProductList.contains(
            state.productStockList[state.productStockUpdateIndex].productId)*/) {
          debugPrint('update cart');
          try {
            emit(state.copyWith(isLoading: true));
            UpdateCartReqModel request = UpdateCartReqModel(
              productId: state.productStockList[state.productStockUpdateIndex].productId == ''? '':state.productStockList[state.productStockUpdateIndex].productId,
              supplierId: state.productStockList[state
                  .productStockUpdateIndex]
                  .productSupplierIds,
              saleId: state.productStockList[state.productStockUpdateIndex]
                  .productSaleId ==
                  ''
                  ? null
                  : state.productStockList[state.productStockUpdateIndex]
                  .productSaleId,
              quantity: state.productStockList[state.productStockUpdateIndex]
                  .quantity,
              cartProductId: _cartProductId
              /*cartProductIdList[cartProductList.indexOf(state
                  .productStockList[state.productStockUpdateIndex].productId)]*/,
            );
            final res = await DioClient(event.context).post(
              '${AppUrls.updateCartProductUrl}${preferencesHelper.getCartId()}',
              data: request,
            );
            UpdateCartResModel response = UpdateCartResModel.fromJson(res);
            if (response.status == 201) {
              Vibration.vibrate();
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
          debugPrint('insert cart');
          try {
            emit(state.copyWith(isLoading: true));
            InsertCartModel.InsertCartReqModel insertCartReqModel =
            InsertCartModel.InsertCartReqModel(products: [
              InsertCartModel.Product(
                  productId: state.productStockList[state.productStockUpdateIndex].productId == ''? 'event.productId' :state.productStockList[state.productStockUpdateIndex].productId,
                  quantity: state
                      .productStockList[state.productStockUpdateIndex]
                      .quantity,
                  supplierId: state
                      .productStockList[state.productStockUpdateIndex]
                      .productSupplierIds,
                  note: state.productStockList[state.productStockUpdateIndex]
                      .note.isEmpty
                      ? null
                      : state
                      .productStockList[state.productStockUpdateIndex].note,
                  saleId: state.productStockList[state
                      .productStockUpdateIndex]
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
                'insert cart url1 = ${AppUrls
                    .insertProductInCartUrl}${preferencesHelper
                    .getCartId()}');
            debugPrint(
                'insert cart url1 auth = ${preferencesHelper
                    .getAuthToken()}');
            final res = await DioClient(event.context).post(
                '${AppUrls.insertProductInCartUrl}${preferencesHelper
                    .getCartId()}',
                data: req,);
            InsertCartResModel response = InsertCartResModel.fromJson(res);
            if (response.status == 201) {

              Vibration.vibrate();

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
                  isLoading: false,
                  productStockList: productStockList,
                //  isCartCountChange: true
              ));
            //  emit(state.copyWith(isCartCountChange: false));
             // add(HomeEvent.setCartCountEvent());


              Navigator.pop(event.context);
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ??
                          response.message!,
                      event.context),
                  type: SnackBarType.SUCCESS);
            } else if (response.status == 403) {
              emit(state.copyWith(isLoading: false));
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
        }
      }


     else if (event is _getAllCartEvent) {
        debugPrint('cartId____${preferencesHelper.getCartId()}');

        emit(state.copyWith(
            isShimmering: true,
            language: preferencesHelper.getAppLanguage(),
        )
        );
        try {
          final res = await DioClient(event.context).post(
            '${AppUrls.getAllCartUrl}${preferencesHelper.getCartId()}',
          );

          GetAllCartResModel response = GetAllCartResModel.fromJson(res);

          if (response.status == 200) {
            emit(state.copyWith( isShimmering: false));
            List<ProductDetailsModel> temp = [];
            List<ProductStockModel> productStockList =
            state.productStockList.toList(growable: true);
            productStockList.clear();
            productStockList.addAll(response.data?.data?.map(
                    (recommendationProduct) =>
                    ProductStockModel(
                      productSupplierIds: '',
                        quantity: recommendationProduct.totalQuantity?? 0,
                        productId: recommendationProduct.id ?? '',
                        stock: recommendationProduct.productStock.toString() )) ??
                []);
             debugPrint('productStockList____${productStockList}');
            await preferencesHelper.setCartCount(
                count: temp.isEmpty
                    ? preferencesHelper.getCartCount()
                    : temp.length);
            emit(state.copyWith(
              productStockList: productStockList,
            ));
          } else {
            emit(state.copyWith(isShimmering: false));
          }
        } on ServerException {}
      }
    });
  }
}
