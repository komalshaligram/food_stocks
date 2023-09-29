import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:food_stock/ui/utils/themes/app_urls.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/model/req_model/login_req_model/login_req_model.dart';
import '../../data/model/res_model/login_res_model/login_res_model.dart';
import '../../repository/dio_client.dart';

part 'log_in_event.dart';

part 'log_in_state.dart';

part 'log_in_bloc.freezed.dart';

class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc() : super(LogInState.initial()) {
    on<LogInEvent>((event, emit) async {
      if (event is _logInApiDataEvent) {
        LoginReqModel reqMap = LoginReqModel(
            contact: event.contactNumber, isRegistration: event.isRegister);

        debugPrint('login reqMap + $reqMap');
        try {
          final response = await DioClient()
              .post(AppUrls.existingUserLoginUrl, data: reqMap);

          LoginResModel businessTypeModel = LoginResModel.fromJson(response);

          debugPrint('login response --- ${businessTypeModel}');

          if (response['status'] == 200) {
            emit(state.copyWith(isLoginSuccess: true));
          } else {
            emit(state.copyWith(
                isLoginFail: true, errorMessage: 'login failed'));
            await Future.delayed(const Duration(seconds: 2));
            emit(state.copyWith(
                isLoginFail: false, errorMessage: 'login failed'));

          }
        } catch (e) {
          emit(state.copyWith(
              isLoginFail: true, errorMessage: 'login failed1'));
          await Future.delayed(const Duration(seconds: 2));
          emit(state.copyWith(
              isLoginFail: false, errorMessage: 'login failed1'));
        }
      }
    });
  }
}
