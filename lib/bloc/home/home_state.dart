part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required String UserImageUrl,
    required String UserCompanyLogoUrl,
    required int cartCount,
    required int messageCount,
    required List<ProductSale> productSalesList,
    required bool isProductSaleShimmering,
    required bool isLoading,
    required bool isProductLoading,
    required List<Product> productDetails,
    required List<ProductStockModel> productStockList,
    required int productStockUpdateIndex,
    required bool isSelectSupplier,
    required List<ProductSupplierModel> productSupplierList,
    required bool isCartCountChange,
    required double totalCredit,
    required double thisMonthExpense,
    required double lastMonthExpense,
    required int orderThisMonth,
    required double balance,
    required int imageIndex,
    required List<MessageData> messageList,
    required bool isMessageShimmering,
    required double expensePercentage,
    required TextEditingController noteController,
    required List<RecommendationData> recommendedProductsList,
    required bool isShimmering,
    required bool isCategoryExpand,
    required bool isSearching,
    required TextEditingController searchController,
    required List<SearchModel> searchList,
    required String search,
    required List<Category> productCategoryList,
    required bool isCatVisible,
    required bool isGuestUser,
    required bool isIgnorePointer,
    required bool isRelatedShimmering,
    required List<RelatedProductDatum> relatedProductList,
  }) = _HomeState;

  factory HomeState.initial() => HomeState(
        UserImageUrl: '',
        UserCompanyLogoUrl: '',
        cartCount: 0,
        messageCount: 0,
        productSalesList: [],
        isProductSaleShimmering: false,
        isLoading: false,
        isProductLoading: false,
        productDetails: [],
        productStockUpdateIndex: -1,
        productStockList: [ProductStockModel(productId: '')],
        isSelectSupplier: false,
        productSupplierList: [],
        isCartCountChange: false,
        balance: 0,
        lastMonthExpense: 0,
        orderThisMonth: 0,
        thisMonthExpense: 0,
        totalCredit: 0,
        imageIndex: 0,
        messageList: [],
        isMessageShimmering: false,
        expensePercentage: 0,
        noteController: TextEditingController(),
        recommendedProductsList: [],
    isShimmering: false,
    isCategoryExpand: false,
    isSearching: false,
    searchController: TextEditingController(),
    searchList: [],
    search: '',
    productCategoryList: [],
    isCatVisible: false,
    isGuestUser: false,
    isIgnorePointer: false,
      isRelatedShimmering:false,
      relatedProductList: [],
      );
}
