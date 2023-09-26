import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
part 'operation_time_event.dart';
part 'operation_time_state.dart';

part 'operation_time_bloc.freezed.dart';



class OperationTimeBloc extends Bloc<OperationTimeEvent, OperationTimeState> {

  OperationTimeBloc() : super(OperationTimeState.initial()) {
    on<OperationTimeEvent>((event, emit) async {
      if(event is _timePickerEvent){
        final TimeOfDay? result = await showTimePicker(
            context: event.context,
            initialTime: TimeOfDay.now(),
            builder: (context, child) {
              return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                      alwaysUse24HourFormat: true
                  ),
                  child: child!);
            });
        if (result != null) {
          String? selectedTime;
          var df = DateFormat("HH:mm");
          var dt = df.parse(result.format(event.context));
          selectedTime  =  DateFormat('HH:mm').format(dt);
          print(selectedTime);
          if(event.index == 1 && event.openingIndex == 1){
            emit(state.copyWith(time: selectedTime));
          }
          if(event.index == 1 && event.openingIndex == 0){
            emit(state.copyWith(time: selectedTime));
          }
        }
      }
    });
  }


}
