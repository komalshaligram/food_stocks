part of 'message_content_bloc.dart';

@freezed
class MessageContentEvent with _$MessageContentEvent {
  const factory MessageContentEvent.getMessageDataEvent(
      {required MessageData messageData,
        required bool isReadMore,
      }) = _GetMessageDataEvent;

  const factory MessageContentEvent.MessageDeleteEvent(
      {required String messageId,
      required BuildContext context,
      required BuildContext dialogContext,
      }) = _MessageDeleteEvent;

  const factory MessageContentEvent.MessageUpdateEvent(
      {
        required String messageId,
        required BuildContext context
      }) = _MessageUpdateEvent;
}
