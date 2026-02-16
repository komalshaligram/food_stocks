part of 'message_content_bloc.dart';

@freezed
class MessageContentEvent with _$MessageContentEvent {
  const factory MessageContentEvent.getMessageDataEvent({
    required MessageData messageData,
    required bool isReadMore,
  }) = _GetMessageDataEvent;

  const factory MessageContentEvent.messageDeleteEvent({
    required String messageId,
    required BuildContext context,
    required BuildContext dialogContext,
  }) = _messageDeleteEvent;

  const factory MessageContentEvent.messageUpdateEvent({
    required String messageId,
    required BuildContext context,
  }) = _messageUpdateEvent;

  const factory MessageContentEvent.imagePreviewEvent() = _imagePreviewEvent;
}
