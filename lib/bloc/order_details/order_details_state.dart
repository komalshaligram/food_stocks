part of 'order_details_bloc.dart';



@freezed
class OrderDetailsState with _$OrderDetailsState {
  const factory OrderDetailsState({
    required GetOrderByIdModel orderByIdList,
  }) = _OrderDetailsState;

  factory OrderDetailsState.initial() => OrderDetailsState(
    orderByIdList: GetOrderByIdModel()

  );


}
