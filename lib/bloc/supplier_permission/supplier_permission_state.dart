part of 'supplier_permission_bloc.dart';


@freezed
class SupplierPermissionState with _$SupplierPermissionState{
  const factory SupplierPermissionState({
    required bool isShimmering,
    required List<PermissionModel>supplierPermissionList,
    required bool isRefresh,
    required bool isSelectAll,
    required bool isUpdateProcess,
    required String subUserId,
  }) = _SupplierPermissionState;

  factory SupplierPermissionState.initial() => SupplierPermissionState(
      isShimmering: false,
      supplierPermissionList : [],
      isRefresh: false,
    isSelectAll: false,
    subUserId: '',
    isUpdateProcess: false

  );
}

