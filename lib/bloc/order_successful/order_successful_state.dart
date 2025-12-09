
part of 'order_successful_bloc.dart';

@freezed
class OrderSuccessfulState with _$OrderSuccessfulState {
  const factory OrderSuccessfulState({
    required bool seePreviousBtn,
    required bool duringCelebration,
    required bool isSubUserCanSeeWallet,
    required int totalSupplier,
    required GetAllCartResModel cartItemList,
    required double totalPayment,
    required double vatPercentage,
    required double bottleTax,
    required int? bottleQty,
    required bool isIncludedVat,
  }) = _OrderSuccessfulState;

  factory OrderSuccessfulState.initial() =>
      const OrderSuccessfulState(
        seePreviousBtn : false,
        duringCelebration: true,
        isSubUserCanSeeWallet: false,
        totalSupplier:0,
        cartItemList: GetAllCartResModel(),
        totalPayment: 0,
        vatPercentage: 0,
        bottleQty: 0,
        bottleTax: 0,
        isIncludedVat: false,
      );

}

