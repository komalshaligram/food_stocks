part of 'more_details_bloc.dart';

@freezed
class MoreDetailsEvent with _$MoreDetailsEvent {
  factory MoreDetailsEvent.dropDownEvent() = _dropDownEvent;

  factory MoreDetailsEvent.pickLogoImageEvent(
      {required BuildContext context,
      required bool isFromCamera}) = _pickLogoImageEvent;

  factory MoreDetailsEvent.getProfileModelEvent(
      {
        required ProfileModel profileModel,
        required BuildContext context,

      }) = _getProfileModelEvent;

  factory MoreDetailsEvent.registrationApiEvent(
      {required BuildContext context}) = _registrationApiEvent;

  factory MoreDetailsEvent.citySearchEvent({
    required String search,

}) = _citySearchEvent;

  factory MoreDetailsEvent.selectCityEvent({
    required String city,
    required BuildContext context,
  }) = _selectCityEvent;

  factory MoreDetailsEvent.getProfileMoreDetailsEvent(
      {required BuildContext context,
      required bool isUpdate}) = _getProfileMoreDetailsEvent;
}
