part of 'return_summary_bloc.dart';

@freezed
class ReturnSummaryState with _$ReturnSummaryState {
  factory ReturnSummaryState({
    required bool isRedirected,
    required List<ReturnProduct> returnProductList,
    required String returnId,
    required bool isShimmer,
    required Map<String?, List<ReturnProduct>> supplierWiseMap,
    required String supplierId,
    required bool isLoading,
    required String language,
    required TextEditingController barCodeController,
  }) = _ReturnSummaryState;

  factory ReturnSummaryState.initial() => ReturnSummaryState(
        supplierWiseMap: {},
        isRedirected: false,
        isShimmer: false,
        supplierId: '',
        isLoading: false,
        language: '',
        returnProductList: [],
        barCodeController: TextEditingController(),
        returnId: '',
      );
}
