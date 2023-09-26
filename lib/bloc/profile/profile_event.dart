part of 'profile_bloc.dart';


@freezed
class ProfileEvent with _$ProfileEvent{

  factory ProfileEvent.dropDownEvent() = _dropDownEvent;
  factory ProfileEvent.textFieldValidateEvent({
    required String businessName,
    required String hp,
    required String owner,
    required String id,
    required String contact,
    required BuildContext context,
    required String selectedBusiness,
}) = _textFieldValidateEvent;
  factory ProfileEvent.profilePicFromCameraEvent(
      ) = _profilePicFromCameraEvent;
  factory ProfileEvent.profilePicFromGalleryEvent(
      ) = _profilePicFromGalleryEvent;

}

