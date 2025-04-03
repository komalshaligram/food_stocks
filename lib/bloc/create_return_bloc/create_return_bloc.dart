import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/req_model/create_return_req_model/create_return_req_model.dart' as req;
import '../../data/model/req_model/delete_return_req/delete_return_req.dart';
import '../../data/model/res_model/create_return_res_model/create_return_res_model.dart';
import '../../data/model/res_model/get_return_by_id_res_model/get_return_by_id_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_constants.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'create_return_state.dart';
part 'create_return_event.dart';
part 'create_return_bloc.freezed.dart';

class CreateReturnBloc extends Bloc<CreateReturnEvent, CreateReturnState> {
  CreateReturnBloc() : super(CreateReturnState.initial()) {
    on<CreateReturnEvent>((event, emit) async {
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
            for(int i =0;i<tempList.length;i++){
              tempList[i]= ReturnProduct(supplierId: tempList[i].supplierId,productImg: tempList[i].productImg,productName: tempList[i].productName,
                  proofImages: tempList[i].proofImages,notes: tempList[i].notes,barcode: tempList[i].barcode,reasonToReturn: tempList[i].reasonToReturn,
                  totalUnits: tempList[i].totalUnits,supplierName: tempList[i].supplierName,returnId:res.data?.id??'');
            }
            emit(state.copyWith(isShimmer: false, returnProductList: tempList, returnId: map[AppStrings.idString],supplierId: res.data?.supplierId??'',
                language: preferencesHelper.getAppLanguage(),isFromPending: map['status']));
          } catch (e) {
            CustomSnackBar.showSnackBar(context: event.context, title: e.toString(), type: SnackBarType.failure);
          }
        } else {
          final List<ReturnProduct> myList = map['list'] as List<ReturnProduct>;
          emit(state.copyWith(language: preferencesHelper.getAppLanguage(), returnProductList: myList,returnId: ''));
        }
      } else if (event is _navigateToAddProductEvent) {
      //  emit(state.copyWith(returnProductList: state.returnProductList));
        Navigator.pushNamed(event.context, RouteDefine.scanReturnProduct.name,arguments: {'list':state.returnProductList,'status':state.isFromPending});
      } else if (event is _deleteEvent) {
        if (state.returnId.isNotEmpty) {
          DeleteReturnReq req = DeleteReturnReq(ids: [state.returnId]);
          try {
            final res = await DioClient(event.context).post(
              AppUrlEndPoints.deleteReturnUrl,
              data: req.toJson(),
            );

            if (res[AppStrings.statusString] == AppConstants.code_200) {
              emit(state.copyWith(returnProductList: []));
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(res[AppStrings.messageString].toString().toLocalization(), event.context),
                type: SnackBarType.success,
              );

              // Use addPostFrameCallback for navigation after the current frame is complete
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamedAndRemoveUntil(
                  event.context,
                  RouteDefine.returnListScreen.name,
                      (Route route) => route.isFirst,
                );
              });
            } else {
              CustomSnackBar.showSnackBar(
                context: event.context,
                title: AppStrings.getLocalizedStrings(res[AppStrings.messageString].toString()
                    .toLocalization(), event.context),
                type: SnackBarType.failure,
              );
            }
          } catch (e) {
            // Add specific error handling
            CustomSnackBar.showSnackBar(
              context: event.context,
              title: '${e.toString()}', // You can handle specific exceptions here
              type: SnackBarType.failure,
            );
          }
        } else {
          CustomSnackBar.showSnackBar(
            context: event.context,
            title: AppLocalizations.of(event.context)!.return_deleted,
            type: SnackBarType.failure,
          );
          emit(state.copyWith(returnProductList: []));
          // Using addPostFrameCallback to ensure navigation occurs after the current frame
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamedAndRemoveUntil(
              event.context,
              RouteDefine.returnListScreen.name,
                  (Route route) => route.isFirst,
            );
          });
        }
      } else if (event is _updateReturnEvent) {
        emit(state.copyWith(isLoading: true));
        try {
          List<req.ReturnProduct> list = [];
          for (int i = 0; i < state.returnProductList.length; i++) {
            list.add(req.ReturnProduct(totalRefund: state.returnProductList[i].totalRefund, proofImages: state.returnProductList[i].proofImages,
                notes: state.returnProductList[i].notes, productName: state.returnProductList[i].productName, productImage: state.returnProductList[i].productImg,
                barcode: state.returnProductList[i].barcode, totalUnits: state.returnProductList[i].totalUnits, isApproved: state.returnProductList[i].isApproved,
                reasonToReturn: state.returnProductList[i].reasonToReturn,supplierId:state.returnProductList[i].supplierId ));
          }
          req.CreateReturnReqModel reqModel = req.CreateReturnReqModel(applicationName: AppStrings.appName,supplierId: state.returnProductList.first.supplierId,isDraft: false,
              clientId: preferencesHelper.getUserId(), returnProducts: list, subUserId: preferencesHelper.getSubUserId().isNotEmpty ? preferencesHelper.getSubUserId() : null,
              );
          final res = await DioClient(event.context).post(
            '${AppUrlEndPoints.updateReturnUrl}${state.returnProductList.first.returnId??state.returnId}',
            data: reqModel.toJson(),
          );
          CreateReturnResModel resModel = CreateReturnResModel.fromJson(res);
          if (resModel.status == AppConstants.code_201) {

            emit(state.copyWith(isLoading: false));
            Navigator.pushNamedAndRemoveUntil(event.context, RouteDefine.returnListScreen.name, (Route route) => route.isFirst);
          }else{
            CustomSnackBar.showSnackBar(context: event.context, title: AppStrings.getLocalizedStrings(res[AppStrings.messageString].toString().toLocalization(), event.context), type: SnackBarType.failure);
            emit(state.copyWith(isShimmer: false));
          }
        } catch (e) {}
      }
      else if (event is _detailReturnEvent) {
        final result = await Navigator.pushNamed(event.context, RouteDefine.productReturnInfoScreen.name, arguments: {'list': state.returnProductList, 'index': event.index,'status':state.isFromPending});
        if(result!=null){
          emit(state.copyWith(returnProductList: []));
          List<ReturnProduct> list = [];
          list.addAll(result as List<ReturnProduct>);
          printData('update:${list.length}');
          emit(state.copyWith(returnProductList: list));
        }
        printData('result:$result');
      }else if(event is _getSummaryListEvent){
        Map map = event.list;
        if(map['list']!=null){
          final supplierWiseMap = groupBy(map['list'], (ReturnProduct products)=> products.supplierId);
          emit(state.copyWith(supplierWiseMap:supplierWiseMap,returnProductList: map['list']));
        }
      }else if(event is _navigateSummaryListEvent){
        final result = await Navigator.pushNamed(event.context, RouteDefine.returnSummaryScreen.name,arguments: {'list':state.returnProductList});
        if(result!=null){
          List<ReturnProduct> list =[];
          list.addAll(result as Iterable<ReturnProduct>);
          emit(state.copyWith(returnProductList: list));
          debugPrint("result:$list");
        }
      }
    });
  }
}