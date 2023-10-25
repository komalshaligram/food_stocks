part of 'qr_scan_bloc.dart';

@freezed
class QrScanState with _$QrScanState {
  const factory QrScanState() = _QrScanState;

  factory QrScanState.initial() => const QrScanState();
}
