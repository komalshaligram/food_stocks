part of 'product_details_bloc.dart';

@freezed
class ProductDetailsState with _$ProductDetailsState {

  const factory ProductDetailsState({
    required bool isProductProblem,
    required bool isRefresh,
    required int selectedRadioTile,
    required List<int>productListIndex,
    required int productWeight,
    required String phoneNumber,
    required OrdersBySupplier orderBySupplierProduct,
    required OrderDatum orderData,
    required bool isShimmering,
    required bool isLoading,
    required int quantity,
    required bool isAllCheck,
    required int missingQuantity,
    required String note,
    required TextEditingController addNoteController,
    required bool isRemoveProcess,
    required String language,

  }) = _ProductDetailsState;

  factory ProductDetailsState.initial()=>  ProductDetailsState(

    isProductProblem: false,
    isRefresh: false,
    selectedRadioTile: 0,
  productListIndex: [],
    productWeight: 0,
    phoneNumber: '',
    orderBySupplierProduct: OrdersBySupplier(),
     orderData: OrderDatum(),
     isShimmering: false,
    isLoading: false,
      quantity: 0,
    isAllCheck: false,
     missingQuantity: 0,
    note: '',
    addNoteController: TextEditingController(),
    isRemoveProcess: false,
    language: 'en'


  );
}