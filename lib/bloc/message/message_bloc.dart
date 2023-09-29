import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_event.dart';
part 'message_state.dart';
part 'message_bloc.freezed.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(const MessageState.initial()) {
    on<MessageEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
