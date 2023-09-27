part of 'more_details_bloc.dart';

@freezed
class MoreDetailsEvent with _$MoreDetailsEvent {
  factory MoreDetailsEvent.dropDownEvent() = _dropDownEvent;

  factory MoreDetailsEvent.logoFromCameraEvent() = _logoFromCameraEvent;

  factory MoreDetailsEvent.logoFromGalleryEvent() = _logoFromGalleryEvent;

  factory MoreDetailsEvent.textFieldValidateEvent(
      {required String city,
      required String address,
      required String email,
      required String fax,
      required File image,
      required BuildContext context}) = _textFieldValidateEvent;
}
