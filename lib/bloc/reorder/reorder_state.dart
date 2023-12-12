part of 'reorder_bloc.dart';

@freezed
class ReorderState with _$ReorderState {
  const factory ReorderState({
    required List<PreviousOrderProductData> previousOrderProductsList,
    required bool isShimmering,
    required bool isLoading,
    required bool isProductLoading,
    required List<Product> productDetails,
    required List<ProductStockModel> productStockList,
    required int productStockUpdateIndex,
    required int pageNum,
    required bool isLoadMore,
    required bool isBottomOfProducts,
    required bool isSelectSupplier,
    required List<ProductSupplierModel> productSupplierList,
    required int imageIndex,
    required RefreshController refreshController,
    required TextEditingController noteController,
  }) = _ReorderState;

  factory ReorderState.initial() => ReorderState(
        previousOrderProductsList: [],
        isShimmering: false,
        isLoading: false,
        isProductLoading: false,
        productDetails: [],
        productStockUpdateIndex: -1,
        productStockList: [],
        pageNum: 0,
        isLoadMore: false,
        isBottomOfProducts: false,
        isSelectSupplier: false,
        productSupplierList: [],
        imageIndex: 0,
        refreshController: RefreshController(),
        noteController: TextEditingController(),
      );
}
