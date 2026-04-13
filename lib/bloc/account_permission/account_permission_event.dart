part of 'account_permission_bloc.dart';

@freezed
class AccountPermissionEvent with _$AccountPermissionEvent {
  factory AccountPermissionEvent.switchButtonEvent({required BuildContext context, required int index}) = _switchButtonEvent;

  factory AccountPermissionEvent.getPermissionList({required BuildContext context, required String subUserId}) = _getPermissionList;

  factory AccountPermissionEvent.updateAccountPermissionEvent({required BuildContext context}) = _updateAccountPermissionEvent;
}
