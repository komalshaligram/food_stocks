part of 'my_accounting_card_bloc.dart';

@freezed
class MyAccountingCardEvent with _$MyAccountingCardEvent {
  factory MyAccountingCardEvent.getRefundDataEvent({required BuildContext context}) = _getRefundDataEvent;
  factory MyAccountingCardEvent.refreshListEvent({required BuildContext context}) = _refreshListEvent;
  factory MyAccountingCardEvent.changeTab(int index) = _changeTab;
}
