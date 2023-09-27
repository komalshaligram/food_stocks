import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'terms_of_use_event.dart';
part 'terms_of_use_state.dart';
part 'terms_of_use_bloc.freezed.dart';

class TermsOfUseBloc extends Bloc<TermsOfUseEvent, TermsOfUseState> {
  TermsOfUseBloc() : super(const TermsOfUseState.initial()) {
    on<TermsOfUseEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
