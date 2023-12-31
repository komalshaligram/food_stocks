part of 'wallet_bloc.dart';

@freezed
class WalletState with _$WalletState {
  const factory WalletState({
    required int year,
    required List<int> yearList,
    required AllWalletTransactionResModel balanceSheetList,
    required String language,
    required double totalCredit,
    required double thisMonthExpense,
    required double lastMonthExpense,
    required int orderThisMonth,
    required double balance,
    required List<FlSpot> monthlyExpenseList,
    required bool isShimmering,
    required String currentDate,
    required DateRange? selectedDateRange,
    required List<Datum>walletTransactionsList,
    required int pageNum,
    required bool isLoadMore,
    required bool isBottomOfProducts,
    required bool isExportShimmering,
    required double expensePercentage,
  }) = _WalletState;

  factory WalletState.initial() => WalletState(
        year: 2020,
        yearList: [],
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
    walletTransactionsList: [],
    pageNum: 0,
    isLoadMore: false,
    isBottomOfProducts: false,
    isExportShimmering: false,
    expensePercentage: 0
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