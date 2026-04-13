part of 'bank_transfer_bloc.dart';

@freezed
class BankTransferState with _$BankTransferState {
  const factory BankTransferState({required bool isLoading, required String bankTransferDetails}) = _BankTransferState;

  factory BankTransferState.initial() => const BankTransferState(isLoading: true, bankTransferDetails: '');
}
