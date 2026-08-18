part of 'verify_client_data_bloc.dart';

@freezed
class VerifyClientDataEvent with _$VerifyClientDataEvent {
  const factory VerifyClientDataEvent.initEvent({required BuildContext context, String? nextRouteName, Map<dynamic, dynamic>? nextRouteArgs}) =
      _initEvent;

  const factory VerifyClientDataEvent.citySearchEvent({required String search}) = _citySearchEvent;

  const factory VerifyClientDataEvent.selectCityEvent({required String city}) = _selectCityEvent;

  const factory VerifyClientDataEvent.pickDeliveryImageEvent({required BuildContext context, required bool isFromCamera}) = _pickDeliveryImageEvent;

  const factory VerifyClientDataEvent.openWazeEvent() = _openWazeEvent;

  const factory VerifyClientDataEvent.submitEvent({required BuildContext context}) = _submitEvent;
}
