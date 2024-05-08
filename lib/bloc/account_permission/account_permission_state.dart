part of 'account_permission_bloc.dart';

@freezed
class AccountPermissionState with _$AccountPermissionState{
  const factory AccountPermissionState({
    required bool isShimmering,
    required List<permissionModel>permissionList,
    required bool isRefresh,
    required bool isUpdateProcess,
    required String subUserId,
  }) = _AccountPermissionState;

  factory AccountPermissionState.initial() => AccountPermissionState(
      isShimmering: false,
      permissionList : [],
      isRefresh: false,
    isUpdateProcess: false,
    subUserId: ''

  );
}

