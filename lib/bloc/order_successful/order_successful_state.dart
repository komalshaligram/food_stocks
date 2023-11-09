
part of 'order_successful_bloc.dart';

@freezed
class OrderSuccessfulState with _$OrderSuccessfulState {
  const factory OrderSuccessfulState({
    required int totalCredit,
    required int thisMonthExpense,
    required int lastMonthExpense,
    required int orderThisMonth,
    required int balance,
  }) = _OrderSuccessfulState;

  factory OrderSuccessfulState.initial() =>
      OrderSuccessfulState(
        balance: 0,
        lastMonthExpense: 0,
        orderThisMonth: 0,
        thisMonthExpense: 0,
        totalCredit: 0,
      );

}

