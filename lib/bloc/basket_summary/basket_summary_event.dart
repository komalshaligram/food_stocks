part of 'basket_summary_bloc.dart';

@freezed
class BasketSummaryEvent with _$BasketSummaryEvent {

  const factory BasketSummaryEvent.getDataEvent({
    required BuildContext context,
    required GetAllCartResModel cartItemList,
    required String orderBySupplierId,
    required String isSupplierSingle,
    int? totalSupplier
  }) = _getDataEvent;


  const factory BasketSummaryEvent.orderSendEvent({
    required BuildContext context,
    required String paymentMethod,
    required bool failPayment
  }) = _orderSendEvent;

  const factory BasketSummaryEvent.payWithBankTransferEvent({required BuildContext context,required bool isFromRemovePopUp}) = _payWithBankTransferEvent;
  const factory BasketSummaryEvent.refreshEvent() = _refreshEvent;
  const factory BasketSummaryEvent.getSupplierPaymentTypeEvent({required BuildContext context, required String id,required int index}) = _getSupplierPaymentTypeEvent;
  const factory BasketSummaryEvent.generalSettings({required BuildContext context, required BuildContext dialogContext, required bool isRetryLoading}) = _generalSettings;
  const factory BasketSummaryEvent.updateMaintenanceEvent({required BuildContext context}) = _updateMaintenanceEvent;
}
