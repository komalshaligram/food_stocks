import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/model/operation_time/operation_time_model.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_styles.dart';

part 'operation_time_event.dart';

part 'operation_time_state.dart';

part 'operation_time_bloc.freezed.dart';

class OperationTimeBloc extends Bloc<OperationTimeEvent, OperationTimeState> {
  OperationTimeBloc() : super(OperationTimeState.initial()) {
    on<OperationTimeEvent>((event, emit) async {
      if (event is _defaultValueAddInListEvent) {
        List<OperationTimeModel> temp = [];
        temp.add(
          OperationTimeModel(
            data: [
              timeData(openingTime: '00:00', closingTime: '00:00'),
            ],
          ),
        );
        temp.add(
          OperationTimeModel(
            data: [
              timeData(openingTime: '00:00', closingTime: '00:00'),
            ],
          ),
        );
        temp.add(
          OperationTimeModel(
            data: [
              timeData(openingTime: '00:00', closingTime: '00:00'),
            ],
          ),
        );
        temp.add(
          OperationTimeModel(
            data: [
              timeData(openingTime: '00:00', closingTime: '00:00'),
            ],
          ),
        );
        temp.add(
          OperationTimeModel(
            data: [
              timeData(openingTime: '00:00', closingTime: '00:00'),
            ],
          ),
        );
        temp.add(
          OperationTimeModel(
            data: [
              timeData(openingTime: '00:00', closingTime: '00:00'),
            ],
          ),
        );
        temp.add(
          OperationTimeModel(
            data: [
              timeData(openingTime: '00:00', closingTime: '00:00'),
            ],
          ),
        );
        emit(state.copyWith(OperationTimeList: temp));
      }

      if (event is _timePickerEvent) {

        void showSnackBar(BuildContext context , String title) {
          final snackBar = SnackBar(
            content: Text(title,
              style: AppStyles.rkRegularTextStyle(size: AppConstants.smallFont , color: AppColors.whiteColor,fontWeight: FontWeight.w400),
            ),
            backgroundColor: AppColors.redColor,
            padding: EdgeInsets.all(20),
            behavior: SnackBarBehavior.floating,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }


        final TimeOfDay? result = await showTimePicker(
            context: event.context,
            initialTime: TimeOfDay.now(),
            builder: (context, child) {
              return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child!);
            });
        if (result != null) {
          String? selectedTime;
          var df = DateFormat("HH:mm");

          var dt = df.parse(result.format(event.context));
          selectedTime = DateFormat('HH:mm').format(dt);

          List<OperationTimeModel> temp = [];
          temp.addAll(state.OperationTimeList);
          String openingTime =
              temp[event.rowIndex].data[event.timeIndex].openingTime;
          String closingTime =
              temp[event.rowIndex].data[event.timeIndex].closingTime;
          String? previousClosingTime;

          var format = DateFormat("HH:mm");
          var start = format.parse(openingTime);
          var selectTimeZone = format.parse(selectedTime);

          if (event.timeIndex > 0) {
            previousClosingTime =
                temp[event.rowIndex].data[event.timeIndex - 1].closingTime;
            var format = DateFormat("HH:mm");
            var preEnd = format.parse(previousClosingTime);

            if (event.openingIndex == 1 && selectTimeZone.isAfter(preEnd)) {
              temp[event.rowIndex].data.removeAt(event.timeIndex);
              temp[event.rowIndex].data.add(timeData(
                  openingTime: selectedTime, closingTime: closingTime));
            } else if (event.openingIndex == 0 &&
                selectTimeZone.isAfter(start)) {
              temp[event.rowIndex].data.removeAt(event.timeIndex);
              temp[event.rowIndex].data.add(timeData(
                  openingTime: openingTime, closingTime: selectedTime));
            } else {
            showSnackBar(event.context,'select proper timezone');
            }
          } else {
            if (event.openingIndex == 1) {
              temp[event.rowIndex].data.removeAt(event.timeIndex);
              temp[event.rowIndex].data.add(timeData(
                  openingTime: selectedTime, closingTime: closingTime));
            } else if (event.openingIndex == 0 &&
                selectTimeZone.isAfter(start)) {
              temp[event.rowIndex].data.removeAt(event.timeIndex);
              temp[event.rowIndex].data.add(timeData(
                  openingTime: openingTime, closingTime: selectedTime));
            } else {
              showSnackBar(event.context,'select proper timezone');
            }
          }
          emit(state.copyWith(
              OperationTimeList: temp, isRefresh: !state.isRefresh));
        }
      }

      if (event is _addMoreTimeZoneEventEvent) {
        List<OperationTimeModel> temp = [];
        temp.addAll(state.OperationTimeList);
        temp[event.rowIndex]
            .data
            .add(timeData(openingTime: '00:00', closingTime: '00:00'));
        emit(state.copyWith(
            OperationTimeList: temp, isRefresh: !state.isRefresh));
      }

      if (event is _deleteTimeZoneEvent) {
        List<OperationTimeModel> temp = [];
        temp.addAll(state.OperationTimeList);
        temp[event.rowIndex].data.removeAt(event.timeIndex);
        emit(state.copyWith(
            OperationTimeList: temp, isRefresh: !state.isRefresh));
      }
    });
  }
}
