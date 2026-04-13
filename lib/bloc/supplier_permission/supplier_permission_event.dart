part of 'supplier_permission_bloc.dart';

@freezed
class SupplierPermissionEvent with _$SupplierPermissionEvent {
  const factory SupplierPermissionEvent.switchButtonEvent({required BuildContext context, required int index}) = _switchButtonEvent;

  const factory SupplierPermissionEvent.getPermissionList({required BuildContext context, required String subUserId}) = _getPermissionList;

  const factory SupplierPermissionEvent.updateSupplierPermissionEvent({required BuildContext context}) = _updateSupplierPermissionEvent;
}
