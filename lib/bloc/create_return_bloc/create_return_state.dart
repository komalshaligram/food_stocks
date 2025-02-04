part of 'create_return_bloc.dart';

@freezed
class CreateReturnState with _$CreateReturnState {
  factory CreateReturnState({required bool isRedirected,
    required List<ReturnProducts> returnProductList,
    required bool isLoading, required String language, required TextEditingController barCodeController}) = _CreateReturnState;

  factory CreateReturnState.initial() => CreateReturnState(isRedirected: false, isLoading: false, language: '',returnProductList:[], barCodeController: TextEditingController());
}
