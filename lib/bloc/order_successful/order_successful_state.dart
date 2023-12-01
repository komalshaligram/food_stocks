
part of 'order_successful_bloc.dart';

@freezed
class OrderSuccessfulState with _$OrderSuccessfulState {
  const factory OrderSuccessfulState({
    required double totalCredit,
    required double thisMonthExpense,
    required double lastMonthExpense,
    required int orderThisMonth,
    required double balance,
    required double expensePercentage,
  }) = _OrderSuccessfulState;

  factory OrderSuccessfulState.initial() =>
      OrderSuccessfulState(
        balance: 0,
        lastMonthExpense: 0,
        orderThisMonth: 0,
        thisMonthExpense: 0,
        totalCredit: 0,
        expensePercentage: 0
      );

}

