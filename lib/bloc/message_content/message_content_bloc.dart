import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_content_event.dart';
part 'message_content_state.dart';
part 'message_content_bloc.freezed.dart';

class MessageContentBloc extends Bloc<MessageContentEvent, MessageContentState> {
  MessageContentBloc() : super(const MessageContentState.initial()) {
    on<MessageContentEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}