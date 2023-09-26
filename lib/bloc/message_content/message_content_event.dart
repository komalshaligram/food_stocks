part of 'message_content_bloc.dart';

@freezed
class MessageContentEvent with _$MessageContentEvent {
  const factory MessageContentEvent.started() = _Started;
}
