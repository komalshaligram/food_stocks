part of 'order_details_bloc.dart';

@freezed
class OrderDetailsState with _$OrderDetailsState {
  const factory OrderDetailsState({required GetOrderByIdModel orderByIdList, required List<StatusData> statusData, required String language}) =
      _OrderDetailsState;

  factory OrderDetailsState.initial() => const OrderDetailsState(orderByIdList: GetOrderByIdModel(), language: '', statusData: []);
}
