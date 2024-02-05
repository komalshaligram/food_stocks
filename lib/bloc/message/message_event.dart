part of 'message_bloc.dart';

@freezed
class MessageEvent with _$MessageEvent {
  const factory MessageEvent.getMessageListEvent({
    required BuildContext context,
  }) = _GetMessageListEvent;

  const factory MessageEvent.removeOrUpdateMessageEvent(
      {required String messageId,
      required bool isRead,
      required bool isDelete}) = _RemoveOrUpdateMessageEvent;

  const factory MessageEvent.refreshListEvent({required BuildContext context}) =_RefreshListEvent;

  const factory MessageEvent.MessageDeleteEvent({
    required String messageId,
    required BuildContext context,
    required BuildContext dialogContext,
  }) =_MessageDeleteEvent;


}
