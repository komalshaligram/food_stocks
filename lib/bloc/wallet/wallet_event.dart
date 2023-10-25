part of 'wallet_bloc.dart';

@freezed
class WalletEvent with _$WalletEvent {
  const factory WalletEvent.dropDownEvent({
    required String date,
    required int index,
  }) = _dropDownEvent;

  const factory WalletEvent.checkLanguage() = _checkLanguage;
}
