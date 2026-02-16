part of 'return_bloc.dart';

@freezed
class ReturnEvent with _$ReturnEvent {
  factory ReturnEvent.getReturnListEvent({
    required BuildContext context,
  }) = _getReturnListEvent;

  factory ReturnEvent.openScannerEvent({
    required BuildContext context,
  }) = _openScannerEvent;

  factory ReturnEvent.deleteEvent({
    required BuildContext context,
  }) = _deleteEvent;

  factory ReturnEvent.scanProductEvent({
    required BuildContext context,
    required String barCode,
  }) = _scanProductEvent;

  factory ReturnEvent.newRequestEvent({
    required BuildContext context,
  }) = _newRequestEvent;

  factory ReturnEvent.getArgumentEvent({
    required BuildContext context,
    required dynamic list,
  }) = _getArgumentEvent;

  factory ReturnEvent.refreshListEvent({
    required BuildContext context,
  }) = _refreshListEvent;
}
