part of 'categories_permission_bloc.dart';


@freezed
class CategoriesPermissionState with _$CategoriesPermissionState{
  const factory CategoriesPermissionState({
    required bool isShimmering,
    required List<CategoriesPermission>categoriesPermissionList,
    required bool isRefresh,
    required bool isSelectAll,
    required bool isUpdateProcess,
    required String subUserId,
  }) = _CategoriesPermissionState;

  factory CategoriesPermissionState.initial() => const CategoriesPermissionState(
      isShimmering: false,
      categoriesPermissionList : [],
      isRefresh: false,
    isSelectAll: false,
    isUpdateProcess: false,
    subUserId: ''

  );
}

