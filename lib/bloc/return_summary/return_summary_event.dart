part of 'return_summary_bloc.dart';

@freezed
class ReturnSummaryEvent with _$ReturnSummaryEvent {
    factory ReturnSummaryEvent.getReturnListEvent({required dynamic product,required BuildContext context}) =
      _getReturnListEvent;
    factory ReturnSummaryEvent.deleteEvent({required BuildContext context}) =
    _deleteEvent;
    factory ReturnSummaryEvent.navigateToAddProductEvent({required BuildContext context}) =
    _navigateToAddProductEvent;
    factory ReturnSummaryEvent.createReturnEvent({required BuildContext context,required String supplierId}) =
    _createReturnEvent;
    factory ReturnSummaryEvent.updateReturnEvent({required BuildContext context,required String supplierId}) =
    _updateReturnEvent;
    factory ReturnSummaryEvent.detailReturnEvent({required BuildContext context, required int index}) =
    _detailReturnEvent;
    factory ReturnSummaryEvent.getSummaryListEvent({required BuildContext context, required dynamic list}) =
    _getSummaryListEvent;
}