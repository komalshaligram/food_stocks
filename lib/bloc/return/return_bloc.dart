import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/data/model/res_model/get_return_list_res_model/get_return_list_res_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/create_return_req_model/create_return_req_model.dart' as req;
import '../../data/model/req_model/product_details_req_model/product_details_req_model.dart';
import '../../data/model/res_model/get_return_by_id_res_model/get_return_by_id_res_model.dart';
import '../../data/model/res_model/product_details_res_model/product_details_res_model.dart';
import '../../data/model/res_model/status_info_res_model/status_info_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';

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
        if(map['list']!=null){
          final List<ReturnProduct> myList = map['list'] as List<ReturnProduct>;
          if (myList.isNotEmpty) {
            for (int i = 0; i < myList.length; i++) {
              tempList.add(ReturnProduct(totalRefund: myList[i].totalRefund,supplierName:myList[i].supplierName,supplierId: myList[i].supplierId, proofImages: myList[i].proofImages, notes: myList[i].notes, productName: myList[i].productName, productImg: myList[i].productImg, barcode: myList[i].barcode, totalUnits: myList[i].totalUnits, isApproved: myList[i].isApproved, reasonToReturn: myList[i].reasonToReturn));
            }
            emit(state.copyWith(returnProductList: tempList));
          }
        }
        add(ReturnEvent.getReturnListEvent(context: event.context));
      } else if (event is _getReturnListEvent) {
        final String statusData = preferencesHelper.getReturnStatusInfo();
        final List<StatusData> statusList = StatusData.decode(statusData);
        emit(state.copyWith(language: preferencesHelper.getAppLanguage(), isLoading: true, statusList: statusList));
        try {
          Map reqMap = {"pageNum": "1", "pageLimit": "20"};
          final res = await DioClient(event.context).post(AppUrlEndPoints.getReturnListUrl, data: reqMap);
          GetReturnListResModel response = GetReturnListResModel.fromJson(res);
          printData('GetProductDetails_____$response');
          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(isLoading: false, returnList: response.data?.returns ?? []));
          } else {
            emit(state.copyWith(isLoading: false));
            Navigator.pop(event.context);
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? '', event.context), type: SnackBarType.failure);
          }
        } on ServerException {}
      } else if (event is _newRequestEvent) {
        preferencesHelper.setReturnProductList(returnList: '');
        Navigator.pushNamed(event.context, RouteDefine.scanReturnProduct.name, arguments: {'list': <ReturnProduct>[]});
      } else if (event is _openScannerEvent) {
        String scanResult = await scanBarcodeOrQRCode(context: event.context, cancelText: AppLocalizations.of(event.context)!.cancel, scanMode: ScanMode.BARCODE);
        if (scanResult != '-1') {
          // -1 result for cancel scanning
          printData('result = $scanResult');
          emit(state.copyWith(barCodeController: TextEditingController(text: scanResult)));
        }
      } else if (event is _scanProductEvent) {
        try {
          emit(state.copyWith(isLoading: true));
          final res = await DioClient(event.context).post(AppUrlEndPoints.getProductDetailsUrl, data: ProductDetailsReqModel(params: event.barCode).toJson());
          ProductDetailsResModel response = ProductDetailsResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(isLoading: false, barCodeController: TextEditingController(text: event.barCode)));
            if (response.product!.isEmpty) {
              CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.product_does_not_exist, type: SnackBarType.failure);
            } else {
              if (state.returnProductList.isNotEmpty) {
                List<ReturnProduct> list = [];
                for (int i = 0; i < response.product!.length; i++) {
                  list.add(const ReturnProduct());
                }
                list.addAll(state.returnProductList);
                Navigator.pushNamed(event.context, RouteDefine.productReturnInfoScreen.name, arguments: {'list': state.returnProductList, 'data': response.product?.first.toJson()});
              } else {
                Navigator.pushNamed(event.context, RouteDefine.productReturnInfoScreen.name, arguments: {'data': response.product?.first.toJson()});
              }
            }
          } else {
            emit(state.copyWith(isLoading: false));
            Navigator.pop(event.context);
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(response.message?.toLocalization() ?? '', event.context), type: SnackBarType.failure);
          }
        } on ServerException {
          Navigator.pop(event.context);
        }
      }
    });
  }
}
