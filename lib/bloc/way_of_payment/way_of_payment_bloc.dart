import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/req_model/terms_condition/terms_condition_req_model.dart';
import '../../data/storage/shared_preferences_helper.dart';
part 'way_of_payment_state.dart';
part 'way_of_payment_event.dart';
part 'way_of_payment_bloc.freezed.dart';

class WayOfPaymentBloc extends Bloc<WayOfPaymentEvent, WayOfPaymentState> {
  WayOfPaymentBloc() : super(WayOfPaymentState.initial()) {
    on<WayOfPaymentEvent>((event, emit) async {
      SharedPreferencesHelper preferences = SharedPreferencesHelper(prefs: await SharedPreferences.getInstance());
      if (event is _radioButtonEvent) {
        emit(state.copyWith(selectRadioTile: event.selectRadioTile));
      } else if (event is _getArgumentEvent) {
        emit(state.copyWith(isUpdate: event.isUpdate, termsReqModel: event.termsReqModel, isEnablePayment: preferences.getAvailablePayment()));
      }
    });
  }
}
