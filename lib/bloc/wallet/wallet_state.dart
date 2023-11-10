part of 'wallet_bloc.dart';

@freezed
class WalletState with _$WalletState {
  const factory WalletState({
    required int year,
    required int year1,
    required List<int> yearList,
    //required List<OrderBalance> balanceSheetList,
    required AllWalletTransactionResModel balanceSheetList,
    required String language,
    required int totalCredit,
    required int thisMonthExpense,
    required int lastMonthExpense,
    required int orderThisMonth,
    required int balance,
    required List<FlSpot> monthlyExpenseList,
    required bool isShimmering,
    required String currentDate,
    required DateRange? selectedDateRange
  }) = _WalletState;

  factory WalletState.initial() => WalletState(
        year: 2020,
        year1: 2020,
        yearList: [
        ],
     currentDate: '',
     balanceSheetList: AllWalletTransactionResModel(),
        language: '',
    balance: 0,
    lastMonthExpense: 0,
     orderThisMonth: 0,
    thisMonthExpense:0 ,
    totalCredit:0 ,
      monthlyExpenseList: [],
    isShimmering: false,
    selectedDateRange: DateRange(DateTime.now(),DateTime.now()),
      );
}


/*balanceSheetList: [
          OrderBalance(
              date: '15.02.2023',
              balance: 12450,
              difference: -1250,
              orderPayment: 152658),
          OrderBalance(
              date: '15.02.2023',
              balance: 12450,
              difference: 1250,
              orderPayment: 152658),
          OrderBalance(
              date: '15.02.2023',
              balance: 12450,
              difference: 1250,
              orderPayment: 152658),
          OrderBalance(
              date: '15.02.2023',
              balance: 12450,
              difference: -1250,
              orderPayment: 152658),
          OrderBalance(
              date: '15.02.2023',
              balance: 12450,
              difference: -1250,
              orderPayment: 152658),
          OrderBalance(
              date: '15.02.2023',
              balance: 12450,
              difference: 1250,
              orderPayment: 152658),
        ],*/