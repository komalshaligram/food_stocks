part of 'way_of_payment_bloc.dart';

@freezed
class WayOfPaymentEvent with _$WayOfPaymentEvent {
  const factory WayOfPaymentEvent.radioButtonEvent({
    required int selectRadioTile,
  }) = _radioButtonEvent;

  const factory WayOfPaymentEvent.getArgumentEvent({
    required bool isUpdate,
    required TermsConditionReqModel termsReqModel,
  }) = _getArgumentEvent;
}
