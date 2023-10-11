part of 'store_bloc.dart';

@freezed
class StoreState with _$StoreState {
  const factory StoreState({required bool isCategoryExpand}) = _StoreState;

  factory StoreState.initial() => const StoreState(isCategoryExpand: false);
}
