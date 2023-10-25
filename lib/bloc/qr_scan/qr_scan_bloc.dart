import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_scan_event.dart';

part 'qr_scan_state.dart';

part 'qr_scan_bloc.freezed.dart';

class QrScanBloc extends Bloc<QrScanEvent, QrScanState> {
  QrScanBloc() : super(QrScanState.initial()) {
    on<QrScanEvent>((event, emit) {});
  }
}
