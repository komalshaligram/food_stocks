
part of 'order_successful_bloc.dart';

@freezed
class OrderSuccessfulState with _$OrderSuccessfulState {
  const factory OrderSuccessfulState({
    required bool seePreviousBtn,
    required bool duringCelebration,
    required bool isSubUserCanSeeWallet,
  }) = _OrderSuccessfulState;

  factory OrderSuccessfulState.initial() =>
      const OrderSuccessfulState(
        seePreviousBtn : false,
        duringCelebration: true,
        isSubUserCanSeeWallet: false
      );

}

