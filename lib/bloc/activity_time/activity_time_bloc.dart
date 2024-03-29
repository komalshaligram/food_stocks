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

import '../../data/model/req_model/profile_details_update_req_model/profile_details_update_req_model.dart';
import '../../data/model/res_model/activity_time_model/activity_time_res_model.dart'
    as res;
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';
import '../../routes/app_routes.dart';
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

      List<Day> sundayList = [];
      List<Day> mondayList = [];
      List<Day> tuesdayList = [];
      List<Day> wednesdayList = [];
      List<Day> thursdayList = [];
      List<Day> fridayAndHolidayEvesList = [];
      List<Day> saturdayAndHolidaysList = [];

      if (event is _getActivityTimeDetailsEvent) {
        emit(state.copyWith(isUpdate: event.isUpdate));
      }

      if (event is _getActivityTimeListEvent) {
        if (state.isUpdate) {
          emit(state.copyWith(isShimmering: true));
          try {
            final res = await DioClient(event.context).post(
              AppUrls.getProfileDetailsUrl,
              data: req.ProfileDetailsReqModel(id: preferences.getUserId())
                  .toJson(),
            );

            debugPrint('respo_______$res');

            response = resGet.ProfileDetailsResModel.fromJson(res);
            debugPrint('response_______${response.toJson()}');

            if (response.status == 200) {
              if ((response.data?.clients?.first.clientDetail?.operationTime
                      ?.length !=
                  0)) {
                List<ActivityTimeModel> temp1 = state.OperationTimeList;
                int listLength = response.data?.clients?.first.clientDetail
                        ?.operationTime?.length ??
                    0;


                var sundayRs = (listLength) > 0
                    ? (response.data?.clients?.first.clientDetail
                            ?.operationTime?[0].Sunday ?? [Day(from:AppStrings.timeString ,until: AppStrings.timeString )]
                        )
                    : [Day(from:AppStrings.timeString  ,until: AppStrings.timeString )];
                var mondayRs = (listLength) > 1
                    ? (response.data?.clients?.first.clientDetail
                            ?.operationTime?[1].Monday ??
                    [Day(from: AppStrings.timeString,until: AppStrings.timeString)])
                    : [Day(from:AppStrings.timeString ,until: AppStrings.timeString)];
                var tuesdayRs = (listLength) > 2
                    ? (response.data?.clients?.first.clientDetail
                            ?.operationTime?[2].Tuesday ??
                    [Day(from:AppStrings.timeString ,until: AppStrings.timeString)])
                    : [Day(from:AppStrings.timeString ,until: AppStrings.timeString)];
                var wednesdayRs = (listLength) > 3
                    ? (response.data?.clients?.first.clientDetail
                            ?.operationTime?[3].Wednesday ??
                    [Day(from:AppStrings.timeString ,until: AppStrings.timeString)])
                    : [Day(from:AppStrings.timeString ,until: AppStrings.timeString)];
                var thursdayRs = (listLength) > 4
                    ? (response.data?.clients?.first.clientDetail
                            ?.operationTime?[4].Thursday ??
                    [Day(from:AppStrings.timeString ,until: AppStrings.timeString)])
                    :   [Day(from:AppStrings.timeString ,until: AppStrings.timeString)];
                var fridayAndHolidayEvesRs = (listLength) > 5
                    ? (response.data?.clients?.first.clientDetail
                            ?.operationTime?[5].Friday ??
                    [Day(from:AppStrings.timeString ,until: AppStrings.timeString)])
                    : [Day(from:AppStrings.timeString ,until: AppStrings.timeString)];
                var saturdayAndHolidaysRs = (listLength) > 6
                    ? (response.data?.clients?.first.clientDetail
                            ?.operationTime?[6].Saturday ??
                    [Day(from:AppStrings.timeString ,until: AppStrings.timeString)])
                    : [Day(from:AppStrings.timeString ,until: AppStrings.timeString)];

                sundayList = sundayRs.map((e) {
                  return Day(from: e.from ?? AppStrings.timeString, until: e.until ?? AppStrings.timeString);
                }).toList();

                mondayList = mondayRs.map((e) {
                  return Day(
                      from:  e.from ?? AppStrings.timeString,
                      until:  e.until ?? AppStrings.timeString );
                }).toList();

                tuesdayList = tuesdayRs.map((e) {
                  return Day(
                      from:  e.from ?? AppStrings.timeString,
                      until: e.until  ?? AppStrings.timeString);
                }).toList();

                wednesdayList = wednesdayRs.map((e) {
                  return Day(from: e.from ?? AppStrings.timeString, until: e.until ?? AppStrings.timeString);
                }).toList();

                thursdayList = thursdayRs.map((e) {
                  return Day(from: e.from ?? AppStrings.timeString, until: e.until ?? AppStrings.timeString);
                }).toList();

                  fridayAndHolidayEvesList = fridayAndHolidayEvesRs.map((e) {
                    return Day(from: e.from ?? AppStrings.timeString, until: e.until ?? AppStrings.timeString);
                  }).toList();

                saturdayAndHolidaysList = saturdayAndHolidaysRs.map((e) {
                  return Day(from: e.from ?? AppStrings.timeString, until: e.until ?? AppStrings.timeString);
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
                  isRefresh: !state.isRefresh,
                ));
              } else {
                emit(state.copyWith(isShimmering: false));
              }
            } else {
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title: AppStrings.getLocalizedStrings(
                      response.message?.toLocalization() ?? response.message!,
                      event.context),
                  type: SnackBarType.FAILURE);
              emit(state.copyWith(isShimmering: false));
            }
          } on ServerException {
            emit(state.copyWith(isShimmering: false));
          }
        }
      }

      if (event is _defaultValueAddInListEvent) {
        List<ActivityTimeModel> temp = [];
        if (state.OperationTimeList.isEmpty) {
          temp.add(
            ActivityTimeModel(
              dayString: AppLocalizations.of(event.context)!.sunday,
              monday: [
                Day(until: AppStrings.timeString, from: AppStrings.timeString),
              ],
            ),
          );
          temp.add(
            ActivityTimeModel(
              dayString: AppLocalizations.of(event.context)!.monday,
              monday: [
                Day(until: AppStrings.timeString, from: AppStrings.timeString),
              ],
            ),
          );
          temp.add(
            ActivityTimeModel(
                dayString: AppLocalizations.of(event.context)!.tuesday,
                monday: [
                  Day(
                      until: AppStrings.timeString,
                      from: AppStrings.timeString),
                ]),
          );
          temp.add(
            ActivityTimeModel(
              dayString: AppLocalizations.of(event.context)!.wednesday,
              monday: [
                Day(until: AppStrings.timeString, from: AppStrings.timeString),
              ],
            ),
          );
          temp.add(
            ActivityTimeModel(
              dayString: AppLocalizations.of(event.context)!.thursday,
              monday: [
                Day(until: AppStrings.timeString, from: AppStrings.timeString),
              ],
            ),
          );
          temp.add(
            ActivityTimeModel(
              dayString:
                  AppLocalizations.of(event.context)!.friday_and_holiday_eves,
              monday: [
                Day(until: AppStrings.timeString, from: AppStrings.timeString),
              ],
            ),
          );
          temp.add(
            ActivityTimeModel(
              dayString:
                  AppLocalizations.of(event.context)!.saturday_and_holidays,
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
          if (event.openingIndex == 0 && event.time == AppStrings.timeString || event.time == '' || event.time == '24:59' ) {
            selectedTime = AppStrings.hr24String;
            emit(state.copyWith(time: selectedTime));
          }
          var format = DateFormat("HH:mm");
          List<ActivityTimeModel> temp = [];
          temp.addAll(state.OperationTimeList);

          String?  afterOpeningTime;
          var afterStart;

          var shortVar = temp[event.rowIndex].monday;

          String? openingTime =
          shortVar[event.timeIndex].from!.isEmpty ?'24:59': shortVar[event.timeIndex].from;
          String? closingTime =
          shortVar[event.timeIndex].until!.isEmpty ?'24:59' : shortVar[event.timeIndex].until;


          if(shortVar.length > 1 && event.openingIndex == 0 && event.previousTime != AppStrings.timeString
          && event.previousTime != '24:59' && shortVar.length != event.timeIndex + 1
          ){
             afterOpeningTime =
             shortVar[event.timeIndex + 1].from!.isEmpty ?'24:59' : shortVar[event.timeIndex + 1].from;

         afterStart = format.parse(afterOpeningTime ?? '');
          }



          String? previousClosingTime;


          var start = format.parse(openingTime!);
          var end = format.parse(closingTime!);



          var selectTimeZone = format.parse(selectedTime);


          if (selectedTime != AppStrings.timeString ) {

            if (event.timeIndex > 0) {
              previousClosingTime =
                  shortVar[event.timeIndex - 1].until;

              var format = DateFormat("HH:mm");
              var preEnd =
                  format.parse(previousClosingTime ?? AppStrings.timeString);

              if (event.openingIndex == 1) {
                if (closingTime == AppStrings.timeString &&
                    selectTimeZone.isAfter(preEnd)) {
                  shortVar.removeAt(event.timeIndex);
                  shortVar.insert(event.timeIndex,Day(from: selectedTime, until: closingTime));
                //  shortVar.add(Day(from: selectedTime, until: closingTime));
                } else if (closingTime != AppStrings.timeString) {
                  if (selectTimeZone.isAfter(preEnd) &&
                      selectTimeZone.isBefore(end)) {
                    shortVar.removeAt(event.timeIndex);
                    shortVar.insert(event.timeIndex,Day(from: selectedTime, until: closingTime));

                    //shortVar.add(Day(from: selectedTime, until: closingTime));
                  } else if (selectTimeZone.isBefore(preEnd)) {
                    CustomSnackBar.showSnackBar(
                        context: event.context,
                        title:
                            '${AppLocalizations.of(event.context)!.please_select_opening_time_after_previous_closing_time}',
                        type: SnackBarType.FAILURE);
                  } else {
                    CustomSnackBar.showSnackBar(
                        context: event.context,
                        title:
                            '${AppLocalizations.of(event.context)!.please_select_opening_time_before_closing_time}',
                        type: SnackBarType.FAILURE);
                  }
                } else {
                  CustomSnackBar.showSnackBar(
                      context: event.context,
                      title:
                          '${AppLocalizations.of(event.context)!.please_select_opening_time_after_previous_closing_time}',
                      type: SnackBarType.FAILURE);
                }
              }
              else if (event.openingIndex == 0) {
                if (openingTime == AppStrings.timeString) {
                  CustomSnackBar.showSnackBar(
                      context: event.context,
                      title:
                          '${AppLocalizations.of(event.context)!.please_select_opening_time}',
                      type: SnackBarType.FAILURE);
                } else if (selectTimeZone.isAfter(start)) {
                  shortVar.removeAt(event.timeIndex);
                  shortVar.insert(event.timeIndex,Day(from: openingTime, until: selectedTime));
                  //shortVar.add(Day(from: openingTime, until: selectedTime));
                } else {
                  CustomSnackBar.showSnackBar(
                      context: event.context,
                      title:
                          '${AppLocalizations.of(event.context)!.please_select_closing_time_after_opening_time}',
                      type: SnackBarType.FAILURE);
                }
              }
            }
            else {
              if (event.openingIndex == 1) {
                if (closingTime != AppStrings.timeString &&
                    selectTimeZone.isBefore(end)) {
                  shortVar.removeAt(event.timeIndex);
                  shortVar.insert(event.timeIndex,Day(from: selectedTime, until: closingTime));
                 // shortVar.add(Day(from: selectedTime, until: closingTime));
                } else if (closingTime == AppStrings.timeString) {
                  shortVar.removeAt(event.timeIndex);
                  shortVar.insert(event.timeIndex,Day(from: selectedTime, until: closingTime));
                  //shortVar.add(Day(from: selectedTime, until: closingTime));
                } else {
                  CustomSnackBar.showSnackBar(
                      context: event.context,
                      title:
                          '${AppLocalizations.of(event.context)!.please_select_opening_time_before_closing_time}',
                      type: SnackBarType.FAILURE);
                }
              }


              else if (event.openingIndex == 0) {
                if (openingTime == AppStrings.timeString) {
                  CustomSnackBar.showSnackBar(
                      context: event.context,
                      title:
                          '${AppLocalizations.of(event.context)!.please_select_opening_time}',
                      type: SnackBarType.FAILURE);
                } else if (shortVar.length == 1   && selectTimeZone.isAfter(start) ) {

                  shortVar.removeAt(event.timeIndex);
                  shortVar.insert(event.timeIndex,Day(from: openingTime, until: selectedTime));


                }
                else if(shortVar.length > 1   && selectTimeZone.isAfter(start) &&
                    selectTimeZone.isBefore(afterStart)){

                  shortVar.removeAt(event.timeIndex);
                  shortVar.insert(event.timeIndex,Day(from: openingTime, until: selectedTime));

                }

                else {
                  CustomSnackBar.showSnackBar(
                      context: event.context,
                      title:
                          '${AppLocalizations.of(event.context)!.please_provide_valid_time}',
                      type: SnackBarType.FAILURE);
                }
              }
            }
            emit(state.copyWith(
                OperationTimeList: temp, isRefresh: !state.isRefresh));
          } else {
            CustomSnackBar.showSnackBar(
                context: event.context,
                title:
                    '${AppLocalizations.of(event.context)!.please_select_time_grater_then_0}',
                type: SnackBarType.FAILURE);
          }
        }
      }

      if (event is _addMoreTimeZoneEventEvent) {
        List<ActivityTimeModel> temp = [];
        temp.addAll(state.OperationTimeList);

        if (state.time != AppStrings.hr24String) {
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
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title:
                      '${AppLocalizations.of(event.context)!.please_select_previous_shift_time}',
                  type: SnackBarType.FAILURE);
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
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title:
                      '${AppLocalizations.of(event.context)!.please_select_first_shift_time}',
                  type: SnackBarType.FAILURE);
            }
          }
        }
        else{
          CustomSnackBar.showSnackBar(
              context: event.context,
              title: '${AppLocalizations.of(event.context)!.select_next_day_shift}',
              type: SnackBarType.FAILURE);
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
        bool isSnackbarActive = false;


        for (int i = 0; i < state.OperationTimeList.length; i++) {

          if(state.OperationTimeList[i].monday != [] && state.OperationTimeList[i].monday.isNotEmpty  ){

            if (state.OperationTimeList[i].monday[0].until ==
                AppStrings.timeString &&
                state.OperationTimeList[i].monday[0].from !=
                    AppStrings.timeString || state.OperationTimeList[i].monday[0].until ==
                '24:59'

            ) {
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title:
                  '${AppLocalizations.of(event.context)!.please_fill_up_closing_time}',
                  type: SnackBarType.FAILURE);
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
                      AppStrings.timeString ||
                  state.OperationTimeList[i].monday[j].until ==
                      '24:59'
              ) {
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title:
                    '${AppLocalizations.of(event.context)!.please_fill_up_closing_time}',
                    type: SnackBarType.FAILURE);
                isSnackbarActive = true;
              }
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
            emit(state.copyWith(isLoading: true));
            if (sundayList.first.from != AppStrings.timeString ||
                mondayList.first.from != AppStrings.timeString &&
                    tuesdayList.first.from != AppStrings.timeString ||
                wednesdayList.first.from != AppStrings.timeString ||
                thursdayList.first.from != AppStrings.timeString ||
                fridayAndHolidayEvesList.first.from != AppStrings.timeString ||
                saturdayAndHolidaysList.first.from != AppStrings.timeString) {
              ActivityTimeReqModel reqMap =
                  ActivityTimeReqModel(operationTime: [
                OperationTime(
                  Sunday:sundayList,
                ),
                OperationTime(Monday: mondayList),
                OperationTime(Tuesday: tuesdayList),
                OperationTime(
                  Wednesday: wednesdayList,
                ),
                OperationTime(
                  Thursday: thursdayList,
                ),
                OperationTime(
                  Friday: fridayAndHolidayEvesList,
                ),
                OperationTime(Saturday: saturdayAndHolidaysList),

                /*   Tuesday: tuesdayList,
                  Wednesday: wednesdayList,
                  Thursday: thursdayList,
                  Friday: fridayAndHolidayEvesList,
                  Saturday: saturdayAndHolidaysList,*/
              ]);

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
                  emit(state.copyWith(isLoading: false));
                } else {
                  CustomSnackBar.showSnackBar(
                      context: event.context,
                      title: AppStrings.getLocalizedStrings(
                          response1.message?.toLocalization() ??
                              response.message!,
                          event.context),
                      type: SnackBarType.FAILURE);
                  emit(state.copyWith(isLoading: false));
                }
              } on ServerException {
                emit(state.copyWith(isLoading: false));
              }
            } else {
              CustomSnackBar.showSnackBar(
                  context: event.context,
                  title:
                      '${AppLocalizations.of(event.context)!.please_select_first_shift_time}',
                  type: SnackBarType.FAILURE);
            }
          } else {
            emit(state.copyWith(isLoading: true));

            ProfileDetailsUpdateReqModel reqMap = ProfileDetailsUpdateReqModel(
                clientDetail: ClientDetail(operationTime: [
                  OperationTime(Sunday: sundayList),
              OperationTime(Monday: mondayList),
              OperationTime(Tuesday: tuesdayList),
              OperationTime(Wednesday: wednesdayList),
              OperationTime(Thursday: thursdayList),
              OperationTime(Friday: fridayAndHolidayEvesList),
              OperationTime(Saturday: saturdayAndHolidaysList),
            ]));


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
                AppUrls.updateProfileDetailsUrl + "/" + preferences.getUserId(),
                data: /*reqMap.toJson()*/ req,
              );

              debugPrint('operation update req _____${req}');

              reqUpdate.ProfileDetailsUpdateResModel res1 =
                  reqUpdate.ProfileDetailsUpdateResModel.fromJson(res);

              debugPrint('operation update res _____${res1}');
              if (res1.status == 200) {
                Navigator.pop(event.context);
                CustomSnackBar.showSnackBar(
                  context: event.context,
                  title:
                      '${AppLocalizations.of(event.context)!.updated_successfully}',
                  type: SnackBarType.SUCCESS,
                );
                emit(state.copyWith(isLoading: false));
              } else {
                CustomSnackBar.showSnackBar(
                    context: event.context,
                    title: AppStrings.getLocalizedStrings(
                        res1.message?.toLocalization() ?? response.message!,
                        event.context),
                    type: SnackBarType.FAILURE);
                emit(state.copyWith(isLoading: false));
              }
            } on ServerException {
              emit(state.copyWith(isLoading: false));
            }
          }
        }
      }
    });
  }
}
