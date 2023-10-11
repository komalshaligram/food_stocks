import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bottom_nav_event.dart';

part 'bottom_nav_state.dart';

part 'bottom_nav_bloc.freezed.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(BottomNavState.initial()) {
    on<BottomNavEvent>((event, emit) {
      if (event is _ChangePageEvent) {
        emit(state.copyWith(index: event.index));
      }
    });
  }
}
