part of 'order_bloc.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState(
      {required GetAllOrderResModel orderList,
      required bool isShimmering,
      required bool isLoadMore,
      required int pageNum,
      required List<Datum> orderDetailsList,
      required bool isBottomOfProducts,
      required RefreshController refreshController,
      required List<StatusData> statusList,
      required String language}) = _OrderState;

  factory OrderState.initial() => OrderState(
      orderList: const GetAllOrderResModel(),
      isShimmering: false,
      isLoadMore: false,
      language: '',
      pageNum: 0,
      orderDetailsList: [],
      isBottomOfProducts: false,
      statusList: <StatusData>[],
      refreshController: RefreshController());
}
