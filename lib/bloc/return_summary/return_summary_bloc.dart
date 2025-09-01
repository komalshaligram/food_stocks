import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/req_model/create_return_req_model/create_return_req_model.dart' as req;
import '../../data/model/res_model/create_return_res_model/create_return_res_model.dart';
import '../../data/model/res_model/get_return_by_id_res_model/get_return_by_id_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';


part 'return_summary_state.dart';
part 'return_summary_event.dart';
part 'return_summary_bloc.freezed.dart';


class ReturnSummaryBloc extends Bloc<ReturnSummaryEvent, ReturnSummaryState> {
  ReturnSummaryBloc() : super(ReturnSummaryState.initial()) {
    on<ReturnSummaryEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (event is _getReturnListEvent) {
        Map map = event.product;
        if (map[AppStrings.isUpdateParamString]) {
          List<ReturnProduct> tempList = [];
          try {
            emit(state.copyWith(isShimmer: true));
            final response = await DioClient(event.context).get(
              path: AppUrlEndPoints.getReturnByIdUrl + map[AppStrings.idString],
            );
            GetReturnByIdResModel res = GetReturnByIdResModel.fromJson(response);
            tempList.addAll(res.data?.returnProducts ?? []);
            printData("tempList ${tempList}");
            for(int i =0;i<tempList.length;i++){
              if(tempList[i].supplierId==null){
                tempList[i]= ReturnProduct(supplierId: res.data?.supplierId,productImg: tempList[i].productImg,productName: tempList[i].productName,
                proofImages: tempList[i].proofImages,notes: tempList[i].notes, returnProductId: tempList[i].returnProductId, barcode: tempList[i].barcode,reasonToReturn: tempList[i].reasonToReturn,
                totalUnits: tempList[i].totalUnits,supplierName: res.data?.supplierName);
              }
            }
            emit(state.copyWith(isShimmer: false, returnProductList: tempList, returnId: map[AppStrings.idString],supplierId: res.data?.supplierId??''));
          } catch (e) {
            CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
          }
        } else {
          final List<ReturnProduct> myList = map['list'] as List<ReturnProduct>;
          emit(state.copyWith(language: preferencesHelper.getAppLanguage(), returnProductList: myList,returnId: ''));
        }
      } else if (event is _navigateToAddProductEvent) {
        emit(state.copyWith(returnProductList: state.returnProductList));
        Navigator.pushNamed(event.context, RouteDefine.scanReturnProduct.name,arguments: {'list':state.returnProductList});
      } else if (event is _updateReturnEvent) {
        emit(state.copyWith(isShimmer: true));
        try {
          List<req.ReturnProduct> list = [];

          for (int i = 0; i < state.returnProductList.length; i++) {
            if(event.supplierId==state.returnProductList[i].supplierId){
              list.add(req.ReturnProduct(totalRefund: state.returnProductList[i].totalRefund, proofImages: state.returnProductList[i].proofImages,
                  notes: state.returnProductList[i].notes, productName: state.returnProductList[i].productName, productImage: state.returnProductList[i].productImg,
                  barcode: state.returnProductList[i].barcode, totalUnits: state.returnProductList[i].totalUnits, isApproved: state.returnProductList[i].isApproved,
                  reasonToReturn: state.returnProductList[i].reasonToReturn,supplierId: state.returnProductList[i].supplierId));
            }
          }
          req.CreateReturnReqModel reqModel = req.CreateReturnReqModel(applicationName: AppStrings.appName,supplierId: event.supplierId,isDraft: false,
            clientId: preferencesHelper.getUserId(), returnProducts: list, subUserId: preferencesHelper.getSubUserId().isNotEmpty ? preferencesHelper.getSubUserId() : null,);
          final res = await DioClient(event.context).post(
            '${AppUrlEndPoints.updateReturnUrl}${state.returnProductList.first.returnId}',
            data: reqModel.toJson(),
          );
          CreateReturnResModel resModel = CreateReturnResModel.fromJson(res);
          if (resModel.status == AppConstants.code_201) {
            Map<String?, List<ReturnProduct>> tempMap = Map.from(state.supplierWiseMap);
            List<ReturnProduct> temp =[];
            temp.addAll(state.returnProductList);
            temp.removeWhere((e)=>e.supplierId ==event.supplierId);
            emit(state.copyWith(supplierWiseMap: {},returnProductList: temp));
            tempMap.remove(event.supplierId);
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(resModel.message?.toLocalization() ?? resModel.message!, event.context), type: SnackBarType.success);
            emit(state.copyWith(supplierWiseMap: tempMap,isShimmer: false,isLoading: false));
            if(state.supplierWiseMap.isEmpty){
              preferencesHelper.setReturnProductList(returnList: '');
              Navigator.pushNamedAndRemoveUntil(event.context, RouteDefine.returnListScreen.name, (Route route) => route.isFirst);
            }
          }
        } catch (e) {}
      }else if(event is _getSummaryListEvent){
        Map map = event.list;
        if(map['list']!=null){
          final supplierWiseMap = groupBy(map['list'], (ReturnProduct products)=> products.supplierId);
          emit(state.copyWith(supplierWiseMap:supplierWiseMap,returnProductList: map['list']));
        }
      }
    });
  }
}