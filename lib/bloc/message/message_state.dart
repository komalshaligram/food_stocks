part of 'message_bloc.dart';

@freezed
class MessageState with _$MessageState {
  const factory MessageState({
    required List<MessageData> messageList,
    required bool isShimmering,
    required int pageNum,
    required bool isBottomOfMessage,
    required bool isLoadMore,
    required bool isMessageRead,
    required List<String> deletedMessageList,
    required RefreshController refreshController,
    required String language,
    required bool isRemoveProcess,
  }) = _MessageState;

  factory MessageState.initial() => MessageState(
    messageList: [],
        isShimmering: false,
        pageNum: 0,
        isBottomOfMessage: false,
        isLoadMore: false,
        isMessageRead: false,
        deletedMessageList: [],
        refreshController: RefreshController(),
    language: 'he',
    isRemoveProcess: false,
  );
}
