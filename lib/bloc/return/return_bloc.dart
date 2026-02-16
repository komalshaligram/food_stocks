import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/data/model/res_model/get_return_list_res_model/get_return_list_res_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/get_all_order_req_model/get_all_order_req_model.dart';
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/res_model/get_return_by_id_res_model/get_return_by_id_res_model.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';
import '../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';

part 'return_state.dart';
part 'return_event.dart';
part 'return_bloc.freezed.dart';

class ReturnBloc extends Bloc<ReturnEvent, ReturnState> {
  ReturnBloc() : super(ReturnState.initial()) {
    on<ReturnEvent>((event, emit) async {
      Map map = {};
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (event is _getArgumentEvent) {
        map = event.list;
        List<ReturnProduct> tempList = [];
        if (map['list'] != null) {
          final List<ReturnProduct> myList = map['list'] as List<ReturnProduct>;
          if (myList.isNotEmpty) {
            for (int i = 0; i < myList.length; i++) {
              tempList.add(ReturnProduct(totalRefund: myList[i].totalRefund, supplierName: myList[i].supplierName, supplierId: myList[i].supplierId, proofImages: myList[i].proofImages, notes: myList[i].notes, productName: myList[i].productName, productImg: myList[i].productImg, returnId: myList[i].returnId, barcode: myList[i].barcode, returnProductId: myList[i].returnProductId, totalUnits: myList[i].totalUnits, isApproved: myList[i].isApproved, reasonToReturn: myList[i].reasonToReturn));
            }
            emit(state.copyWith(returnProductList: tempList));
          }
        }
        add(ReturnEvent.getReturnListEvent(context: event.context));
      } else if (event is _getReturnListEvent) {
        final String statusData = preferencesHelper.getReturnStatusInfo();
        final List<StatusData> statusList = StatusData.decode(statusData);
        if (state.isLoadMore) {
          return;
        }
        if (state.isBottomOfProducts) {
          return;
        }
        emit(state.copyWith(language: preferencesHelper.getAppLanguage(), isLoading: state.pageNum == 0 ? true : false, statusList: statusList, isLoadMore: state.pageNum == 0 ? false : true));
        try {
          GetAllOrderReqModel reqMap = GetAllOrderReqModel(pageNum: state.pageNum + 1, pageLimit: AppConstants.orderPageLimit, userId: preferencesHelper.getUserId());

          // userId :preferencesHelper.getUserId()
          final res = await DioClient(event.context).post(AppUrlEndPoints.getReturnListUrl, data: reqMap);
          GetReturnListResModel response = GetReturnListResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            List<Return> orderList = state.returnList.toList(growable: true);
            if ((response.data?.totalRecords ?? 1) > state.returnList.length) {
              orderList.addAll(response.data?.returns ?? []);
              emit(state.copyWith(isLoading: false, returnList: orderList, pageNum: state.pageNum + 1, isLoadMore: false));
              emit(state.copyWith(isBottomOfProducts: response.data?.returns?.length == (response.data?.totalRecords ?? 0) ? true : false));
            } else {
              emit(state.copyWith(isLoading: false, isLoadMore: false));
            }
          } else {
            emit(state.copyWith(isLoading: false, isLoadMore: false));
            Navigator.pop(event.context);
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? '', event.context), type: SnackBarType.failure);
          }
        } on ServerException {
          emit(state.copyWith(isLoading: false, isLoadMore: false));
        }
        state.refreshController.refreshCompleted();
        state.refreshController.loadComplete();
      } else if (event is _newRequestEvent) {
        preferencesHelper.setReturnProductList(returnList: '');
        Navigator.pushNamed(event.context, RouteDefine.scanReturnProduct.name, arguments: {'list': <ReturnProduct>[]});
      } else if (event is _openScannerEvent) {
        String scanResult = await scanBarcodeOrQRCode(context: event.context, cancelText: AppLocalizations.of(event.context)!.cancel, scanMode: ScanMode.BARCODE);
        if (scanResult != '-1') {
          // -1 result for cancel scanning
          emit(state.copyWith(barCodeController: TextEditingController(text: scanResult)));
        }
      } else if (event is _scanProductEvent) {
        try {
          emit(state.copyWith(isLoading: true));
          final res = await DioClient(event.context).post(AppUrlEndPoints.getProductDetailsUrl, data: ProductDetailsReqModel(params: event.barCode, isReturn: true).toJson());
          ProductDetailsResModel response = ProductDetailsResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(isLoading: false, barCodeController: TextEditingController(text: event.barCode)));
            if (response.product!.isEmpty) {
              CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.product_does_not_exist, type: SnackBarType.failure);
            } else {
              List<ReturnProduct> list = [];

              for (int i = 0; i < response.product!.length; i++) {
                list.add(ReturnProduct(productName: response.product![i].productName, productImg: '${AppUrlEndPoints.baseFileUrl}${response.product![i].mainImage}', returnId: state.returnProductList.isNotEmpty ? state.returnProductList.first.returnId ?? '' : '', supplierName: response.product![i].supplierName, supplierId: response.product![i].supplierId, barcode: response.product![i].qrcode));
              }
              list.addAll(state.returnProductList);

              Navigator.pushNamed(event.context, RouteDefine.productReturnInfoScreen.name, arguments: {
                'list': list,
              });
            }
          } else {
            emit(state.copyWith(isLoading: false));
            Navigator.pop(event.context);
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? '', event.context), type: SnackBarType.failure);
          }
        } on ServerException {
          Navigator.pop(event.context);
        }
      } else if (event is _refreshListEvent) {
        emit(state.copyWith(pageNum: 0, returnList: [], isBottomOfProducts: false));
        add(ReturnEvent.getReturnListEvent(context: event.context));
      }
    });
  }
}
