part of 'message_bloc.dart';

@freezed
class MessageState with _$MessageState {
  const factory MessageState({
    required List<MessageData> messageList,
    required bool isShimmering,
    required int pageNum,
    required bool isBottomOfMessage,
    required bool isLoadMore,
  }) = _MessageState;

  factory MessageState.initial() => MessageState(
        messageList: [],
        isShimmering: false,
        pageNum: 0,
        isBottomOfMessage: false,
        isLoadMore: false,
      );
}
