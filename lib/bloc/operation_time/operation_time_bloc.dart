import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/model/operation_time/operation_time_model.dart';
import '../../data/model/req_model/operation_time/operation_time_req_model.dart';
import '../../data/model/res_model/operation_time_model/operation_time_res_model.dart'
    as res;
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'operation_time_event.dart';

part 'operation_time_state.dart';

part 'operation_time_bloc.freezed.dart';

class OperationTimeBloc extends Bloc<OperationTimeEvent, OperationTimeState> {
  OperationTimeBloc() : super(OperationTimeState.initial()) {
    on<OperationTimeEvent>((event, emit) async {
      List<Day> sundayList = [];
      List<Day> mondayList = [];
      List<Day> tuesdayList = [];
      List<Day> wednesdayList = [];
      List<Day> thursdayList = [];
      List<Day> fridayAndHolidayEvesList = [];
      List<Day> saturdayAndHolidaysList = [];

      if (event is _defaultValueAddInListEvent) {
        List<OperationTimeModel> temp = [];
        if (state.OperationTimeList.isEmpty) {
          temp.add(
            OperationTimeModel(
              dayString: AppLocalizations.of(event.context)!.sunday,
              monday: [
                Day(until: '00:00', from: '00:00'),
              ],
            ),
          );
          temp.add(
            OperationTimeModel(
              dayString: AppLocalizations.of(event.context)!.monday,
              monday: [
                Day(until: '00:00', from: '00:00'),
              ],
            ),
          );
          temp.add(
            OperationTimeModel(
                dayString: AppLocalizations.of(event.context)!.tuesday,
                monday: [
                  Day(until: '00:00', from: '00:00'),
                ]),
          );
          temp.add(
            OperationTimeModel(
              dayString: AppLocalizations.of(event.context)!.wednesday,
              monday: [
                Day(until: '00:00', from: '00:00'),
              ],
            ),
          );
          temp.add(
            OperationTimeModel(
              dayString: AppLocalizations.of(event.context)!.thursday,
              monday: [
                Day(until: '00:00', from: '00:00'),
              ],
            ),
          );
          temp.add(
            OperationTimeModel(
              dayString:
                  AppLocalizations.of(event.context)!.friday_and_holiday_eves,
              monday: [
                Day(until: '00:00', from: '00:00'),
              ],
            ),
          );
          temp.add(
            OperationTimeModel(
              dayString:
                  AppLocalizations.of(event.context)!.saturday_and_holidays,
              monday: [
                Day(until: '00:00', from: '00:00'),
              ],
            ),
          );
          emit(state.copyWith(OperationTimeList: temp));
        } else {
          emit(state.copyWith(OperationTimeList: state.OperationTimeList));
        }
      }

      if (event is _timePickerEvent) {
        emit(state.copyWith(time: event.time));
        Navigator.pop(event.timePickerContext);
        if (state.time.isNotEmpty) {
          String? selectedTime;
          selectedTime = state.time;
          List<OperationTimeModel> temp = [];

          temp.addAll(state.OperationTimeList);
          String openingTime =
              temp[event.rowIndex].monday[event.timeIndex].from!;
          String closingTime =
              temp[event.rowIndex].monday[event.timeIndex].until!;
          String? previousClosingTime;

          var format = DateFormat("HH:mm");
          var start = format.parse(openingTime);
          var end = format.parse(closingTime);

          var selectTimeZone = format.parse(selectedTime);

          if (event.timeIndex > 0) {
            previousClosingTime =
                temp[event.rowIndex].monday[event.timeIndex - 1].until;

            var format = DateFormat("HH:mm");
            var preEnd = format.parse(previousClosingTime!);

            if (event.openingIndex == 1 && selectTimeZone.isAfter(preEnd)) {
              temp[event.rowIndex].monday.removeAt(event.timeIndex);
              temp[event.rowIndex]
                  .monday
                  .add(Day(from: selectedTime, until: closingTime));
            } else if (event.openingIndex == 0) {
              if (temp[event.rowIndex].monday[event.timeIndex].from! ==
                  '00:00') {
                showSnackBar(
                    context: event.context,
                    title: 'select opening Time',
                    bgColor: AppColors.redColor);
              } else if (selectTimeZone.isAfter(start)) {
                temp[event.rowIndex].monday.removeAt(event.timeIndex);
                temp[event.rowIndex]
                    .monday
                    .add(Day(from: openingTime, until: selectedTime));
              } else {
                showSnackBar(
                    context: event.context,
                    title: 'select closing time after opening time',
                    bgColor: AppColors.redColor);
              }
            }
          } else {
            if (event.openingIndex == 1) {
              if (closingTime != '00:00' && selectTimeZone.isBefore(end)) {
                temp[event.rowIndex].monday.removeAt(event.timeIndex);
                temp[event.rowIndex]
                    .monday
                    .add(Day(from: selectedTime, until: closingTime));
              } else if (closingTime == '00:00') {
                temp[event.rowIndex].monday.removeAt(event.timeIndex);
                temp[event.rowIndex]
                    .monday
                    .add(Day(from: selectedTime, until: closingTime));
              } else {
                showSnackBar(
                    context: event.context,
                    title: 'select opening time before closing time',
                    bgColor: AppColors.redColor);
              }
            } else if (event.openingIndex == 0) {
              if (temp[event.rowIndex].monday[event.timeIndex].from! ==
                  '00:00') {
                showSnackBar(
                    context: event.context,
                    title: 'select opening Time',
                    bgColor: AppColors.redColor);
              } else if (selectTimeZone.isAfter(start)) {
                temp[event.rowIndex].monday.removeAt(event.timeIndex);
                temp[event.rowIndex]
                    .monday
                    .add(Day(from: openingTime, until: selectedTime));
              } else {
                showSnackBar(
                    context: event.context,
                    title: 'select opening time after closing time',
                    bgColor: AppColors.redColor);
              }
            }
          }
          emit(state.copyWith(
              OperationTimeList: temp, isRefresh: !state.isRefresh));
        }
      }

      if (event is _addMoreTimeZoneEventEvent) {
        List<OperationTimeModel> temp = [];
        temp.addAll(state.OperationTimeList);

        if (state.OperationTimeList[event.rowIndex].monday.length > 1) {
          int len = state.OperationTimeList[event.rowIndex].monday.length;

          if (state.OperationTimeList[event.rowIndex].monday[len - 1].from !=
                  '00:00' &&
              state.OperationTimeList[event.rowIndex].monday[len - 1].until !=
                  '00:00') {
            temp[event.rowIndex].monday.add(Day(from: '00:00', until: '00:00'));
            emit(state.copyWith(
                OperationTimeList: temp, isRefresh: !state.isRefresh));
          } else {
            showSnackBar(
                context: event.context,
                title: 'select previous shift time',
                bgColor: AppColors.redColor);
          }
        } else {
          if (state.OperationTimeList[event.rowIndex].monday[0].from !=
                  '00:00' &&
              state.OperationTimeList[event.rowIndex].monday[0].until !=
                  '00:00') {
            temp[event.rowIndex].monday.add(Day(from: '00:00', until: '00:00'));
            emit(state.copyWith(
                OperationTimeList: temp, isRefresh: !state.isRefresh));
          } else {
            showSnackBar(
                context: event.context,
                title: 'select first shift time',
                bgColor: AppColors.redColor);
          }
        }
      }

      if (event is _deleteTimeZoneEvent) {
        List<OperationTimeModel> temp = [];
        temp.addAll(state.OperationTimeList);
        temp[event.rowIndex].monday.removeAt(event.timeIndex);
        emit(state.copyWith(
            OperationTimeList: temp, isRefresh: !state.isRefresh));
      }

      if (event is _operationTimeApiEvent) {
        sundayList.addAll(
          state.OperationTimeList[0].monday,
        );
        mondayList.addAll(
          state.OperationTimeList[1].monday,
        );
        tuesdayList.addAll(
          state.OperationTimeList[2].monday,
        );
        wednesdayList.addAll(
          state.OperationTimeList[3].monday,
        );
        thursdayList.addAll(
          state.OperationTimeList[4].monday,
        );
        fridayAndHolidayEvesList.addAll(
          state.OperationTimeList[5].monday,
        );
        saturdayAndHolidaysList.addAll(
          state.OperationTimeList[6].monday,
        );

        if (sundayList.first.from != '00:00' ||
            mondayList.first.from != '00:00' &&
                tuesdayList.first.from != '00:00' ||
            wednesdayList.first.from != '00:00' ||
            thursdayList.first.from != '00:00' ||
            fridayAndHolidayEvesList.first.from != '00:00' ||
            saturdayAndHolidaysList.first.from != '00:00') {
          OperationTimeReqModel reqMap = OperationTimeReqModel(
            operationTime: OperationTime(
              sunday: sundayList,
              monday: mondayList,
              tuesday: tuesdayList,
              wednesday: wednesdayList,
              thursday: thursdayList,
              fridayAndHolidayEves: fridayAndHolidayEvesList,
              saturdayAndHolidays: saturdayAndHolidaysList,
            ),
          );

          debugPrint('operation time reqMap + $reqMap');
          try {
            final response = await DioClient().post(
                '/v1/clients/operationTime/65142f55c891fb10e5301f0e',
                data: reqMap);

            res.OperationTimeResModel operationTimeResModel =
                res.OperationTimeResModel.fromJson(response);

            debugPrint('operation time response --- ${operationTimeResModel}');

            if (response['status'] == 200) {
              /*   emit(state.copyWith(isRegisterSuccess: true));

              emit(state.copyWith(
                isRegisterSuccess: false,
              ));*/
              Navigator.pushNamed(
                  event.context, RouteDefine.fileUploadScreen.name);
            } else {
              showSnackBar(
                  context: event.context,
                  title: response['message'],
                  bgColor: AppColors.redColor);
              /*   emit(state.copyWith(
                  isRegisterFail: true, errorMessage: response['message']));

              emit(state.copyWith(
                isRegisterFail: false,
              ));*/
            }
          } catch (e) {
            debugPrint(e.toString());
            emit(state.copyWith(
                isRegisterFail: true, errorMessage: e.toString()));
            emit(state.copyWith(
              isRegisterFail: false,
            ));
          }
        } else {
          emit(state.copyWith(
              isRegisterFail: true, errorMessage: 'please select shiftTime'));
          emit(state.copyWith(
            isRegisterFail: false,
          ));
        }
      }
    });
  }
}

