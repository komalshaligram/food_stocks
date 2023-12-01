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
        productStockList: [],
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
    expensePercentage: 0
      );
}
