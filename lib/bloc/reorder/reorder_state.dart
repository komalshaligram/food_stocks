part of 'reorder_bloc.dart';

@freezed
class ReorderState with _$ReorderState {
  const factory ReorderState({
    required List<PreviousOrderProductData> previousOrderProductsList,
    required bool isShimmering,
    required bool isLoading,
    required bool isProductLoading,
    required List<Product> productDetails,
    required List<List<ProductStockModel>> productStockList,
    required int productStockUpdateIndex,
    required int pageNum,
    required bool isLoadMore,
    required bool isBottomOfProducts,
    required bool isSelectSupplier,
    required List<ProductSupplierModel> productSupplierList,
    required int imageIndex,
    required RefreshController refreshController,
    required TextEditingController noteController,
    required int cartCount,
    required bool duringCelebration,
    required bool isCategoryExpand,
    required bool isSearching,
    required TextEditingController searchController,
    required List<SearchModel> searchList,
    required String search,
    required List<Category> productCategoryList,
    required bool isCatVisible,
    required bool isGridView,
    required List<RelatedProductDatum> relatedProductList,
    required bool isRelatedShimmering,
    required int productListIndex
  }) = _ReorderState;

  factory ReorderState.initial() => ReorderState(
        previousOrderProductsList: [],
        isShimmering: false,
        isLoading: false,
        isProductLoading: false,
        productDetails: [],
        productStockUpdateIndex: -1,
      productStockList: [[ProductStockModel(productId: '')],[],[]],
        pageNum: 0,
        isLoadMore: false,
        isBottomOfProducts: false,
        isSelectSupplier: false,
        productSupplierList: [],
        imageIndex: 0,
        refreshController: RefreshController(),
        noteController: TextEditingController(),
    duringCelebration: false,
    cartCount: 0,
    isCategoryExpand: false,
    isSearching: false,
    searchController: TextEditingController(),
    searchList: [],
    search: '',
    productCategoryList: [],
    isCatVisible: false,
    isGridView: true,
    relatedProductList: [],
    isRelatedShimmering: false,
    productListIndex: -1

      );
}
