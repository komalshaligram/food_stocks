import 'package:bloc/bloc.dart';
import 'package:food_stock/data/model/res_model/get_messages_res_model/get_messages_res_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_content_event.dart';
part 'message_content_state.dart';
part 'message_content_bloc.freezed.dart';

class MessageContentBloc extends Bloc<MessageContentEvent, MessageContentState> {
  MessageContentBloc() : super(MessageContentState.initial()) {
    on<MessageContentEvent>((event, emit) {
      if (event is _GetMessageDataEvent) {
        emit(state.copyWith(message: event.messageData));
      }
    });
  }
}
