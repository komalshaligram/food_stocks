part of 'create_return_bloc.dart';

@freezed
class CreateReturnState with _$CreateReturnState {
  factory CreateReturnState({required bool isRedirected,
    required List<ReturnProduct> returnProductList,
    required String returnId,
    required bool isShimmer,
    required Map<String?,List<ReturnProduct>> supplierWiseMap,
    required String supplierId,
    required bool isFromPending,
    required bool isLoading, required String language, required TextEditingController barCodeController}) = _CreateReturnState;

  factory CreateReturnState.initial() => CreateReturnState(supplierWiseMap:{},isRedirected: false,isShimmer:false,isFromPending:false,
      supplierId:'',isLoading: false, language: '',returnProductList:[], barCodeController: TextEditingController(),returnId:'');
}