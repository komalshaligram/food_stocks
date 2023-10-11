part of 'store_category_bloc.dart';

@freezed
class StoreCategoryEvent with _$StoreCategoryEvent {
  const factory StoreCategoryEvent.changeCategoryExpansionEvent(
      {bool? isOpened}) = _ChangeCategoryExpansionEvent;

  const factory StoreCategoryEvent.changeTopNavigationEvent(
      {required int index}) = _ChangeTopNavigationEvent;
}
