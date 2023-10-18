import 'package:bloc/bloc.dart';
import 'package:food_stock/ui/utils/themes/app_strings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/storage/shared_preferences_helper.dart';

part 'store_category_event.dart';

part 'store_category_state.dart';

part 'store_category_bloc.freezed.dart';

class StoreCategoryBloc extends Bloc<StoreCategoryEvent, StoreCategoryState> {
  StoreCategoryBloc() : super(StoreCategoryState.initial()) {
    on<StoreCategoryEvent>((event, emit) async {
      if (event is _ChangeCategoryExpansionEvent) {
        if (event.isOpened != null) {
          emit(state.copyWith(isCategoryExpand: false));
        } else {
          emit(state.copyWith(isCategoryExpand: !state.isCategoryExpand));
        }
      } else if (event is _ChangeUIUponAppLangEvent) {
        SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(
            prefs: await SharedPreferences.getInstance());
        emit(state.copyWith(
            isMirror:
                preferencesHelper.getAppLanguage() == AppStrings.hebrewString
                    ? true
                    : false));
      } else if (event is _ChangeCategoryOrSubCategoryEvent) {
        emit(state.copyWith(isCategory: event.isCategory));
      }
    });
  }
}
