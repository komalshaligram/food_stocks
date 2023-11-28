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
}
