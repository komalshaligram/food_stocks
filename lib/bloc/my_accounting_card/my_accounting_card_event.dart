part of 'my_accounting_card_bloc.dart';

@freezed
class MyAccountingCardEvent with _$MyAccountingCardEvent {
  factory MyAccountingCardEvent.getClientInvoicesFromRivchitDataEvent({required BuildContext context}) = _getClientInvoicesFromRivchitDataEvent;

  factory MyAccountingCardEvent.getClientRefundInvoicesFromRivchitDataEvent({required BuildContext context}) = _getClientRefundInvoicesFromRivchitDataEvent;

  factory MyAccountingCardEvent.refreshListEvent({required BuildContext context}) = _refreshListEvent;

  factory MyAccountingCardEvent.changeTab(int index) = _changeTab;

  factory MyAccountingCardEvent.updateInvoicesDateRange({required DateTime? from, required DateTime? to, required BuildContext context}) = _updateInvoicesDateRange;

  factory MyAccountingCardEvent.updateRefundsDateRange({required DateTime? from, required DateTime? to, required BuildContext context}) = _updateRefundsDateRange;
}
