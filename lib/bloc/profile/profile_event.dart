part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.started() = _Started;

  factory ProfileEvent.dropDownEvent() = _dropDownEvent;

  factory ProfileEvent.profilePicFromCameraEvent({required BuildContext context}) = _profilePicFromCameraEvent;

  factory ProfileEvent.profilePicFromGalleryEvent({required BuildContext context}) =
      _profilePicFromGalleryEvent;

  factory ProfileEvent.getBusinessTypeListEvent() = _getBusinessTypeListEvent;

  factory ProfileEvent.navigateToMoreDetailsScreenEvent({required BuildContext context}) =
      _navigateToMoreDetailsScreenEvent;
}
