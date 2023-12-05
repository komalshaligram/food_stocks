
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/error/exceptions.dart';
import '../../data/model/activity_time/activity_time_model.dart';
import '../../data/model/req_model/activity_time/activity_time_req_model.dart';
import '../../data/model/req_model/profile_details_update_req_model/profile_details_update_req_model.dart'
    as update;
import '../../data/model/res_model/activity_time_model/activity_time_res_model.dart'
    as res;
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../ui/utils/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../ui/utils/themes/app_strings.dart';
import '../../data/model/res_model/profile_details_res_model/profile_details_res_model.dart'
    as resGet;
import 'package:food_stock/data/model/req_model/profile_details_req_model/profile_details_req_model.dart'
    as req;
import '../../data/model/res_model/profile_details_update_res_model/profile_details_update_res_model.dart'
    as reqUpdate;

part 'activity_time_event.dart';

part 'activity_time_state.dart';

part 'activity_time_bloc.freezed.dart';

class ActivityTimeBloc extends Bloc<ActivityTimeEvent, ActivityTimeState> {
  ActivityTimeBloc() : super(ActivityTimeState.initial()) {
    on<ActivityTimeEvent>((event, emit) async {
      SharedPreferencesHelper preferences =
          SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      resGet.ProfileDetailsResModel response = resGet.ProfileDetailsResModel();

      List<Day>? sundayList = [];
      List<Day>? mondayList = [];
      List<Day>? tuesdayList = [];
      List<Day>? wednesdayList = [];
      List<Day>? thursdayList = [];
      List<Day>? fridayAndHolidayEvesList = [];
      List<Day>? saturdayAndHolidaysList = [];

      if (event is _getActivityTimeDetailsEvent) {
        emit(state.copyWith(isUpdate: event.isUpdate));
      }

      if (event is _getActivityTimeListEvent) {
        if (state.isUpdate) {
          emit(state.copyWith(isShimmering: true));
          try {
            final res = await DioClient(event.context).post(AppUrls.getProfileDetailsUrl,
                data: req.ProfileDetailsReqModel(id: preferences.getUserId())
                    .toJson(),
             /*   options: Options(
                  headers: {
                    HttpHeaders.authorizationHeader:
                    'Bearer ${preferences.getAuthToken()}',
                  },
                )*/

            );
            response = resGet.ProfileDetailsResModel.fromJson(res);
            debugPrint('response_______$response');

            if (response.status == 200) {
              if (response.data!.clients!.first.clientDetail!.operationTime!
                  .isNotEmpty) {
                List<ActivityTimeModel> temp1 = state.OperationTimeList;
                var sundayRs = response.data!.clients!.first.clientDetail!
                    .operationTime![0].sunday!;
                var mondayRs = response.data!.clients!.first.clientDetail!
                    .operationTime![0].monday!;
                var tuesdayRs = response.data!.clients!.first.clientDetail!
                    .operationTime![0].tuesday!;
                var wednesdayRs = response.data!.clients!.first.clientDetail!
                    .operationTime![0].wednesday!;
                var thursdayRs = response.data!.clients!.first.clientDetail!
                    .operationTime![0].thursday!;
                var fridayAndHolidayEvesRs = response.data!.clients!.first
                    .clientDetail!.operationTime![0].fridayAndHolidayEves!;
                var saturdayAndHolidaysRs = response.data!.clients!.first
                    .clientDetail!.operationTime![0].saturdayAndHolidays!;

                List<Day> sundayList = sundayRs.map((e) {
                  return Day(from: e.from, until: e.until);
                }).toList();

                List<Day> mondayList = mondayRs.map((e) {
                  return Day(from: e.from, until: e.until);
                }).toList();

                List<Day> tuesdayList = tuesdayRs.map((e) {
                  return Day(from: e.from, until: e.until);
                }).toList();
                List<Day> wednesdayList = wednesdayRs.map((e) {
                  return Day(from: e.from, until: e.until);
                }).toList();

                List<Day> thursdayList = thursdayRs.map((e) {
                  return Day(from: e.from, until: e.until);
                }).toList();

                List<Day> fridayAndHolidayEvesList =
                    fridayAndHolidayEvesRs.map((e) {
                  return Day(from: e.from, until: e.until);
                }).toList();

                List<Day> saturdayAndHolidaysList =
                    saturdayAndHolidaysRs.map((e) {
                  return Day(from: e.from, until: e.until);
                }).toList();
                temp1[0].monday = sundayList;
                temp1[1].monday = mondayList;
                temp1[2].monday = tuesdayList;
                temp1[3].monday = wednesdayList;
                temp1[4].monday = thursdayList;
                temp1[5].monday = fridayAndHolidayEvesList;
                temp1[6].monday = saturdayAndHolidaysList;
                emit(state.copyWith(
                    isShimmering: false,
                    OperationTimeList: temp1,
                    isRefresh: !state.isRefresh));
              } else {
                emit(state.copyWith(isShimmering: false));
              }
            } else {
              showSnackBar(
                  context: event.context,
                  title: response.message ?? AppStrings.somethingWrongString,
                  bgColor: AppColors.redColor);
            }
          } on ServerException {
          }
        }
      }

      if (event is _defaultValueAddInListEvent) {
        List<ActivityTimeModel> temp = [];
        if (state.OperationTimeList.isEmpty) {
          temp.add(
            ActivityTimeModel(
              dayString: AppLocalizations.of(event.context).sunday,
              monday: [
                Day(until: AppStrings.timeString, from: AppStrings.timeString),
              ],
            ),
          );
          temp.add(
            ActivityTimeModel(
              dayString: AppLocalizations.of(event.context).monday,
              monday: [
                Day(until: AppStrings.timeString, from: AppStrings.timeString),
              ],
            ),
          );
          temp.add(
            ActivityTimeModel(
                dayString: AppLocalizations.of(event.context).tuesday,
                monday: [
                  Day(
                      until: AppStrings.timeString,
                      from: AppStrings.timeString),
                ]),
          );
          temp.add(
            ActivityTimeModel(
              dayString: AppLocalizations.of(event.context).wednesday,
              monday: [
                Day(until: AppStrings.timeString, from: AppStrings.timeString),
              ],
            ),
          );
          temp.add(
            ActivityTimeModel(
              dayString: AppLocalizations.of(event.context).thursday,
              monday: [
                Day(until: AppStrings.timeString, from: AppStrings.timeString),
              ],
            ),
          );
          temp.add(
            ActivityTimeModel(
              dayString:
                  AppLocalizations.of(event.context).friday_and_holiday_eves,
              monday: [
                Day(until: AppStrings.timeString, from: AppStrings.timeString),
              ],
            ),
          );
          temp.add(
            ActivityTimeModel(
              dayString:
                  AppLocalizations.of(event.context).saturday_and_holidays,
              monday: [
                Day(until: AppStrings.timeString, from: AppStrings.timeString),
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
          if(event.openingIndex == 0  && event.time == AppStrings.timeString){
              selectedTime = AppStrings.hr24String;
              emit(state.copyWith(time: selectedTime));
          }

          List<ActivityTimeModel> temp = [];
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
          if (selectedTime != AppStrings.timeString) {
            if (event.timeIndex > 0) {
              previousClosingTime =
                  temp[event.rowIndex].monday[event.timeIndex - 1].until;

              var format = DateFormat("HH:mm");
              var preEnd = format.parse(previousClosingTime!);

              if (event.openingIndex == 1) {
                if (closingTime == AppStrings.timeString &&
                    selectTimeZone.isAfter(preEnd)) {
                  temp[event.rowIndex].monday.removeAt(event.timeIndex);
                  temp[event.rowIndex]
                      .monday
                      .add(Day(from: selectedTime, until: closingTime));
                } else if (closingTime != AppStrings.timeString) {
                  if (selectTimeZone.isAfter(preEnd) &&
                      selectTimeZone.isBefore(end)) {
                    temp[event.rowIndex].monday.removeAt(event.timeIndex);
                    temp[event.rowIndex]
                        .monday
                        .add(Day(from: selectedTime, until: closingTime));
                  } else if (selectTimeZone.isBefore(preEnd)) {
                    showSnackBar(
                        context: event.context,
                        title: AppStrings.openingTimeAfterPreviousClosingString,
                        bgColor: AppColors.redColor);
                  } else {
                    showSnackBar(
                        context: event.context,
                        title: AppStrings.openingTimeAfterClosingString,
                        bgColor: AppColors.redColor);
                  }
                } else {
                  showSnackBar(
                      context: event.context,
                      title: AppStrings.openingTimeAfterPreviousClosingString,
                      bgColor: AppColors.redColor);
                }
              } else if (event.openingIndex == 0) {
                if (openingTime == AppStrings.timeString) {
                  showSnackBar(
                      context: event.context,
                      title: AppStrings.selectOpeningString,
                      bgColor: AppColors.redColor);
                } else if (selectTimeZone.isAfter(start)) {
                  temp[event.rowIndex].monday.removeAt(event.timeIndex);
                  temp[event.rowIndex]
                      .monday
                      .add(Day(from: openingTime, until: selectedTime));
                } else {
                  showSnackBar(
                      context: event.context,
                      title: AppStrings.closingTimeAfterOpeningString,
                      bgColor: AppColors.redColor);
                }
              }
            } else {
              if (event.openingIndex == 1) {
                if (closingTime != AppStrings.timeString &&
                    selectTimeZone.isBefore(end)) {
                  temp[event.rowIndex].monday.removeAt(event.timeIndex);
                  temp[event.rowIndex]
                      .monday
                      .add(Day(from: selectedTime, until: closingTime));
                } else if (closingTime == AppStrings.timeString) {
                  temp[event.rowIndex].monday.removeAt(event.timeIndex);
                  temp[event.rowIndex]
                      .monday
                      .add(Day(from: selectedTime, until: closingTime));
                } else {
                  showSnackBar(
                      context: event.context,
                      title: AppStrings.openingTimeAfterClosingString,
                      bgColor: AppColors.redColor);
                }
              } else if (event.openingIndex == 0) {
                if (openingTime == AppStrings.timeString) {
                  showSnackBar(
                      context: event.context,
                      title: AppStrings.selectOpeningString,
                      bgColor: AppColors.redColor);
                } else if (selectTimeZone.isAfter(start)) {
                  temp[event.rowIndex].monday.removeAt(event.timeIndex);
                  temp[event.rowIndex]
                      .monday
                      .add(Day(from: openingTime, until: selectedTime));
                } else {
                  showSnackBar(
                      context: event.context,
                      title: AppStrings.closingTimeAfterOpeningString,
                      bgColor: AppColors.redColor);
                }
              }
            }
            emit(state.copyWith(
                OperationTimeList: temp, isRefresh: !state.isRefresh));
          } else {
            showSnackBar(
                context: event.context,
                title: AppStrings.selectTimeMoreThen0String,
                bgColor: AppColors.redColor);
          }
        }
      }

      if (event is _addMoreTimeZoneEventEvent) {
        List<ActivityTimeModel> temp = [];
        temp.addAll(state.OperationTimeList);
        if(state.time != AppStrings.hr24String){
          if (state.OperationTimeList[event.rowIndex].monday.length > 1) {
            int len = state.OperationTimeList[event.rowIndex].monday.length;
            if (state.OperationTimeList[event.rowIndex].monday[len - 1].from !=
                AppStrings.timeString &&
                state.OperationTimeList[event.rowIndex].monday[len - 1].until !=
                    AppStrings.timeString) {
              temp[event.rowIndex].monday.add(
                  Day(from: AppStrings.timeString, until: AppStrings.timeString));
              emit(state.copyWith(
                  OperationTimeList: temp, isRefresh: !state.isRefresh));
            } else {
              showSnackBar(
                  context: event.context,
                  title: AppStrings.selectPreviousShiftString,
                  bgColor: AppColors.redColor);
            }
          } else {
            if (state.OperationTimeList[event.rowIndex].monday[0].from !=
                AppStrings.timeString &&
                state.OperationTimeList[event.rowIndex].monday[0].until !=
                    AppStrings.timeString) {
              temp[event.rowIndex].monday.add(
                  Day(from: AppStrings.timeString, until: AppStrings.timeString));
              emit(state.copyWith(
                  OperationTimeList: temp, isRefresh: !state.isRefresh));
            } else {
              showSnackBar(
                  context: event.context,
                  title: AppStrings.selectFirstShiftString,
                  bgColor: AppColors.redColor);
            }
          }
        }
        else{
          showSnackBar(
              context: event.context,
              title: AppStrings.selectNextDayShiftString,
              bgColor: AppColors.redColor);
        }
      }

      if (event is _deleteTimeZoneEvent) {
        List<ActivityTimeModel> temp = [];
        temp.addAll(state.OperationTimeList);
        temp[event.rowIndex].monday.removeAt(event.timeIndex);
        emit(state.copyWith(
            OperationTimeList: temp, isRefresh: !state.isRefresh));
      }

      if (event is _activityTimeApiEvent) {
        // emit(state.copyWith(isLoading: true));
        bool isSnackbarActive = false;
        for (int i = 0; i < state.OperationTimeList.length; i++) {
          if (state.OperationTimeList[i].monday[0].until ==
                  AppStrings.timeString &&
              state.OperationTimeList[i].monday[0].from !=
                  AppStrings.timeString) {
            showSnackBar(
                context: event.context,
                title: AppStrings.fillUpClosingTimeString,
                bgColor: AppColors.redColor);
            isSnackbarActive = true;
          }
          for (int j = 1; j < state.OperationTimeList[i].monday.length; j++) {
            if (state.OperationTimeList[i].monday[j] ==
                Day(
                    from: AppStrings.timeString,
                    until: AppStrings.timeString)) {
              state.OperationTimeList[i].monday.removeAt(j);
            } else if (state.OperationTimeList[i].monday[j].until ==
                    AppStrings.timeString &&
                state.OperationTimeList[i].monday[j].from !=
                    AppStrings.timeString) {
              showSnackBar(
                  context: event.context,
                  title: AppStrings.fillUpClosingTimeString,
                  bgColor: AppColors.redColor);
              isSnackbarActive = true;
            }
          }
        }

        if (isSnackbarActive == false) {
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

          if (!state.isUpdate) {
            if (sundayList.first.from != AppStrings.timeString ||
                mondayList.first.from != AppStrings.timeString &&
                    tuesdayList.first.from != AppStrings.timeString ||
                wednesdayList.first.from != AppStrings.timeString ||
                thursdayList.first.from != AppStrings.timeString ||
                fridayAndHolidayEvesList.first.from != AppStrings.timeString ||
                saturdayAndHolidaysList.first.from != AppStrings.timeString) {
              ActivityTimeReqModel reqMap = ActivityTimeReqModel(
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
                final response1 = await DioClient(event.context).post(
                    AppUrls.operationTimeUrl + '/' + preferences.getUserId(),
                    //  AppUrls.operationTimeUrl + '/' + '651ff55af3c2b715fe5f1ba8',
                    data: reqMap);
                res.ActivityTimeResModel operationTimeResModel =
                    res.ActivityTimeResModel.fromJson(response1);

                debugPrint(
                    'operation time response --- ${operationTimeResModel}');

                if (response1['status'] == 200) {
                  Navigator.pushNamed(
                      event.context, RouteDefine.fileUploadScreen.name);
                } else {
                  showSnackBar(
                      context: event.context,
                      title: response1['message'],
                      bgColor: AppColors.redColor);
                }
              } on ServerException {}
            } else {
              showSnackBar(
                  context: event.context,
                  title: AppStrings.selectShiftTimeString,
                  bgColor: AppColors.redColor);

            }
          } else {
            update.ProfileDetailsUpdateReqModel reqMap =
                update.ProfileDetailsUpdateReqModel(
                    clientDetail: update.ClientDetail(
              operationTime: update.OperationTime(
                sunday: sundayList,
                monday: mondayList,
                tuesday: tuesdayList,
                wednesday: wednesdayList,
                thursday: thursdayList,
                fridayAndHolidayEves: fridayAndHolidayEvesList,
                saturdayAndHolidays: saturdayAndHolidaysList,
              ),
            ));
            Map<String, dynamic> req = reqMap.toJson();
            Map<String, dynamic>? clientDetail = reqMap.clientDetail?.toJson();
            debugPrint("update before Model = ${req}");
            clientDetail?.removeWhere((key, value) {
              if (value != null) {
                debugPrint("[$key] = $value");
              }
              return value == null;
            });
            req[AppStrings.clientDetailString] = clientDetail;
            req.removeWhere((key, value) {
              if (value != null) {
                debugPrint("[$key] = $value");
              }
              return value == null;
            });
            debugPrint("update after Model = ${req}");
            try {
              final res = await DioClient(event.context).post(
                  AppUrls.updateProfileDetailsUrl +
                      "/" +
                      preferences.getUserId(),
                  data: /*reqMap.toJson()*/ req,
              /*    options: Options(
                    headers: {
                      HttpHeaders.authorizationHeader:
                      'Bearer ${preferences.getAuthToken()}',
                    },
                  )*/
              );

              debugPrint('operation update req _____${req}');

              reqUpdate.ProfileDetailsUpdateResModel res1 =
                  reqUpdate.ProfileDetailsUpdateResModel.fromJson(res);

              debugPrint('operation update res _____${res1}');
              if (res1.status == 200) {
                showSnackBar(
                    context: event.context,
                    title: AppStrings.updateSuccessString,
                    bgColor: AppColors.mainColor);
                Navigator.pop(event.context);
              } else {
                showSnackBar(
                    context: event.context,
                    title: res.message ?? AppStrings.somethingWrongString,
                    bgColor: AppColors.redColor);
              }
            } on ServerException {
            }
          }
        }
      }
    });
  }
}
