import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_and_answer_event.dart';
part 'question_and_answer_state.dart';
part 'question_and_answer_bloc.freezed.dart';

class QuestionAndAnswerBloc extends Bloc<QuestionAndAnswerEvent, QuestionAndAnswerState> {
  QuestionAndAnswerBloc() : super(const QuestionAndAnswerState.initial()) {
    on<QuestionAndAnswerEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
