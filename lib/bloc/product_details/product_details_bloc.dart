import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/data/model/req_model/remove_issue/remove_issue_req_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/create_issue/create_issue_req_model.dart'
    as create;
import '../../data/model/res_model/get_order_by_id/get_order_by_id_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'product_details_event.dart';

part 'product_details_state.dart';

part 'product_details_bloc.freezed.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
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
                'createIssue url  = ${AppUrls.baseUrl}${AppUrls.createIssueUrl}${event.orderId}');
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
                'removeIssue url  = ${AppUrls.baseUrl}${AppUrls.removeIssueUrl}${event.orderId}');
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
    });
  }
}
