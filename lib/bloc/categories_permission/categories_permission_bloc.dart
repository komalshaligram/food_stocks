import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_stock/ui/utils/themes/app_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/req_model/update_permission/update_permission_model.dart' as update;
import '../../data/model/res_model/categories_permission/categories_permission_res_model.dart';
import '../../repository/dio_client.dart';
import '../../ui/utils/app_utils.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../ui/utils/themes/app_urls.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'categories_permission_event.dart';
part 'categories_permission_state.dart';
part 'categories_permission_bloc.freezed.dart';

class CategoriesPermissionBloc extends Bloc<CategoriesPermissionEvent, CategoriesPermissionState> {
  CategoriesPermissionBloc() : super(CategoriesPermissionState.initial()) {
    on<CategoriesPermissionEvent>((event, emit) async {
      if (event is _getPermissionList) {
        try {
          emit(state.copyWith(isShimmering: true, subUserId: event.subUserId));
          final res = await DioClient(event.context).get(path: '${AppUrlEndPoints.getCategoriesPermissionUrl}${event.subUserId}');
          CategoriesPermissionResModel response = CategoriesPermissionResModel.fromJson(res);

          if (response.status == AppConstants.code_200) {
            emit(state.copyWith(isShimmering: false));
            emit(state.copyWith(isSelectAll: true));
            emit(state.copyWith(categoriesPermissionList: response.data ?? []));

            for (int i = 0; i < response.data!.length; i++) {
              if (response.data?[i].isAllowed == false) {
                emit(state.copyWith(isSelectAll: false));
                break;
              }
            }
          } else {
            emit(state.copyWith(isShimmering: false));
          }
        } on ServerException {
          emit(state.copyWith(isShimmering: false));
        } catch (exc) {
          emit(state.copyWith(isShimmering: false));
        }
      } else if (event is _switchButtonEvent) {
        List<CategoriesPermission> categoriesPermissionList = List.from(state.categoriesPermissionList);
        if (event.subCategoriesIndex == -2) {
          bool isEnable = !state.isSelectAll;

          for (int i = 0; i < categoriesPermissionList.length; i++) {
            categoriesPermissionList[i] = categoriesPermissionList[i].copyWith(
              isAllowed: isEnable,
            );
            for (int j = 0; j < (categoriesPermissionList[i].subCategories!.length); j++) {
              categoriesPermissionList[i].subCategories![j] = categoriesPermissionList[i].subCategories![j].copyWith(isAllowed: isEnable);
            }
          }
          emit(state.copyWith(categoriesPermissionList: categoriesPermissionList, isSelectAll: isEnable, isRefresh: !state.isRefresh));
        } else if (event.subCategoriesIndex == -1) {
          bool isAllowed = categoriesPermissionList[event.categoriesIndex].isAllowed ?? false;

          categoriesPermissionList[event.categoriesIndex] = categoriesPermissionList[event.categoriesIndex].copyWith(isAllowed: !isAllowed);

          if (categoriesPermissionList[event.categoriesIndex].isAllowed == false) {
            emit(state.copyWith(isSelectAll: false));
          }

          if (categoriesPermissionList[event.categoriesIndex].isAllowed == false) {
            for (int i = 0; i < (categoriesPermissionList[event.categoriesIndex].subCategories?.length ?? 0); i++) {
              categoriesPermissionList[event.categoriesIndex].subCategories![i] = categoriesPermissionList[event.categoriesIndex].subCategories![i].copyWith(isAllowed: false);
            }
          } else {
            for (int i = 0; i < (categoriesPermissionList[event.categoriesIndex].subCategories?.length ?? 0); i++) {
              categoriesPermissionList[event.categoriesIndex].subCategories![i] = categoriesPermissionList[event.categoriesIndex].subCategories![i].copyWith(isAllowed: true);
            }
          }

          emit(state.copyWith(categoriesPermissionList: categoriesPermissionList, isRefresh: !state.isRefresh));
        } else {
          if (categoriesPermissionList[event.categoriesIndex].isAllowed ?? false) {
            bool isAllowed = categoriesPermissionList[event.categoriesIndex].subCategories?[event.subCategoriesIndex].isAllowed ?? false;

            categoriesPermissionList[event.categoriesIndex].subCategories![event.subCategoriesIndex] = categoriesPermissionList[event.categoriesIndex].subCategories![event.subCategoriesIndex].copyWith(isAllowed: !isAllowed);
          }

          emit(state.copyWith(categoriesPermissionList: categoriesPermissionList, isRefresh: !state.isRefresh));
        }

        emit(state.copyWith(isSelectAll: true));

        for (int i = 0; i < (categoriesPermissionList.length); i++) {
          if (categoriesPermissionList[i].isAllowed == false) {
            emit(state.copyWith(isSelectAll: false));
            break;
          }
          for (int j = 0; j < (categoriesPermissionList[i].subCategories?.length ?? 0); j++) {
            if (categoriesPermissionList[i].subCategories![j].isAllowed == false) {
              emit(state.copyWith(isSelectAll: false));
              break;
            }
          }
        }
      } else if (event is _updateCategoriesPermissionEvent) {
        try {
          emit(state.copyWith(isUpdateProcess: true));

          List<update.CategoryPermission> updateCategoryPermissionList = [];
          List<String> categories = [];

          for (var element in state.categoriesPermissionList) {
            categories.add(element.categoryId!);
          }

          List<update.SubCategory> subCategoryList = [];

          for (int i = 0; i < categories.length; i++) {
            subCategoryList = [];
            for (int j = 0; j < (state.categoriesPermissionList[i].subCategories?.length ?? 0); j++) {
              if (categories[i] == state.categoriesPermissionList[i].subCategories?[j].subCategoryData?.parentCategoryId) {
                subCategoryList.add(update.SubCategory(subCategoryId: state.categoriesPermissionList[i].subCategories?[j].subCategoryId, isAllowed: state.categoriesPermissionList[i].subCategories?[j].isAllowed));
              }
            }
            updateCategoryPermissionList.add(update.CategoryPermission(subCategories: subCategoryList, isAllowed: state.categoriesPermissionList[i].isAllowed, categoryId: state.categoriesPermissionList[i].categoryId));
          }

          update.UpdatePermissionModel req = update.UpdatePermissionModel(categoryPermissions: updateCategoryPermissionList);

          Map<String, dynamic> updatePermissionReq = req.toJson();

          updatePermissionReq.removeWhere((key, value) {
            if (value != null) {
              printData("[$key] = $value");
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
