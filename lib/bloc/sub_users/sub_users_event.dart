part of 'sub_users_bloc.dart';

@freezed
class SubUsersEvent with _$SubUsersEvent {
  const factory SubUsersEvent.getSubUserList({
    required BuildContext context,
  }) = _getSubUserList;

  const factory SubUsersEvent.refreshListEvent({
    required BuildContext context,
  }) = _RefreshListEvent;

  const factory SubUsersEvent.popEvent({
    required BuildContext context,
  }) = _popEvent;

  const factory SubUsersEvent.userApproveEvent({
    required BuildContext context,
  }) = _userApproveEvent;
}
