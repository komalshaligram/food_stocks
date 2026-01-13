part of 'account_permission_bloc.dart';

@freezed
class AccountPermissionEvent with _$AccountPermissionEvent {
  const factory AccountPermissionEvent.switchButtonEvent({
    required BuildContext context,
    required int index,
  }) = _switchButtonEvent;

  const factory AccountPermissionEvent.getPermissionList({
    required BuildContext context,
    required String subUserId,
  }) = _getPermissionList;

  const factory AccountPermissionEvent.updateAccountPermissionEvent({
    required BuildContext context,
  }) = _updateAccountPermissionEvent;
}
