part of 'message_content_bloc.dart';

@freezed
class MessageContentState with _$MessageContentState {
  const factory MessageContentState({
    required MessageData message,
    required bool isReadMore,
    required bool isPreview,
    required String language,
  }) = _MessageContentState;

  factory MessageContentState.initial() => MessageContentState(
        message: MessageData(),
    isReadMore: false,
    isPreview: false,
    language: AppStrings.hebrewString
      );
}
