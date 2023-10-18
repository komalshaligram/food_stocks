part of 'wallet_bloc.dart';

@freezed
class WalletState with _$WalletState {
  const factory WalletState({
    required String date,
    required List<String> dateList,
    required List<OrderBalance>balanceSheetList,

  }) = _WalletState;
  factory WalletState.initial()=>  WalletState(
    date: '01.01.2023 - 01.01.2024',
    dateList: ['01.01.2023 - 01.01.2024','01.01.2024 - 01.01.2025','01.01.2025 - 01.01.2026'],
    balanceSheetList: [
      OrderBalance(date: '15.02.2023', balance: 12450 , difference: -1250, orderPayment: 152658),
      OrderBalance(date: '15.02.2023', balance: 12450 , difference: -1250, orderPayment: 152658),
      OrderBalance(date: '15.02.2023', balance: 12450 , difference: 1250, orderPayment: 152658),
      OrderBalance(date: '15.02.2023', balance: 12450 , difference: -1250, orderPayment: 152658),
      OrderBalance(date: '15.02.2023', balance: 12450 , difference: -1250, orderPayment: 152658),
      OrderBalance(date: '15.02.2023', balance: 12450 , difference: -1250, orderPayment: 152658),

    ]

  );
}




