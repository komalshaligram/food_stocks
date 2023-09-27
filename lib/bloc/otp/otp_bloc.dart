import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_event.dart';
part 'otp_state.dart';
part 'otp_bloc.freezed.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  late StreamSubscription _periodicOtpTimerSubscription;
  OtpBloc() : super(OtpState.initial()) {
    on<OtpEvent>((event, emit) {
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
    });
  }
}
