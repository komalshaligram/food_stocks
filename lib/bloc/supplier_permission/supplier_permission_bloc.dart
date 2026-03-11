import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../ui/utils/constants/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/permission_model/permission_model.dart';
import '../../data/model/req_model/update_permission/update_permission_model.dart';
import '../../data/model/res_model/supplier_permission/supplier_permission_res_model.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/constants/app_strings.dart';
import '../../ui/utils/constants/app_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'supplier_permission_event.dart';
part 'supplier_permission_state.dart';
part 'supplier_permission_bloc.freezed.dart';

class SupplierPermissionBloc extends Bloc<SupplierPermissionEvent, SupplierPermissionState> {
  SupplierPermissionBloc() : super(SupplierPermissionState.initial()) {
    on<SupplierPermissionEvent>((event, emit) async {
      if (event is _getPermissionList) {
        try {
          emit(state.copyWith(isShimmering: true, subUserId: event.subUserId));
          final res = await DioClient(event.context).get(path: '${AppUrlEndPoints.getSupplierPermissionUrl}${event.subUserId}');
          SupplierPermissionResModel response = SupplierPermissionResModel.fromJson(res);
          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(isShimmering: false));
            List<PermissionModel> supplierPermissionList = [];

            emit(state.copyWith(isSelectAll: true));

            for (int i = 0; i < (response.data?.length ?? 0); i++) {
              if (response.data?[i].isAllowed == false) {
                emit(state.copyWith(isSelectAll: false));
                break;
              }
            }

            response.data?.forEach((element) {
              supplierPermissionList.add(PermissionModel(
                supplierId: element.supplierId,
                title: element.supplier?.contactName ?? '',
                isEnable: element.isAllowed ?? false,
              ));
            });
            emit(state.copyWith(supplierPermissionList: supplierPermissionList));
          } else {
            emit(state.copyWith(isShimmering: false));
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      }

      if (event is _switchButtonEvent) {
        List<PermissionModel> supplierPermissionList = state.supplierPermissionList.toList(growable: true);
        if (event.index == -1) {
          bool isEnable = !state.isSelectAll;
          for (var element in supplierPermissionList) {
            element.isEnable = isEnable;
          }
          emit(state.copyWith(supplierPermissionList: supplierPermissionList, isSelectAll: isEnable));
        } else {
          supplierPermissionList[event.index].isEnable = !supplierPermissionList[event.index].isEnable;
          if (supplierPermissionList[event.index].isEnable == false) {
            emit(state.copyWith(isSelectAll: false));
          }
          emit(state.copyWith(supplierPermissionList: supplierPermissionList, isRefresh: !state.isRefresh));
        }

        emit(state.copyWith(isSelectAll: true));

        for (int i = 0; i < (supplierPermissionList.length); i++) {
          if (supplierPermissionList[i].isEnable == false) {
            emit(state.copyWith(isSelectAll: false));
            break;
          }
        }
      } else if (event is _updateSupplierPermissionEvent) {
        try {
          emit(state.copyWith(isUpdateProcess: true));

          List<SupplierPermission> updateSupplierPermission = [];
          for (var element in state.supplierPermissionList) {
            updateSupplierPermission.add(SupplierPermission(supplierId: element.supplierId, isAllowed: element.isEnable));
          }

          UpdatePermissionModel req = UpdatePermissionModel(supplierPermissions: updateSupplierPermission);

          Map<String, dynamic> updatePermissionReq = req.toJson();

          updatePermissionReq.removeWhere((key, value) {
            if (value != null) {
              debugPrint("[$key] = $value");
            }
            return value == null;
          });

          final response = await DioClient(event.context).put(path: '${AppUrlEndPoints.updatePermissionUrl}${state.subUserId}', data: updatePermissionReq);

          if (response[AppStrings.statusString] == AppConstants.code_200) {
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
