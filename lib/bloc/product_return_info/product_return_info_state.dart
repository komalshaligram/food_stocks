part of 'product_return_info_bloc.dart';

@freezed
class ProductReturnInfoState with _$ProductReturnInfoState {
  const factory ProductReturnInfoState(
      {required File proofFile,
      required File proofFile1,
      required File proofFile2,
      required String language,
      required int productQty,
      required String scaleType,
      required int totalQty,
      required bool isLoading,
      required int selectedRadioTile,
      required String productName,
      required String productImg,
      required String noOfUnits,
      required String reason,
      required List<RadioModel> radioList,
      required List<String> proofImagesList,
      required String barCode,
      required String returnProductId,
      required bool isShimmer,
      required String updateId,
      required String statusId,
      required List<ReturnProduct> returnProductList,
      required List<String> returnIdList,
      required int mainIndex,
      required String supplierId,
      required String supplierName,
      required String returnId,
      required bool isFromPending,
      required TextEditingController addNoteController}) = _ProductReturnInfoState;

  factory ProductReturnInfoState.initial() => ProductReturnInfoState(
      proofFile: File(''),
      proofFile1: File(''),
      isLoading: false,
      barCode: '',
      returnProductId: '',
      proofFile2: File(''),
      addNoteController: TextEditingController(),
      noOfUnits: '1',
      productImg: '',
      productName: '',
      reason: '',
      radioList: [],
      supplierId: '',
      returnProductList: [],
      productQty: 1,
      scaleType: '',
      language: AppStrings.hebrewString,
      totalQty: 1,
      selectedRadioTile: 0,
      proofImagesList: [],
      returnIdList: [],
      isShimmer: false,
      updateId: '',
      statusId: '',
      mainIndex: -1,
      supplierName: '',
      returnId: '',
      isFromPending: false);
}

class RadioModel {
  String text;
  int id;

  RadioModel({required this.text, required this.id});
}
