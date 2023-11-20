part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required String UserImageUrl,
    required String UserCompanyLogoUrl,
    required int cartCount,
    required ProductSalesResModel productSalesList,
    required bool isShimmering,
    required bool isLoading,
    required bool isProductLoading,
    required List<Product> productDetails,
    required List<ProductStockModel> productStockList,
    required int productStockUpdateIndex,
    required bool isSelectSupplier,
    required List<ProductSupplierModel> productSupplierList,
    required bool isCartCountChange,
    required int totalCredit,
    required int thisMonthExpense,
    required int lastMonthExpense,
    required int orderThisMonth,
    required int balance,
  }) = _HomeState;

  factory HomeState.initial() => HomeState(
        UserImageUrl: '',
        UserCompanyLogoUrl: '',
        cartCount: 0,
        productSalesList: ProductSalesResModel(),
        isShimmering: false,
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
      );
}
