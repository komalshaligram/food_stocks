part of 'product_return_info_bloc.dart';

@freezed
class ProductReturnInfoState with _$ProductReturnInfoState {
  const factory ProductReturnInfoState({required File proofFile,
    required File proofFile1, required File proofFile2,
    required String language,
    required int productQty,
    required int totalQty,
    required bool isLoading,
    required int selectedRadioTile,
    required String productName,
    required String productImg,
    required String noOfUnits,
    required String reason,
    required List<RadioModel> radioList,
    required List<String> proofImagesList,
    required TextEditingController addNoteController}) = _ProductReturnInfoState;

  factory ProductReturnInfoState.initial() => ProductReturnInfoState(proofFile: File(''), proofFile1: File(''),isLoading:false,
      proofFile2: File(''), addNoteController: TextEditingController(),noOfUnits: '1',productImg: '',productName: '',reason:'',radioList:[],
      productQty: 1, language: AppStrings.hebrewString,totalQty:1,selectedRadioTile: 1,proofImagesList:[]);
}
class RadioModel{
  String text;
  int id;

  RadioModel({required this.text,required this.id});
}