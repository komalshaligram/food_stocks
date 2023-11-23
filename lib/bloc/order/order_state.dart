part of 'order_bloc.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState({
   required GetAllOrderResModel orderList,
    required bool isShimmering,
   required bool isLoadMore,
   required int pageNum,
   required List<Datum> orderDetailsList,
   required bool isBottomOfProducts,



  }) = _OrderState;

   factory OrderState.initial() => OrderState(
       orderList: GetAllOrderResModel(),
     isShimmering: false,
     isLoadMore: false,
     pageNum: 0,
     orderDetailsList: [],
     isBottomOfProducts: false

  );


}
