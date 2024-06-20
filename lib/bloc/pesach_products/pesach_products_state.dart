part of 'pesach_products_bloc.dart';

@freezed
class PesachProductsState with _$PesachProductsState {
  const factory PesachProductsState({
    required String supplierId,
    required String search,
    required List<PesachData> productList,
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
    required TextEditingController noteController,
    required RefreshController refreshController,
    required String searchType,
    required bool isGuestUser,
    required bool isGridView,
    required bool isCategoryExpand,
    required bool isSearching,
    required TextEditingController searchController,
    required List<SearchModel> searchList,
    required List<Category> productCategoryList,
    required bool isCatVisible,
    required List<RelatedProductDatum> relatedProductList,
    required bool isRelatedShimmering,
    required bool duringCelebration,
    required int cartCount,
    required int productListIndex,
    required double bottleDeposit,
    required bool isSubUserAddToBasket,


  }) = _PesachProductsState;

  factory PesachProductsState.initial() => PesachProductsState(
    supplierId: '',
        search: '',
      bottleDeposit:0.0,
        productList: [],
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
        noteController: TextEditingController(),
        refreshController: RefreshController(),
        searchType: '',
      isGuestUser:false,
     isGridView :false,
    isCategoryExpand: false,
    isSearching: false,
    searchController: TextEditingController(),
    searchList: [],
    productCategoryList: [],
    isCatVisible: false,
    relatedProductList: [],
    isRelatedShimmering: false,
    duringCelebration: false,
    cartCount: 0,
    productListIndex: 0,
    isSubUserAddToBasket: false,
    
    


      );
}
