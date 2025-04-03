import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../data/model/req_model/remove_issue/remove_issue_req_model.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/constants/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/error/exceptions.dart';

import '../../data/model/product_stock_model/product_stock_model.dart';
import '../../data/model/req_model/create_issue/create_issue_req_model.dart' as create;

import '../../data/model/res_model/account_permission/account_permission_res_model.dart';
import '../../data/model/res_model/get_all_cart_res_model/get_all_cart_res_model.dart';
import '../../data/model/res_model/get_order_by_id/get_order_by_id_model.dart';

import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'product_details_event.dart';

part 'product_details_state.dart';

part 'product_details_bloc.freezed.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  ProductDetailsBloc() : super(ProductDetailsState.initial()) {
    on<ProductDetailsEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getOrderByIdEvent) {

        emit(state.copyWith(isShimmering: true, isLoading: true, language: preferencesHelper.getAppLanguage(), isSubUserCreateDuplicateOrder: preferencesHelper.getCanDuplicateOrder(), isIncludedVat: preferencesHelper.getIsIncludedVat()));
        try {
          final res = await DioClient(event.context).get(
            path: '${AppUrlEndPoints.getOrderById}${preferencesHelper.getOrderId()}',
          );
          printData('GetOrderById url   = ${AppUrlEndPoints.getOrderById}${event.orderId}');
   
          GetOrderByIdModel response = GetOrderByIdModel.fromJson(res);
       

          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(orderBySupplierProduct: response.data?.ordersBySupplier?.first ?? const OrdersBySupplier(), orderData: response.data?.orderData?.first ?? const OrderDatum(), isShimmering: false, isLoading: false, isRefresh: !state.isRefresh));
          } else {
            emit(state.copyWith(isShimmering: false, isLoading: false));
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.failure);
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false, isLoading: false));
        } catch (e) {
          emit(state.copyWith(isShimmering: false, isLoading: false));
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
        }
      }

      if (event is _getProductDataEvent) {
        emit(state.copyWith(orderBySupplierProduct: event.orderBySupplierProduct, orderData: event.orderData, language: preferencesHelper.getAppLanguage()));
      } else if (event is _productProblemEvent) {
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
        emit(state.copyWith(selectedRadioTile: event.selectRadioTile, isRefresh: !state.isRefresh));
      } else if (event is _productIncrementEvent) {
        if (event.productQuantity > event.messingQuantity) {
          emit(state.copyWith(
            quantity: event.messingQuantity.round() + 1,
            isRefresh: !state.isRefresh,
          ));
        } else {
          CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.missing_quantity_not_more_than_original, type: SnackBarType.failure);
        }
      } else if (event is _productDecrementEvent) {
        if (event.messingQuantity >= 1) {
          emit(state.copyWith(quantity: event.messingQuantity.round() - 1, isRefresh: !state.isRefresh, missingQuantity: event.messingQuantity.round() - 1));
        }
      } else if (event is _createIssueEvent) {
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
              '${AppUrlEndPoints.createIssueUrl}${event.orderId}',
              data: reqMap,
            );

         
            if (response[AppStrings.statusString] == AppConstants.code_201) {
              emit(state.copyWith(isLoading: false));

              Navigator.pop(event.bottomSheetContext, {AppStrings.issueString: event.issue});

              CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response[AppStrings.messageString].toString().toLocalization(), event.context), type: SnackBarType.success);
            } else {
              Navigator.pop(event.bottomSheetContext, {AppStrings.issueString: ''});
              emit(state.copyWith(isLoading: false));
              CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response[AppStrings.messageString].toString().toLocalization(), event.context), type: SnackBarType.failure);
            }
          } on ServerException {
            Navigator.pop(event.bottomSheetContext, {AppStrings.issueString: ''});
          } catch (e) {
            Navigator.pop(event.bottomSheetContext, {AppStrings.issueString: ''});
            CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
          }
        } else {
          emit(state.copyWith(isLoading: false));
          Navigator.pop(event.context);
          CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.select_issue, type: SnackBarType.failure);
        }
      } else if (event is _checkAllEvent) {
        List<int> number = [];
        if (state.isAllCheck == false) {
          int length = state.orderBySupplierProduct.products?.length ?? 0;
          number = List<int>.generate(length, (i) => i);
        } else {
          number = [];
        }
        emit(state.copyWith(productListIndex: number, isAllCheck: !state.isAllCheck));
      } else if (event is _getBottomSheetDataEvent) {
        TextEditingController note = TextEditingController();
        note.text = event.note;
        emit(state.copyWith(addNoteController: note));
      } else if (event is _removeIssueEvent) {
        emit(state.copyWith(isRemoveProcess: true));

        RemoveIssueReqModel reqMap = RemoveIssueReqModel(supplierId: event.supplierId, orderId: event.orderId, products: event.product);

        try {
          final response = await DioClient(event.context).post(
            AppUrlEndPoints.removeIssueUrl,
            data: reqMap,
          );

      
          if (response[AppStrings.statusString] == AppConstants.code_200) {
            add(ProductDetailsEvent.getOrderByIdEvent(context: event.context, orderId: preferencesHelper.getOrderId()));
            emit(state.copyWith(isRemoveProcess: false));
            Navigator.pop(event.bottomSheetContext, {AppStrings.issueString: 'issue'});

            // Navigator.pop(event.context);
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response[AppStrings.messageString].toString().toLocalization(), event.context), type: SnackBarType.success);
          } else {
            emit(state.copyWith(isRemoveProcess: false));
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response[AppStrings.messageString].toString().toLocalization(), event.context), type: SnackBarType.failure);
          }
        } on ServerException {
          emit(state.copyWith(isRemoveProcess: false));
        } catch (e) {
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
        }
      } else if (event is _duplicateOrderEvent) {
        emit(state.copyWith(isDuplicateOrderProcess: true));
        try {
          final response = await DioClient(event.context).post(
            AppUrlEndPoints.duplicateOrderUrl,
            data: {AppStrings.orderIdString: event.orderId, AppStrings.cartIdString: preferencesHelper.getCartId()},
          );

   
          if (response[AppStrings.statusString] == AppConstants.code_200) {
            Navigator.pop(event.dialogContext);

            Navigator.pushNamed(event.context, RouteDefine.bottomNavScreen.name, arguments: {AppStrings.isBasketScreenString: 'true'});
            emit(state.copyWith(isDuplicateOrderProcess: false));
          } else {
            Navigator.pop(event.dialogContext);
            emit(state.copyWith(isDuplicateOrderProcess: false));
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response[AppStrings.messageString].toString().toLocalization(), event.context), type: SnackBarType.failure);
          }
        } on ServerException {
          emit(state.copyWith(isDuplicateOrderProcess: false));
        } catch (e) {
          emit(state.copyWith(isDuplicateOrderProcess: false));
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
        }
      } else if (event is _getAllCartEvent) {
        printData('cartId____${preferencesHelper.getCartId()}');

        emit(state.copyWith(isDuplicateOrderProcess: true));
        try {
          final res = await DioClient(event.context).post(
            '${AppUrlEndPoints.getAllCartUrl}${preferencesHelper.getCartId()}',
          );

       
          GetAllCartResModel response = GetAllCartResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(
              isDuplicateOrderProcess: false,
            ));
            List<ProductStockModel> stockList = [];
            stockList.addAll(response.data?.data?.map((product) => ProductStockModel(quantity: product.totalQuantity ?? 0, productId: product.id ?? '', stock: product.productStock.toString(), lowStock: product.lowStock.toString())) ?? []);

            await preferencesHelper.setCartCount(count: stockList.length);
            emit(state.copyWith(isCartCount: true));
          } else {
            emit(state.copyWith(isDuplicateOrderProcess: false));
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.failure);
          }
        } on ServerException {
          emit(state.copyWith(isDuplicateOrderProcess: false));
        } catch (e) {
          emit(state.copyWith(isDuplicateOrderProcess: false));
          CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
        }
      } else if (event is _getPermissionList) {
        if (preferencesHelper.getSubUser()) {
          try {
            final res = await DioClient(event.context).get(path: '${AppUrlEndPoints.getAccountPermissionUrl}${preferencesHelper.getSubUserId()}');
            AccountPermissionResModel response = AccountPermissionResModel.fromJson(res);
          
            printData('AccountPermission url = ${AppUrlEndPoints.baseUrl}${AppUrlEndPoints.getAccountPermissionUrl}${preferencesHelper.getSubUserId()}');
            if (response.status == AppConstants.code_200) {
              var res = response.data?.permissions;
              preferencesHelper.setCanSeeWallet(isSeeWallet: res?.canSeeWallet ?? false);
              preferencesHelper.setCanAddBasket(isAddBasket: res?.canAddToCart ?? false);
              preferencesHelper.setCanCreateOrder(isCreateOrder: res?.canCreateOrder ?? false);
              preferencesHelper.setCanSeeOrder(isSeeOrder: res?.canSeeOrders ?? false);
              preferencesHelper.setCanDuplicateOrder(isDuplicateOrder: res?.canDuplicateOrders ?? false);
              preferencesHelper.setCanUpdateBusinessInfo(isUpdateBusinessInfo: res?.canSeeAndUpdateBusinessInfo ?? false);
              preferencesHelper.setCanUpdateAdditionalInfo(isUpdateAdditionalInfo: res?.canSeeAndUpdateAdditionalInfo ?? false);
              preferencesHelper.setCanUpdateTimeInfo(isUpdateTimeInfo: res?.canSeeAndUpdateTimesInfo ?? false);
              preferencesHelper.setCanSeeFormsFiles(isSeeFormsFiles: res?.canSeeFileAndForms ?? false);
              preferencesHelper.setManageSubUser(isManageSubUser: res?.canManageSubUsers ?? false);

            } else {
              CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? response.message!, event.context), type: SnackBarType.failure);
            }
          } catch (e) {
            CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
          }
        }
      }
    });
  }
}
