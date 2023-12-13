part of 'question_and_answer_bloc.dart';

@freezed
class QuestionAndAnswerEvent with _$QuestionAndAnswerEvent {
  const factory QuestionAndAnswerEvent.getQNAListEvent(
      {required BuildContext context}) = _GetQNAListEvent;

  const factory QuestionAndAnswerEvent.refreshListEvent(
      {required BuildContext context}) = _RefreshListEvent;
}
