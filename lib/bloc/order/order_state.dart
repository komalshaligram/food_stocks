part of 'order_bloc.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState({
   required GetAllOrderResModel orderList,
  }) = _OrderState;

   factory OrderState.initial() => OrderState(
       orderList: GetAllOrderResModel(),

  );


}
