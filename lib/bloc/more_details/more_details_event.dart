part of 'more_details_bloc.dart';

@freezed
class MoreDetailsEvent with _$MoreDetailsEvent {
  factory MoreDetailsEvent.dropDownEvent() = _dropDownEvent;

  factory MoreDetailsEvent.logoFromCameraEvent({required BuildContext context}) = _logoFromCameraEvent;

  factory MoreDetailsEvent.logoFromGalleryEvent({required BuildContext context}) = _logoFromGalleryEvent;

  factory MoreDetailsEvent.getProfileModelEvent({required ProfileModel profileModel}) = _getProfileModelEvent;

  factory MoreDetailsEvent.textFieldValidateEvent(
      {required String city,
      required String address,
      required String email,
      required String fax,
      required File image,
      required BuildContext context}) = _textFieldValidateEvent;

  factory MoreDetailsEvent.navigateToOperationTimeScreenEvent({required BuildContext context}) =
  _navigateToOperationTimeScreenEvent;
}
