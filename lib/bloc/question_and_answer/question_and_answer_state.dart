part of 'question_and_answer_bloc.dart';

@freezed
class QuestionAndAnswerState with _$QuestionAndAnswerState {
  const factory QuestionAndAnswerState({
    required List<Datum> qnaList,
    required int pageNum,
    required bool isBottomOfQNA,
    required bool isLoadMore,
    required bool isShimmering,
    required RefreshController refreshController,
  }) = _QuestionAndAnswerState;

  factory QuestionAndAnswerState.initial() => QuestionAndAnswerState(
    qnaList: [],
        pageNum: 0,
        isBottomOfQNA: false,
        isLoadMore: false,
        isShimmering: false,
        refreshController: RefreshController(),
      );
}
