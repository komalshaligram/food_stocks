part of 'recommendation_products_bloc.dart';

@freezed
class RecommendationProductsState with _$RecommendationProductsState {
  const factory RecommendationProductsState({
    required List<RecommendationData> recommendationProductsList,
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
  }) = _RecommendationProductsState;

  factory RecommendationProductsState.initial() => RecommendationProductsState(
        recommendationProductsList: [],
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
