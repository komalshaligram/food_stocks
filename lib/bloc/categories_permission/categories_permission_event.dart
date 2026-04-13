part of 'categories_permission_bloc.dart';

@freezed
class CategoriesPermissionEvent with _$CategoriesPermissionEvent {
  const factory CategoriesPermissionEvent.switchButtonEvent({
    required BuildContext context,
    required int categoriesIndex,
    required int subCategoriesIndex,
  }) = _switchButtonEvent;

  const factory CategoriesPermissionEvent.getPermissionList({required BuildContext context, required String subUserId}) = _getPermissionList;

  const factory CategoriesPermissionEvent.updateCategoriesPermissionEvent({required BuildContext context}) = _updateCategoriesPermissionEvent;
}
