part of 'sub_users_profile_bloc.dart';

@freezed
class SubUsersProfileEvent with _$SubUsersProfileEvent {
  const factory SubUsersProfileEvent.getAppLanguageEvent({required BuildContext context}) = _getAppLanguageEvent;

  factory SubUsersProfileEvent.pickProfileImageEvent({required BuildContext context, required bool isFromCamera}) = _pickProfileImageEvent;

  const factory SubUsersProfileEvent.createSubUserEvent({required BuildContext context}) = _createSubUserEvent;

  const factory SubUsersProfileEvent.deleteFileEvent({required BuildContext context}) = _deleteFileEvent;

  const factory SubUsersProfileEvent.deleteAccountEvent({required BuildContext context, required BuildContext dialogContext}) = _deleteAccountEvent;

  const factory SubUsersProfileEvent.updateSubUserEvent({required BuildContext context}) = _updateSubUserEvent;

  const factory SubUsersProfileEvent.getSubUserByIdEvent({required BuildContext context, required String subUserId, required bool isUpdate}) = _getSubUserByIdEvent;
}
