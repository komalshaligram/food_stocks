import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_data_event.dart';
part 'form_data_state.dart';
part 'form_data_bloc.freezed.dart';


class FormDataBloc extends Bloc<FormDataEvent, FormDataState> {
  FormDataBloc() : super(FormDataState.initial()) {
    on<FormDataEvent>((event, emit) async {
      if(event is _selectAgentEvent){
        emit(state.copyWith(agent: event.agent));
      }
      if(event is _selectBusinessTypeEvent){
        emit(state.copyWith(business: event.business));
      }
    });
  }
}