import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ui/utils/constants/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/permission_model/permission_model.dart';
import '../../data/model/req_model/update_permission/update_permission_model.dart';
import '../../data/model/res_model/brand_permission/brand_permission_res_model.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'brands_permission_event.dart';
part 'brands_permission_state.dart';
part 'brands_permission_bloc.freezed.dart';


class BrandsPermissionBloc extends Bloc<BrandsPermissionEvent, BrandsPermissionState> {
  BrandsPermissionBloc() : super(BrandsPermissionState.initial()) {
    on<BrandsPermissionEvent>((event, emit) async {

      if(event is _getPermissionList ){

        try {
          emit(state.copyWith(isShimmering: true , subUserId: event.subUserId));
          printData('subUserId____${event.subUserId}');
          final res = await DioClient(event.context).get(
              path: '${AppUrlEndPoints.getBrandPermissionUrl}${event.subUserId}');
          BrandPermissionResModel response = BrandPermissionResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {

            emit(state.copyWith(isShimmering:false));
            List<PermissionModel>brandPermissionList = [];

            response.data?.forEach((element) {
              brandPermissionList.add(
                  PermissionModel(
                      title: element.brand?.brandName ?? '',
                    isEnable: element.isAllowed ?? false,
                    brandId: element.brand?.id ?? ''
                  ));
            });
            emit(state.copyWith(isSelectAll: true));

            for(int i = 0 ; i < (response.data?.length ?? 0); i++ ){
              if(response.data?[i].isAllowed == false){
                emit(state.copyWith(isSelectAll: false));
                break;
              }
            }
            emit(state.copyWith(brandPermissionList: brandPermissionList));
          } else {
            emit(state.copyWith(isShimmering: false));
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      }


      if(event is _switchButtonEvent){
        List<PermissionModel>brandPermissionList = state.brandPermissionList.toList(growable: true);
        if(event.index == -1){
          bool isEnable = !state.isSelectAll;
          for (var element in brandPermissionList) {
            element.isEnable = isEnable;
          }
          emit(state.copyWith(brandPermissionList: brandPermissionList,isSelectAll:isEnable ));
        }
        else {
          brandPermissionList[event.index].isEnable =
          !brandPermissionList[event.index].isEnable;
          if (brandPermissionList[event.index].isEnable == false) {
            emit(state.copyWith(isSelectAll: false));
          }
          emit(state.copyWith(brandPermissionList: brandPermissionList,
              isRefresh: !state.isRefresh));
        }

        emit(state.copyWith(isSelectAll: true));

        for(int i = 0 ; i < (brandPermissionList.length ); i++ ){
          if(brandPermissionList[i].isEnable == false){
            emit(state.copyWith(isSelectAll: false));
            break;
          }
        }

      }

      else if(event is _updateBrandPermissionEvent){
        try {
          emit(state.copyWith(isUpdateProcess: true));
          List<BrandPermission> updateBrandPermission = [];
          for (var element in state.brandPermissionList) {
            updateBrandPermission.add(
                BrandPermission(
                  brandId: element.brandId,
                  isAllowed: element.isEnable
            ));
          }

          UpdatePermissionModel req = UpdatePermissionModel(
            brandPermissions: updateBrandPermission
          );

          Map<String, dynamic> updatePermissionReq = req.toJson();

          updatePermissionReq.removeWhere((key, value) {
            if (value != null) {
              printData("[$key] = $value");
            }
            return value == null;
          });


          final response = await DioClient(event.context).put(
              path: '${AppUrlEndPoints.updatePermissionUrl}${state.subUserId}',
              data: updatePermissionReq);

          if (response[AppStrings.statusString] == AppConstants.code_200) {
            emit(state.copyWith(isUpdateProcess: false));
            Navigator.pop(event.context);
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:  AppLocalizations.of(event.context)!.success_message,
                type: SnackBarType.success);

          } else {
            emit(state.copyWith(isUpdateProcess: false));
          }
        } on ServerException {

          emit(state.copyWith(isUpdateProcess: false));
        }
        catch(e){

          emit(state.copyWith(isUpdateProcess: false));
        }
      }
    });
  }
}