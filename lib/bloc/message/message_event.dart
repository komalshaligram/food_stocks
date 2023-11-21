part of 'message_bloc.dart';

@freezed
class MessageEvent with _$MessageEvent {
  const factory MessageEvent.getMessageListEvent({
    required BuildContext context,
  }) = _GetMessageListEvent;
}
