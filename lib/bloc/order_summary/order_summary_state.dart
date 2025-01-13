part of 'order_summary_bloc.dart';

@freezed
class OrderSummaryState with _$OrderSummaryState {
  const factory OrderSummaryState({

    required CartProductsSupplierResModel orderSummaryList,
    required bool isLoading,
    required bool isShimmering,
    required bool isEnable,
    required GetAllCartResModel cartItemList,
    required String language,
    required bool isAllPaymentAvailable,
    required bool isWalletRelatedError,
    required String errorString,
    required bool isPaymentFail,
    required bool updatePaymentMethod,
    required String bankTransferInfo,
    required List<String> paymentTypesList,
    required bool showPopUp,
    required int index,
    required bool isDialogOpen,
    required List<CartProductDataResModel> tempList
}) = _OrderSummaryState;

  factory OrderSummaryState.initial() => const OrderSummaryState(
 orderSummaryList: CartProductsSupplierResModel(),
    isLoading: false,
    isShimmering: false,
    isEnable: false,
    cartItemList: GetAllCartResModel(),
    language: '',
      isAllPaymentAvailable :false,
      isWalletRelatedError : false,
      errorString :'',
    isPaymentFail: false,
    updatePaymentMethod: false,
      bankTransferInfo:'',
      showPopUp: false,
      paymentTypesList :[],
    index :0,
    isDialogOpen: false,
      tempList:[]
  );
}
