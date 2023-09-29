import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_event.dart';
part 'contact_state.dart';
part 'contact_bloc.freezed.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(const ContactState.initial()) {
    on<ContactEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
