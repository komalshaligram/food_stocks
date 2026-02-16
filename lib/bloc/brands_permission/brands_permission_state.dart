part of 'brands_permission_bloc.dart';

@freezed
class BrandsPermissionState with _$BrandsPermissionState {
  const factory BrandsPermissionState({
    required bool isShimmering,
    required List<PermissionModel> brandPermissionList,
    required bool isRefresh,
    required bool isSelectAll,
    required bool isUpdateProcess,
    required String subUserId,
  }) = _BrandsPermissionState;

  factory BrandsPermissionState.initial() => const BrandsPermissionState(
        isShimmering: false,
        brandPermissionList: [],
        isRefresh: false,
        isSelectAll: false,
        subUserId: '',
        isUpdateProcess: false,
      );
}
