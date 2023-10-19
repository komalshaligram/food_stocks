import 'package:bloc/bloc.dart';
import 'package:food_stock/data/error/exceptions.dart';
import 'package:food_stock/data/model/res_model/product_categories_res_model/product_categories_res_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/storage/shared_preferences_helper.dart';
import '../../ui/utils/themes/app_strings.dart';

part 'store_event.dart';

part 'store_state.dart';

part 'store_bloc.freezed.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(StoreState.initial()) {
    on<StoreEvent>((event, emit) async {
      if (event is _ChangeCategoryExpansion) {
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
      } else if (event is _GetProductCategoriesListEvent) {
        try {} on ServerException {}
      }
    });
  }
}
