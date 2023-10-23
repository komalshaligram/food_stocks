part of 'store_bloc.dart';

@freezed
class StoreEvent with _$StoreEvent {
  const factory StoreEvent.changeCategoryExpansion({bool? isOpened}) =
      _ChangeCategoryExpansion;

  const factory StoreEvent.changeUIUponAppLangEvent() =
      _ChangeUIUponAppLangEvent;

  const factory StoreEvent.getProductCategoriesListEvent() =
      _GetProductCategoriesListEvent;
}
