part of 'wallet_bloc.dart';

@freezed
class WalletEvent with _$WalletEvent {
  const factory WalletEvent.getTotalExpenseEvent({
    required int year,
    required BuildContext context
  }) = _getTotalExpenseEvent;

  const factory WalletEvent.checkLanguage() = _checkLanguage;

  const factory WalletEvent.dropDownListEvent() = _dropDownListEvent;

  const factory WalletEvent.getWalletRecordEvent({
    required BuildContext context
}) = _getWalletRecordEvent;

  const factory WalletEvent.getAllWalletTransactionEvent({
    required BuildContext context,
    required int year,
    required int month
  }) = _getAllWalletTransactionEvent;

  const factory WalletEvent.getDateRangeEvent({
    required BuildContext context,
    required DateRange? range,

  }) = _getDateRangeEvent;

  const factory WalletEvent.getDropDownElementEvent({
    required int year,
  }) = _getDropDownElementEvent;

  const factory WalletEvent.exportWalletTransactionEvent({
    required BuildContext context,
}) = _exportWalletTransactionEvent;

}
