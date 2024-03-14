part of 'bank_info_bloc.dart';

@freezed
class BankInfoEvent with _$BankInfoEvent {
  factory BankInfoEvent.selectBankEvent({required String agent}) =
  _selectBankEvent;

}