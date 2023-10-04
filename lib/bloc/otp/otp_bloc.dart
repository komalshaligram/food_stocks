import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/otp_req_model/otp_req_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
import '../../repository/dio_client.dart';

part 'otp_event.dart';
part 'otp_state.dart';
part 'otp_bloc.freezed.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  late StreamSubscription _periodicOtpTimerSubscription;
  OtpBloc() : super(OtpState.initial()) {
    on<OtpEvent>((event, emit) async {

      if(event is _SetOtpTimerEvent) {
        if(state.otpTimer == 0) {
          emit(state.copyWith(otpTimer: 30));
          _periodicOtpTimerSubscription =
              Stream.periodic(const Duration(seconds: 1), (x) => x).listen(
                    (_) => add(_UpdateTimerEvent()),
                onError: (error) => debugPrint("otp timer error = $error"),
              );
        }
      } else if(event is _UpdateTimerEvent) {
        if(state.otpTimer == 0) {
          _periodicOtpTimerSubscription.cancel();
        } else {
          emit(state.copyWith(otpTimer: state.otpTimer - 1));
        }
      } else if(event is _cancelTimerscriptionEvent) {
        _periodicOtpTimerSubscription.cancel();
      }


      if(event is _otpApiEvent){

        if(event.otp.isNotEmpty){
          OtpReqModel reqMap =
          OtpReqModel(
              contact: event.contact,otp:event.otp);
          debugPrint('otp req + $reqMap');
          try {
            final response = await DioClient().post('/v1/auth/clientLogin',data: reqMap,context: event.context);
            print('otp response + $response');

            if(response['status'] == 200){
              debugPrint('otp tocken + ${response['authToken']['accessToken']}');
              debugPrint('otp refreshToken + ${response['authToken']['refreshToken']}');
              SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
              preferencesHelper.setAuthToken(accessToken: response['authToken']['accessToken']);
              preferencesHelper.setAuthToken(accessToken: response['authToken']['refreshToken']);
              emit(state.copyWith(isLoginSuccess: true));
            }
            else{
              emit(state.copyWith(isLoginFail: true ,errorMessage:response['message'] ));
              await Future.delayed(const Duration(milliseconds: 2));
              emit(state.copyWith(isLoginFail: false));
            }

          } catch(e) {
            emit(state.copyWith(isLoginFail: true ,errorMessage: e.toString()));
            await Future.delayed(const Duration(milliseconds: 2));
            emit(state.copyWith(isLoginFail: false));
          }

        }
        else{
          emit(state.copyWith(isLoginFail: true ,errorMessage: 'enter otp'));
          await Future.delayed(const Duration(milliseconds: 2));
          emit(state.copyWith(isLoginFail: false));
        }



    }

    });
  }
}
