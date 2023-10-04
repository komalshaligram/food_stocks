import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_stock/ui/utils/app_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/model/operation_time/operation_time_model.dart';
import '../../data/model/req_model/profile_req_model/profile_model.dart';
import '../../data/model/res_model/profile_res_model/profile_res_model.dart' as res;
import '../../repository/dio_client.dart';
import '../../ui/utils/themes/app_colors.dart';
part 'operation_time_event.dart';
part 'operation_time_state.dart';
part 'operation_time_bloc.freezed.dart';

class OperationTimeBloc extends Bloc<OperationTimeEvent, OperationTimeState> {
  ProfileModel profileModel = ProfileModel();

  OperationTimeBloc() : super(OperationTimeState.initial()) {
    on<OperationTimeEvent>((event, emit) async {
      List<Monday> sundayList = [];
      List<Monday> mondayList = [];
      List<Monday> tuesdayList = [];
      List<Monday> wednesdayList = [];
      List<Monday> thursdayList = [];
      List<Monday> fridayAndHolidayEvesList = [];
      List<Monday> saturdayAndHolidaysList = [];

      if (event is _defaultValueAddInListEvent) {
        List<OperationTimeModel> temp = [];
        if (state.OperationTimeList.isEmpty) {
          temp.add(
            OperationTimeModel(
              monday: [
                Monday(unitl: '0:0', from: '0:0'),
              ],
            ),
          );
          temp.add(
            OperationTimeModel(
              monday: [
                Monday(unitl: '0:0', from: '0:0'),
              ],
            ),
          );
          temp.add(
            OperationTimeModel(
              monday: [
                Monday(unitl: '0:0', from: '0:0'),
              ],
            ),
          );
          temp.add(
            OperationTimeModel(
              monday: [
                Monday(unitl: '0:0', from: '0:0'),
              ],
            ),
          );
          temp.add(
            OperationTimeModel(
              monday: [
                Monday(unitl: '0:0', from: '0:0'),
              ],
            ),
          );
          temp.add(
            OperationTimeModel(
              monday: [
                Monday(unitl: '0:0', from: '0:0'),
              ],
            ),
          );
          temp.add(
            OperationTimeModel(
              monday: [
                Monday(unitl: '0:0', from: '0:0'),
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
              temp[event.rowIndex].monday[event.timeIndex].unitl!;
          String? previousClosingTime;

          var format = DateFormat("HH:mm");
          var start = format.parse(openingTime);
          var selectTimeZone = format.parse(selectedTime);
          print(selectTimeZone);
          print(start);
          print(selectTimeZone.isAfter(start));

          if (event.timeIndex > 0) {
            previousClosingTime =
                temp[event.rowIndex].monday[event.timeIndex - 1].unitl;
            var format = DateFormat("HH:mm");
            var preEnd = format.parse(previousClosingTime!);

            if (event.openingIndex == 1 && selectTimeZone.isAfter(preEnd)) {
              temp[event.rowIndex].monday.removeAt(event.timeIndex);
              temp[event.rowIndex]
                  .monday
                  .add(Monday(from: selectedTime, unitl: closingTime));
            } else if (event.openingIndex == 0) {
              if (temp[event.rowIndex].monday[event.timeIndex].from! == '0:0') {
                showSnackBar(
                    context: event.context, title: 'select opening Time', bgColor: AppColors.redColor);
              } else if (selectTimeZone.isAfter(start)) {
                temp[event.rowIndex].monday.removeAt(event.timeIndex);
                temp[event.rowIndex]
                    .monday
                    .add(Monday(from: openingTime, unitl: selectedTime));
              }
              else {
                showSnackBar(
                    context: event.context,
                    title: 'select closing time after opening time',
                    bgColor:  AppColors.redColor);
              }
            }
          }
          else {
            if (event.openingIndex == 1) {
              temp[event.rowIndex].monday.removeAt(event.timeIndex);
              temp[event.rowIndex]
                  .monday
                  .add(Monday(from: selectedTime, unitl: closingTime));
            } else if (event.openingIndex == 0) {
              if (temp[event.rowIndex].monday[event.timeIndex].from! == '0:0') {
                showSnackBar(
                    context: event.context,title:  'select opening Time', bgColor: AppColors.redColor);
              } else if (selectTimeZone.isAfter(start)) {
                temp[event.rowIndex].monday.removeAt(event.timeIndex);
                temp[event.rowIndex]
                    .monday
                    .add(Monday(from: openingTime, unitl: selectedTime));
              } else {
                showSnackBar(
                    context: event.context,
                    title:'select opening time after closing time',
                    bgColor:AppColors.redColor);
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
                  '0:0' &&
              state.OperationTimeList[event.rowIndex].monday[len - 1].unitl !=
                  '0:0') {
            temp[event.rowIndex].monday.add(Monday(from: '0:0', unitl: '0:0'));
            emit(state.copyWith(
                OperationTimeList: temp, isRefresh: !state.isRefresh));
          } else {
            showSnackBar(context:event.context, title:'select previous shift time',
                bgColor:AppColors.redColor);
          }
        } else {
          if (state.OperationTimeList[event.rowIndex].monday[0].from != '0:0' &&
              state.OperationTimeList[event.rowIndex].monday[0].unitl !=
                  '0:0') {
            temp[event.rowIndex].monday.add(Monday(from: '0:0', unitl: '0:0'));
            emit(state.copyWith(
                OperationTimeList: temp, isRefresh: !state.isRefresh));
          } else {
            showSnackBar(
                context: event.context, title:'select first shift time', bgColor: AppColors.redColor);
          }
        }
      }

      if (event is _deleteTimeZoneEvent) {
        List<OperationTimeModel> temp = [];
        temp.addAll(state.OperationTimeList);
        temp[event.rowIndex].monday.removeAt(event.timeIndex);
        emit(state.copyWith(
            OperationTimeList: temp, isRefresh: !state.isRefresh));
      } else if (event is _getProfileModelEvent) {
        profileModel = event.profileModel;
        debugPrint('get contact name = ${profileModel.contactName}');
      }

      if (event is _timeZoneApiEvent) {
        ProfileModel? reqMap;
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


        if (event.isTimeOperation && sundayList.first.from != '0:0' ||
            mondayList.first.from != '0:0' && tuesdayList.first.from != '0:0' ||
            wednesdayList.first.from != '0:0' ||
            thursdayList.first.from != '0:0' ||
            fridayAndHolidayEvesList.first.from != '0:0' ||
            saturdayAndHolidaysList.first.from != '0:0') {
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
                operationTime: OperationTime(
                  sunday: sundayList,
                  monday: mondayList,
                  tuesday: tuesdayList,
                  wednesday: wednesdayList,
                  thursday: thursdayList,
                  fridayAndHolidayEves: fridayAndHolidayEvesList,
                  saturdayAndHolidays: saturdayAndHolidaysList,
                ),
                tokenId: profileModel.clientDetail?.tokenId,
              ));
          debugPrint('operation time reqMap + $reqMap');
          try {
            final response = await DioClient()
                .post('/v1/clients/createClient', data: reqMap);

            res.ProfileResModel profileResModel =
                res.ProfileResModel.fromJson(response);

            debugPrint('operation time response --- ${profileResModel}');

            if (response['status'] == 200) {
              emit(state.copyWith(isRegisterSuccess: true));
              await Future.delayed(const Duration(seconds: 2));
              emit(state.copyWith(
                isRegisterSuccess: false,
              ));
            } else {
              emit(state.copyWith(
                  isRegisterFail: true, errorMessage: response['message']));
              await Future.delayed(const Duration(seconds: 2));
              emit(state.copyWith(
                isRegisterFail: false,
              ));
            }
          } catch (e) {
            debugPrint(e.toString());
            emit(state.copyWith(
                isRegisterFail: true, errorMessage: e.toString()));
            await Future.delayed(const Duration(seconds: 2));
            emit(state.copyWith(
              isRegisterFail: false,
            ));
          }
        } else {
          if (event.isTimeOperation) {
            emit(state.copyWith(
                isRegisterFail: true, errorMessage: 'please select shiftTime'));
            await Future.delayed(const Duration(seconds: 2));
            emit(state.copyWith(
              isRegisterFail: false,
            ));
          }
        }

        if (event.isTimeOperation == false) {
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
                operationTime: OperationTime(),
                tokenId: profileModel.clientDetail?.tokenId,
              ));

          debugPrint('operation time reqMap + $reqMap');
          try {
            final response = await DioClient()
                .post('/v1/clients/createClient', data: reqMap,context: event.context);

            res.ProfileResModel profileResModel =
                res.ProfileResModel.fromJson(response);

            debugPrint('operation time response --- ${profileResModel}');

            if (response['status'] == 200) {
              emit(state.copyWith(isRegisterSuccess: true));
              await Future.delayed(const Duration(seconds: 2));
              emit(state.copyWith(
                isRegisterSuccess: false,
              ));
            } else {
              emit(state.copyWith(
                  isRegisterFail: true, errorMessage: response['message']));
              await Future.delayed(const Duration(seconds: 2));
              emit(state.copyWith(
                isRegisterFail: false,
              ));
            }
          } catch (e) {
            debugPrint(e.toString());
            emit(state.copyWith(
                isRegisterFail: true, errorMessage: e.toString()));
            await Future.delayed(const Duration(seconds: 2));
            emit(state.copyWith(
              isRegisterFail: false,
            ));
          }
        }
      }
    });
  }
}