/*
reqMap = ProfileModel(
// statusId: profileModel.statusId,
profileImage: profileModel.profileImage,
phoneNumber: profileModel.phoneNumber,
logo: profileModel.logo,
// lastName: '',
// firstName: '',
cityId: profileModel.cityId,
contactName: profileModel.contactName,
createdBy: '60abf964173234001c903a05',
updatedBy: '60abf964173234001c903a05',
address: profileModel.address,
email: profileModel.email,
clientDetail: ClientDetail(
fax: profileModel.clientDetail?.fax,
clientTypeId: '60abf964173234001c903a05',
applicationVersion:
profileModel.clientDetail?.applicationVersion,
ownerName: profileModel.clientDetail?.ownerName,
bussinessName: profileModel.clientDetail?.bussinessName,
bussinessId: profileModel.clientDetail?.bussinessId,
deviceType: profileModel.clientDetail?.deviceType,
israelId: profileModel.clientDetail?.israelId,
lastSeen: DateTime.now(),
monthlyCredits: 100,
// operationTime: OperationTime(
//   sunday: sundayList,
//   monday: mondayList,
//   tuesday: tuesdayList,
//   wednesday: wednesdayList,
//   thursday: thursdayList,
//   fridayAndHolidayEves: fridayAndHolidayEvesList,
//   saturdayAndHolidays: saturdayAndHolidaysList,
// ),
tokenId: profileModel.clientDetail?.tokenId,
));*/
/*      reqMap = ProfileModel(
              // statusId: profileModel.statusId,
              profileImage: profileModel.profileImage,
              phoneNumber: profileModel.phoneNumber,
              logo: profileModel.logo,
              // lastName: '',
              // firstName: '',
              cityId: profileModel.cityId,
              contactName: profileModel.contactName,
              createdBy: '60abf964173234001c903a05',
              updatedBy: '60abf964173234001c903a05',
              address: profileModel.address,
              email: profileModel.email,
              clientDetail: ClientDetail(
                fax: profileModel.clientDetail?.fax,
                clientTypeId: '60abf964173234001c903a05',
                applicationVersion:
                    profileModel.clientDetail?.applicationVersion,
                ownerName: profileModel.clientDetail?.ownerName,
                bussinessName: profileModel.clientDetail?.bussinessName,
                bussinessId: profileModel.clientDetail?.bussinessId,
                deviceType: profileModel.clientDetail?.deviceType,
                israelId: profileModel.clientDetail?.israelId,
                lastSeen: DateTime.now(),
                monthlyCredits: 100,
                //operationTime: OperationTime(),
                tokenId: profileModel.clientDetail?.tokenId,
              ));*/
