part of 'way_of_payment_bloc.dart';

@freezed
class WayOfPaymentState with _$WayOfPaymentState{

  const factory WayOfPaymentState({
    required int selectRadioTile,
    required bool isUpdate,
  }) = _WayOfPaymentState;

  factory WayOfPaymentState.initial()=> const WayOfPaymentState(
    selectRadioTile: 0,
    isUpdate : false


  );

}