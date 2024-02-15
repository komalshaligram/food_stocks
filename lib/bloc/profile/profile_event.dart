part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.started() = _Started;

  factory ProfileEvent.dropDownEvent() = _dropDownEvent;

  factory ProfileEvent.pickProfileImageEvent(
      {required BuildContext context,
      required bool isFromCamera}) = _pickProfileImageEvent;

  factory ProfileEvent.getBusinessTypeListEvent(
      {required BuildContext context}) = _getBusinessTypeListEvent;

  factory ProfileEvent.navigateToMoreDetailsScreenEvent(
      {
    required BuildContext context,
  }) = _navigateToMoreDetailsScreenEvent;

  factory ProfileEvent.getProfileDetailsEvent(
      {required BuildContext context,
      required bool isUpdate,
      required String mobileNo}) = _getProfileDetailsEvent;

  factory ProfileEvent.updateProfileDetailsEvent(
      {required BuildContext context}) = _updateProfileDetailsEvent;

  factory ProfileEvent.changeBusinessTypeEvent(
      {required String newBusinessType}) = _ChangeBusinessTypeEventEvent;

  factory ProfileEvent.deleteAccountEvent({required BuildContext context}) = _DeleteAccountEvent;

  factory ProfileEvent.deleteFileEvent({
    required BuildContext context,
  }) = _deleteFileEvent;
}
