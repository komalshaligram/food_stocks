import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/model/operation_time/operation_time_model.dart';
import '../../data/model/req_model/profile_req_model/profile_model.dart';

import '../../repository/dio_client.dart';
import '../../ui/utils/themes/app_colors.dart';
import '../../ui/utils/themes/app_constants.dart';
import '../../ui/utils/themes/app_styles.dart';

part 'operation_time_event.dart';

part 'operation_time_state.dart';

part 'operation_time_bloc.freezed.dart';

class OperationTimeBloc extends Bloc<OperationTimeEvent, OperationTimeState> {
  ProfileModel profileModel = ProfileModel();

  OperationTimeBloc() : super(OperationTimeState.initial()) {
    on<OperationTimeEvent>((event, emit) async {
      if (event is _defaultValueAddInListEvent) {
        List<OperationTimeModel> temp = [];
        temp.add(
          OperationTimeModel(
            data: [
              timeData(openingTime: '0:0', closingTime: '0:0'),
            ],
          ),
        );
        temp.add(
          OperationTimeModel(
            data: [
              timeData(openingTime: '0:0', closingTime: '0:0'),
            ],
          ),
        );
        temp.add(
          OperationTimeModel(
            data: [
              timeData(openingTime: '0:0', closingTime: '0:0'),
            ],
          ),
        );
        temp.add(
          OperationTimeModel(
            data: [
              timeData(openingTime: '0:0', closingTime: '0:0'),
            ],
          ),
        );
        temp.add(
          OperationTimeModel(
            data: [
              timeData(openingTime: '0:0', closingTime: '0:0'),
            ],
          ),
        );
        temp.add(
          OperationTimeModel(
            data: [
              timeData(openingTime: '0:0', closingTime: '0:0'),
            ],
          ),
        );
        temp.add(
          OperationTimeModel(
            data: [
              timeData(openingTime: '0:0', closingTime: '0:0'),
            ],
          ),
        );
        emit(state.copyWith(OperationTimeList: temp));
      }

      if (event is _timePickerEvent) {
        void showSnackBar(BuildContext context, String title) {
          final snackBar = SnackBar(
            content: Text(
              title,
              style: AppStyles.rkRegularTextStyle(
                  size: AppConstants.smallFont,
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w400),
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
              showSnackBar(event.context, 'select proper timezone');
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
              showSnackBar(event.context, 'select proper timezone');
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
            .add(timeData(openingTime: '0:0', closingTime: '0:0'));
        emit(state.copyWith(
            OperationTimeList: temp, isRefresh: !state.isRefresh));
      }

      if (event is _deleteTimeZoneEvent) {
        List<OperationTimeModel> temp = [];
        temp.addAll(state.OperationTimeList);
        temp[event.rowIndex].data.removeAt(event.timeIndex);
        emit(state.copyWith(
            OperationTimeList: temp, isRefresh: !state.isRefresh));
      } else if (event is _getProfileModelEvent) {
        profileModel = event.profileModel;
        debugPrint('get contact name = ${profileModel.contactName}');
      }

      if (event is _timeZoneApiEvent) {
        if (state.OperationTimeList[0].data[0].openingTime != '0:0' &&
            state.OperationTimeList[0].data[0].closingTime != '0:0') {
          ProfileModel reqMap = ProfileModel(
              statusId: profileModel.statusId,
              profileImage: profileModel.profileImage,
              phoneNumber: '4563217850',
              logo: profileModel.logo,
              lastName: '',
              firstName: '',
              cityId: profileModel.cityId,
              contactName: profileModel.contactName,
              address: profileModel.address,
              email: profileModel.email,
              clientDetail: ClientDetail(
                fax: profileModel.clientDetail?.fax,
                //  clientTypeId: '60abf964173234001c903a05',
                applicationVersion:
                    profileModel.clientDetail?.applicationVersion,
                ownerName: profileModel.clientDetail?.ownerName,
                bussinessName: profileModel.clientDetail?.bussinessName,
                bussinessId: profileModel.clientDetail?.bussinessId,
                deviceType: profileModel.clientDetail?.deviceType,
                israelId: profileModel.clientDetail?.israelId,
                lastSeen: DateTime.now(),
                // monthlyCredits: 100,
                operationTime: OperationTime(monday: [
                  Monday(
                    from: state.OperationTimeList[0].data[0].openingTime,
                    unitl: state.OperationTimeList[0].data[0].closingTime,
                  ),
                ]),
                tokenId: profileModel.clientDetail?.tokenId,
              ));

          debugPrint('operation time reqMap + $reqMap');
          try {
            final response = await DioClient()
                .post('/v1/clients/createClient', data: reqMap);

            ProfileModel profileResModel =
                ProfileModel.fromJson(response);

            debugPrint('operation time response --- ${profileResModel}');

            if (response['status'] == 200) {
              emit(state.copyWith(isRegisterSuccess: true));
            } else {
              emit(state.copyWith(
                  isRegisterFail: false, errorMessage: 'login failed'));
              await Future.delayed(const Duration(seconds: 2));
              emit(state.copyWith(
                isRegisterFail: false,
              ));
            }
          } catch (e) {
            debugPrint(e.toString());
            emit(state.copyWith(
                isRegisterFail: true, errorMessage: 'login failed1'));
            await Future.delayed(const Duration(seconds: 2));
            emit(state.copyWith(
              isRegisterFail: false,
            ));
          }
        }
        else{
          emit(state.copyWith(
              isRegisterFail: true, errorMessage: 'please select shiftTime'));
          await Future.delayed(const Duration(seconds: 2));
          emit(state.copyWith(
            isRegisterFail: false,
          ));
        }
      }

    });
  }
}
