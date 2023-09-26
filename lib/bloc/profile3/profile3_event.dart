part of 'profile3_bloc.dart';


@freezed
class Profile3Event with _$Profile3Event{

  factory Profile3Event.dropDownEvent() = _dropDownEvent;
  factory Profile3Event.logoFromCameraEvent(
      ) = _logoFromCameraEvent;
  factory Profile3Event.logoFromGalleryEvent(
      ) = _logoFromGalleryEvent;


  factory Profile3Event.textFieldValidateEvent({
    required String city,
    required String address,
    required String email,
    required String fax,
    required File image,
    required BuildContext context

  }) = _textFieldValidateEvent;

}

