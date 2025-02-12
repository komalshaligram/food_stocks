part of 'create_return_bloc.dart';

@freezed
class CreateReturnEvent with _$CreateReturnEvent {
    factory CreateReturnEvent.getReturnListEvent({required dynamic product}) =
      _getReturnListEvent;
    factory CreateReturnEvent.deleteEvent({required BuildContext context}) =
    _deleteEvent;
    factory CreateReturnEvent.navigateToAddProductEvent({required BuildContext context}) =
    _navigateToAddProductEvent;
    factory CreateReturnEvent.createReturnEvent({required BuildContext context}) =
    _createReturnEvent;
}