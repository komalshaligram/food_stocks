import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'operation_time_event.dart';
part 'operation_time_state.dart';

part 'operation_time_bloc.freezed.dart';



class OperationTimeBloc extends Bloc<OperationTimeEvent, OperationTimeState> {

  OperationTimeBloc() : super(OperationTimeState.initial()) {
    on<OperationTimeEvent>((event, emit) async {



    });
  }


}
