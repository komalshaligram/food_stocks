import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/permission_model/permission_model.dart';
import '../../data/model/req_model/update_permission/update_permission_model.dart';
import '../../data/model/res_model/account_permission/account_permission_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';
part 'account_permission_event.dart';
part 'account_permission_state.dart';
part 'account_permission_bloc.freezed.dart';


class AccountPermissionBloc extends Bloc<AccountPermissionEvent, AccountPermissionState> {
  AccountPermissionBloc() : super(AccountPermissionState.initial()) {
    on<AccountPermissionEvent>((event, emit) async {
      SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
          prefs: await SharedPreferences.getInstance());

      if(event is _getPermissionList){
        try {
          emit(state.copyWith(isShimmering: true , subUserId: event.subUserId));
          final res = await DioClient(event.context).get(
              path: '${AppUrls.getAccountPermissionUrl}${event.subUserId}');
          AccountPermissionResModel response = AccountPermissionResModel.fromJson(res);
          debugPrint('AccountPermission response = ${response.data.toString()}');
          debugPrint('AccountPermission url = ${AppUrls.baseUrl}${AppUrls.getAccountPermissionUrl}');
          if (response.status == 200) {
            List<permissionModel>permissionList = [];
            permissionList = [
              permissionModel(title: AppLocalizations.of(event.context)!.account_admin,
              isEnable: response.data?.permissions?.accountAdmin ?? false
              ),
              permissionModel(title: AppLocalizations.of(event.context)!.can_see_wallet,
                  isEnable: response.data?.permissions?.canSeeWallet ?? false
              ),
              permissionModel(title: AppLocalizations.of(event.context)!.can_add_basket,
                  isEnable: response.data?.permissions?.canAddToCart ?? false
              ),
              permissionModel(title: AppLocalizations.of(event.context)!.can_create_order,
                  isEnable: response.data?.permissions?.canCreateOrder ?? false
              ),
              permissionModel(title: AppLocalizations.of(event.context)!.see_order,
                  isEnable: response.data?.permissions?.canSeeOrders ?? false
              ),
              permissionModel(title: AppLocalizations.of(event.context)!.can_approve_order,
                  isEnable: response.data?.permissions?.canApproveOrders ?? false
              ),
              permissionModel(title: AppLocalizations.of(event.context)!.can_duplicate_order,
                  isEnable: response.data?.permissions?.canDuplicateOrders ?? false
              ),
              permissionModel(title: AppLocalizations.of(event.context)!.can_see_update_business_info,
                  isEnable: response.data?.permissions?.canSeeAndUpdateBusinessInfo ?? false
              ),
              permissionModel(title: AppLocalizations.of(event.context)!.can_see_update_additional_info,
                  isEnable: response.data?.permissions?.canSeeAndUpdateAdditionalInfo ?? false
              ),
              permissionModel(title: AppLocalizations.of(event.context)!.can_see_update_times_info,
                  isEnable: response.data?.permissions?.canSeeAndUpdateTimesInfo ?? false
              ),
              permissionModel(title: AppLocalizations.of(event.context)!.can_see_files_forms,
                  isEnable: response.data?.permissions?.canSeeFileAndForms ?? false
              ),
              permissionModel(title: AppLocalizations.of(event.context)!.can_manage_sub_users,
                  isEnable: response.data?.permissions?.canManageSubUsers ?? false
              ),
            ];
            emit(state.copyWith(isShimmering:false,permissionList: permissionList));
          } else {
            emit(state.copyWith(isShimmering: false));
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      }

      else if(event is _switchButtonEvent){
        List<permissionModel>permissionList = state.permissionList.toList(growable: true);
        permissionList[event.index].isEnable =  !permissionList[event.index].isEnable;
        emit(state.copyWith(permissionList: permissionList,isRefresh: !state.isRefresh));
      }

      else if(event is _updateAccountPermissionEvent){
        try {
          emit(state.copyWith(isUpdateProcess: true));

          UpdatePermissionModel req = UpdatePermissionModel(
            accountPermissions: AccountPermissions(
              accountAdmin: state.permissionList[0].isEnable,
              canSeeWallet: state.permissionList[1].isEnable,
              canAddToCart: state.permissionList[2].isEnable,
              canCreateOrder: state.permissionList[3].isEnable,
              canSeeOrders: state.permissionList[4].isEnable,
              canApproveOrders: state.permissionList[5].isEnable,
              canDuplicateOrders: state.permissionList[6].isEnable,
              canSeeAndUpdateBusinessInfo: state.permissionList[7].isEnable,
              canSeeAndUpdateAdditionalInfo: state.permissionList[8].isEnable,
              canSeeAndUpdateTimesInfo: state.permissionList[9].isEnable,
              canSeeFileAndForms: state.permissionList[10].isEnable,
              canManageSubUsers: state.permissionList[11].isEnable,
            )
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
              if(preferencesHelper.getSubUser()){
                preferencesHelper.setAccountAdmin(isAccountAdmin: state.permissionList[0].isEnable);
                preferencesHelper.setCanSeeWallet(isSeeWallet: state.permissionList[1].isEnable);
                preferencesHelper.setCanAddBasket(isAddBasket: state.permissionList[2].isEnable);
                preferencesHelper.setCanCreateOrder(isCreateOrder: state.permissionList[3].isEnable);
                preferencesHelper.setCanSeeOrder(isSeeOrder: state.permissionList[4].isEnable);
                preferencesHelper.setCanApproveOrder(isApproveOrder: state.permissionList[5].isEnable);
                preferencesHelper.setCanDuplicateOrder(isDuplicateOrder: state.permissionList[6].isEnable);
                preferencesHelper.setCanUpdateBusinessInfo(isUpdateBusinessInfo: state.permissionList[7].isEnable);
                preferencesHelper.setCanUpdateAdditionalInfo(isUpdateAdditionalInfo: state.permissionList[8].isEnable);
                preferencesHelper.setCanUpdateTimeInfo(isUpdateTimeInfo: state.permissionList[9].isEnable);
                preferencesHelper.setCanSeeFormsFiles(isSeeFormsFiles: state.permissionList[10].isEnable);
                preferencesHelper.setManageSubUser(isManageSubUser:state.permissionList[11].isEnable);
              }
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
          print('catch');
          emit(state.copyWith(isUpdateProcess: false));
        }
      }
    });
  }
}