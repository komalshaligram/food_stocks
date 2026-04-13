part of 'brands_permission_bloc.dart';

@freezed
class BrandsPermissionEvent with _$BrandsPermissionEvent {
  const factory BrandsPermissionEvent.switchButtonEvent({required BuildContext context, required int index}) = _switchButtonEvent;

  const factory BrandsPermissionEvent.getPermissionList({required BuildContext context, required String subUserId}) = _getPermissionList;

  const factory BrandsPermissionEvent.updateBrandPermissionEvent({required BuildContext context}) = _updateBrandPermissionEvent;
}
