part of 'create_return_bloc.dart';

@freezed
class CreateReturnEvent with _$CreateReturnEvent {
  factory CreateReturnEvent.getReturnListEvent({required dynamic product, required BuildContext context}) = _getReturnListEvent;

  factory CreateReturnEvent.deleteEvent({required BuildContext context}) = _deleteEvent;

  factory CreateReturnEvent.navigateToAddProductEvent({required BuildContext context}) = _navigateToAddProductEvent;

  factory CreateReturnEvent.createReturnEvent({required BuildContext context, required String supplierId}) = _createReturnEvent;

  factory CreateReturnEvent.updateReturnEvent({required BuildContext context}) = _updateReturnEvent;

  factory CreateReturnEvent.detailReturnEvent({required BuildContext context, required int index}) = _detailReturnEvent;

  factory CreateReturnEvent.getSummaryListEvent({required BuildContext context, required dynamic list}) = _getSummaryListEvent;

  factory CreateReturnEvent.navigateSummaryListEvent({required BuildContext context}) = _navigateSummaryListEvent;
}
