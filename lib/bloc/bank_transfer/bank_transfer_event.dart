part of 'bank_transfer_bloc.dart';


@freezed
class BankTransferEvent with _$BankTransferEvent {
  factory BankTransferEvent.getBankTransferInfoEvent({required
  BuildContext context}) =
  _getBankTransferInfoEvent;
}