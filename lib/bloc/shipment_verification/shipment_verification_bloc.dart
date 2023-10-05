import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'shipment_verification_event.dart';
part 'shipment_verification_state.dart';
part 'shipment_verification_bloc.freezed.dart';


class ShipmentVerificationBloc extends Bloc<ShipmentVerificationEvent, ShipmentVerificationState> {
  ShipmentVerificationBloc() : super(ShipmentVerificationState.initial()) {
    on<ShipmentVerificationEvent>((event, emit) async {

    });
  }
}