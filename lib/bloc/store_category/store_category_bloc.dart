import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_category_event.dart';

part 'store_category_state.dart';

part 'store_category_bloc.freezed.dart';

class StoreCategoryBloc extends Bloc<StoreCategoryEvent, StoreCategoryState> {
  StoreCategoryBloc() : super(StoreCategoryState.initial()) {
    on<StoreCategoryEvent>((event, emit) {
      if (event is _ChangeCategoryExpansion) {
        if (event.isOpened != null) {
          emit(state.copyWith(isCategoryExpand: false));
        } else {
          emit(state.copyWith(isCategoryExpand: !state.isCategoryExpand));
        }
      } else if (event is _ShowCategoryOrSubCategory) {}
    });
  }
}
