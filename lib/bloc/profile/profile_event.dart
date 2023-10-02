part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.started() = _Started;

  factory ProfileEvent.dropDownEvent() = _dropDownEvent;

  factory ProfileEvent.pickProfileImageEvent(
      {required BuildContext context,
      required bool isFromCamera}) = _pickProfileImageEvent;

  factory ProfileEvent.getBusinessTypeListEvent() = _getBusinessTypeListEvent;

  factory ProfileEvent.navigateToMoreDetailsScreenEvent({required BuildContext context}) =
      _navigateToMoreDetailsScreenEvent;
}
