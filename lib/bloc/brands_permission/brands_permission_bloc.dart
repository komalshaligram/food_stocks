import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/permission_model/permission_model.dart';
import '../../data/model/req_model/update_permission/update_permission_model.dart';
import '../../data/model/res_model/brand_permission/brand_permission_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';
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
          debugPrint('subUserId____${event.subUserId}');
          final res = await DioClient(event.context).get(
              path: '${AppUrls.getBrandPermissionUrl}${event.subUserId}');
          BrandPermissionResModel response = BrandPermissionResModel.fromJson(res);
          debugPrint('BrandPermission response = ${response.data.toString()}');
          debugPrint('BrandPermission url = ${AppUrls.baseUrl}${AppUrls.getBrandPermissionUrl}${event.subUserId}');
          if (response.status == 200) {

            emit(state.copyWith(isShimmering:false));
            List<permissionModel>brandPermissionList = [];

            response.data?.forEach((element) {
              brandPermissionList.add(
                  permissionModel(
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
        List<permissionModel>brandPermissionList = state.brandPermissionList.toList(growable: true);
        if(event.index == -1){
          bool isEnable = !state.isSelectAll;
          brandPermissionList.forEach((element) {
            element.isEnable = isEnable;
          });
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
          state.brandPermissionList.forEach((element) {
            updateBrandPermission.add(
                BrandPermission(
                  brandId: element.brandId,
                  isAllowed: element.isEnable
            ));
          });

          UpdatePermissionModel req = UpdatePermissionModel(
            brandPermissions: updateBrandPermission
          );

          Map<String, dynamic> updatePermissionReq = req.toJson();

          updatePermissionReq.removeWhere((key, value) {
            if (value != null) {
              debugPrint("[$key] = $value");
            }
            return value == null;
          });

          debugPrint('updatePermission req  = $updatePermissionReq');


          final response = await DioClient(event.context).put(
              path: '${AppUrls.updatePermissionUrl}${state.subUserId}',
              data: updatePermissionReq);

          debugPrint('updatePermission url  = ${AppUrls.baseUrl}${AppUrls.updatePermissionUrl}');
          debugPrint('updatePermission response  = ${response}');
          if (response[AppStrings.statusString] == 200) {
            emit(state.copyWith(isUpdateProcess: false));
            Navigator.pop(event.context);
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:  '${AppLocalizations.of(event.context)!.successmessage}',
                type: SnackBarType.SUCCESS);

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