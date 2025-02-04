part of 'create_return_bloc.dart';

@freezed
class CreateReturnEvent with _$CreateReturnEvent {
    factory CreateReturnEvent.getReturnListEvent({required ReturnProducts product}) =
      _getReturnListEvent;
    factory CreateReturnEvent.deleteEvent({required BuildContext context}) =
    _deleteEvent;
    factory CreateReturnEvent.getArgumentsEvent({required BuildContext context,required ReturnProducts products}) =
    _getArgumentsEvent;
}