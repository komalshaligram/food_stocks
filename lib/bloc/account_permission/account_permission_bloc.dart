import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/permission_model/permission_model.dart';
import '../../data/model/req_model/update_permission/update_permission_model.dart';
import '../../data/model/res_model/account_permission/account_permission_res_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import 'package:food_stock/l10n/generated/app_localizations.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
import '../../ui/utils/constants/app_constants.dart';
part 'account_permission_event.dart';
part 'account_permission_state.dart';
part 'account_permission_bloc.freezed.dart';

class AccountPermissionBloc extends Bloc<AccountPermissionEvent, AccountPermissionState> {
  AccountPermissionBloc() : super(AccountPermissionState.initial()) {
    on<AccountPermissionEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());

      if (event is _getPermissionList) {
        try {
          emit(state.copyWith(isShimmering: true, subUserId: event.subUserId));
          final res = await DioClient(event.context).get(path: '${AppUrlEndPoints.getAccountPermissionUrl}${event.subUserId}');
          AccountPermissionResModel response = AccountPermissionResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            List<PermissionModel> permissionList = [];
            permissionList = [
              PermissionModel(title: AppLocalizations.of(event.context)!.account_admin, isEnable: response.data?.permissions?.accountAdmin ?? false),
              PermissionModel(title: AppLocalizations.of(event.context)!.can_see_wallet, isEnable: response.data?.permissions?.canSeeWallet ?? false),
              PermissionModel(title: AppLocalizations.of(event.context)!.can_add_basket, isEnable: response.data?.permissions?.canAddToCart ?? false),
              PermissionModel(title: AppLocalizations.of(event.context)!.can_create_order, isEnable: response.data?.permissions?.canCreateOrder ?? false),
              PermissionModel(title: AppLocalizations.of(event.context)!.see_order, isEnable: response.data?.permissions?.canSeeOrders ?? false),
              PermissionModel(title: AppLocalizations.of(event.context)!.can_approve_order, isEnable: response.data?.permissions?.canApproveOrders ?? false),
              PermissionModel(title: AppLocalizations.of(event.context)!.can_duplicate_order, isEnable: response.data?.permissions?.canDuplicateOrders ?? false),
              PermissionModel(title: AppLocalizations.of(event.context)!.can_see_update_business_info, isEnable: response.data?.permissions?.canSeeAndUpdateBusinessInfo ?? false),
              PermissionModel(title: AppLocalizations.of(event.context)!.can_see_update_additional_info, isEnable: response.data?.permissions?.canSeeAndUpdateAdditionalInfo ?? false),
              PermissionModel(title: AppLocalizations.of(event.context)!.can_see_update_times_info, isEnable: response.data?.permissions?.canSeeAndUpdateTimesInfo ?? false),
              PermissionModel(title: AppLocalizations.of(event.context)!.can_see_files_forms, isEnable: response.data?.permissions?.canSeeFileAndForms ?? false),
              PermissionModel(title: AppLocalizations.of(event.context)!.can_manage_sub_users, isEnable: response.data?.permissions?.canManageSubUsers ?? false),
              PermissionModel(title: AppLocalizations.of(event.context)!.can_see_invoices, isEnable: response.data?.permissions?.canSeeInvoices ?? false),
              PermissionModel(title: AppLocalizations.of(event.context)!.returns, isEnable: response.data?.permissions?.returns ?? false),
              PermissionModel(title: AppLocalizations.of(event.context)!.can_scan_documents, isEnable: response.data?.permissions?.canScanDocuments ?? false),
            ];
            emit(state.copyWith(isShimmering: false, permissionList: permissionList));
          } else {
            emit(state.copyWith(isShimmering: false));
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      } else if (event is _switchButtonEvent) {
        List<PermissionModel> permissionList = state.permissionList.toList(growable: true);
        permissionList[event.index].isEnable = !permissionList[event.index].isEnable;
        emit(state.copyWith(permissionList: permissionList, isRefresh: !state.isRefresh));
      } else if (event is _updateAccountPermissionEvent) {
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
            canSeeInvoices: state.permissionList[12].isEnable,
            returns: state.permissionList[13].isEnable,
            canScanDocuments: state.permissionList[14].isEnable,
          ));

          Map<String, dynamic> updatePermissionReq = req.toJson();
          updatePermissionReq.removeWhere((key, value) {
            if (value != null) {}
            return value == null;
          });

          final response = await DioClient(event.context).put(path: '${AppUrlEndPoints.updatePermissionUrl}${state.subUserId}', data: updatePermissionReq);

          if (response[AppStrings.statusString] == AppConstants.code_200) {
            if (preferences.getSubUser()) {
              preferences.setAccountAdmin(isAccountAdmin: state.permissionList[0].isEnable);
              preferences.setCanSeeWallet(isSeeWallet: state.permissionList[1].isEnable);
              preferences.setCanAddBasket(isAddBasket: state.permissionList[2].isEnable);
              preferences.setCanCreateOrder(isCreateOrder: state.permissionList[3].isEnable);
              preferences.setCanSeeOrder(isSeeOrder: state.permissionList[4].isEnable);
              preferences.setCanApproveOrder(isApproveOrder: state.permissionList[5].isEnable);
              preferences.setCanDuplicateOrder(isDuplicateOrder: state.permissionList[6].isEnable);
              preferences.setCanUpdateBusinessInfo(isUpdateBusinessInfo: state.permissionList[7].isEnable);
              preferences.setCanUpdateAdditionalInfo(isUpdateAdditionalInfo: state.permissionList[8].isEnable);
              preferences.setCanUpdateTimeInfo(isUpdateTimeInfo: state.permissionList[9].isEnable);
              preferences.setCanSeeFormsFiles(isSeeFormsFiles: state.permissionList[10].isEnable);
              preferences.setManageSubUser(isManageSubUser: state.permissionList[11].isEnable);
              preferences.setCanSeeInvoices(isCanSeeInvoices: state.permissionList[12].isEnable);
              preferences.setCanSeeReturns(isCanSeeReturns: state.permissionList[13].isEnable);
              preferences.setCanScanDocuments(isCanScanDocuments: state.permissionList[14].isEnable);
            }
            emit(state.copyWith(isUpdateProcess: false));
            Navigator.pop(event.context);
            CustomSnackBar.showSnackBar(context: event.context, title: AppLocalizations.of(event.context)!.success_message, type: SnackBarType.success);
          } else {
            emit(state.copyWith(isUpdateProcess: false));
          }
        } on ServerException {
          emit(state.copyWith(isUpdateProcess: false));
        } catch (e) {
          emit(state.copyWith(isUpdateProcess: false));
        }
      }
    });
  }
}
