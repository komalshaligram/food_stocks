part of 'store_bloc.dart';

@freezed
class StoreEvent with _$StoreEvent {
  const factory StoreEvent.changeCategoryExpansion({bool? isOpened}) =
      _ChangeCategoryExpansion;
}
