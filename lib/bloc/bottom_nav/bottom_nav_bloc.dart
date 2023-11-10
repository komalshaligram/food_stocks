import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bottom_nav_event.dart';

part 'bottom_nav_state.dart';

part 'bottom_nav_bloc.freezed.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super(BottomNavState.initial()) {
    on<BottomNavEvent>((event, emit) {
      if (event is _ChangePageEvent) {
        emit(state.copyWith(index: event.index));
      } else if (event is _UpdateCartCountEvent) {
        emit(state.copyWith(cartCount: state.cartCount + event.cartCount));
        debugPrint('cart count = ${state.cartCount}');
      } else if (event is _ResetCartCountEvent) {
        emit(state.copyWith(cartCount: 0));
        debugPrint('reset cart count = ${state.cartCount}');
      }
    });
  }
}
