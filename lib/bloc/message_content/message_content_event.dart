part of 'message_content_bloc.dart';

@freezed
class MessageContentEvent with _$MessageContentEvent {
  const factory MessageContentEvent.getMessageDataEvent(
      {required Message messageData}) = _GetMessageDataEvent;
}
