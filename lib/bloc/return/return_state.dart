part of 'return_bloc.dart';

@freezed
class ReturnState with _$ReturnState {
  const factory ReturnState({required bool isRedirected, required bool isLoading,
    required List<Return> returnList,
    required List<StatusData> statusList,
    required List<ReturnProduct> returnProductList,
    required String language, required TextEditingController barCodeController}) = _ReturnState;

  factory ReturnState.initial() => ReturnState(isRedirected: false, returnProductList:[],isLoading: false,
      language: '',returnList: [],statusList: [], barCodeController: TextEditingController());
}
